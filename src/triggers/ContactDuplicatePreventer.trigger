trigger ContactDuplicatePreventer on Contact
                               (before insert, before update) {

    /*Map<String, Contact> contactMap = new Map<String, Contact>();
    for (Contact contact : System.Trigger.new) {
        
       
        if ((contact.Email != null) &&
                (System.Trigger.isInsert ||
                (contact.Email != 
                    System.Trigger.oldMap.get(contact.Id).Email))) {
        
            // Make sure another new lead isn't also a duplicate  
    
            if (contactMap.containsKey(contact.Email)) {
                contact.Email.addError('Another new contact has the '
                                    + 'same email address.');
            } else {
                contactMap.put(contact.Email, contact);
            }
       }
    }
    
    
    for (Contact contact : [SELECT Email FROM Contact
                      WHERE Email IN :ContactMap.KeySet()]) {
        Contact newContact = ContactMap.get(contact.Email);
        newContact.Email.addError('A contact with this email '
                               + 'address already exists.');
    }*/
}