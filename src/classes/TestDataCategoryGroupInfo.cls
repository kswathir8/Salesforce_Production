/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: Test class for DataCategoryGroupInfo. 
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
@isTest
private class TestDataCategoryGroupInfo {

 static testMethod void validateDataCategoryGroupInfoObject(){
  DataCategoryInfo[] structure = new DataCategoryInfo[1];
  structure[0] = new DataCategoryInfo('Product','Product__c','Product__c');
  DataCategoryGroupInfo dataCategoryGroupInfo = new DataCategoryGroupInfo('Product','Product__c','Test DataCategoryInfoClass',structure);
  System.assertEquals('Product', dataCategoryGroupInfo.getName());
  System.assertEquals('Product__c', dataCategoryGroupInfo.getLabel());
  System.assertEquals('Test DataCategoryInfoClass', dataCategoryGroupInfo.getDescription());
  System.assertEquals(structure.size(),dataCategoryGroupInfo.getGroupStructure().size());
 }

}