public class ucl_HerokuResponseHandler {
    
    public static List<ucl_LegalAdvisorHandler> parseFromJSONtoHandler(String json) {
		return (List<ucl_LegalAdvisorHandler>) System.JSON.deserialize(json, List<ucl_LegalAdvisorHandler>.class);
	}
    
    /*
	Given a list of Legal Advisor Handlers, creates a Custom Object Legal Advisor for each one
	*/
    public static List<ucl_Legal_Advisor__c> getLegalAdvisorsFromHandlers(List<ucl_LegalAdvisorHandler> listOfHandlers) {
        //creates a new list to allocate the 'ucl_Legal_Advisor__c' created from the handlers
        List<ucl_Legal_Advisor__c> CustomObjectLegalAdvisorResults = new List<ucl_Legal_Advisor__c>();
        
        for (ucl_LegalAdvisorHandler advisorHandler : listOfHandlers){
            ucl_Legal_Advisor__c CustomObjectLegalAdvisor = createCustomAdvisorFromHandler(advisorHandler);
            CustomObjectLegalAdvisorResults.add(CustomObjectLegalAdvisor);
            break; //the purpose of this break is to just parse the first registry
        }
        return CustomObjectLegalAdvisorResults;
	}
    
    /*
	for each LegalAdvisor Handler with Id, retrieves all his clients as Custom Objects
	*/
    public static List<ucl_Client__c> getClientsFromHandlers(List<ucl_LegalAdvisorHandler> JSONToHandlerResults){
        List<ucl_Client__c> CustomObjectClientResults = new List<ucl_Client__c>();
        
        for (ucl_LegalAdvisorHandler advisorHandler : JSONToHandlerResults){
            for(ucl_ClientHandler ClientHandler: advisorHandler.Clients){
            	ucl_Client__c CustomObjectClient = createCustomClient(ClientHandler,advisorHandler.Id);
                CustomObjectClientResults.add(CustomObjectClient);    
            }
            break;
        }
        
        return CustomObjectClientResults;
    }
    
    /*recieve the Date as the string value of the JSON
	and parse it into a Date format ready to insert into the 
	data base, the Date format in the JSON response is month/day/year so
	Date.parse or Date.valueOf would throw an exeption, to counter
	that problem we split the JSON date and re organize-it into a 
	valid format
	*/
    public static Date stringToDate(String dateAsString){
        List<String> splitDate = dateAsString.split('/');
        //build a new date in the format of: year-month-day
		Date toDate = Date.newInstance(Integer.valueOf(splitDate[2]), Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]));
        return toDate;
    }
    
    public static ucl_Legal_Advisor__c createCustomAdvisorFromHandler(ucl_LegalAdvisorHandler advisorHandler){
        ucl_Legal_Advisor__c CustomLegalAdvisor = new ucl_Legal_Advisor__c(Name=advisorHandler.AccountName,
                                                                       Account_Number__c=advisorHandler.AccountNumber,
                                                                       Account_Status__c=advisorHandler.AccountStatus, 
                                                                       As_of_Date__c=stringToDate(advisorHandler.AsOfDate),
                                                                       Created_By_Admin__c=false);
        return CustomLegalAdvisor;
    }
    
    public static ucl_Client__c createCustomClient(ucl_ClientHandler ClientHandler,Id LegalAdvisorId){
        ucl_Client__c CustomObjectClient = new ucl_Client__c(Name=ClientHandler.FirstName + ClientHandler.LastName,
                                                                 Client_Number__c=ClientHandler.ClientNumber,
                                                                 First_Name__c=ClientHandler.FirstName,
                                                                 Last_Name__c=ClientHandler.LastName,
                                                                 Email__c=ClientHandler.Email,
                                                                 Phone__c=ClientHandler.Phone,
                                                                 Addres__c=ClientHandler.Address,
                                                                 Asesored_By__c=LegalAdvisorId);
        return CustomObjectClient;
    }
}