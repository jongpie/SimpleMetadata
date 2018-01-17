# Simple Metadata Lightning Components
A lightweight library of Apex classes for Salesforce that provide easy access to metadata information for frontend and backend developers
<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## SObjectMetadata.cls
* Contains metadata information for the specified SObject. There are 2 ways to create an instance of SObjectMetadata

    By passing the SObject's API name as a string in the constructor
    `new SObjectMetadata('Account')`

    By passing the SObject Type in the constructor
    `new SObjectMetadata(Schema.Account.SObjectType)`

## FieldMetadata.cls
* Contains metadata information for the specified field. There is 1 way to create an instance of FieldMetadata

    By passing the SObject's API name and the field's API name as strings in the constructor
    `new FieldMetadata('Account', 'Type')`
