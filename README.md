# SimpleMetadata
A lightweight library of Apex classes for Salesforce that provide easy access to metadata information for frontend and backend Salesforce developers
<br />
<br />
<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## SObjectMetadata.cls
* Contains metadata information for the specified SObject. There are 2 ways to create an instance of SObjectMetadata

    By passing the SObject's API name as a string in the constructor
    ```
    new SObjectMetadata('Account')
    ```

    By passing the SObject Type in the constructor
    ```
    new SObjectMetadata(Schema.Account.SObjectType)`
    ```

    ### Sample Usage
    Scenario: if the user has access to delete an SObject, then delete it

    ```
    public class MyClass {

        public void deleteRecord(MyCustomObject__c myRecord) {
            // If the user does not have access to delete, then stop
            if(new SObjectMetadata('MyCustomObject__c').isDeletable == false) return;

            //Otherwise, delete the record
            delete myRecord.MyCustomField__c;
        }

    }
    ```

## FieldMetadata.cls
* Contains metadata information for the specified field. There are 2 ways to create an instance of FieldMetadata

    By passing the SObject's API name and the field's API name as strings in the constructor
    ```
    new FieldMetadata('Account', 'Type')
    ```

    By passing the SObject Type and the SObject Field in the constructor
    ```
    new FieldMetadata(Schema.Account.SObjectType, Schema.Account.Type)
    ```

    ### Sample Usage
    Scenario: if the user has access to edit a field, set the value

    ```
    public class MyClass {

        public void setMyField(MyCustomObject__c myRecord) {
            // If the user does not have access to delete, then stop
            if(new FieldMetadata('MyCustomObject__c', 'MyCustomField__c').isUpdateable) {

            // Otherwise, set the field
            myRecord.MyCustomField__c = 'some value';
        }

    }
    ```