/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: Test class for KnowledgeArticleSearchController. 
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
@isTest
private class TestKnowledgeArticleSearchController {

 static testMethod void validateDataCategoryGroupInfo(){
  DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
  KnowledgeArticleSearchController KnowledgeArticleSearchControllerObj = new KnowledgeArticleSearchController();
  System.assertEquals(KnowledgeArticleSearchControllerObj.getDataCategoryGroupInfo().size(), dataCategoryGroupInfo.size());
 }
 
 static testMethod void testClassVariables() {
  KnowledgeArticleSearchController KnowledgeArticleSearchControllerObj = new KnowledgeArticleSearchController(); 
  KnowledgeArticleSearchControllerObj.refreshSearchResult();
  System.assertEquals(KnowledgeArticleSearchControllerObj.getCurrentPageNumber(),1.0);
  KnowledgeArticleSearchControllerObj.next();
  System.assertEquals(KnowledgeArticleSearchControllerObj.getCurrentPageNumber(),1.0);
  KnowledgeArticleSearchControllerObj.previous();
  System.assertEquals(KnowledgeArticleSearchControllerObj.getCurrentPageNumber(),1.0);
  System.assertEquals(KnowledgeArticleSearchControllerObj.getPrevRequired(),false);
  System.assertEquals(KnowledgeArticleSearchControllerObj.getNextRequired(),false);

 }   
 
 static testMethod void validateCategoryKeyword() {
  KnowledgeArticleSearchController KnowledgeArticleSearchControllerObj = new KnowledgeArticleSearchController();
  DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();
  String categoryCondition = '';
  for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
   ApexPages.currentPage().getParameters().put('categoryType_'+categoryGroup.getName(),'All');
   if(categoryCondition==''){
    categoryCondition=categoryCondition+categoryGroup.getName() + ':' + System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
   }else {
    categoryCondition=categoryCondition + ',' +categoryGroup.getName() + ':' + System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
   }
  }
  System.assertEquals(categoryCondition, KnowledgeArticleSearchControllerObj.getCategoryKeyword());
 }
 
}