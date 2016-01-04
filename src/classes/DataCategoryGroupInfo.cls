/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: This class holds the Data Category Group Info. from the describe result (Used in KnowledgeArticleSearchController)
* @history:
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
public class DataCategoryGroupInfo {

    private String name;
    private String label;
    private String description;
    private DataCategoryInfo[] groupStructure;
    
    public DataCategoryGroupInfo (String name, String label, String description, DataCategoryInfo[] structure) {
        this.name = name;
        this.label = label;
        this.description = description;
        this.groupStructure = structure;
    }
    
    public String getName(){
        return this.name;
    }
    
    public String getLabel(){
        return this.label;
    }
    
    public String getDescription(){
        return this.description;
    }
    
    public DataCategoryInfo[] getGroupStructure(){
        return this.groupStructure;
    }
}