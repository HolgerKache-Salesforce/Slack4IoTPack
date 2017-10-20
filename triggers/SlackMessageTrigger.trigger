trigger SlackMessageTrigger on Slack_Message__c (before insert) {

        SlackPublisher.postToSlack(Trigger.new);
}