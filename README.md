# Slack 4 IoT Package

The package offers an integration for IoT Explorer with Slack. With the package you can send messages to any Slack channel directly from IoT Explorer output actions. You can freely construct the message text and format it with the familiar Slack markdown options.

With the Slack integration for IoT Explorer you can send alerts to your Slack channel, create debug output, or even consume your IoT messages with downstream applications. 

Intended Audience

The package is intended for any IoT Explorer developer. It requires access to a Slack account with admin privileges to set up an application integration.

Once configured, the integration will be useful to all users in the targeted Slack channel. No access to IoT Explorer is required at that point.

# Contributors

The package is related to Jonathan Jenkins’ package for Twilio integration at: [https://git.soma.salesforce.com/jonathan-jenkins/pe-to-twilio](https://git.soma.salesforce.com/jonathan-jenkins/pe-to-twilio)

Especially the persistence of authentication details in custom objects was directly replicated from the above package.

# Story

Slack is the fastest growing cloud-based team collaboration platform today. It is based on real-time messaging technology and features an open API for easy integration with external platforms. 

Thanks to that open API approach, Slack has become more than a collaboration platform for humans. It is a platform for real-time bots and agents to communicate and even integrate. All major productivity tools including Splunk, Datadog, Jenkins, Docker today have bots communicating directly with Slack. In a true publisher-subscriber fashion, some agents publish messages to a Slack channel, while other agents subscribe to messages on a channel.

IoT Explorer, too,  is based on a real-time messaging platform. Messages are emitted through Platform Events and processed by IoT Explorer rules inside orchestrations. The result of a these rules can be emitted again as a Platform Event or a Salesforce record today.

WIth this package we can emit messages directly to Slack and open IoT Explorer for real-time integration with external systems. In the most simple scenario described here, we have a human read the output action in a formatted text. In a much bigger context, however, these messages could be consumed by any subscriber to the Slack channel.

# Solution

## Setup Process

Before you can emit your first message, you have to do 2 things as admin:

1 - for Slack, register a new app with a webhook for incoming traffic

2 - for Salesforce, allow the Slack input webhook to be reached from Salesforce and configure your org with the webhook details

**1 Slack**

To execute these steps you have to have admin privileges on the channel. If you don’t have those for a given channel, you can either request or simply create a new channel. The owner of a channel will have admin privileges.

To get started, either use the find the "Add an app" menu item ...![image alt text](image_0.png)

… or navigate directly to [https://api.slack.com/apps](https://api.slack.com/apps)

![image alt text](image_1.png)

* Create an app with a name (e.g. "IoT Explorer") and select the right workspace![image alt text](image_2.png)

* Click "Activate Incoming Webhooks" first and then “Add New Webhook to Workspace”![image alt text](image_3.png)

* Authorize the new webhook with existing channel![image alt text](image_4.png)

* Copy the webhook URL (you will need that in the next step with Salesforce configuration)

**2**** Salesforce**

The first thing to do in Salesforce is allow for outgoing traffic to [https://hooks.slack.com](https://hooks.slack.com). This is a security configuration and requires appropriate privileges on the org you are trying to configure. IoT Explorer today requires admin privileges, so chances are you already have admin rights to make this change anyways.

From Setup → Security→ Remote Site Settings

* Add the copied webhook URL (with or without the actual path) as new remote site

![image alt text](image_5.png)

Finally you are going to create an instance of a custom object "Slack_PE_Settings__c" to populate the Slack webhook URL into.

Open workbench at [https://workbench.developerforce.com/insert.php](https://workbench.developerforce.com/insert.php)

* With data → Insert you can select the "Slack_PE_Settings__c" object![image alt text](image_6.png)

* Use any "Name" to identify the configuration with

* For OwnerId use the Smart Lookup field "Owner.Username"

* The webhook__c is the complete webhook URL (including path) copied from Slack above![image alt text](image_7.png)

## Metadata Config

Besides the "Slack PE Settings" there is one custom object called “Slack Message”. That object has a single field “Text” of type String(255) for the actual Slack message.

![image alt text](image_8.png)

To test the Slack integration we would need real IoT input events to be available. Without a connection to some device management system, however, we will have to simulate input.

For demo purposes only, we demonstrate the input through a platform event called “Slack_post_event__e”. That platform event has a couple of fields, one for a text(255) value and one used as key (a numeric id). 

The platform event can simply be created using workbench or any other external REST client (like Postman). Below is the schema for the platform event.

In a real-world situation we would expect complex orchestrations based on real IoT input events.


![image alt text](image_9.png) 

## IoT Explorer Config

IoT orchestrations to emit Slack messages can be trivial or complex. The Slack output only concerns the output action. To create a new Slack output action, select "Salesforce Record" for output.

![image alt text](image_10.png)

Create a new object of type "Slack Message"![image alt text](image_11.png)

The only required field to the object is "Text__c". Here you can construct the message format using any values, including the Slack markdown formatting options (like ` for single-line code`, ```for multi-line code```, _for cursive text_, and *for bold text*).

The provided sample orchestration uses the Slack_post_event__e body to construct a Slack_Message__c instance and wrap the value with a few additional fields into "Text__c". 

![image alt text](image_12.png)

The resulting Slack message will look like:

![image alt text](image_13.png)

# Solution Diagram

![image alt text](image_14.png) 

# Short Video

Available here: [./demo_recording_480p.mov](./demo_recording_480p.mov)

# Submission

## Email

hkache@salesforce.com

