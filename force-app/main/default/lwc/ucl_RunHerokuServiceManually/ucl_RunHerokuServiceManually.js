import { LightningElement } from 'lwc';
import doGet from "@salesforce/apex/ucl_HerokuService.doGet";
export default class Ucl_RunHerokuServiceManually extends LightningElement {
    
    executionResult = 'Not executed yet.';
    
    handleClick(){
        doGet()
            .then(() => {
                this.executionResult = 'The data was successfully loaded.'
            })
            .catch((error) => {
                this.executionResult = 'An error has occurred during the execution.'
            })
    }
}