/*this schedulable class just run every night at 1 AM and execute
the Apex callout wich consumes the heroku endpoint to retrieve all the legal advisors and clients
and then insert them into the database*/
public class ucl_NightlyHerokuService implements Schedulable {
	public void execute(SchedulableContext ctx) {
        try{
        	ucl_HerokuService.doGet();    
        } catch (Exception e){
            ucl_LogHandler.saveLog('Something went wrong during the nightly execution of the Heroku service', e.getMessage(), 'ucl_NightylHerokuService');
            ucl_LogHandler.sendEmail();
        }
    }
}