/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class SObjectMetadata {

    // Aura-enabled member variables
    @AuraEnabled public Boolean hasHistoryTrackingEnabled    {get; private set;}
    @AuraEnabled public Boolean hasMultiCurrency             {get; private set;}
    @AuraEnabled public Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled public Boolean isAccessible                 {get; private set;}
    @AuraEnabled public Boolean isChatterFeedEnabled         {get; private set;}
    @AuraEnabled public Boolean isCreateable                 {get; private set;}
    @AuraEnabled public Boolean isCustom                     {get; private set;}
    @AuraEnabled public Boolean isCustomSetting              {get; private set;}
    @AuraEnabled public Boolean isDeletable                  {get; private set;}
    @AuraEnabled public Boolean isMruEnabled                 {get; private set;}
    @AuraEnabled public Boolean isMergeable                  {get; private set;}
    @AuraEnabled public Boolean isQueryable                  {get; private set;}
    @AuraEnabled public Boolean isSearchable                 {get; private set;}
    @AuraEnabled public Boolean isUndeletable                {get; private set;}
    @AuraEnabled public Boolean isUpdateable                 {get; private set;}
    @AuraEnabled public Fields fields                        {get; private set;}
    @AuraEnabled public List<String> fieldSetNames           {get; private set;}
    @AuraEnabled public String keyPrefix                     {get; private set;}
    @AuraEnabled public String label                         {get; private set;}
    @AuraEnabled public String labelPlural                   {get; private set;}
    @AuraEnabled public String localName                     {get; private set;}
    @AuraEnabled public String name                          {get; private set;}
    @AuraEnabled public String nameField                     {get; private set;}
    @AuraEnabled public String namespace                     {get; private set;}
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

        this.hasMultiCurrency     = this.getDescribe().fields.getMap().containsKey('CurrencyIsoCode');
        this.hasSubtypes          = this.getDescribe().getHasSubtypes();
        this.isAccessible         = this.getDescribe().isAccessible();
        this.isChatterFeedEnabled = this.getDescribe().isFeedEnabled();
        this.isCreateable         = this.getDescribe().isCreateable();
        this.isCustom             = this.getDescribe().isCustom();
        this.isCustomSetting      = this.getDescribe().isCustomSetting();
        this.isDeletable          = this.getDescribe().isDeletable();
        this.isMergeable          = this.getDescribe().isMergeable();
        this.isMRUEnabled         = this.getDescribe().isMruEnabled();
        this.isQueryable          = this.getDescribe().isQueryable();
        this.isSearchable         = this.getDescribe().isSearchable();
        this.isUndeletable        = this.getDescribe().isUndeletable();
        this.isUpdateable         = this.getDescribe().isUpdateable();
        this.fields               = new Fields(this.getDescribe());
        this.keyPrefix            = this.getDescribe().getKeyPrefix();
        this.label                = this.getDescribe().getLabel();
        this.labelPlural          = this.getDescribe().getLabelPlural();
        this.localName            = this.getDescribe().getLocalName();

        this.setHasHistoryTrackingEnabled();
        this.setFields();
        this.setFieldSets();
        this.setNamespace();
        this.setRecordTypes();
        this.setTabIcon();
    }

    public override String toString() {
        return JSON.serialize(this);
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

    private void setHasHistoryTrackingEnabled() {
        String historyObjectName;
        // The naming convention is slightly different for custom objects (MyCustomObject__History) vs standard (LeadHistory)
        if(this.name.endsWith('__c')) historyObjectName = this.name.substring(0, this.name.length() - 1) + 'History';
        else historyObjectName = this.name + 'History';

        this.hasHistoryTrackingEnabled = Schema.getGlobalDescribe().containsKey(historyObjectName);
    }

    private void setFields() {
        this.fields = new FIelds();
        this.fields.allFieldNames        = new List<String>();
        this.fields.accessibleFieldNames = new List<String>();
        this.fields.createableFieldNames = new List<String>();
        this.fields.requiredFieldNames   = new List<String>();
        this.fields.updateableFieldNames = new List<String>();

        for(Schema.SObjectField field : this.getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            String fieldName = fieldDescribe.getName();

            if(fieldDescribe.isNameField()) this.nameField = fieldDescribe.getName();

            this.fields.allFieldNames.add(fieldName);
            if(fieldDescribe.isAccessible()) this.fields.accessibleFieldNames.add(fieldName);
            if(fieldDescribe.isCreateable()) this.fields.createableFieldNames.add(fieldName);
            if(fieldDescribe.isNillable() == false && fieldDescribe.isCreateable()) this.fields.requiredFieldNames.add(fieldName);
            if(fieldDescribe.isUpdateable()) this.fields.updateableFieldNames.add(fieldName);
        }
    }

    private void setFieldSets() {
        this.fieldSetNames = new List<String>();
        for(Schema.FieldSet fieldSet : this.getDescribe().fieldSets.getMap().values()) {
            this.fieldSetNames.add(fieldSet.getName());
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

    public virtual class Fields {
        @AuraEnabled public List<String> accessibleFieldNames {get; private set;}
        @AuraEnabled public List<String> allFieldNames        {get; private set;}
        @AuraEnabled public List<String> createableFieldNames {get; private set;}
        @AuraEnabled public List<String> requiredFieldNames   {get; private set;}
        @AuraEnabled public List<String> updateableFieldNames {get; private set;}
    }

    public virtual class RecordTypeMetadata {

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