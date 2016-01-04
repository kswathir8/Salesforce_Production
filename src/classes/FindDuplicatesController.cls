public with sharing class FindDuplicatesController {

    public Lead origRecord      {get;set;}
    
    // Input fields
    public String fullName      {get;set;}
    public String lastName      {get;set;}
    public String Company       {get;set;}
    public String email         {get;set;}
    public String emailDomain   {get;set;}
    public String Phone         {get;set;}
    
    // Checkboxes
    public Boolean useFullName  {get;set;}
    public Boolean useLastName  {get;set;}
    public Boolean useCompany   {get;set;}
    public Boolean useEmail     {get;set;}
    public Boolean useEmailDomain   {get;set;}
    public Boolean usePhone     {get;set;}
    
    // Search Lists
    public List<Lead> matchingLeads {get;set;}
    public List<Account> matchingAccounts {get;set;}
    public List<Opportunity> matchingOpportunities {get;set;}
    public List<Contact> matchingContacts {get;set;}
    
    // Accessor functions for VF Page
    public List<Schema.FieldSetMember> getLeadFields(){
        return getFields('Lead');
    }
    
    public List<Schema.FieldSetMember> getContactFields(){
        return getFields('Contact');
    }
    
    public List<Schema.FieldSetMember> getAccountFields(){
        return getFields('Account');
    }

    // Constructor
    public FindDuplicatesController(ApexPages.StandardController stdController){
        origRecord = (Lead)stdController.getRecord();
        if(origRecord.Name != null) fullName = origRecord.Name;
        if(origRecord.lastName != null) lastName = origRecord.LastName;
        if(origRecord.Company != null)  Company = origRecord.Company;
        if(origRecord.email != null)    email = origRecord.Email;
        if(email != null && email.contains('@') ) emailDomain = '@' + email.substringAfter('@');
        if(origRecord.phone != null)    phone = origRecord.Phone;
        
        useFullName = false;
        useLastName = false;
        useCompany = true;
        useEmail = false;
        useEmailDomain = false;
        usePhone = false;
        
        matchingLeads = new List<Lead>();
        matchingAccounts = new List<Account>();
        matchingOpportunities = new List<Opportunity>();
        matchingContacts = new List<Contact>();
        
        search();
    }
    
    
    public void search(){
        
        if(!useCompany && !useEmailDomain) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Company and Email Domain cannot both be unchecked.'));
        //if(!useFullName && !uselastName) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Name and Last Name cannot both be unchecked.'));
        //if(!useEmail && !useEmailDomain) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email and Email Domain cannot both be unchecked.'));
    
        if(ApexPages.hasMessages()) return;
    
        String leadQuery = 'Select ' + getQueryFields('Lead') + 'id,lastName,Name From Lead Where id != \'' + origRecord.id + '\'';
        String contactQuery = 'Select ' + getQueryFields('Contact') + ' id,lastName,Name From Contact Where ';
        String accountQuery = 'Select ' + getQueryFields('Account') + ' id,Name From Account Where ';
        
        
        Map<String,String> filterMap = new Map<String,String>();
        
        String ORFilters = '';
        Integer numOfORFilter = 0;
        
        if(useFullName && fullName != null) filterMap.put('fullname',' Name like \'%'+fullName+'%\' ');
        if(useLastName && lastName != null) filterMap.put('lastname',' Name like \'%'+lastName+'%\' ');
        if(useCompany && Company != null){ 
            filterMap.put('company',' Company like \'%'+Company+'%\' ');
            filterMap.put('accountname',' Name like \'%'+Company+'%\' ');
        }
        if(useEmail && Email != null) filterMap.put('email',' email = \'' + email + '\' ');
        if(useEmailDomain && EmailDomain != null)   filterMap.put('emailDomain',' email like \'%' + emailDomain + '\' ');
        
        List<String> formats = new List<String>();
        
        if(usePhone && Phone != null){
            formats = getPhoneFormats(Phone);
            String formatString = String.valueOf(formats);
            formatString = '(\'' + formatString.substring(1,formatString.length()).replaceAll(',','\',\'');
            formatString = + formatString.substring(0,formatString.length()-1) + '\')'; 
            if(formatString != '(\'\')') filterMap.put('phone',' Phone IN ' + formatString);
        }
        
    
        if(filterMap.size() > 0){ 
            leadQuery = leadQuery.substring(0,leadQuery.lastIndexOf('id')) + getLeadQueryFilters(filterMap) + ' AND ' + leadQuery.substring(leadQuery.lastIndexOf('id'),leadQuery.length());
            contactQuery += getContactQueryFilters(filterMap);
            accountQuery += getAccountQueryFilters(filterMap);
        }
        
        System.debug(leadQuery);
        System.debug(contactQuery);
        System.debug(accountQuery);
        
        matchingLeads = Database.query(leadQuery + ' limit 300');
        if(contactQuery.trim().toUpperCase().lastindexOf('WHERE') + 5 != contactQuery.trim().length() ) matchingContacts = Database.query(contactQuery + ' limit 300');
        if(accountQuery.trim().toUpperCase().lastindexOf('WHERE') + 5 != accountQuery.trim().length() ) matchingAccounts = Database.query(accountQuery + ' limit 300');
        
        // filter lists
        // (1) Company OR Email Domain
		// (2) Email
		// (3) Last Name
		// (4) Name
		// (5) Phone 
		
		filterLeads(matchingLeads);
        filterAccounts(matchingAccounts);
        filterContacts(matchingContacts);
    }
    
    private void filterLeads(List<Lead> leadsToFilter){
    	if(leadstoFilter.size() == 0) return;
    	
    	List<Integer> itrOfLeadsToRemove = new List<Integer>();
    	
    	for(Integer leadListItr = 0; leadListItr < leadsToFilter.size(); leadListItr++){
    		
    		Boolean remove = false;
    		if(useEmail && leadsToFilter.get(leadListItr).email != email) remove = true;
    		if(usephone && leadsToFilter.get(leadListItr).phone != phone) remove = true;
    		if(uselastName && leadsToFilter.get(leadListItr).lastName != lastName) remove = true;
    		if(useFullName && leadsToFilter.get(leadListItr).name != fullName) remove = true;
    		
    		if(remove){ 
    			leadsToFilter.remove(leadListItr);
    			leadListItr--;
    		}
    	}
    	
    }
    
    private void filterAccounts(List<Account> accountsToFilter){
    	if(accountsToFilter.size() == 0) return;
    	
    	for(Integer accountListItr = 0; accountListItr < accountsToFilter.size(); accountListItr++){
    		Boolean remove = false;
    		if(usephone && accountsToFilter.get(accountListItr).phone != phone) remove = true;
    		if(remove) accountsToFilter.remove(accountListItr);
    	}
    }
    
    private void filterContacts(List<Contact> contactsToFilter){
    	if(contactstoFilter.size() == 0) return;
    	
    	for(Integer contactListItr = 0; contactListItr < contactsToFilter.size(); contactListItr++){
    		
    		Boolean remove = false;
    		if(useEmail && contactsToFilter.get(contactListItr).email != email) remove = true;
    		if(usephone && contactsToFilter.get(contactListItr).phone != phone) remove = true;
    		if(uselastName && contactsToFilter.get(contactListItr).lastName != lastName) remove = true;
    		if(useFullName && contactsToFilter.get(contactListItr).name != fullName) remove = true;
    		
    		if(remove) contactsToFilter.remove(contactListItr);
    	}
    }
    
    
    
    public List<Schema.FieldSetMember> getFields(String objectType){
        if(objectType == 'Lead')    return SObjectType.Lead.Fieldsets.Find_Duplicates.getFields();
        if(objectType == 'Account') return SObjectType.Account.Fieldsets.Find_Duplicates.getFields();
        if(objectType == 'Contact') return SObjectType.Contact.Fieldsets.Find_Duplicates.getFields();
        if(objectType == 'Opportunity') return SObjectType.Opportunity.Fieldsets.Find_Duplicates.getFields();
        return new List<Schema.FieldSetMember>();
    }
    
    private static List<String> getPhoneFormats(String rawPhoneNumber){
        List<String> formats = new List<String>();
        String phoneNumerics = '';
        for(Integer stringIndex = 0; stringIndex < rawPhoneNumber.length(); stringIndex++){
            //System.debug(rawPhoneNumber.substring(stringIndex,stringIndex+1));
            //System.debug(rawPhoneNumber.substring(stringIndex,stringIndex+1).isNumeric());
            if(rawPhoneNumber.substring(stringIndex,stringIndex+1).isNumeric()) phoneNumerics = phoneNumerics + String.valueOf(rawPhoneNumber.substring(stringIndex,stringIndex+1));
        }
        
        system.debug(phoneNumerics);
        
        if(phoneNumerics.length() == 10){
            formats.add('(' + phoneNumerics.substring(0,3) + ') ' + phoneNumerics.substring(3,6) + '-' + phoneNumerics.substring(6,10));
            formats.add(phoneNumerics.substring(0,3) + '-' + phoneNumerics.substring(3,6) + '-' + phoneNumerics.substring(6,10));
            formats.add(phoneNumerics);
            formats.add('+'+phoneNumerics);
        }
        
        return formats;
    }
    
    private static String getLeadQueryFilters(Map<String,String> filters){
        String queryString = ' ';
        if(filters.containsKey('fullname')) queryString += filters.get('fullname') + ' OR ';
        if(filters.containsKey('company')) queryString += filters.get('company') + ' OR ';
        if(filters.containsKey('email')) queryString += filters.get('email') + ' OR ';
        if(filters.containsKey('emailDomain')) queryString += filters.get('emailDomain') + ' OR ';
        if(filters.containsKey('phone')) queryString += filters.get('phone') + ' OR ';
        if(queryString != ' ')  queryString = queryString.substring(0,queryString.lastIndexOf(' OR '));
        if(filters.size() > 1 ) queryString = ' ( ' + queryString + ' ) ';
        return queryString;
    }
    
    private static String getContactQueryFilters(Map<String,String> filters){
        String queryString = ' ';
        if(filters.containsKey('fullname')) queryString += filters.get('fullname') + ' OR ';
        if(filters.containsKey('email')) queryString += filters.get('email') + ' OR ';
        if(filters.containsKey('phone')) queryString += filters.get('phone') + ' OR ';
        if(filters.containsKey('emailDomain')) queryString += filters.get('emailDomain') + ' OR ';
        if(queryString != ' ')  queryString = queryString.substring(0,queryString.lastIndexOf(' OR '));
        return queryString;
    }
    
    private static String getAccountQueryFilters(Map<String,String> filters){
        String queryString = ' ';
        if(filters.containsKey('accountname')) queryString += filters.get('accountname') + ' OR ';
        if(filters.containsKey('phone')) queryString += filters.get('phone') + ' OR ';
        if(queryString != ' ')  queryString = queryString.substring(0,queryString.lastIndexOf(' OR '));
        return queryString;
    }
    
    private String getQueryFields(String objectType){
        String queryFields = ' ';
        for(Schema.FieldSetMember fsm: getFields(objectType)){
            queryFields += fsm.getFieldPath() + ', ';
        }
        return queryFields;
    }
    
    /********************************
    *       Test Methods            *
    ********************************/
    
    public static testMethod void testAccessorFields(){
        
        Lead testLead = new Lead(Company='Test Company',firstName='Some',lastName='Guy',email='gram@fake123test.com',phone='650-933-9505');
        insert testLead;
        
        FindDuplicatesController fdc = new FindDuplicatesController(new ApexPages.Standardcontroller(testLead));
        
        Test.startTest();
        
            fdc.getLeadFields();
            fdc.getAccountFields();
            fdc.getContactFields();
        
        Test.stopTest();
        
        System.assert(!fdc.useFullName);
        System.assert(!fdc.useLastName);
        System.assert(fdc.useCompany);
        System.assert(!fdc.useEmail);
        System.assert(!fdc.useEmailDomain);
        System.assert(!fdc.usePhone);
        
        
    }
    
    public static testMethod void testConstructorWithNoOtherItems(){
        Lead testLead = new Lead(Company='Test Company',firstName='Some',lastName='Guy',email='gram@fake123test.com',phone='650-933-9505');
        insert testLead;
        
        List<Lead> matchedLeadList = new List<Lead>();
        
        Test.startTest();
            FindDuplicatesController fdc = new FindDuplicatesController(new ApexPages.Standardcontroller(testLead));
            matchedLeadList = fdc.matchingLeads;
        Test.stopTest();
        
        System.assertEquals(0,matchedLeadList.size());

    }
    
    public static testMethod void testConstructorWithMatchingLead(){
        Lead testLead = new Lead(Company='Test Company',firstName='Some',lastName='Guy',email='gram@fake123test.com',phone='650-933-9505');
        insert testLead;
        
        Lead testMatchingCompanyLead = new Lead(Company='Test Company',firstName='NotSome',lastName='NotGuy',email='Notgram@fake123test.com',phone='123-650-933-9505');
        insert testMatchingCompanyLead;
        
        List<Lead> matchedLeadList = new List<Lead>();
        
        Test.startTest();
            FindDuplicatesController fdc = new FindDuplicatesController(new ApexPages.Standardcontroller(testLead));
            matchedLeadList = fdc.matchingLeads;
        Test.stopTest();
        
        System.assertEquals(1,matchedLeadList.size());
        System.assertEquals(testLead.Company,matchedLeadList.get(0).Company);

    }
    
    public static testMethod void testConstructorWithMatchingAccount(){
        Lead testLead = new Lead(Company='Test Company',firstName='Some',lastName='Guy',email='gram@fake123test.com',phone='650-933-9505');
        insert testLead;
        
        Account testMatchingNameAccount = new Account(Name='Test Company');
        insert testMatchingNameAccount;
        
        List<Account> matchedAccountList = new List<Account>();
        
        Test.startTest();
            FindDuplicatesController fdc = new FindDuplicatesController(new ApexPages.Standardcontroller(testLead));
            matchedAccountList = fdc.matchingAccounts;
        Test.stopTest();
        
        System.assertEquals(1,matchedAccountList.size());
        System.assertEquals(testLead.Company,matchedAccountList.get(0).Name);

    }
    
    
    
    

}