/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class FieldMetadata {

    @AuraEnabled public final Integer byteLength                           {get; private set;}
    @AuraEnabled public final Object defaultValue                          {get; private set;}
    @AuraEnabled public final Integer digits                               {get; private set;}
    @AuraEnabled public final String displayType                           {get; private set;}
    @AuraEnabled public final String inlineHelpText                        {get; private set;}
    @AuraEnabled public final Boolean isAccessible                         {get; private set;}
    @AuraEnabled public final Boolean isAutoNumber                         {get; private set;}
    @AuraEnabled public final Boolean isCalculated                         {get; private set;}
    @AuraEnabled public final Boolean isCaseSensitive                      {get; private set;}
    @AuraEnabled public final Boolean isCreateable                         {get; private set;}
    @AuraEnabled public final Boolean isCustom                             {get; private set;}
    @AuraEnabled public final Boolean isDefaultedOnCreate                  {get; private set;}
    @AuraEnabled public final Boolean isFilterable                         {get; private set;}
    @AuraEnabled public final Boolean isGroupable                          {get; private set;}
    @AuraEnabled public final Boolean isNameField                          {get; private set;}
    @AuraEnabled public final Boolean isNillable                           {get; private set;}
    @AuraEnabled public final Boolean isRequired                           {get; private set;}
    @AuraEnabled public final Boolean isSortable                           {get; private set;}
    @AuraEnabled public final Boolean isUpdateable                         {get; private set;}
    @AuraEnabled public final String label                                 {get; private set;}
    @AuraEnabled public final String localName                             {get; private set;}
    @AuraEnabled public final Integer maxLength                            {get; private set;}
    @AuraEnabled public final String name                                  {get; private set;}
    @AuraEnabled public final String namespace                             {get; private set;}
    @AuraEnabled public final List<PicklistEntryMetadata> picklistOptions  {get; private set;}
    @AuraEnabled public final Integer precision                            {get; private set;}
    @AuraEnabled public final String relationshipName                      {get; private set;}
    @AuraEnabled public final Integer relationshipOrder                    {get; private set;}
    @AuraEnabled public final List<SObjectMetadata> relationshipReferences {get; private set;}
    @AuraEnabled public final Integer scale                                {get; private set;}
    @AuraEnabled public final String soapType                              {get; private set;}
    @AuraEnabled public final String sobjectName                           {get; private set;}

    public FieldMetadata(Schema.SObjectType sobjectType, Schema.SObjectField sobjectField) {
        this(sobjectType.getDescribe().getName(), sobjectField.getDescribe().getName());
    }

    public FieldMetadata(String sobjectName, String fieldName) {
        this.sobjectName     = sobjectName;
        this.name            = fieldName;

        Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
        Schema.DescribeFieldResult fieldDescribe     = sobjectDescribe.fields.getMap().get(fieldName).getDescribe();

        this.byteLength             = fieldDescribe.getByteLength();
        this.defaultValue           = fieldDescribe.getDefaultValue();
        this.digits                 = fieldDescribe.getDigits();
        this.displayType            = fieldDescribe.getType().name();
        this.inlineHelpText         = fieldDescribe.getInlineHelpText();
        this.isAccessible           = fieldDescribe.isAccessible();
        this.isAutoNumber           = fieldDescribe.isAutoNumber();
        this.isCalculated           = fieldDescribe.isCalculated();
        this.isCaseSensitive        = fieldDescribe.isCaseSensitive();
        this.isCreateable           = fieldDescribe.isCreateable();
        this.isCustom               = fieldDescribe.isCustom();
        this.isDefaultedOnCreate    = fieldDescribe.isDefaultedOnCreate();
        this.isFilterable           = fieldDescribe.isFilterable();
        this.isGroupable            = fieldDescribe.isGroupable();
        this.isNameField            = fieldDescribe.isNameField();
        this.isNillable             = fieldDescribe.isNillable();
        this.isRequired             = fieldDescribe.isNillable() == false && fieldDescribe.isCreateable(); // If a field is NOT nillable, then it's required
        this.isSortable             = fieldDescribe.isSortable();
        this.isUpdateable           = fieldDescribe.isUpdateable();
        this.label                  = fieldDescribe.getLabel();
        this.localName              = fieldDescribe.getLocalName();
        this.maxLength              = fieldDescribe.getLength();
        this.namespace              = this.getNamespace();
        this.picklistOptions        = this.getPicklistOptions(fieldDescribe);
        this.precision              = fieldDescribe.getPrecision();
        this.relationshipName       = fieldDescribe.getRelationshipName();
        this.relationshipOrder      = fieldDescribe.getRelationshipOrder();
        this.relationshipReferences = this.getRelationshipReferences(fieldDescribe);
        this.scale                  = fieldDescribe.getScale();
        this.soapType               = fieldDescribe.getSOAPType().name();
    }

    private String getNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private List<PicklistEntryMetadata> getPicklistOptions(Schema.DescribeFieldResult fieldDescribe) {
        List<PicklistEntryMetadata> picklistOptions = new List<PicklistEntryMetadata>();

        if(fieldDescribe.getPickListValues().isEmpty()) return picklistOptions;

        picklistOptions.add(new PicklistEntryMetadata()); // Add an empty picklist value
        for(Schema.PicklistEntry picklistEntry : fieldDescribe.getPickListValues()) {
            picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
        }
        return picklistOptions;
    }

    private List<SObjectMetadata> getRelationshipReferences(Schema.DescribeFieldResult fieldDescribe) {
        List<SObjectMetadata> relationshipReferences = new List<SObjectMetadata>();
        for(Schema.SObjectType sobjectType : fieldDescribe.getReferenceTo()) {
            relationshipReferences.add(new SObjectMetadata(sobjectType));
        }
        return relationshipReferences;
    }

    public virtual class PicklistEntryMetadata {

        @AuraEnabled public final Boolean isDefaultValue {get; private set;}
        @AuraEnabled public final String label           {get; private set;}
        @AuraEnabled public final String value           {get; private set;}

        public PicklistEntryMetadata() {
            this.isDefaultValue = false;
            this.label          = '--None--';
            this.value          = '';
        }

        public PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.isDefaultValue = picklistEntry.isDefaultValue();
            this.label          = picklistEntry.getLabel();
            this.value          = picklistEntry.getValue();
        }

    }

}