@isTest
private class TestForAddAttachmentController{
    static testMethod void testMethodForCodeCoverage(){ 
        // set the caseid 
        System.currentPagereference().getParameters().put('caseId','5004000000CSyjA'); 
        AddAttachmentController obj=new AddAttachmentController();
        //call the uoplad method for create attachment
        obj.upload();
        // for back to originin case
        obj.cancel();         
    }
}