import { LightningElement, track, wire } from 'lwc';
import getAvailableEvents from '@salesforce/apex/EventController.getAvailableEvents';
import registerForEvent from '@salesforce/apex/EventController.registerForEvent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EventRegistrationForm extends LightningElement {
    @track eventOptions = [];
    @track selectedEvent = '';
    @track participantName = '';
    @track email = '';

    @wire(getAvailableEvents)
    wiredEvents({ error, data }) {
        if (data) {
            this.eventOptions = data.map(event => ({ label: event.Name, value: event.Id }));
        } else if (error) {
            this.showToast('Error', 'Failed to load events', 'error');
        }
    }

    handleEventSelection(event) {
        this.selectedEvent = event.target.value;
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleRegistration() {
        registerForEvent({ 
            eventId: this.selectedEvent, 
            participantName: this.participantName, 
            email: this.email 
        })
        .then(() => {
            this.showToast('Success', 'Registration successful!', 'success');
            this.clearForm();
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
    }

    clearForm() {
        this.selectedEvent = '';
        this.participantName = '';
        this.email = '';
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
