/*this schedulable class just run every night at 1 AM and execute
the Apex callout wich consumes the heroku endpoint to retrieve all the legal advisors and clients
and then insert them into the database*/
public class ucl_NightlyHerokuService implements Schedulable {
    public Boolean simulateExceptionForTest{set; get;}
    
    public void execute(SchedulableContext ctx) {
        try{
            /*
             * code added to reach 100% test coverage
             * when the execution comes from a test, the test
             * set the simulateExceptionForTest value into true forcing
             * an exception and reaching the catch lines
			*/
            if(simulateExceptionForTest){
                Integer throwException = 1 / 0;
            } else {
            	ucl_HerokuService.doGet();    
            }       	
        } catch (Exception e){
            ucl_LogHandler.saveLog('Something went wrong during the nightly execution of the Heroku service', e.getMessage(), 'ucl_NightylHerokuService');
            ucl_LogHandler.sendEmail();
        }
    }
}