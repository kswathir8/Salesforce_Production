/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: Test class for DataCategoryInfo. 
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
@isTest
private class TestDataCategoryInfo {

 static testMethod void validateDataCategoryInfoObject() {
  DataCategoryInfo dataCategoryInfo = new DataCategoryInfo('Products__c', 'Products__c', 'Products');
  System.assertEquals('Products__c',dataCategoryInfo.getName());
  System.assertEquals('Products__c',dataCategoryInfo.getLabel());
  System.assertEquals('Products',dataCategoryInfo.getDisplayName());
 }
}