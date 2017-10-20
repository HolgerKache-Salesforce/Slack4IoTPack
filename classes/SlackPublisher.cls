public class SlackPublisher {
    
    @InvocableMethod(label='Post to Slack')
    public static void postToSlack(List<Slack_Message__c> messages) {

        String slackURL; 
        
        Slack_PE_Settings__c[] config = [SELECT webhook__c FROM Slack_PE_Settings__c WHERE Name = 'iot-explorer'];
       
        if (config.size() > 0) {
            System.debug('webhhook = ' + config[0].webhook__c);
            slackURL = config[0].webhook__c;
        }
        
        for (Slack_Message__c message:messages) {
        
            Map<String,Object> msg = new Map<String,Object>();
        
            msg.put('text', message.Text__c);
            msg.put('mrkdwn', true);
        
            String body = JSON.serialize(msg);    
            System.enqueueJob(new QueueableSlackCall(slackURL, 'POST', body));
        }
    }
     
    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
   
        private IoT_Debug_Log__c debugLog; 
        
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
            this.debugLog = new IoT_Debug_Log__c();
        }
         
        public void execute(System.QueueableContext ctx) {
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // create a new LOG output object for every request/response pair
            debugLog.Name = req.getBody();
            debugLog.Message__c = res.getBody();
        }
        
    }
   
}