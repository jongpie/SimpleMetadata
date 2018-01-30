/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private  class FieldSetMetadata_Tests {

     @isTest
    static void it_should_return_metadata_for_sobject_name_and_field_set_name() {
        SObjectField nameFieldField = Account.Name;

        Schema.FieldSet fieldSet = getFieldSet();
        if(fieldSet == null) return;

        Test.startTest();

        String sobjectName = String.valueOf(fieldSet.getSObjectType());
        String fieldSetNamespace = fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__';
        String fieldSetName = fieldSetNamespace + fieldSet.getName();
        FieldSetMetadata fieldSetMetadata = new FieldSetMetadata(sobjectName, fieldSetName);
        validateAttributesAreSet(fieldSet, fieldSetMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_field_set_token() {
        SObjectField nameFieldField = Account.Name;

        Schema.FieldSet fieldSet = getFieldSet();
        if(fieldSet == null) return;

        Test.startTest();

        FieldSetMetadata fieldSetMetadata = new FieldSetMetadata(fieldSet);
        validateAttributesAreSet(fieldSet, fieldSetMetadata);

        Test.stopTest();
    }

    private static Schema.FieldSet getFieldSet() {
        // Dynamically check for field sets in some of the most commonly used objects
        // If not results are found, then test coverage will drop

        List<String> commonSObjectNames = new List<String>{
            'Account', 'Lead', 'Contact', 'Opportunity'
        };
        for(String sobjectName : commonSObjectNames) {
            Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
            // If there are any fields sets found, return the first one
            if(sobjectDescribe.fieldSets.getMap().isEmpty() == false) return sobjectDescribe.fieldSets.getMap().values()[0];
        }
        return null;
    }

    private static void validateAttributesAreSet(Schema.FieldSet fieldSet, FieldSetMetadata fieldSetMetadata) {
        String namespacePrefix = '';
        if(fieldSet.getNamespace() != null) namespacePrefix = fieldSet.getNamespace() + '__';
        String fieldSetName = namespacePrefix + fieldSet.getName();

        System.assertEquals(fieldSet.getDescription(), fieldSetMetadata.description);
        System.assertEquals(fieldSet.getFields().size(), fieldSetMetadata.fieldSetMembers.size());
        // TODO add asserts for field set members' field metadata
        System.assertEquals(fieldSet.getLabel(), fieldSetMetadata.label);
        // TODO add assert for localName
        System.assertEquals(fieldSetName, fieldSetMetadata.name);
        System.assertEquals(fieldSet.getNamespace(), fieldSetMetadata.namespace);
        System.assertEquals(String.valueOf(fieldSet.getSObjectType()), fieldSetMetadata.sobjectName);
    }

}