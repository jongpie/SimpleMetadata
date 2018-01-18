/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.              *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public class SObjectMetadata {

    // Aura-enabled member variables
    @AuraEnabled public Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled public Boolean isAccessible                 {get; private set;}
    @AuraEnabled public Boolean isCreateable                 {get; private set;}
    @AuraEnabled public Boolean isCustom                     {get; private set;}
    @AuraEnabled public Boolean isCustomSetting              {get; private set;}
    @AuraEnabled public Boolean isDeletable                  {get; private set;}
    @AuraEnabled public Boolean isFeedEnabled                {get; private set;}
    @AuraEnabled public Boolean isMruEnabled                 {get; private set;}
    @AuraEnabled public Boolean isMergeable                  {get; private set;}
    @AuraEnabled public Boolean isQueryable                  {get; private set;}
    @AuraEnabled public Boolean isSearchable                 {get; private set;}
    @AuraEnabled public Boolean isUndeletable                {get; private set;}
    @AuraEnabled public Boolean isUpdateable                 {get; private set;}
    @AuraEnabled public List<String> fieldNames              {get; private set;}
    @AuraEnabled public String keyPrefix                     {get; private set;}
    @AuraEnabled public String label                         {get; private set;}
    @AuraEnabled public String labelPlural                   {get; private set;}
    @AuraEnabled public String localName                     {get; private set;}
    @AuraEnabled public String name                          {get; private set;}
    @AuraEnabled public String nameField                     {get; private set;}
    @AuraEnabled public String nameSpace                     {get; private set;}
    @AuraEnabled public List<RecordTypeMetadata> recordTypes {get; private set;}
    @AuraEnabled public String tabIcon                       {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Schema.DescribeSObjectResult sobjectDescribe;
    private transient Schema.SObjectType sobjectType;

    public SObjectMetadata(Schema.SObjectType sobjectType) {
        this(sobjectType.getDescribe().getName());
    }

    public SObjectMetadata(String sobjectName) {
        this.name = sobjectName;

        this.hasSubtypes     = this.getDescribe().getHasSubtypes();
        this.isAccessible    = this.getDescribe().isAccessible();
        this.isCreateable    = this.getDescribe().isCreateable();
        this.isCustom        = this.getDescribe().isCustom();
        this.isCustomSetting = this.getDescribe().isCustomSetting();
        this.isDeletable     = this.getDescribe().isDeletable();
        this.isFeedEnabled   = this.getDescribe().isFeedEnabled();
        this.isMruEnabled    = this.getDescribe().isMruEnabled();
        this.isMergeable     = this.getDescribe().isMergeable();
        this.isQueryable     = this.getDescribe().isQueryable();
        this.isSearchable    = this.getDescribe().isSearchable();
        this.isUndeletable   = this.getDescribe().isUndeletable();
        this.isUpdateable    = this.getDescribe().isUpdateable();
        this.keyPrefix       = this.getDescribe().getKeyPrefix();
        this.label           = this.getDescribe().getLabel();
        this.labelPlural     = this.getDescribe().getLabelPlural();
        this.localName       = this.getDescribe().getLocalName();

        this.setFields();
        this.setNamespace();
        this.setRecordTypes();
        this.setTabIcon();
    }

    public Schema.DescribeSObjectResult getDescribe() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.sobjectDescribe == null) this.sobjectDescribe = this.getSObjectType().getDescribe();

        return this.sobjectDescribe;
    }

    public Schema.SObjectType getSObjectType() {
        // If a JSON object is deserialized into an instance of this class, private variables are null, so set them when needed
        if(this.sobjectType == null) this.sobjectType = Schema.getGlobalDescribe().get(this.name);

        return this.sobjectType;
    }

    public String serialize() {
        return JSON.serialize(this);
    }

    private void setFields() {
        this.fieldNames = new List<String>();
        for(Schema.SObjectField field : this.getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(fieldDescribe.isNameField()) this.nameField = fieldDescribe.getName();

            this.fieldNames.add(fieldDescribe.getName());
        }
    }

    private void setNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        this.namespace = localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private void setRecordTypes() {
        this.recordTypes = new List<RecordTypeMetadata>();
        for(Schema.RecordTypeInfo recordTypeInfo : this.getDescribe().getRecordTypeInfos()) {
            this.recordTypes.add(new RecordTypeMetadata(recordTypeInfo));
        }
    }

    private void setTabIcon() {
        for(Schema.DescribeTabSetResult tabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult tabResult : tabSetResult.getTabs()) {
                if(tabResult.getSObjectName() != this.name) continue;

                String iconType = tabResult.isCustom() ? 'custom' : 'standard';
                String svgIconName;
                for(Schema.DescribeIconResult icon : tabResult.getIcons()) {
                    if(icon.getContentType() != 'image/svg+xml') continue;

                    svgIconName = icon.getUrl().substringAfterLast('/').replace('.svg', '');
                    this.tabIcon = iconType + ':' + svgIconName;
                    break;
                }
            }
        }
        // Hardcoded exceptions - Salesforce doesn't return SVGs for these objects, so hardcoding is necessary
        if(this.tabIcon == null && this.name == 'Asset') this.tabIcon = 'standard:maintenance_asset';
        if(this.tabIcon == null && this.name == 'AssetRelationship') this.tabIcon = 'standard:asset_relationship';
    }

    public class RecordTypeMetadata {

        // Aura-enabled member variables
        @AuraEnabled public Boolean isActive                   {get; private set;}
        @AuraEnabled public Boolean isAvailable                {get; private set;}
        @AuraEnabled public Boolean isDefaultRecordTypeMapping {get; private set;}
        @AuraEnabled public Boolean isMaster                   {get; private set;}
        @AuraEnabled public Id recordTypeId                    {get; private set;}
        @AuraEnabled public String name                        {get; private set;}

        // Private variables - marked as transient so they aren't included during JSON.serialize()
        private transient Schema.RecordTypeInfo recordTypeInfo {get; private set;}

        private RecordTypeMetadata(Schema.RecordTypeInfo recordTypeInfo) {
            this.recordTypeInfo = recordTypeInfo;

            this.isActive                   = this.recordTypeInfo.isActive();
            this.isAvailable                = this.recordTypeInfo.isAvailable();
            this.isDefaultRecordTypeMapping = this.recordTypeInfo.isDefaultRecordTypeMapping();
            this.isMaster                   = this.recordTypeInfo.isMaster();
            this.name                       = this.recordTypeInfo.getName();
            this.recordTypeId               = this.recordTypeInfo.getRecordTypeId();
        }

    }

}