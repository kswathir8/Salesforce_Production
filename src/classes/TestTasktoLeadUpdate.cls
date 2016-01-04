@isTest

public class TestTasktoLeadUpdate{


 // Class:TestTasktoLeadUpdate(Swathi Karkala)
  
 //Test Method for TestTasktoLeadUpdate
 
 public static testMethod void TestTasktoLeadUpdate(){
 
 Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient';  
               ld.sales_appointment_checkbox__c=True;
               ld.status ='Working';  
               ld.transfer_lead__c=false;               
               ld.Requalify_Date_Time__c = datetime.now();     
               insert ld;
               
               
               
               Task ts = new Task();
               ts.OwnerId = UserInfo.getUserId();
               ts.Subject='Donni';
               ts.Priority = 'Low';
               ts.Status = 'No Show';
               ts.attended__c = true;
               insert ts;
               
               List<Task> tk=new List<Task>();
               tk.add(ts);
               
               Map<ID,Task> testmap1=new Map<ID,Task>();
               
               Map<ID,Task> testmap2=new Map<ID,Task>();
               
               TasktoLeadUpdate test=new TasktoLeadUpdate();
               
               //test.UpdateLead(tk,testmap1,testmap2);
 
 }

}