public class ucl_LegalAdvisorHandler {
    public String Id {get; set;}
    public String AccountNumber {get; set;}
    public String AccountName {get; set;}
    public String AccountStatus {get; set;}
    public String AsOfDate {get; set;}
    public List<ucl_ClientHandler> Clients {get; set;}
}