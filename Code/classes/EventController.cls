public with sharing class EventController {

    // Method to create an Event
    @AuraEnabled
    public static void createEvent(String name, Date mydate, String location, Integer maxCapacity) {
        Event__c newEvent = new Event__c(
            Name = name,
            Event_Date__c = mydate,
            Location__c = location,
            Maximum_Capacity__c = maxCapacity,
            Available_Capacity__c = maxCapacity // initialize available capacity to max capacity
        );
        insert newEvent;
    }

    // Method to fetch available events for registration (only events with capacity greater than zero)
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getAvailableEvents() {
        return [
            SELECT Id, Name, Available_Capacity__c 
            FROM Event__c 
            WHERE Available_Capacity__c > 0
        ];
    }

    // Method to register a participant for an event
    @AuraEnabled
    public static void registerForEvent(Id eventId, String participantName, String email) {
        // Fetch the Event record to verify capacity
        Event__c event = [SELECT Id, Available_Capacity__c FROM Event__c WHERE Id = :eventId FOR UPDATE];
        
        if (event.Available_Capacity__c > 0) {
            // Create the Registration record if capacity is available
            Registration__c newRegistration = new Registration__c(
                Event__c = eventId,
                Participant_Name__c = participantName,
                Email__c = email,
                Status__c = 'Registered'
            );
            insert newRegistration;

            // Update the event's available capacity
            event.Available_Capacity__c -= 1;

            if (event.Available_Capacity__c == 0) {
                event.Status__c = 'Sold Out';
            }

            update event;
        } else {
            // If no capacity, throw an exception
            throw new AuraHandledException('The selected event is sold out.');
        }
    }
}
