# InAppMessagingSalesforce

This is a sample app that demonstrates how to use MovableInk In App Messages with the Salesforce Marketing Cloud SDK.

The important files are SalesforceClient.swift and WebViewController.swift.

## SalesforceClient

This is the client that initializes the Salesforce Marketing Cloud SDK and sets up the In App Message event delegate.

When SFMC's InAppMessageEventDelegate is called `sfmc_shouldShow(inAppMessage:) -> Bool`, we extract the link from within the message and show it via the WebViewController.

Unfortunately, SFMC doesn't currently expose an API to notify them that we've shown the message ourselves, so it'll try again on the next app boot. To solve this, we store the message id locally and check against that to determine if we've seen a message or not.

If you have multiple journeys running at the same time, it's important to use priorities to ensure the user gets the right message.

From SFMCs docs:

> #### What’s In-App Message Priority and How Do I Know Which Message Shows First?
>
> Priority determines which in-app message displays when more than one message is available. A priority 1 message displays first. The next time the user opens the app, the next highest priority is displayed. If no message priority is set or multiple messages have the same priority, the next message displayed is the message with the most recent last modified date for the activity.

Because of this limitation, users may become stuck on a high priority message and never see a lower priority message. You should utilize filters in your Journey to ensure you are targeting the correct users.

## WebViewController

This is the controller that handles the web view that is shown when the In App Message is asked to be shown. It sets up the web view it self to show the in app message, and handles click events on buttons within the message to allow you to track the event and deeplink the user to a specific page in your app.

 
