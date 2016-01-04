public with sharing class PartnerChatter {

	public User user {get; set;}

	public PartnerChatter() {
		user = [SELECT Id, AccountId FROM User WHERE Id = :UserInfo.getUserId()];
	}
}