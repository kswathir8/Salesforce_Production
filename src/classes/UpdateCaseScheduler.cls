global class UpdateCaseScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
   UpdateCaseStatus.UpdateCases();
   //CaseUpdates caseups = new CaseUpdates();
   //database.executebatch(caseups);

   }
}