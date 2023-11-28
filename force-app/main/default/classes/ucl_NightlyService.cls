public class ucl_NightlyService implements Schedulable {
	public void execute(SchedulableContext ctx) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            //PLACE HOLDER CODE - LOGIC NOT WORKING YET
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'advisors' key as a list
            List<Object> advisors = (List<Object>) results.get('advisors');
            System.debug('Received the following Legal Advisors:');
            for(Object advisor: advisors) {
                System.debug(advisor);
            }
        }
    }
}