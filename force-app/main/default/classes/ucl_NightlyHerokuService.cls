/*this schedulable class just run every night at 1 AM and execute
the Apex callout wich consumes the heroku endpoint to retrieve all the legal advisors and clients
and then insert them into the database*/
public class ucl_NightlyHerokuService implements Schedulable {
	public void execute(SchedulableContext ctx) {
        ucl_HerokuService.doGet();
    }
}