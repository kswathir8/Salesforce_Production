@isTest
private class IntacctAPI_Test {

    static testMethod void myUnitTest() {
        
        Dom.Document response1 = new Dom.Document();
        Dom.Document response2 = new Dom.Document();
        Dom.Document response3 = new Dom.Document();
        String s1, s2, s3;
        
        s1 = '<response>' +
            + '<control>' + 
                + '<status>failure</status>' +
                + '<senderid>senderId</senderid>' +
                + '<controlid>controlId</controlid>' +
                + '<uniqueid>false</uniqueid>' +
                + '<dtdversion>2.1</dtdversion>' +
              + '</control>' +
              + '<errormessage>' +
                    + '<error>' +
                          + '<errorno>XL03000003</errorno>' +
                          + '<description></description>' +
                          + '<description2>XML Parse error: Error 504: Element function content does not follow the DTD, expecting (create_apaccountlabel | create_apadjustment | create_apadjustmentbatch | create_araccountlabel | create_aradjustment | create_aradjustmentbatch | create_arpayment | create_arpaymentbatch | create_bill | create_recurringbill | create_billbatch | create_checkingaccount | create_savingsaccount | update_checkingaccount | update_savingsaccount | delete_checkingaccount | delete_savingsaccount | create_contact | create_customer | create_department | create_employee | create_expensereport | create_expensereportbatch | create_expensetype | create_glaccount | create_statglaccount | create_gltransaction | delete_gltransaction | create_recurringgltransaction | delete_recurringgltransaction | create_statgltransaction | create_recurringstatgltrans | delete_recurringstatgltrans | create_invoice | create_recurringinvoice | create_invoicebatch | create_journal | create_location | create_statjournal | create_project | update_project | delete_project | create_class | delete_class | create_vendor | delete_apaccountlabel | delete_apadjustment | create_locationgroup | delete_araccountlabel | delete_aradjustment | delete_bill | delete_recurringbill | delete_contact | delete_customer | delete_department | delete_employee | delete_expensereport | delete_expensetype | delete_glaccount | delete_statglaccount | delete_invoice | delete_recurringinvoice | delete_journal | delete_statjournal | delete_location | delete_vendor | get | get_accountbalances | get_accountgroupdetails | get_apadjustment | get_aradjustment | get_bill | get_expensereport | get_invoice | get_list | get_trialbalance | get_myclients | init_session | update_apaccountlabel | update_araccountlabel | update_contact | update_customer | update_department | update_invoice | update_bill | update_apadjustment | update_aradjustment | update_employee | update_expensereport | update_expensetype | update_glaccount | update_statglaccount | update_journal | update_location | update_vendor | create_paymentrequest | reclassify_bill | reclassify_invoice | delete_paymentrequest | create_appayment | create_stkittransaction | create_ictransaction | update_ictransaction | create_sotransaction | update_sotransaction | create_recursotransaction | delete_recursotransaction | create_potransaction | update_potransaction | get_salestotals | get_icitemtotals | record_cctransaction | record_wucctransactions | record_wureceipts | record_wudisbursements | record_wuadjjournalentries | record_wujournalentries | get_companyprefs | set_companyprefs | get_applications | record_otherreceipt | record_deposit | create_territory | delete_territory | update_territory | apply_arpayment | delete_sotransaction | delete_potransaction | delete_ictransaction | create_item | update_item | delete_item | create_sopricelist | delete_sopricelist | update_sopricelist | create_popricelist | delete_popricelist | update_popricelist | create_vsoepricelist | update_vsoepricelist | delete_vsoepricelist | create_vsoeitempricelist | update_vsoeitempricelist | delete_vsoeitempricelist | create_invpricelistentry | delete_invpricelistentry | update_invpricelistentry | get_closedbooksdate | get_araging | delete_arpayment | create_customerachinfo | update_customerachinfo | delete_customerachinfo | create_customerchargecard | update_customerchargecard | delete_customerchargecard | create_customerbankaccount | update_customerbankaccount | delete_customerbankaccount | create_taxdetail | update_taxdetail | delete_taxdetail | create_taxschedule | update_taxschedule | delete_taxschedule | create_taxscheduledetail | delete_taxscheduledetail | create_contacttaxgroup | delete_contacttaxgroup | create_itemtaxgroup | delete_itemtaxgroup | create_taxschedulemap | delete_taxschedulemap | describe | reconcile_bank | reverse_bill | reverse_appayment | create_apterm | update_apterm | delete_apterm | create_arterm | update_arterm | delete_arterm | create_timesheet | update_timesheet | delete_timesheet | create_task | update_task | delete_task | create_allocation | update_allocation | delete_allocation | update_cctransaction | reverse_cctransaction | hold_revrecschedule | resume_revrecschedule | terminate_revrecschedule | update_revrecschedule | create_revrecscheduleentry | post_revrecscheduleentry | unpost_revrecscheduleentry | create_expenseadjustmentreport | update_expenseadjustmentreport | delete_expenseadjustmentreport | get_expenseadjustmentreport | create_supdoc | update_supdoc | delete_supdoc | create_supdocfolder | update_supdocfolder | delete_supdocfolder | create_timetype | update_timetype | delete_timetype | create_earningtype | update_earningtype | delete_earningtype | create_employeerate | update_employeerate | delete_employeerate), got (). Line: 21, column: 3.</description2>' +
                          + '<correction></correction>' +
                    + '</error>' +
              + '</errormessage>' +
            + '</response>';        
        response1.load(s1);
        
        s2 = '<response>' +
              + '<control>' +
                    + '<status>success</status>' +
                    + '<senderid>senderId</senderid>' +
                    + '<controlid>controlId</controlid>' +
                    + '<uniqueid>false</uniqueid>' +
                    + '<dtdversion>2.1</dtdversion>' +
              + '</control>' +
              + '<operation>' +
                    + '<authentication>' +
                          + '<status>failure</status>' +
                          + '<userid>userId</userid>' +
                          + '<companyid>companyId</companyid>' +
                    + '</authentication>' +
                    + '<errormessage>' +
                          + '<error>' +
                                + '<errorno>DL03000007</errorno>' +
                                + '<description></description>' +
                                + '<description2>The user login  does not exist</description2>' +
                                + '<correction></correction>' +
                          + '</error>' +
                    + '</errormessage>' +
              + '</operation>' +
        + '</response>';
        response2.load(s2);
        
        s3 = '<response>' +
                  + '<control>' +
                        + '<status>success</status>' +
                        + '<senderid>senderId</senderid>' +
                        + '<controlid>controlId</controlid>' +
                        + '<uniqueid>false</uniqueid>' +
                        + '<dtdversion>2.1</dtdversion>' +
                  + '</control>' +
                  + '<operation>' +
                        + '<authentication>' +
                              + '<status>success</status>' +
                              + '<userid>userId</userid>' +
                              + '<companyid>companyId</companyid>' +
                        + '</authentication>' +
                        + '<result>' +
                              + '<status>failure</status>' +
                              + '<function>get</function>' +
                              + '<controlid>controlId</controlid>' +
                              + '<listtype>bill</listtype>' +  
                              + '<errormessage>' +
                                    + '<error>' +
                                          + '<errorno>ZYX</errorno>' +
                                          + '<description></description>' +
                                          + '<description2>Failed to run query QRY_APBILL_SELECT_SINGLE_VID</description2>' +
                                          + '<correction></correction>' +
                                    + '</error>' +
                              + '</errormessage>' +
                        + '</result>' +
                  + '</operation>' +
            + '</response>';
        response3.load(s3);
        
        IntacctAPI.ParseErrors(response1);
        IntacctAPI.ParseErrors(response2);
        IntacctAPI.ParseErrors(response3);
    }
}