@isTest
private class ucl_LegalAdvisorHandler_Test {
	@isTest
    static void testGettersAndSetters(){
        ucl_LegalAdvisorHandler testLegalAdvisor = new ucl_LegalAdvisorHandler();
        
        testLegalAdvisor.Id = '001xx000003DGbHAAW';
        testLegalAdvisor.AccountName = 'AccountName__test';
        testLegalAdvisor.AccountNumber = 'AccountNumber__test';
        testLegalAdvisor.AccountStatus = 'AccountStatus__test';
        testLegalAdvisor.AsOfDate = 'AsOfDate__test';
        
        //create the client for the test
        ucl_ClientHandler testClient = new ucl_ClientHandler();
        
        testClient.FirstName = 'FirstName__test';
        testClient.LastName = 'LastName__test';
        testClient.Email = 'Email__test';
        testClient.Phone = 'Phone__test';
        testClient.Address = 'Address__test';
        testClient.ClientNumber = 'ClientNumber__test';
        
        testLegalAdvisor.Clients.add(testClient);
        
        System.assertEquals('001xx000003DGbHAAW', testLegalAdvisor.Id, 'An error has occurred setting or getting the Id property');
        System.assertEquals('AccountName__test', testLegalAdvisor.AccountName, 'An error has occurred setting or getting the AccountName property');
        System.assertEquals('AccountNumber__test', testLegalAdvisor.AccountNumber, 'An error has occurred setting or getting the AccountNumber property');
        System.assertEquals('AccountStatus__test', testLegalAdvisor.AccountStatus, 'An error has occurred setting or getting the AccountStatus property');
        System.assertEquals('AsOfDate__test', testLegalAdvisor.AsOfDate, 'An error has occurred setting or getting the AsOfDate property');
        System.assertEquals(1, testLegalAdvisor.Clients.size(), 'An error has occurred setting or getting the Clients property');
    }
}