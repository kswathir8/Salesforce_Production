<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Distribution_Engine_Email_Notification</fullName>
        <description>Distribution Engine - Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Distribution_Engine_Templates/Distribution_Engine_Notification</template>
    </alerts>
    <rules>
        <fullName>Distribution Engine Notification</fullName>
        <actions>
            <name>Distribution_Engine_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email notifications to reps / agents for assignment, alerting and re-assignment by Distribution Engine</description>
        <formula>((ISNEW() &amp;&amp; In_error__c != true) || (ISCHANGED(In_alert__c) &amp;&amp; In_alert__c = true) || (ISCHANGED(Is_reassigned_to_queue__c) &amp;&amp; Is_reassigned_to_queue__c == true)) &amp;&amp; Email_notifications_disabled__c != true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
