public with sharing class PartnerMarketingAssets {

	public List<Document> documents {get; set;}

	public PartnerMarketingAssets() {
		try {
			Folder marketingAssetsFolder = [SELECT Id, Name FROM Folder WHERE Name = 'Axcient Marketing Assets' LIMIT 1];
			documents = [SELECT Id, Name, Description FROM Document WHERE FolderId = :marketingAssetsFolder.Id ORDER By Name];
		} catch (Exception e) {
			System.debug('Exception while querying for folder and documents: ' + e.getMessage());
		}
	}
}