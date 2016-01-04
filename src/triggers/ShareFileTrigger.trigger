trigger ShareFileTrigger on ShareFile_Summary__c (after update) {
    /*
    ShareFileGetDEID s = new ShareFileGetDEID(); 
    DateTime runTime = System.now().addMinutes(1);
    String schedTime = '' + runTime.second();
    schedTime += ' ' + runTime.minute();
    schedTime += ' ' + runTime.hour();
    schedTime += ' ' + runTime.day();
    schedTime += ' ' + runTime.month();
    schedTime += ' ?';
    schedTime += ' ' + runTime.year();
    System.debug(schedTime);
    system.schedule('Get ShareFiles ' + System.now(), schedTime, s);
    */
}