/*
 * An Apex Callout wich consumes the public Heroku endpoint on demand and insert the records into the database.
 * the 'NightlyHerokuService' is just an Scheduled Apex class wich execute this callout every night.
*/
public with sharing class ucl_HerokuService {
    @AuraEnabled
    @future(callout=true)
    public static void doGet(){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            //String forceResponse = '[{"AccountNumber":"a209ebbb-39c6-4852-8732-82237c0674fb","AccountName":"Fadeo","AccountStatus":"Enabled","AsOfDate":"2/20/2023","Clients":[{"FirstName":"Merrel","LastName":"Hewes","Email":"mhewes1@paypal.com","Phone":"246-738-5648","Address":"003 Moland Way","ClientNumber":"735add3a-0684-4bd9-beda-04dfb7575ed9"},{"FirstName":"Van","LastName":"McTeer","Email":"vmcteer2@hhs.gov","Phone":"421-793-9612","Address":"2 Oneill Point","ClientNumber":"fe83f246-ff94-4895-8306-55eb4d0eb26a"},{"FirstName":"Ebenezer","LastName":"Dyer","Email":"edyer3@pinterest.com","Phone":"597-831-0857","Address":"221 North Drive","ClientNumber":"2e66f1c8-1100-463f-9fd0-0a53ea57bad1"},{"FirstName":"Brody","LastName":"Moseby","Email":"bmoseby4@blogtalkradio.com","Phone":"937-383-6950","Address":"848 Magdeline Terrace","ClientNumber":"70f194d5-5106-4302-a65a-75cccc1c3328"},{"FirstName":"Ami","LastName":"Kneafsey","Email":"akneafsey5@tripadvisor.com","Phone":"479-131-3563","Address":"376 Vermont Parkway","ClientNumber":"055db4ba-992c-46bf-80fc-5c9f1cd35287"}]}]';
            // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
                /*
                * get the JSON response from the Heroku endpoint and store it into a list of handlers, this let us get 
                * the Legal Advisors and the Clients from the Handler avoiding deserializing the JSON response again
                */
                //response.getBody()
                List<ucl_LegalAdvisorHandler> JSONToHandlerResults = ucl_HerokuResponseHandler.parseFromJSONtoHandler(response.getBody());
                
                /*
                * parse the JSON response into a List of Handlers, this are used later on to be converted into a list of 'ucl_Legal_Advisor__c',
                * making the parsing flow something like JSON -> Handler -> CustomObject compatible with the insert.
                * The motive behind this is that the JSON response has different field names comparing to the 'ucl_Legal_Advisor__c' field names
                * So the Handler object helps as a bridge between the JSON and the Custom Object
                */
                List<ucl_Legal_Advisor__c> customObjectLegalAdvisorsResults = ucl_HerokuResponseHandler.getLegalAdvisorsFromHandlers(JSONToHandlerResults);
                List<Database.upsertResult> upsertResults = new List<Database.upsertResult>();
                
                try{
                    upsertResults = Database.upsert(customObjectLegalAdvisorsResults,ucl_Legal_Advisor__c.Account_Number__c,true);
                }catch(DmlException e){
                    ucl_LogHandler.saveLog('Something went wrong handling the legal advisors data into the database', e.getMessage(), 'ucl_HerokuService');
                    throw e;
                }
                
                /*
                * the handler object has the client list but no id, so after the upsert of the custom objects,
                * we put the id of each custom object on it's corresponding handler, this is done to refer
                * each client with the correct id
                */
                for(Integer i = 0; i < customObjectLegalAdvisorsResults.size(); i++){
                    JSONToHandlerResults[i].Id = upsertResults[i].getId();
                }
                
                List<ucl_Client__c> customObjectClientResults = ucl_HerokuResponseHandler.getClientsFromHandlers(JSONToHandlerResults);
                upsert customObjectLegalAdvisorsResults;
                try{
                    Database.upsert(customObjectClientResults, ucl_Client__c.Client_Number__c, true);
                    /*
                    * delete those clients who weren't in the JSON response and weren't created
                    * by an admin
                    */
                    List<ucl_Client__c> clientsToDelete = ucl_ResponseValidationHandler.getCustomClientsToDelete(customObjectClientResults);
                    delete clientsToDelete;
                }catch(DmlException e){
                    ucl_LogHandler.saveLog('Something went wrong handling the clients data into the database', e.getMessage(), 'ucl_HerokuService');
                    throw e;
                }                
            } else {
            	ucl_LogHandler.saveLog('Something went wrong fetching the Heroku service', 'Response status code:' + String.valueOf(response.getStatusCode()), 'ucl_HerokuService');
            }
        } catch (Exception e) {
            ucl_LogHandler.saveLog('Something went wrong during the execution of the Heroku service', e.getMessage(), 'ucl_HerokuService');  
            throw e;
        }
	}
}