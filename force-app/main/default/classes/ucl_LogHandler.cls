/*
 * The handler for the logs, offers an easy way to store incoming logs into the
 * database and a method to erase old logs
*/
public with sharing class ucl_LogHandler {
    @AuraEnabled
    public static void saveLog(String description, String message, String location){
        ucl_Log__c logToSave = new ucl_Log__c(Description__c = description,
                                             Message__c = message,
                                             Location__c = location,
                                             Time__c = System.now());
        insert logToSave;
    }
    
    public void checkAndDeleteOldLogs(){
        DateTime currentDate = System.now();
		DateTime oneMonthAgo = currentDate.addMonths(-1);
        
        List<ucl_Log__c> oldLogs = [SELECT Id from ucl_Log__c where Time__c < :oneMonthAgo];
        delete oldLogs;
    }
    
    public static void sendEmail(){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'nachofernandezuru@gmail.com'});
        email.setSubject('An error occurred ');
        email.setPlainTextBody('Something went wrong during the execution of the Heroku Service, the error log is already saved in the database for further information');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    } 
}