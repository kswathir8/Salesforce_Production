/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: Test class for DataCategoryUtil. 
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
@isTest
private class TestDataCategoryUtil {

 static testMethod void validateCategoryGroups(){
  String[] objTypes = new String[] { 'KnowledgeArticleVersion' };
  Describedatacategorygroupresult[] datacategorygroupresult = Schema.describeDataCategoryGroups(objTypes);
  DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
  System.assertEquals(datacategorygroupresult.size(),dataCategoryGroupInfo.size());
 }

 static testMethod void validateCategoryGroupsResults(){
  DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
  String[] objTypes = new String[] { 'KnowledgeArticleVersion' };
  Describedatacategorygroupresult[] datacategorygroupresult = Schema.describeDataCategoryGroups(objTypes);
  for(Integer i=0;i< dataCategoryGroupInfo.size(); i++) {
   System.assertEquals(dataCategoryGroupInfo[i].getName(),datacategorygroupresult[i].getName());
   System.assertEquals(dataCategoryGroupInfo[i].getLabel(),datacategorygroupresult[i].getLabel());
   System.assertEquals(dataCategoryGroupInfo[i].getDescription(),datacategorygroupresult[i].getDescription());
  }
 }
}