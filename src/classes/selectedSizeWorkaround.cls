public class selectedSizeWorkaround {
    
   Integer count = 0;
            
    public PageReference incrementCounter() {
        count++;
        return null;
    }
    
    ApexPages.StandardSetController setCon;

    public selectedSizeWorkaround(ApexPages.StandardSetController controller) {
        setCon = controller;
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }
    
   
}