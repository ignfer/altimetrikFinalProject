/*An Apex Callout wich consumes the public Heroku endpoint on demand and
insert the records into the database.
the 'NightlyHerokuService' is just an Scheduled Apex class wich execute
this callout every night.*/
public with sharing class ucl_HerokuService {
    @AuraEnabled
    public static void doGet(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            //get the JSON response from the Heroku endpoint and store it into a list of handlers, this let us get 
            //the Legal Advisors and the Clients from the Handler avoiding deserializing the JSON response again
            List<ucl_LegalAdvisorHandler> JSONToHandlerResults = ucl_HerokuResponseHandler.parseFromJSONtoHandler(response.getBody());
            
            /*parse the JSON response into a List of Handlers and then into a list of 'ucl_Legal_Advisor__c',
            parsing from JSON -> Handler -> CustomObject compatible with the insert.
            The motive behind this is that the JSON response has different field names comparing to the 'ucl_Legal_Advisor__c' field names
            So the Handler object helps as a bridge between the JSON and the Custom Object*/
            List<ucl_Legal_Advisor__c> CustomObjectLegalAdvisorsResults = ucl_HerokuResponseHandler.getLegalAdvisorsFromHandlers(JSONToHandlerResults);
            insert CustomObjectLegalAdvisorsResults;

            /*the handler object has the client list but no id, so after the insert of the custom objects,
			we put the id of each custom object on it's corresponding handler, this is done to refer
			each client with the correct id*/
            for(Integer i = 0; i < CustomObjectLegalAdvisorsResults.size(); i++){
                JSONToHandlerResults[i].Id=CustomObjectLegalAdvisorsResults[i].Id;
            }
            
            List<ucl_Client__c> CustomObjectClientResults = ucl_HerokuResponseHandler.getClientsFromHandlers(JSONToHandlerResults);
            insert CustomObjectClientResults;
        }
	}
}