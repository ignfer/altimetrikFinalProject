import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import doGet from '@salesforce/apex/ucl_HerokuService.doGet';
import saveLog from '@salesforce/apex/ucl_LogHandler.saveLog';

export default class Ucl_RunHerokuServiceManually extends LightningElement {

    @api description_ref = 'Something went wrong during the heroku service execution';
    @api message_ref = 'The manual execution of the heroku service failed';
    @api location_ref = 'ucl_HerokuService';
    
    handleClick(){
        doGet()
            .then(() => {
                const event = new ShowToastEvent({
                    title: 'Service executed successfully!',
                    message: 'The data from the heroku service was loaded',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            })
            .catch((error) => {
                this.handleSaveLog();
            })
    }

    handleSaveLog(){
        saveLog({description : this.description_ref,
            message : this.message_ref,
            location : this.location_ref})
            .then(() => {
                const event = new ShowToastEvent({
                    title : 'Error',
                    message : 'An error has occurred executing the service, check the logs for more information',
                    variant : 'error'
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title : 'Error',
                    message : 'An error has occurred executing the service and the log couldnt be create, contact your System Administrator',
                    variant : 'error'
                });
                this.dispatchEvent(event); 
            });
    }
}