@isTest
private class ucl_ClientHandler_Test {
	@isTest
    static void testGettersAndSetters(){
        ucl_ClientHandler testClient = new ucl_ClientHandler();
        
        testClient.FirstName = 'FirstName__test';
        testClient.LastName = 'LastName__test';
        testClient.Email = 'Email__test';
        testClient.Phone = 'Phone__test';
        testClient.Address = 'Address__test';
        testClient.ClientNumber = 'ClientNumber__test';
        
        System.assertEquals('FirstName__test', testClient.FirstName, 'An error has occurred setting or getting the FirstName property');
        System.assertEquals('LastName__test', testClient.LastName, 'An error has occurred setting or getting the LastName property');
        System.assertEquals('Email__test', testClient.Email, 'An error has occurred setting or getting the Email property');
        System.assertEquals('Phone__test', testClient.Phone, 'An error has occurred setting or getting the Phone property');
        System.assertEquals('Address__test', testClient.Address, 'An error has occurred setting or getting the Address property');
        System.assertEquals('ClientNumber__test', testClient.ClientNumber, 'An error has occurred setting or getting the ClientNumber property'); 
    }
}