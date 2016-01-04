public class RecursiveTriggerController {

    private static boolean alreadyExecuted = false;
    
    public static boolean hasAlreadyRunTrigger() {
        return alreadyExecuted ;
    }
    
    public static void setAlreadyRunTrigger() {
        alreadyExecuted = true;
    } 
}