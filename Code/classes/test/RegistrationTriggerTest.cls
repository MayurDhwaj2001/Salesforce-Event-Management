@isTest
public class RegistrationTriggerTest {

    @isTest static void testEventCapacityUpdate() {
        // Create a new Event
        Event__c testEvent = new Event__c(
            Name = 'Test Event',
            Event_Date__c = Date.today(),
            Location__c = 'Test Location',
            Maximum_Capacity__c = 5,
            Available_Capacity__c = 5
        );
        insert testEvent;

        // Create registrations for the event
        List<Registration__c> registrations = new List<Registration__c>();
        for (Integer i = 0; i < 5; i++) {
            registrations.add(new Registration__c(
                Event__c = testEvent.Id,
                Participant_Name__c = 'Participant ' + i,
                Email__c = 'participant' + i + '@example.com',
                Status__c = 'Registered'
            ));
        }
        insert registrations;

        // Re-query the event after inserting registrations
        testEvent = [SELECT Id, Available_Capacity__c, Status__c FROM Event__c WHERE Id = :testEvent.Id];

        // Assert that the available capacity is 0 and status is 'Sold Out'
        System.assertEquals(0, testEvent.Available_Capacity__c, 'The event capacity should be 0.');
        System.assertEquals('Sold Out', testEvent.Status__c, 'The event status should be Sold Out.');
    }
}
