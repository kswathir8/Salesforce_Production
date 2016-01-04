public with sharing class HPDirectXML {

	public XmlStreamReader xsr;
	public DEID__c xmlObject;

	public HPDirectXML(String xmlString){
		
		xsr = new XmlStreamReader(xmlString);
		xmlObject = new DEID__c();
		
		while(xsr.hasNext()){
			
			if(xsr.getEventType() == XmlTag.START_ELEMENT && 'field' == xsr.getLocalName()){
				xsr.next();
				String text = xsr.getText();
				//System.debug(text);
				if(text == 'serialnumber') xmlObject.serialnumber__c = getFieldValue(xsr);
				else if(text == 'sap_order') xmlObject.sap_order__c = getFieldValue(xsr);
				else if(text == 'legacy_order') xmlObject.legacy_order__c = getFieldValue(xsr);
				else if(text == 'end_customer_purchase_order') xmlObject.end_customer_purchase_order__c = getFieldValue(xsr);
				else if(text == 'product_name') xmlObject.product_name__c = getFieldValue(xsr);
				else if(text == 'deviceName_label') xmlObject.deviceName_label__c = getFieldValue(xsr);
				else if(text == 'lo_mac') xmlObject.lo_mac__c = getFieldValue(xsr);
				else if(text == 'lo_password') xmlObject.lo_password__c = getFieldValue(xsr);
				else if(text == 'nic1mac') xmlObject.nic1mac__c = getFieldValue(xsr);
				else if(text == 'nic2mac') xmlObject.nic2mac__c = getFieldValue(xsr);
				else if(text == 'nic3mac') xmlObject.nic3mac__c = getFieldValue(xsr);
				else if(text == 'nic4mac') xmlObject.nic4mac__c = getFieldValue(xsr);
				else if(text == 'wwn0') xmlObject.wwn0__c = getFieldValue(xsr);
				else if(text == 'wwn1') xmlObject.wwn1__c = getFieldValue(xsr);
				else if(text == 'asset_tag') xmlObject.asset_tag__c = getFieldValue(xsr);
			}
			xsr.next();
		}
		
		xmlObject.Name = xmlObject.serialnumber__c;
	}
	
	public DEID__c getObject(){
		return xmlObject;
	}
	
	public String getFieldValue(XmlStreamReader xsr){
		while(xsr.hasNext()){
			if(xsr.getEventType() == XmlTag.START_ELEMENT && 'value' == xsr.getLocalName()){
				xsr.next();
				return xsr.getText();
			}
			xsr.next();
		}
		return null;
	}
	
	/********************************************
	*			Test Methods					*
	********************************************/
	
	public static testMethod void testConstWithEmptyString(){
		DEID__c testObject = new DEID__c();
		Exception e;
		
		Test.startTest();
			try{
				HPDirectXML xmlTest = new HPDirectXML('');
				testObject = xmlTest.getObject();
			
			}
			catch(XMLException xmle){
				e = xmle;
			}
			catch(Exception otherE){
				throw otherE;
			}
		Test.stopTest();
	
		System.assertNotEquals(null,e);
	
	}
	
	public static testMethod void testConstWithAllFields(){
		DEID__c testObject = new DEID__c();
		
		String xmlString = '<DEAXNT-C01>\n';
		xmlString += '  <USE302S9SE>\n';
		xmlString += '      <field>serialnumber</field>\n';
		xmlString += '      <value>USE302S9SE</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>sap_order</field>\n';
		xmlString += '      <value>0202200375</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>legacy_order</field>\n';
		xmlString += '      <value>D7IC50379133</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>end_customer_purchase_order</field>\n';
		xmlString += '      <value>6051035D</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>product_name</field>\n';
		xmlString += '      <value>ProLiant ML110 G7</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>asset_tag</field>\n';
		xmlString += '      <value>n/a</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>deviceName_label</field>\n';
		xmlString += '      <value>BG0113H0211620009</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>lo_mac</field>\n';
		xmlString += '      <value>A0B3CCEA89ED</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>lo_password</field>\n';
		xmlString += '      <value>42491232</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>nic1mac</field>\n';
		xmlString += '      <value>A0B3CCEA89EA</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>nic2mac</field>\n';
		xmlString += '      <value>A0B3CCEA89EB</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>nic3mac</field>\n';
		xmlString += '      <value>28924A3616E4</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>nic4mac</field>\n';
		xmlString += '      <value>n/a</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>wwn0</field>\n';
		xmlString += '      <value>n/a</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '    <USE302S9SE>\n';
		xmlString += '      <field>wwn1</field>\n';
		xmlString += '      <value>n/a</value>\n';
		xmlString += '    </USE302S9SE>\n';
		xmlString += '  </DEAXNT-C01>\n';
		
		Test.startTest();
			HPDirectXML xmlTest = new HPDirectXML(xmlString);
			testObject = xmlTest.getObject();
		Test.stopTest();
	
		System.assertNotEquals(null,testObject);
		System.assertEquals('USE302S9SE',testObject.Name);
		System.assertEquals('USE302S9SE',testObject.serialnumber__c);
		System.assertEquals('0202200375',testObject.sap_order__c);
		System.assertEquals('D7IC50379133',testObject.legacy_order__c);
		System.assertEquals('6051035D',testObject.end_customer_purchase_order__c);
		System.assertEquals('ProLiant ML110 G7',testObject.product_name__c);
		System.assertEquals('n/a',testObject.asset_tag__c);
		System.assertEquals('BG0113H0211620009',testObject.deviceName_label__c);
		System.assertEquals('A0B3CCEA89ED',testObject.lo_mac__c);
		System.assertEquals('42491232',testObject.lo_password__c);
		System.assertEquals('A0B3CCEA89EA',testObject.nic1mac__c);
		System.assertEquals('A0B3CCEA89EB',testObject.nic2mac__c);
		System.assertEquals('28924A3616E4',testObject.nic3mac__c);
		System.assertEquals('n/a',testObject.nic4mac__c);
		System.assertEquals('n/a',testObject.wwn0__c);
		System.assertEquals('n/a',testObject.wwn1__c);
		
	
	}
	

}