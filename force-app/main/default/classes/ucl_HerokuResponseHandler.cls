/*
 * A separated class in charge of handling the response from the Heroku
 * service, it parses from JSON to Handlers and from Handlers to Custom Objects
 * when is needed it also communicates with the response validation class
 * wich is in charge of validating the data of the response to acomplish the
 * proposed business logic
*/
public class ucl_HerokuResponseHandler {
    
    public static List<ucl_LegalAdvisorHandler> parseFromJSONtoHandler(String json) {
        try {
            List<ucl_LegalAdvisorHandler> legalAdvisorHandlers = (List<ucl_LegalAdvisorHandler>) System.JSON.deserialize(json, List<ucl_LegalAdvisorHandler>.class);
        	return ucl_ResponseValidationHandler.getValidAdvisors(legalAdvisorHandlers);
        } catch(JsonException je) {
            ucl_LogHandler.saveLog('Something went wrong parsing the Heroku response', je.getMessage(), 'ucl_HerokuResponseHandler');
            throw je;
        }
	}
    
    /*
     * Given a list of Legal Advisor Handlers, creates a Custom Object Legal Advisor for each one
	*/
    public static List<ucl_Legal_Advisor__c> getLegalAdvisorsFromHandlers(List<ucl_LegalAdvisorHandler> listOfHandlers) {
    	//allocate the 'ucl_Legal_Advisor__c' created from the handlers
        List<ucl_Legal_Advisor__c> CustomObjectLegalAdvisorResults = new List<ucl_Legal_Advisor__c>();
        try{
            for (ucl_LegalAdvisorHandler advisorHandler : listOfHandlers){
                ucl_Legal_Advisor__c CustomObjectLegalAdvisor = createCustomAdvisorFromHandler(advisorHandler);
                CustomObjectLegalAdvisorResults.add(CustomObjectLegalAdvisor);
                //break; //the purpose of this break is to just parse the first registry
            }
            return CustomObjectLegalAdvisorResults;
        } catch(Exception e) {
            ucl_LogHandler.saveLog('Something went wrong parsing the Heroku response into advisor handlers', e.getMessage(), 'ucl_HerokuResponseHandler');
            throw e;
        }
	}
    
    /*
     * for each LegalAdvisor Handler, if it has an Id, retrieves all his clients as Custom Objects
     * and saves them
	*/
    public static List<ucl_Client__c> getClientsFromHandlers(List<ucl_LegalAdvisorHandler> JSONToHandlerResults){
        List<ucl_Client__c> CustomObjectClientResults = new List<ucl_Client__c>();
        try {
            for (ucl_LegalAdvisorHandler advisorHandler : JSONToHandlerResults){
                if(advisorHandler.Id != null){
                    for(ucl_ClientHandler ClientHandler: advisorHandler.Clients){
                        ucl_Client__c CustomObjectClient = createCustomClient(ClientHandler,advisorHandler.Id);
                        CustomObjectClientResults.add(CustomObjectClient);    
                    }
                }
                //break; //the purpose of this break is to just parse the first registry
            }
            
            return CustomObjectClientResults;
        } catch (Exception e) {
            ucl_LogHandler.saveLog('Something went wrong parsing the Heroku response into client handlers', e.getMessage(), 'ucl_HerokuResponseHandler');
            throw e;
        }
    }
    
    /*
     * recieve the Date as the string value of the JSON and parse it into a Date format ready to insert into the
     * data base, the Date format in the JSON response is month/day/year so Date.parse or Date.valueOf would throw an exeption, to counter
     * that problem we split the JSON date and re organize-it into a valid format
	*/
    public static Date stringToDate(String dateAsString){
        try {
            List<String> splitDate = dateAsString.split('/');
            //build a new date in the format of: year-month-day
            Date toDate = Date.newInstance(Integer.valueOf(splitDate[2]), Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]));
            return toDate;
        } catch (Exception e) {
            ucl_LogHandler.saveLog('Something went wrong parsing the Heroku date', e.getMessage(), 'ucl_HerokuResponseHandler');
            throw e;
        }
    }
    
    /*
     * an auxiliar method to create a legal advisor custom object from the legal advisor handler 
	*/
    public static ucl_Legal_Advisor__c createCustomAdvisorFromHandler(ucl_LegalAdvisorHandler advisorHandler){
        try {
            ucl_Legal_Advisor__c CustomLegalAdvisor = new ucl_Legal_Advisor__c(Name = advisorHandler.AccountName,
                                                                           Account_Number__c = advisorHandler.AccountNumber,
                                                                           Account_Status__c = advisorHandler.AccountStatus, 
                                                                           As_of_Date__c = stringToDate(advisorHandler.AsOfDate));
            return CustomLegalAdvisor;
        } catch (Exception e) {
            ucl_LogHandler.saveLog('Something went wrong creating the advisor handler', e.getMessage(), 'ucl_HerokuResponseHandler');
            throw e;
        }
    }
    
    /*
     * an auxiliar method to create a client custom object from the client handler 
	*/
    public static ucl_Client__c createCustomClient(ucl_ClientHandler ClientHandler,Id LegalAdvisorId){
        try {
            ucl_Client__c CustomObjectClient = new ucl_Client__c(Name=ClientHandler.FirstName + ClientHandler.LastName,
                                                                 Client_Number__c = ClientHandler.ClientNumber,
                                                                 First_Name__c = ClientHandler.FirstName,
                                                                 Last_Name__c = ClientHandler.LastName,
                                                                 Email__c = ClientHandler.Email,
                                                                 Phone__c = ClientHandler.Phone,
                                                                 Addres__c = ClientHandler.Address,
                                                             	 Created_By_Admin__c = false,
                                                                 Asesored_By__c = LegalAdvisorId);
        return CustomObjectClient;
        } catch (Exception e ) {
            ucl_LogHandler.saveLog('Something went wrong creating the client handler', e.getMessage(), 'ucl_HerokuResponseHandler');
            throw e;
        }
    }
}