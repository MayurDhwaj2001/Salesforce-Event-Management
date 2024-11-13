trigger RegistrationTrigger on Registration__c (after insert) {
    // Create a map to hold the event Ids and their updated capacities
    Map<Id, Event__c> eventsToUpdate = new Map<Id, Event__c>();

    // Loop through the newly inserted registrations
    for (Registration__c registration : Trigger.new) {
        // Get the related event record
        Event__c event = [SELECT Id, Available_Capacity__c, Status__c FROM Event__c WHERE Id = :registration.Event__c LIMIT 1];

        // Decrement the available capacity by 1
        event.Available_Capacity__c -= 1;

        // If available capacity is 0, update the event status to "Sold Out"
        if (event.Available_Capacity__c == 0) {
            event.Status__c = 'Sold Out';
        }

        // Add the event to the map for updating after all registrations have been processed
        eventsToUpdate.put(event.Id, event);
    }

    // Update the events with the new available capacities and status if needed
    update eventsToUpdate.values();
}
