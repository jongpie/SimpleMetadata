/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class FieldSetMetadata {

    // Aura-enabled member variables
    @AuraEnabled String description                           {get; private set;}
    @AuraEnabled List<FieldSetMemberMetadata> fieldSetMembers {get; private set;}
    @AuraEnabled String label                                 {get; private set;}
    @AuraEnabled String localName                             {get; private set;}
    @AuraEnabled String name                                  {get; private set;}
    @AuraEnabled String namespace                             {get; private set;}
    @AuraEnabled String sobjectName                           {get; private set;}
    @AuraEnabled SObjectMetadata sobjectMetadata              {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Schema.FieldSet fieldSet;

    public FieldSetMetadata(Schema.FieldSet fieldSet) {
        this(String.valueOf(fieldset.getSObjectType()), fieldSet.getName());
    }

    public FieldSetMetadata(String sobjectName, String fieldSetName) {
        this.sobjectName = sobjectName;
        this.name        = fieldSetName;

        this.sobjectMetadata = new SObjectMetadata(sobjectName);

        this.description = this.getFieldSet().getDescription();
        this.label       = this.getFieldSet().getLabel();
        this.namespace   = this.getFieldSet().getNamespace();

        this.setLocalName();
        this.setFields();
    }

    public override String toString() {
        return JSON.serialize(this);
    }

    public Schema.FieldSet getFieldSet() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.fieldSet == null) this.fieldSet = this.sobjectMetadata.getDescribe().fieldSets.getMap().get(this.name);

        return this.fieldSet;
    }

    private void setLocalName() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        // Add to to the localNameIndex to compensate for the '__' part of the namespace
        this.localName = localNameIndex < 0 ? null : this.name.substring(localNameIndex + 2, this.name.length());
    }

    private void setFields() {
        this.fieldSetMembers = new List<FieldSetMemberMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(sobjectName, fieldSetMember);

            this.fieldSetMembers.add(fieldSetMemberMetadata);
        }
    }

    public virtual class FieldSetMemberMetadata {

        // Aura-enabled member variables
        @AuraEnabled public String displayType          {get; private set;}
        @AuraEnabled public FieldMetadata fieldMetadata {get; private set;}
        @AuraEnabled public String fieldPath            {get; private set;}
        @AuraEnabled public Boolean isDBRequired        {get; private set;}
        @AuraEnabled public Boolean isRequired          {get; private set;}
        @AuraEnabled public String label                {get; private set;}
        @AuraEnabled public String sobjectName          {get; private set;}

        // Private variables - marked as transient so they aren't included during JSON.serialize()
        private transient Schema.FieldSetMember fieldSetMember;

        private FieldSetMemberMetadata(String sobjectName, Schema.FieldSetMember fieldSetMember) {
            this.sobjectName    = sobjectName;
            this.fieldSetMember = fieldSetMember;

            this.displayType  = this.fieldSetMember.getType().name();
            this.fieldPath    = this.fieldSetMember.getFieldPath();
            this.isDBRequired = this.fieldSetMember.getDBRequired();
            this.isRequired   = this.fieldSetMember.getRequired();
            this.label        = this.fieldSetMember.getLabel();

            this.setFieldMetadata();
        }

        private void setFieldMetadata() {
            List<String> fieldChain = this.fieldPath.split('\\.');

            if(fieldChain.size() == 0) return;

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

                this.fieldMetadata = new FieldMetadata(currentFieldSObjectName, currentFieldName);
            }
        }

    }

}