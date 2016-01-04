@isTest
private class TG_XMLUtils_Test {

    static testMethod void myUnitTest() {
        DOM.Document XML = new DOM.Document();
        XML.createRootElement('root', 'http://tempuri.org/intacct_response.v2.1', 'xs');
        DOM.xmlNode root = XML.getRootElement();
        DOM.xmlNode child1 = root.addChildElement('xs:child1', null, null);
        DOM.xmlNode child2 = root.addChildElement('xs:child2', null, null);
        child1.addTextNode('child1Text');
        child2.addTextNode('child2Text');

        Test.startTest();
        TG_XmlUtils.NodeNameInfo info = TG_XmlUtils.getNamespaceFromNodeName('xs:root', root);
        System.assertEquals(info.localName, 'root');
        System.assertEquals(info.namespaceURI, 'http://tempuri.org/intacct_response.v2.1');
        System.assertEquals(info.nameSpacePrefix, 'xs');

        String xmlString = TG_XmlUtils.toXmlString(root);
        System.assertEquals(xmlString, '<xs:root><xs:child1>child1Text</xs:child1><xs:child2>child2Text</xs:child2></xs:root>');

        child1.setAttribute('test', 'true');
        TG_XmlUtils.copyAttributes(child1, child2);
        xmlString = TG_XmlUtils.toXmlString(child2);
        System.assertEquals(xmlString, '<xs:child2 test=\'true\'>child2Text</xs:child2>');

        TG_XmlUtils.appendChild(root, child1);
        TG_XmlUtils.appendChild(root, child2);
        DOM.xmlNode child3 = root.getChildren()[2];
        xmlString = TG_XmlUtils.toXmlString(child3);
        System.assertEquals(xmlString, '<xs:child1 test=\'true\'>child1Text</xs:child1>');

        DOM.Xmlnode rootClone = TG_XmlUtils.clone(root, true);
        DOM.xmlNode child5 = rootClone.getChildren()[0];
        xmlString = TG_XmlUtils.toXmlString(child5);
        System.assertEquals(xmlString, '<xs:child1 test=\'true\'>child1Text</xs:child1>');

        xmlString = TG_XmlUtils.getTextContents(root);
        System.assertEquals(xmlString, 'child1Text child2Text child1Text child2Text');

        Test.stopTest();
    }
}