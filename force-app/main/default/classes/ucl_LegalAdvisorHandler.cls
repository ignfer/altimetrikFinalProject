public class ucl_LegalAdvisorHandler {
    public String AccountNumber {get; set;}
	public String AccountName {get; set;}
	public String AccountStatus {get; set;}
	public String AsOfDate {get; set;}
	public List<ucl_ClientHandler> Clients {get; set;}
    
	public class ucl_ClientHandler {
		public String FirstName {get; set;}
		public String LastName {get; set;}
		public String Email {get; set;}
		public String Phone {get; set;}
		public String Address {get; set;}
		public String ClientNumber {get; set;}
	}
    
    public static List<ucl_LegalAdvisorHandler> parseFromJSONtoHandler(String json) {
		return (List<ucl_LegalAdvisorHandler>) System.JSON.deserialize(json, List<ucl_LegalAdvisorHandler>.class);
	}
    
    public static List<ucl_Legal_Advisor__c> parseFromJSONtoCustomObject(String json) {
		//retrieve the list of LegalAdvisorHandlers contained on the JSON response
        List<ucl_LegalAdvisorHandler> resultsHandler = ucl_LegalAdvisorHandler.parseFromJSONtoHandler(json);
        //creates a new list to allocate the 'ucl_Legal_Advisor__c' created from the handlers
        List<ucl_Legal_Advisor__c> resultsCustom = new List<ucl_Legal_Advisor__c>();
        //for each handler creates a custom object compatible with an insert operation
        for (ucl_LegalAdvisorHandler advisor : resultsHandler){
            Date testDate = Date.today();
            ucl_Legal_Advisor__c newAdvisor = new ucl_Legal_Advisor__c(Name=advisor.AccountNumber,Account_Name__c=advisor.AccountName,Account_Status__c=advisor.AccountStatus, As_of_Date__c=testDate);
            resultsCustom.add(newAdvisor);
        }
        
        return resultsCustom;
	}
}