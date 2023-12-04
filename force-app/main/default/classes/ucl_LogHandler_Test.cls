@isTest
public class ucl_LogHandler_Test {
	@isTest
    static void testSaveLog(){
        ucl_LogHandler.saveLog('description__test',
                              'message__test',
                              'location__test');
        ucl_Log__c insertedLog = [SELECT Description__c,
                                 Message__c,
                                 Location__c 
                                 FROM ucl_Log__c
                                 WHERE Description__c = 'description__test' AND
                                 Message__c = 'message__test' AND
                                 Location__c = 'location__test'];
        
        System.assertEquals('message_test', insertedLog.Message__c);
    }
    
    @isTest
    static void testCheckAndDeleteOldLogs(){
        DateTime currentDate = System.now();
		DateTime oneMonthAgo = currentDate.addMonths(-1);
        
        ucl_LogHandler.checkAndDeleteOldLogs();
        
        List<ucl_Log__c> oldLogs = [SELECT Id from ucl_Log__c where Time__c < :oneMonthAgo];
        System.assertEquals(0,oldLogs.size());
    }
    
    @isTest
    static void testSendEmail(){
		Test.startTest();
        ucl_LogHandler.sendEmail();        
        Test.stopTest();
        
        List<EmailMessage> sentEmail = [SELECT ToAddress FROM EmailMessage];
        
        System.assertEquals(1, sentEmail.size());
        //System.assertEquals('nachofernandezuru@gmail.com', sentEmails[0].ToAddress);
        //System.assertEquals('An error occurred', sentEmails[0].Subject);
        //System.assertEquals('Something went wrong during the execution of the Heroku Service, the error log is already saved in the database for further information', sentEmails[0].PlainTextBody);
        
    }
}