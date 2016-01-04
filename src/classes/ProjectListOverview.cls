public with sharing class ProjectListOverview {
    
    public String UserID {get;set;}
    public Profile superAdmin; 
    public UserRole adminRole;
    public List<User> users; 
    public ApexPages.StandardSetController activeProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT '+ getFeilds('Active') +' FROM Milestone1_Project__c Where Status__c=\'Active\' AND Active_Status__c IN (\'\',\'Coding in Development Sandbox\',\'Deployed to Full Sandbox\',\'Testing in Full Sandbox\') AND Release__r.Current_Release__c = false ORDER BY Owner.Name ASC'));
    public ApexPages.StandardSetController queueProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT '+ getFeilds('Queued') +' FROM Milestone1_Project__c Where Release__r.Current_Release__c = true ORDER BY Status__c ASC'));
    public ApexPages.StandardSetController onHoldProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT '+ getFeilds('OnHold') +' FROM Milestone1_Project__c Where Status__c=\'On Hold\' AND Release__r.Current_Release__c = false'));
    public ApexPages.StandardSetController completedProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT '+ getFeilds('Completed') +' FROM Milestone1_Project__c Where Status__c=\'Completed\' AND Release__r.Current_Release__c = false ORDER BY Release_Date__c DESC NULLS LAST '));
    public String sortField {get;set;}
    public String block {get;set;}
    public Map<String,Boolean> BlockToAscMap;
    
    public ProjectListOverview(){
        
        activeProjects.setPageSize(10);
        queueProjects.setPageSize(10);
        onHoldProjects.setPageSize(10);
        completedProjects.setPageSize(10);
        
        BlockToAscMap = new Map<String,Boolean>();
        BlockToAscMap.put('Active',true);
        BlockToAscMap.put('Queue',true);
        BlockToAscMap.put('OnHold',true);
        BlockToAscMap.put('Completed',true);
        
        superAdmin = [Select id From Profile Where Name = 'SUPER SYS ADMIN' ];
        adminRole = [Select id From UserRole Where Name = 'ADMIN'];
        users = [Select id,Name From User Where ProfileID = :superAdmin.id AND UserRoleID = :adminRole.id AND isActive = true];
    }
    
    public List<SelectOption> getUserOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('000000000000000','All Team Members'));
        for(User u: users){
            options.add(new SelectOption(u.id,u.name));
        }
        return options;
    }
    
    public PageReference changeOwnerShip(){
        if(UserID == '000000000000000'){
            activeProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Active') +' FROM Milestone1_Project__c Where Status__c=\'Active\' AND Active_Status__c IN (\'\',\'Coding in Development Sandbox\',\'Deployed to Full Sandbox\',\'Testing in Full Sandbox\') AND Release__r.Current_Release__c = false ORDER BY Owner.Name ASC'));
            queueProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Queued') +' FROM Milestone1_Project__c Where Release__r.Current_Release__c = true ORDER BY Status__c ASC'));
            onHoldProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('OnHold') +' FROM Milestone1_Project__c Where Status__c=\'On Hold\' AND Release__r.Current_Release__c = false'));
            completedProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Completed') +' FROM Milestone1_Project__c Where Status__c=\'Completed\' AND Release__r.Current_Release__c = false ORDER BY Release_Date__c DESC NULLS LAST'));
        }
        else{
            activeProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Active') +' FROM Milestone1_Project__c Where Status__c=\'Active\' AND OwnerID = \'' + USerID + '\' AND Active_Status__c IN (\'\',\'Coding in Development Sandbox\',\'Deployed to Full Sandbox\',\'Testing in Full Sandbox\') AND Release__r.Current_Release__c = false ORDER BY Owner.Name ASC'));
            queueProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Queued') +' FROM Milestone1_Project__c Where Release__r.Current_Release__c = true AND OwnerID = \'' + USerID + '\'  ORDER BY Status__c ASC'));
            onHoldProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('OnHold') +' FROM Milestone1_Project__c Where Status__c=\'On Hold\' AND OwnerID = \'' + USerID + '\' AND Release__r.Current_Release__c = false'));
            completedProjects = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,'+ getFeilds('Completed') +' FROM Milestone1_Project__c Where Status__c=\'Completed\' AND OwnerID = \'' + USerID + '\' AND Release__r.Current_Release__c = false ORDER BY Release_Date__c DESC NULLS LAST'));
        }
        activeProjects.setPageSize(10);
        queueProjects.setPageSize(10);
        onHoldProjects.setPageSize(10);
        completedProjects.setPageSize(10);
        return null;
    }
    
    public PageReference changeSortOrder(){
        String query = '';
        String userString = ' ';
        if(UserID != '000000000000000') userString = ' AND OwnerID = \'' + UserID + '\'' + userString;
        
        if(block == 'Active'){ 
            query += 'SELECT ' + getFeilds('Active') + ' FROM Milestone1_Project__c Where Status__c=\'Active\' ' + userString + ' AND Active_Status__c IN (\'\',\'Coding in Development Sandbox\',\'Deployed to Full Sandbox\',\'Testing in Full Sandbox\') AND Release__r.Current_Release__c = false';
            query += ' ORDER BY ' + sortField;
            if(BlockToAscMap.get('Active')) query += ' ASC';
            else query += ' DESC NULLS LAST';
            BlockToAscMap.put('Active',!BlockToAscMap.get('Active'));
            activeProjects = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }
        else if(block == 'Queue'){ 
            query += 'SELECT ' + getFeilds('Queued') + ' FROM Milestone1_Project__c Where Release__r.Current_Release__c = true ' + userString;
            query += ' ORDER BY ' + sortField;
            if(BlockToAscMap.get('Queue')) query += ' ASC';
            else query += ' DESC NULLS LAST';
            BlockToAscMap.put('Queue',!BlockToAscMap.get('Queue'));
            queueProjects = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }
        else if(block == 'OnHold'){ 
            query += 'SELECT ' + getFeilds('OnHold') + ' FROM Milestone1_Project__c Where Status__c=\'On Hold\' ' + userString + ' AND Release__r.Current_Release__c = false';
            query += ' ORDER BY ' + sortField;
            if(BlockToAscMap.get('OnHold')) query += ' ASC';
            else query += ' DESC NULLS LAST';
            BlockToAscMap.put('OnHold',!BlockToAscMap.get('OnHold'));
            onholdProjects = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }
        else if(block == 'Completed'){
            query += 'SELECT ' + getFeilds('Completed') + ' FROM Milestone1_Project__c Where Status__c=\'Completed\' ' + userString + ' AND Release__r.Current_Release__c = false';
            query += ' ORDER BY ' + sortField;
            if(BlockToAscMap.get('Completed')) query += ' ASC';
            else query += ' DESC NULLS LAST';
            BlockToAscMap.put('Completed',!BlockToAscMap.get('Completed'));
            completedProjects = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }
        
        return null;
    }
    
    public static String getFeilds(String fieldSetName){
        List<Schema.FieldSetMember> fieldSet;
        if(fieldSetName == 'Queued')    fieldSet = SObjectType.Milestone1_Project__c.FieldSets.Queued.getFields();
        else if(fieldSetName == 'Active')   fieldSet = SObjectType.Milestone1_Project__c.FieldSets.Active.getFields();
        else if(fieldSetName == 'OnHold')   fieldSet = SObjectType.Milestone1_Project__c.FieldSets.OnHold.getFields();
        else if(fieldSetName == 'Completed')    fieldSet = SObjectType.Milestone1_Project__c.FieldSets.Completed.getFields();
        else return ' ';
        
        String returnString = ' ';
        for(Schema.FieldSetMember f: fieldSet){
                returnString += f.getFieldPath() + ', ';
        }
        return (returnString.substring(0,returnString.length()-2) + ' ');
    }
    
    // Get Pagination data
    
    public List<Milestone1_Project__c> getActive_Milestone1_Project(){
        return (List<Milestone1_Project__c>) activeProjects.getRecords();
    }
    
    public Integer getActivePageNumber(){
        return activeProjects.getPageNumber();
    }
    
    public Integer getActiveResultPages(){
        return (activeProjects.getResultSize()/activeProjects.getPageSize() + 1);
    }
    
    public List<Milestone1_Project__c> getqueue_Milestone1_Project(){
        return (List<Milestone1_Project__c>) queueProjects.getRecords();
    }
    
    public Integer getqueuePageNumber(){
        return queueProjects.getPageNumber();
    }
    
    public Integer getqueueResultPages(){
        return (queueProjects.getResultSize()/queueProjects.getPageSize() + 1);
    }
    
     public List<Milestone1_Project__c> getOnHold_Milestone1_Project(){
        return (List<Milestone1_Project__c>) onHoldProjects.getRecords();
    }
    
    public Integer getOnHoldPageNumber(){
        return OnHoldProjects.getPageNumber();
    }
    
    public Integer getOnHoldResultPages(){
        return (OnHoldProjects.getResultSize()/OnHoldProjects.getPageSize() + 1);
    }
    
    public List<Milestone1_Project__c> getCompleted_Milestone1_Project(){
        return (List<Milestone1_Project__c>) completedProjects.getRecords();
    }
    
    public Integer getCompletedPageNumber(){
        return CompletedProjects.getPageNumber();
    }
    
    public Integer getCompletedResultPages(){
        return (CompletedProjects.getResultSize()/CompletedProjects.getPageSize() + 1);
    }

    // Pagination Iteration ( and comment alliteration )


    public PageReference getQueuePrevious(){
        queueProjects.previous();
        return null;
    }
    
    public PageReference getQueueNext(){
        queueProjects.next();
        return null;
    }
    
    public PageReference getQueueFirst(){
        queueProjects.First();
        return null;
    }
    
    public PageReference getQueueLast(){
        queueProjects.Last();
        return null;
    }
    
    public Boolean getQueueHasPrevious(){
        return queueProjects.getHasPrevious();
    }
    public Boolean getQueueHasNext(){
        return queueProjects.getHasNext();
    }
    
    // -------------
    
    public PageReference getActivePrevious(){
        activeProjects.previous();
        return null;
    }
    
    public PageReference getActiveNext(){
        activeProjects.next();
        return null;
    }
    
    public PageReference getActiveFirst(){
        activeProjects.First();
        return null;
    }
    
    public PageReference getActiveLast(){
        activeProjects.Last();
        return null;
    }
    
    public Boolean getActiveHasPrevious(){
        return activeProjects.getHasPrevious();
    }
    public Boolean getActiveHasNext(){
        return activeProjects.getHasNext();
    }
    
    // --------------
    
    public PageReference getOnHoldPrevious(){
        onHoldProjects.previous();
        return null;
    }
    
    public PageReference getOnHoldNext(){
        onHoldProjects.next();
        return null;
    }
    
    public PageReference getOnHoldFirst(){
        onHoldProjects.First();
        return null;
    }
    
    public PageReference getOnHoldLast(){
        onHoldProjects.Last();
        return null;
    }
    
    public Boolean getOnHoldHasPrevious(){
        return onHoldProjects.getHasPrevious();
    }
    public Boolean getOnHoldHasNext(){
        return onHoldProjects.getHasNext();
    }
    
    public PageReference getCompletedPrevious(){
        completedProjects.Previous();
        return null;
    }
    
    public PageReference getCompletedNext(){
        completedProjects.next();
        return null;
    }
    
    public PageReference getCompletedFirst(){
        completedProjects.First();
        return null;
    }
    
    public PageReference getCompletedLast(){
        completedProjects.Last();
        return null;
    }
    
    public Boolean getCompletedHasPrevious(){
        return completedProjects.getHasPrevious();
    }
    
    public Boolean getCompletedHasNext(){
        return completedProjects.getHasNext();
    }
    
    /**************************
    *       Testing           *
    **************************/

    public static testMethod void testGetSetFunctions(){
        ProjectListOverview plo = new ProjectListOverview();
        List<SelectOption> options = plo.getUserOptions();
        
        List<Milestone1_Project__c> active = plo.getActive_Milestone1_Project();
        System.assertEquals(1,plo.getActivePageNumber());
        System.assertEquals(1,plo.getActiveResultPages());
        List<Milestone1_Project__c> queue = plo.getqueue_Milestone1_Project();
        System.assertEquals(1,plo.getqueuePageNumber());
        System.assertEquals(1,plo.getqueueResultPages());
        List<Milestone1_Project__c> onhold = plo.getOnHold_Milestone1_Project();
        System.assertEquals(1,plo.getonHoldPageNumber());
        System.assertEquals(1,plo.getonHoldResultPages());
        List<Milestone1_Project__c> completed = plo.getCompleted_Milestone1_Project();
        System.assertEquals(1,plo.getcompletedPageNumber());
        System.assertEquals(1,plo.getcompletedResultPages());
        
        // Queue
        
        plo.getQueuePrevious();
        plo.getQueueNext();
        plo.getQueueFirst();
        plo.getQueueLast();
        plo.getQueueHasNext();
        plo.getQueueHasPrevious();
        
        // Active
        
        plo.getActivePrevious();
        plo.getActiveNext();
        plo.getActiveFirst();
        plo.getActiveLast();
        plo.getActiveHasNext();
        plo.getActiveHasPrevious();
        
        // OnHold
        
        plo.getOnHoldPrevious();
        plo.getOnHoldNext();
        plo.getOnHoldFirst();
        plo.getOnHoldLast();
        plo.getOnHoldHasNext();
        plo.getOnHoldHasPrevious();
        
        // Completed
        
        plo.getCompletedPrevious();
        plo.getCompletedNext();
        plo.getCompletedFirst();
        plo.getCompletedLast();
        plo.getCompletedHasNext();
        plo.getCompletedHasPrevious();
        
    }
    
    public static testMethod void testChangeOwner(){
        
        ProjectListOverview plo = new ProjectListOverview();
        plo.UserId = '000000000000000';
        plo.changeOwnerShip();
        plo.UserId = UserInfo.getUserID();
        plo.changeOwnerShip();
        
    }


}