/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.              *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public class FieldMetadata {

    // Aura-enabled member variables
    @AuraEnabled public Integer byteLength                           {get; private set;}
    @AuraEnabled public Integer digits                               {get; private set;}
    @AuraEnabled public Boolean isAccessible                         {get; private set;}
    @AuraEnabled public Boolean isAutoNumber                         {get; private set;}
    @AuraEnabled public Boolean isCalculated                         {get; private set;}
    @AuraEnabled public Boolean isCaseSensitive                      {get; private set;}
    @AuraEnabled public Boolean isCreateable                         {get; private set;}
    @AuraEnabled public Boolean isCustom                             {get; private set;}
    @AuraEnabled public Boolean isDefaultedOnCreate                  {get; private set;}
    @AuraEnabled public Boolean isFilterable                         {get; private set;}
    @AuraEnabled public Boolean isGroupable                          {get; private set;}
    @AuraEnabled public Boolean isNameField                          {get; private set;}
    @AuraEnabled public Boolean isNillable                           {get; private set;}
    @AuraEnabled public Boolean isRequired                           {get; private set;}
    @AuraEnabled public Boolean isSortable                           {get; private set;}
    @AuraEnabled public Boolean isUpdateable                         {get; private set;}
    @AuraEnabled public Integer maxLength                            {get; private set;}
    @AuraEnabled public List<PicklistEntryMetadata> picklistOptions  {get; private set;}
    @AuraEnabled public Object defaultValue                          {get; private set;}
    @AuraEnabled public String displayType                           {get; private set;}
    @AuraEnabled public String inlineHelpText                        {get; private set;}
    @AuraEnabled public String label                                 {get; private set;}
    @AuraEnabled public String localName                             {get; private set;}
    @AuraEnabled public String name                                  {get; private set;}
    @AuraEnabled public String namespace                             {get; private set;}
    @AuraEnabled public Integer precision                            {get; private set;}
    @AuraEnabled public String relationshipName                      {get; private set;}
    @AuraEnabled public Integer relationshipOrder                    {get; private set;}
    @AuraEnabled public List<SObjectMetadata> relationshipReferences {get; private set;}
    @AuraEnabled public Integer scale                                {get; private set;}
    @AuraEnabled public String soapType                              {get; private set;}
    @AuraEnabled public String sobjectName                           {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Schema.DescribeFieldResult fieldDescribe;
    private transient Schema.SObjectField sobjectField;

    public FieldMetadata(Schema.SObjectType sobjectType, Schema.SObjectField sobjectField) {
        this(sobjectType.getDescribe().getName(), sobjectField.getDescribe().getName());
    }

    public FieldMetadata(String sobjectName, String fieldName) {
        this.sobjectName     = sobjectName;
        this.name            = fieldName;

        this.byteLength          = this.getDescribe().getByteLength();
        this.defaultValue        = this.getDescribe().getDefaultValue();
        this.digits              = this.getDescribe().getDigits();
        this.displayType         = this.getDescribe().getType().name();
        this.inlineHelpText      = this.getDescribe().getInlineHelpText();
        this.isAccessible        = this.getDescribe().isAccessible();
        this.isAutoNumber        = this.getDescribe().isAutoNumber();
        this.isCalculated        = this.getDescribe().isCalculated();
        this.isCaseSensitive     = this.getDescribe().isCaseSensitive();
        this.isCreateable        = this.getDescribe().isCreateable();
        this.isCustom            = this.getDescribe().isCustom();
        this.isDefaultedOnCreate = this.getDescribe().isDefaultedOnCreate();
        this.isFilterable        = this.getDescribe().isFilterable();
        this.isGroupable         = this.getDescribe().isGroupable();
        this.isNameField         = this.getDescribe().isNameField();
        this.isNillable          = this.getDescribe().isNillable();
        this.isRequired          = this.getDescribe().isNillable() == false; // If a field is NOT nillable, then it's required
        this.isSortable          = this.getDescribe().isSortable();
        this.isUpdateable        = this.getDescribe().isUpdateable();
        this.label               = this.getDescribe().getLabel();
        this.localName           = this.getDescribe().getLocalName();
        this.maxLength           = this.getDescribe().getLength();
        this.precision           = this.getDescribe().getPrecision();
        this.relationshipName    = this.getDescribe().getRelationshipName();
        this.relationshipOrder   = this.getDescribe().getRelationshipOrder();
        this.scale               = this.getDescribe().getScale();
        this.soapType            = this.getDescribe().getSOAPType().name();

        this.setNamespace();
        this.setPicklistOptions();
        this.setRelationshipReferences();
    }

    public Schema.DescribeFieldResult getDescribe() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.fieldDescribe == null) this.fieldDescribe = this.getSObjectField().getDescribe();

        return this.fieldDescribe;
    }

    public Schema.SObjectField getSObjectField() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.sobjectField == null) this.sobjectField = Schema.getGlobalDescribe().get(this.sobjectName).getDescribe().fields.getMap().get(this.name);

        return this.sobjectField;
    }

    public String serialize() {
        return JSON.serialize(this);
    }

    private void setNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        this.namespace = localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private void setPicklistOptions() {
        this.picklistOptions = new List<PicklistEntryMetadata>();

        if(this.getDescribe().getPickListValues().isEmpty()) return;

        this.picklistOptions.add(new PicklistEntryMetadata()); // Empty picklist value
        for(Schema.PicklistEntry picklistEntry : this.getDescribe().getPickListValues()) {
            this.picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
        }
    }

    private void setRelationshipReferences() {
        this.relationshipReferences = new List<SObjectMetadata>();
        for(Schema.SObjectType sobjectType : this.fieldDescribe.getReferenceTo()) {
            this.relationshipReferences.add(new SObjectMetadata(sobjectType));
        }
    }

    public class PicklistEntryMetadata {

        // Aura-enabled member variables
        @AuraEnabled public Boolean isDefaultValue {get; private set;}
        @AuraEnabled public String label           {get; private set;}
        @AuraEnabled public String value           {get; private set;}

        // Private variables - marked as transient so they aren't included during JSON.serialize()
        private transient Schema.PicklistEntry picklistEntry;

        private PicklistEntryMetadata() {
            this.label          = '--None--';
            this.value          = '';
            this.isDefaultValue = false;
        }

        private PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.picklistEntry  = picklistEntry;

            this.label          = picklistEntry.getLabel();
            this.value          = picklistEntry.getValue();
            this.isDefaultValue = picklistEntry.isDefaultValue();
        }

    }

}