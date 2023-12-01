/*
 * responsible for the validation of the incoming or entering data
*/
public class ucl_ResponseValidationHandler {
    
    /*
     * maps the already existent and enabled accounts, then for each of the legal advisors handlers recieved,
     * ask if its compatible with the isEnabled validation, and if it is, put it in the valid Advisors group and
     * return it. Removing invalid advisors as soon as the parsing is done avoid us working with extra data that
     * wouldn't end in the database annyways 
	*/
    public static List<ucl_LegalAdvisorHandler> getValidAdvisors(List<ucl_LegalAdvisorHandler> legalAdvisors){
        List<ucl_LegalAdvisorHandler> validAdvisors = new List<ucl_LegalAdvisorHandler>();
        //advisors accounts already in salesforce with the enabled status, used in the isEnabled validation
        Map<String,String> enabledAccountNumbers = new Map<String,String>();
        
        for( ucl_Legal_Advisor__c advisor : [SELECT Account_Number__c from ucl_Legal_Advisor__c where Account_Status__c = 'Enabled']){
            enabledAccountNumbers.put(advisor.Account_Number__c,advisor.Account_Number__c);
        }
        
        for(ucl_LegalAdvisorHandler legalAdvisor : legalAdvisors){
            if(isEnabled(legalAdvisor,enabledAccountNumbers)){
                validAdvisors.add(legalAdvisor);
            }
        }
        return validAdvisors;
    }
    
    /*
     * if an advisor account status is enabled or if is disabled but the account number was already
     * in the database 
	*/
    public static Boolean isEnabled(ucl_LegalAdvisorHandler advisor,Map<String,String> enabledAccountNumbers){
        if (advisor.AccountStatus == 'Enabled' || 
            advisor.AccountStatus == 'Disabled' && enabledAccountNumbers.containsKey(advisor.AccountNumber)){
            return true;
        }else{
            return false;
        }
    }
    
    /*
     * Maps the clients that will be proccessed 'enteringClients' and compares them
     * to the ones already saved in the database that weren't created by an admin, 
     * if a client exist on the database but doesn't exist on the entering clients, the client will be 
     * saved up for later deletion
	*/
    public static List<ucl_Client__c> getCustomClientsToDelete(List<ucl_Client__c> clients){
        
        List<ucl_Client__c> customClientsToDelete = new List<ucl_Client__c>();
        //clients already loaded in salesforce
        List<ucl_Client__c> alreadyExistentClients = [SELECT Id,Client_Number__c FROM ucl_Client__c WHERE Created_By_Admin__c = False];
        
        Map<String,String> enteringClients = new Map<String,String>();
        for(ucl_Client__c client : clients){
            enteringClients.put(client.Client_Number__c,client.Client_Number__c);
        }
		
        for(ucl_Client__c client : alreadyExistentClients){
            if(!enteringClients.containsKey(client.Client_Number__c)){
                customClientsToDelete.add(client);
            }
        }
        
        return customClientsToDelete;
    }

}