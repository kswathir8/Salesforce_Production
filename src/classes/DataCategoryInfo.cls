/**
* @author: Anusha Surapaneni
* @date: 10/29/2013
* @description: This class holds the Data Category Info. from the describe result (Used in KnowledgeArticleSearchController)
* @history:
    1.Base Code Author SFDC - "http://www.salesforce.com/docs/developer/knowledge_devpre/index.htm"
*/
public class DataCategoryInfo {

    private String name;
    private String label;
    private String displayName;
    
    public DataCategoryInfo(String name, String label, String displayName) {
        this.name = name;
        this.label = label;
        this.displayName = displayName;
    }
    
    public String getName() {
        return this.name;
    }
    
    public String getLabel() {
        return this.label;
    }
    
    public String getDisplayName() {
        return this.displayName;
    }
}