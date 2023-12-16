![Ignacio Fernandez logo](https://github.com/ignfer/altimetrikFinalProject/blob/main/IF_logo.png)
# Project description 🤔

Universal Containers Lawyers is a company that provides legal advisory to their customers.
**They consume data from an external system that stores the information into Heroku on a daily
basis.** They want to adopt Salesforce and need to migrate the information stored in Heroku into an org.
**The data is retrieved as a JSON, and contains two types of entities: ‘Legal Advisor’, and ‘Client’.**
There is a **web service in Heroku** that contains the json file. Also, given that this information
changes periodically, they need a way to **do this process automatically every day.**
Legal Advisors are firms that provide legal services to different clients. Clients are the ones that
hire the advisors services.

---

# Features ☑️
* Custom object for the Legal Advisor
* Custom object for the Clients
* Master-Detail relationship between Legal Advisor and his Clients
* Error Handling and stored Logs
* Nightly execution service
* Email alerts if the nightly service execution fails
* Lightning Web Componen to manually run the service
* Custom UCL app
* 75%+ code coverage



