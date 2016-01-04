// Notes on test setup
// These test classes require/assume the following:
// 1. There is at least one active user in the first two roles specified
//      in the list of TaskCounterRoles__c objects intiailized in intializeData
//      (see approx lines 27-31)
// 2. There is at least one active user in the role 'SDR MSP Recruiter' and
//      'Channel Development Manager' for tests TestAppointments1 and TestAppointments2
// If activity custom formula IsAppointment__c is changed, you may need to modify
// the code in TestAppointments1 and TestAppointments2. 
// The first role specified in each must match the Created_By_Role__c condition in the formula.
// The second role specified in each must match one of the Assigned_To_Role__c conditions in the formula.
@istest
public class TaskCounterTests {

    @testsetup
    static void initializeData()
    {
        Contact ct = new Contact(LastName = 'testct');
        Lead ld = new Lead(LastName = 'testld', Email = 'testld@testemail.com', Company='testcomp');
        insert ct;
        insert ld;
        List<Campaign> camps = new List<Campaign>{
            new Campaign(Name = 'testcamp', IsActive = true),
            new Campaign(Name = 'testcamp2', IsActive = true)
            };
        insert camps;
        List<CampaignMember> cms = new List<CampaignMember>{
            new CampaignMember(ContactID = ct.id, CampaignID = camps[0].id, FCRM__FCR_Response_Date__c = DateTime.Now(), FCRM__FCR_Response_Status__c = 'Working'),
            new CampaignMember(LeadID = ld.id, CampaignID = camps[0].id, FCRM__FCR_Response_Date__c = DateTime.Now(), FCRM__FCR_Response_Status__c = 'Working')
            };
        insert cms;
        List<TaskCounterRoles__c> roleinfo = new List<TaskCounterRoles__c>{
            new TaskCounterRoles__c(Name='Territory Sales Manager', Role__c='Territory Sales Manager'),
            new TaskCounterRoles__c(Name='Channel Development Manager', Role__c='Channel Development Manager'),
            new TaskCounterRoles__c(Name='Partner Recruiter', Role__c='Partner Recruiter'),
            new TaskCounterRoles__c(Name='Demand Gen Specialist', Role__c='Demand Gen Specialist'),
            new TaskCounterRoles__c(Name='Territory Sales Executive', Role__c='Territory Sales Executive')
        };
        insert roleinfo;
        
    }


   /* @istest
    public static void TestAppointments1()
    {
        Map<String, User> testRoles = getUsersForRoles(new List<String>{'SDR MSP Recruiter','Channel Development Manager'});
        //system.AssertEquals(2, testRoles.size());   // Make sure we got them both
        system.RunAs(testRoles.get('SDR MSP Recruiter'))
        {
            // Run as the demand gen specialist
            List<Contact> testContacts = [Select ID from Contact];
            
            Task testTask = new Task(WhoID = testContacts[0].id, ownerID = testRoles.get('Channel Development Manager').id);
            insert testTask;
            
            Task theTask = [Select ID, CreatedByID, OwnerID, Assigned_To_Role__c, Created_by_Role__c, IsAppointment__c from Task where ID = :testTask.id];
            system.debug('created by ' + theTask.CreatedByID);
            system.debug('owner id ' + theTask.OwnerID);
            system.debug('assigned to role ' + theTask.Assigned_To_Role__c);
            system.debug('created by role ' + theTask.Created_by_Role__c);
            system.Assert(theTask.IsAppointment__c);
            
            Task testTaskResult = [Select ID, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID = :testTask.id];
            system.Assert(testTaskResult.Active_Response_ID__c != null);
            system.AssertEquals('testcamp', testTaskResult.Active_Response_Campaign__c);
            CampaignMember cm = [Select ID, Task_Appointments__c from CampaignMember where ID = :testTaskResult.Active_Response_ID__c];
            system.AssertEquals(1, cm.Task_Appointments__c);
        }
    }

    @istest
    public static void TestAppointments2()
    {
        Map<String, User> testRoles = getUsersForRoles(new List<String>{'SDR MSP Recruiter','Channel Development Manager'});
        //system.AssertEquals(2, testRoles.size());   // Make sure we got them both
        system.RunAs(testRoles.get('SDR MSP Recruiter'))
        {
            // Run as the demand gen specialist
            List<Lead> testLeads = [Select ID from Lead];
            
            Task testTask = new Task(WhoID = testLeads[0].id, ownerID = testRoles.get('Channel Development Manager').id);
            insert testTask;
            
            Task theTask = [Select ID, CreatedByID, OwnerID, Assigned_To_Role__c, Created_by_Role__c, IsAppointment__c from Task where ID = :testTask.id];
            system.debug('created by ' + theTask.CreatedByID);
            system.debug('owner id ' + theTask.OwnerID);
            system.debug('assigned to role ' + theTask.Assigned_To_Role__c);
            system.debug('created by role ' + theTask.Created_by_Role__c);
            system.Assert(theTask.IsAppointment__c);
            
            Task testTaskResult = [Select ID, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID = :testTask.id];
            system.Assert(testTaskResult.Active_Response_ID__c != null);
            system.AssertEquals('testcamp', testTaskResult.Active_Response_Campaign__c);
            CampaignMember cm = [Select ID, Task_Appointments__c from CampaignMember where ID = :testTaskResult.Active_Response_ID__c];
            system.AssertEquals(1, cm.Task_Appointments__c);
        }
    }*/

