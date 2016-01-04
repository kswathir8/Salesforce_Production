/******************************************
 *  Class Name: AddAttachmentController   *
 *  Created By: Cleartask                 *
 *                                        *
 ******************************************/
public class AddAttachmentController{
 // variable used for Attachement-start
    public Boolean flag{get;set;}    
    public Attachment attachmentInCase{get;set;}
    private String caseId=ApexPages.currentPage().getParameters().get('caseId');     
    public Attachment attachmentObj{get;set;}
 // variable used for Attachement-end  
 // Constructure -start  
    public AddAttachmentController(){
        attachmentObj= new Attachment();
        flag=false;        
    }
 // Constructure -end
 /*
  * upload method is for insert attachement in Case -start  
  */
    public void upload(){ 
        try{
            attachmentObj.parentid = caseId;
            insert attachmentObj;
            System.debug('###########After Insert');
            attachmentInCase=[Select Name, BodyLength From Attachment where (parentid=:caseId and CreatedDate=:System.now()) LIMIT 1];
            System.debug('##########'+attachmentInCase);
            flag=true;
            attachmentObj= new Attachment();
        }catch(Exception e){
            System.debug('###########In Catch');
            flag=false;
        } 
    }
 /*
  * upload method is for insert attachement in Case -end
  */
  
 /*
  * cancel method is for back to the origin Case -start  
  */
    public PageReference cancel(){
        if(caseId != null){
            PageReference casePage = new PageReference('/' +caseId); 
            casePage.setRedirect(true);
            return casePage;
        }
        return null;
    } 
 /*
  * cancel method is for back to the origin Case -start  
  */  
}