/*An Apex Callout wich consumes the public Heroku endpoint on demand and
insert the records into the database.
the 'NightlyHerokuService' is just an Scheduled Apex class wich execute
this callout every night.*/
public class ucl_HerokuService {
    
    public static void doGet(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            /*parse the JSON response into a List of Handlers and then into a list of 'ucl_Legal_Advisor__c',
            parsing from JSON -> Handler -> CustomObject compatible with the insert.
            The motive behind this is that the JSON response has different field names comparing to the 'ucl_Legal_Advisor__c' field names
            So the Handler object helps as a bridge between the JSON and the Custom Object*/
            List<ucl_Legal_Advisor__c> JSONToCustomObjectResults = ucl_LegalAdvisorHandler.parseFromJSONtoCustomObject(response.getBody());

            insert JSONToCustomObjectResults;
        }
	}
}