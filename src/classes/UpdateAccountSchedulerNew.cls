global class UpdateAccountSchedulerNew implements Schedulable {
   global void execute(SchedulableContext SC) {
   UpdateAccountFields.UpdateAccounts();

   }
}