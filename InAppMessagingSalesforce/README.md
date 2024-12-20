# InAppMessagingSalesforce

This is a sample app that demonstrates how to use MovableInk In App Messages with the Salesforce Marketing Cloud SDK.

The important files are SalesforceClient.swift and WebViewController.swift.

## SalesforceClient

This is the client that initializes the Salesforce Marketing Cloud SDK and sets up the In App Message event delegate.

When SFMC's InAppMessageEventDelegate is called `sfmc_shouldShow(inAppMessage:) -> Bool`, we extract the link from within the message and show it via the WebViewController.

## WebViewController

This is the controller that handles the web view that is shown when the In App Message is asked to be shown. It sets up the web view it self to show the in app message, and handles click events on buttons within the message to allow you to track the event and deeplink the user to a specific page in your app.

