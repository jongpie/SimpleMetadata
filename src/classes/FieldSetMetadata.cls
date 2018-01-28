/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class FieldSetMetadata {

    @AuraEnabled global final String description                           {get; private set;}
    @AuraEnabled global final List<FieldSetMemberMetadata> fieldSetMembers {get; private set;}
    @AuraEnabled global final String label                                 {get; private set;}
    @AuraEnabled global final String localName                             {get; private set;}
    @AuraEnabled global final String name                                  {get; private set;}
    @AuraEnabled global final String namespace                             {get; private set;}
    @AuraEnabled global final String sobjectName                           {get; private set;}
    @AuraEnabled global final SObjectMetadata sobjectMetadata              {get; private set;}

    global FieldSetMetadata(Schema.FieldSet fieldSet) {
        this(
            String.valueOf(fieldset.getSObjectType()),
            (fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__') + fieldSet.getName()
        );
    }

    global FieldSetMetadata(String sobjectName, String fieldSetName) {
        this.sobjectName = sobjectName;
        this.name        = fieldSetName;

        Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
        Schema.FieldSet fieldSet                     = sobjectDescribe.fieldSets.getMap().get(fieldSetName);

        this.description     = fieldSet.getDescription();
        this.fieldSetMembers = this.getFieldSetMembers(fieldSet);
        this.label           = fieldSet.getLabel();
        this.localName       = this.getLocalName();
        this.namespace       = fieldSet.getNamespace();
    }

    private List<FieldSetMemberMetadata> getFieldSetMembers(Schema.FieldSet fieldSet) {
        List<FieldSetMemberMetadata> fieldSetMembers = new List<FieldSetMemberMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(sobjectName, fieldSetMember);

            fieldSetMembers.add(fieldSetMemberMetadata);
        }
        return fieldSetMembers;
    }

    private String getLocalName() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        // Add to to the localNameIndex to compensate for the '__' part of the namespace
        return localNameIndex < 0 ? null : this.name.substring(localNameIndex + 2, this.name.length());
    }

    global virtual class FieldSetMemberMetadata {

        @AuraEnabled global final String displayType          {get; private set;}
        @AuraEnabled global final FieldMetadata fieldMetadata {get; private set;}
        @AuraEnabled global final String fieldPath            {get; private set;}
        @AuraEnabled global final Boolean isDBRequired        {get; private set;}
        @AuraEnabled global final Boolean isRequired          {get; private set;}
        @AuraEnabled global final String label                {get; private set;}
        @AuraEnabled global final String sobjectName          {get; private set;}

        private FieldSetMemberMetadata(String sobjectName, Schema.FieldSetMember fieldSetMember) {
            this.sobjectName    = sobjectName;

            this.displayType   = fieldSetMember.getType().name();
            this.fieldMetadata = this.getFieldMetadata(fieldSetMember);
            this.fieldPath     = fieldSetMember.getFieldPath();
            this.isDBRequired  = fieldSetMember.getDBRequired();
            this.isRequired    = fieldSetMember.getRequired();
            this.label         = fieldSetMember.getLabel();
        }

        private FieldMetadata getFieldMetadata(Schema.FieldSetMember fieldSetMember) {
            FieldMetadata fieldMetadata;

            List<String> fieldChain = fieldSetMember.getFieldPath().split('\\.');

            if(fieldChain.size() == 0) return fieldMetadata;

            Schema.SObjectType currentFieldSObjectType = Schema.getGlobalDescribe().get(this.sobjectName);
            String currentFieldSObjectName = this.sobjectName;
            String currentFieldName;

            for(Integer i = 0; i < fieldChain.size(); i++) {
                currentFieldName = fieldChain[i];

                for(Schema.SObjectField sobjectField : Schema.getGlobalDescribe().get(currentFieldSObjectName).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult fieldDescribe = sobjectField.getDescribe();

                    if(fieldDescribe.getRelationshipName() == currentFieldName && !fieldDescribe.getReferenceTo().isEmpty()) {
                        currentFieldSObjectType = fieldDescribe.getReferenceTo()[0];
                        currentFieldSObjectName = currentFieldSObjectType.getDescribe().getName();

                        break;
                    }

                }
            }

            return new FieldMetadata(currentFieldSObjectName, currentFieldName);
        }

    }

}