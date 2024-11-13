import { LightningElement, track } from 'lwc';
import createEvent from '@salesforce/apex/EventController.createEvent'; // Apex method

export default class EventCreationForm extends LightningElement {
    @track eventName = '';
    @track eventDate = '';
    @track location = '';
    @track maxCapacity = 0;

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleEventCreation() {
        createEvent({ 
            name: this.eventName, 
            date: this.eventDate, 
            location: this.location, 
            maxCapacity: this.maxCapacity 
        })
        .then(() => {
            this.showToast('Success', 'Event created successfully', 'success');
            this.clearForm();
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
    }

    clearForm() {
        this.eventName = '';
        this.eventDate = '';
        this.location = '';
        this.maxCapacity = 0;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}
