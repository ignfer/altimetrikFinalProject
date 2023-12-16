@isTest
public class ucl_ResponseValidationHandler_Test {
	private static String forceValidResponse = '[{"AccountNumber":"a209ebbb-39c6-4852-8732-82237c0674fb","AccountName":"Fadeo","AccountStatus":"Enabled","AsOfDate":"2/20/2023","Clients":[{"FirstName":"Merrel","LastName":"Hewes","Email":"mhewes1@paypal.com","Phone":"246-738-5648","Address":"003 Moland Way","ClientNumber":"735add3a-0684-4bd9-beda-04dfb7575ed9"},{"FirstName":"Van","LastName":"McTeer","Email":"vmcteer2@hhs.gov","Phone":"421-793-9612","Address":"2 Oneill Point","ClientNumber":"fe83f246-ff94-4895-8306-55eb4d0eb26a"},{"FirstName":"Ebenezer","LastName":"Dyer","Email":"edyer3@pinterest.com","Phone":"597-831-0857","Address":"221 North Drive","ClientNumber":"2e66f1c8-1100-463f-9fd0-0a53ea57bad1"},{"FirstName":"Brody","LastName":"Moseby","Email":"bmoseby4@blogtalkradio.com","Phone":"937-383-6950","Address":"848 Magdeline Terrace","ClientNumber":"70f194d5-5106-4302-a65a-75cccc1c3328"},{"FirstName":"Ami","LastName":"Kneafsey","Email":"akneafsey5@tripadvisor.com","Phone":"479-131-3563","Address":"376 Vermont Parkway","ClientNumber":"055db4ba-992c-46bf-80fc-5c9f1cd35287"}]}]';
    /*
     * provides a force response with a disabled status legal advisor
	*/
    private static String forceValidResponseDisabled = '[{"AccountNumber":"a209ebbb-39c6-4852-8732-82237c0674fb","AccountName":"Fadeo","AccountStatus":"Disabled","AsOfDate":"2/20/2023","Clients":[{"FirstName":"Merrel","LastName":"Hewes","Email":"mhewes1@paypal.com","Phone":"246-738-5648","Address":"003 Moland Way","ClientNumber":"735add3a-0684-4bd9-beda-04dfb7575ed9"},{"FirstName":"Van","LastName":"McTeer","Email":"vmcteer2@hhs.gov","Phone":"421-793-9612","Address":"2 Oneill Point","ClientNumber":"fe83f246-ff94-4895-8306-55eb4d0eb26a"},{"FirstName":"Ebenezer","LastName":"Dyer","Email":"edyer3@pinterest.com","Phone":"597-831-0857","Address":"221 North Drive","ClientNumber":"2e66f1c8-1100-463f-9fd0-0a53ea57bad1"},{"FirstName":"Brody","LastName":"Moseby","Email":"bmoseby4@blogtalkradio.com","Phone":"937-383-6950","Address":"848 Magdeline Terrace","ClientNumber":"70f194d5-5106-4302-a65a-75cccc1c3328"},{"FirstName":"Ami","LastName":"Kneafsey","Email":"akneafsey5@tripadvisor.com","Phone":"479-131-3563","Address":"376 Vermont Parkway","ClientNumber":"055db4ba-992c-46bf-80fc-5c9f1cd35287"}]}]';
    /*
     * provides a force response with 4 clients instead of the original 5
	*/
    private static String forceValidResponseDiffClient = '[{"AccountNumber":"a209ebbb-39c6-4852-8732-82237c0674fb","AccountName":"Fadeo","AccountStatus":"Disabled","AsOfDate":"2/20/2023","Clients":[{"FirstName":"Merrel","LastName":"Hewes","Email":"mhewes1@paypal.com","Phone":"246-738-5648","Address":"003 Moland Way","ClientNumber":"735add3a-0684-4bd9-beda-04dfb7575ed9"},{"FirstName":"Van","LastName":"McTeer","Email":"vmcteer2@hhs.gov","Phone":"421-793-9612","Address":"2 Oneill Point","ClientNumber":"fe83f246-ff94-4895-8306-55eb4d0eb26a"},{"FirstName":"Ebenezer","LastName":"Dyer","Email":"edyer3@pinterest.com","Phone":"597-831-0857","Address":"221 North Drive","ClientNumber":"2e66f1c8-1100-463f-9fd0-0a53ea57bad1"},{"FirstName":"Brody","LastName":"Moseby","Email":"bmoseby4@blogtalkradio.com","Phone":"937-383-6950","Address":"848 Magdeline Terrace","ClientNumber":"70f194d5-5106-4302-a65a-75cccc1c3328"}]}]';
    
    @isTest
    static void testGetCustomClientsToDelete(){
        List<ucl_LegalAdvisorHandler> results = ucl_HerokuResponseHandler.parseFromJSONtoHandler(forceValidResponse);
        List<ucl_Legal_Advisor__c> customObjectLegalAdvisor = ucl_HerokuResponseHandler.getLegalAdvisorsFromHandlers(results);
        insert customObjectLegalAdvisor;
        results[0].Id = customObjectLegalAdvisor[0].Id;
        List<ucl_Client__c> customObjectClient = ucl_HerokuResponseHandler.getClientsFromHandlers(results);
        insert customObjectClient;
        
        List<ucl_Client__c> clientsToDelete = ucl_ResponseValidationHandler.getCustomClientsToDelete(customObjectClient);
    }
    
    @isTest
    static void testDisabledLegalAdvisor(){
        List<ucl_LegalAdvisorHandler> results = ucl_HerokuResponseHandler.parseFromJSONtoHandler(forceValidResponseDisabled);
        List<ucl_Legal_Advisor__c> customObjectLegalAdvisor = ucl_HerokuResponseHandler.getLegalAdvisorsFromHandlers(results);
        insert customObjectLegalAdvisor;
    }
    
    @isTest
    static void testWithNoIncomingClients(){
        List<ucl_LegalAdvisorHandler> results = ucl_HerokuResponseHandler.parseFromJSONtoHandler(forceValidResponse);
        List<ucl_Legal_Advisor__c> customObjectLegalAdvisor = ucl_HerokuResponseHandler.getLegalAdvisorsFromHandlers(results);
        insert customObjectLegalAdvisor;
        results[0].Id = customObjectLegalAdvisor[0].Id;
        List<ucl_Client__c> customObjectClient = ucl_HerokuResponseHandler.getClientsFromHandlers(results);
        insert customObjectClient;
        
        List<ucl_Client__c> customObjectClientEmpty = new List<ucl_Client__c>();
        
        List<ucl_Client__c> clientsToDelete = ucl_ResponseValidationHandler.getCustomClientsToDelete(customObjectClientEmpty);
    }
}