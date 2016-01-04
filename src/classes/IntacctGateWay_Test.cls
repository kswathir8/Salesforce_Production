@isTest
private class IntacctGateWay_Test {

    static testMethod void myUnitTest() {

        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'test');
        function.addChildElement('get_list', null, null).setAttribute('object', 'glaccount');

        DOM.Document XML1 = new DOM.Document();
        XML1.load('<function></function>');
        DOM.xmlNode function1 = XML1.getRootElement();
        function1.setAttribute('controlid', 'test');
        function1.addChildElement('get_list', null, null).setAttribute('object', 'bill');

        DOM.xmlNode[] functions = new DOM.xmlNode[2];
        functions[0] = function;
        functions[1] = function1;        

        Test.startTest();//used in order to get separate governors

        DOM.Document test1 = IntacctGateWay.BuildList('glaccount');
        DOM.Document test2 = IntacctGateWay.BuildRequestDocument(function);
        DOM.Document test3 = IntacctGateWay.BuildRequestDocument(function, 'test', false);

        DOM.Document test4 = IntacctGateWay.BuildRequestDocument(functions);
        DOM.Document test5 = IntacctGateWay.BuildRequestDocument(functions, 'test', true);

        HttpRequest req = IntacctGateWay.BuildHttpRequest(test1);
        Test.stopTest();

        System.assertEquals(test1.getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
        System.assertEquals(test2.getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
        System.assertEquals(test3.getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
        System.assertEquals(test4.getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
        System.assertEquals(test4.getRootElement().getChildren()[1].getChildren()[1].getChildren()[1].getChildren()[0].getAttribute('object', null), 'bill');
        System.assertEquals(test5.getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
        System.assertEquals(test5.getRootElement().getChildren()[1].getChildren()[1].getChildren()[1].getChildren()[0].getAttribute('object', null), 'bill');
        System.assertEquals(req.getBodyDocument().getRootElement().getChildren()[1].getChildren()[1].getChildren()[0].getChildren()[0].getAttribute('object', null), 'glaccount');
    }
}