    /*@istest
    public static void TestActivityCounter1()
    {
        Map<String, TaskCounterRoles__c> allConfiguredRoles = TaskCounterRoles__c.getAll();
        List<String> allRoles = new List<String>();
        for(TaskcounterRoles__c tcr: allConfiguredRoles.values()) allRoles.add(tcr.Role__c);
        
        
        Map<String, User> testRoles = getUsersForRoles(new List<String>{allRoles[0],allRoles[1]});
        system.AssertEquals(2, testRoles.size());   // Make sure we got them both
        system.RunAs(testRoles.get(allRoles[0]))
        {
            // Run as the demand gen specialist
            List<Contact> testContacts = [Select ID from Contact];
            
            Task testTask = new Task(WhoID = testContacts[0].id, Status='Completed', ownerID = testRoles.get(allRoles[1]).id);
            insert testTask;
            
            Task testTaskResult = [Select ID, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID = :testTask.id];
            system.Assert(testTaskResult.Active_Response_ID__c != null);
            system.AssertEquals('testcamp', testTaskResult.Active_Response_Campaign__c);
            CampaignMember cm = [Select ID, Activity_Counter__c from CampaignMember where ID = :testTaskResult.Active_Response_ID__c];
            system.AssertEquals(1, cm.Activity_Counter__c);
        }
    }

    @istest
    public static void TestActivityCounter2()
    {
        Map<String, TaskCounterRoles__c> allConfiguredRoles = TaskCounterRoles__c.getAll();
        List<String> allRoles = new List<String>();
        for(TaskcounterRoles__c tcr: allConfiguredRoles.values()) allRoles.add(tcr.Role__c);
        
        
        Map<String, User> testRoles = getUsersForRoles(new List<String>{allRoles[0],allRoles[1]});
        system.AssertEquals(2, testRoles.size());   // Make sure we got them both
        system.RunAs(testRoles.get(allRoles[0]))
        {
            // Run as the demand gen specialist
            List<Lead> testLeads = [Select ID from Lead];
            
            Task testTask = new Task(WhoID = testLeads[0].id, Status='Completed', ownerID = testRoles.get(allRoles[1]).id);
            insert testTask;
            
            Task testTaskResult = [Select ID, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID = :testTask.id];
            system.Assert(testTaskResult.Active_Response_ID__c != null);
            system.AssertEquals('testcamp', testTaskResult.Active_Response_Campaign__c);
            CampaignMember cm = [Select ID, Activity_Counter__c from CampaignMember where ID = :testTaskResult.Active_Response_ID__c];
            system.AssertEquals(1, cm.Activity_Counter__c);
        }
    }

    @istest
    public static void TestActivityCounter3()
    {
        Map<String, TaskCounterRoles__c> allConfiguredRoles = TaskCounterRoles__c.getAll();
        List<String> allRoles = new List<String>();
        for(TaskcounterRoles__c tcr: allConfiguredRoles.values()) allRoles.add(tcr.Role__c);
        
        
        Map<String, User> testRoles = getUsersForRoles(new List<String>{allRoles[0],allRoles[1]});
        system.AssertEquals(2, testRoles.size());   // Make sure we got them both
        system.RunAs(testRoles.get(allRoles[0]))
        {
            // Run as the demand gen specialist
            List<Lead> testLeads = [Select ID from Lead];
            
            Task testTask = new Task(WhoID = testLeads[0].id, Status='Completed', ownerID = testRoles.get(allRoles[0]).id);
            
            insert testTask;
            Task queriedTask = [Select ID, Status from Task where ID = :testTask.ID];
            queriedTask.Status='Completed';
            update queriedTask;
            
            
            Task testTaskResult = [Select ID, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID = :testTask.id];
            system.Assert(testTaskResult.Active_Response_ID__c != null);
            system.AssertEquals('testcamp', testTaskResult.Active_Response_Campaign__c);
            CampaignMember cm = [Select ID, Activity_Counter__c from CampaignMember where ID = :testTaskResult.Active_Response_ID__c];
            system.AssertEquals(1, cm.Activity_Counter__c);
        }
    }*/



    private static Map<String, User> getUsersForRoles(List<String> roles)
    {
        Map<String, User> results = new Map<String, User>();
        List<User> users = [Select ID, UserRole.Name from User where UserRole.Name in :roles and IsActive=True];
        for(User u: users)
        {
            if(!results.containsKey(u.UserRole.Name)) results.put(u.UserRole.Name, u);
        }
        return results;
    }


}