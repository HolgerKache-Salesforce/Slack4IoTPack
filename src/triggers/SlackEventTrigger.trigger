trigger SlackEventTrigger on Slack_post_event__e (after insert) {

        SlackPublisher.postToSlack(Trigger.new);
}