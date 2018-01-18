/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.              *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public with sharing class FieldSetMetadata {

    // Aura-enabled member variables
    @AuraEnabled String description                  {get; private set;}
    @AuraEnabled List<FieldSetMemberMetadata> fields {get; private set;}
    @AuraEnabled String label                        {get; private set;}
    @AuraEnabled String name                         {get; private set;}
    @AuraEnabled String namespace                    {get; private set;}
    @AuraEnabled String sobjectName                  {get; private set;}
    @AuraEnabled SObjectMetadata sobjectMetadata     {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Schema.FieldSet fieldSet;

    public FieldSetMetadata(String sobjectName, String fieldSetName) {
        this.sobjectName = sobjectName;
        this.name        = fieldSetName;

        this.sobjectMetadata = new SObjectMetadata(sobjectName);

        this.description = this.getFieldSet().getDescription();
        this.label       = this.getFieldSet().getLabel();
        this.namespace   = this.getFieldSet().getNamespace();

        this.setFields();
    }

    public Schema.FieldSet getFieldSet() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.fieldSet == null) this.fieldSet = this.sobjectMetadata.getDescribe().fieldSets.getMap().get(this.name);

        return this.fieldSet;
    }

    public override String toString() {
        return JSON.serialize(this);
    }

    private void setFields() {
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            String fieldName = fieldSetMember.getFieldPath();
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(sobjectName, fieldName, fieldSetMember);

            this.fields.add(fieldSetMemberMetadata);
        }
    }

    public class FieldSetMemberMetadata {

        // Aura-enabled member variables
        @AuraEnabled public String displayType          {get; private set;}
        @AuraEnabled public FieldMetadata fieldMetadata {get; private set;}
        @AuraEnabled public String fieldName            {get; private set;}
        @AuraEnabled public String fieldPath            {get; private set;}
        @AuraEnabled public Boolean isDBRequired        {get; private set;}
        @AuraEnabled public Boolean isRequired          {get; private set;}
        @AuraEnabled public String label                {get; private set;}
        @AuraEnabled public String sobjectName          {get; private set;}

        // Private variables - marked as transient so they aren't included during JSON.serialize()
        private transient Schema.FieldSetMember fieldSetMember;

        private FieldSetMemberMetadata(String sobjectName, String fieldName, Schema.FieldSetMember fieldSetMember) {
            this.sobjectName    = sobjectName;
            this.fieldName      = fieldName;
            this.fieldSetMember = fieldSetMember;

            this.fieldMetadata = new FieldMetadata(sobjectName, fieldName);

            this.displayType  = this.fieldSetMember.getType().name();
            this.fieldPath    = this.fieldSetMember.getFieldPath();
            this.isDBRequired = this.fieldSetMember.getDBRequired();
            this.isRequired   = this.fieldSetMember.getRequired();
            this.label        = this.fieldSetMember.getLabel();
        }

    }

}