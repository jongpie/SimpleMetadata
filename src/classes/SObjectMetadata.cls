/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class SObjectMetadata {

    @AuraEnabled public final Boolean hasMultiCurrency             {get; private set;}
    @AuraEnabled public final Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled public final Boolean isAccessible                 {get; private set;}
    @AuraEnabled public final Boolean isChatterFeedEnabled         {get; private set;}
    @AuraEnabled public final Boolean isCreateable                 {get; private set;}
    @AuraEnabled public final Boolean isCustom                     {get; private set;}
    @AuraEnabled public final Boolean isCustomSetting              {get; private set;}
    @AuraEnabled public final Boolean isDeletable                  {get; private set;}
    @AuraEnabled public final Boolean isMruEnabled                 {get; private set;}
    @AuraEnabled public final Boolean isMergeable                  {get; private set;}
    @AuraEnabled public final Boolean isQueryable                  {get; private set;}
    @AuraEnabled public final Boolean isSearchable                 {get; private set;}
    @AuraEnabled public final Boolean isUndeletable                {get; private set;}
    @AuraEnabled public final Boolean isUpdateable                 {get; private set;}
    @AuraEnabled public final Fields fields                        {get; private set;}
    @AuraEnabled public final List<String> fieldSetNames           {get; private set;}
    @AuraEnabled public final String keyPrefix                     {get; private set;}
    @AuraEnabled public final String label                         {get; private set;}
    @AuraEnabled public final String labelPlural                   {get; private set;}
    @AuraEnabled public final String localName                     {get; private set;}
    @AuraEnabled public final String name                          {get; private set;}
    @AuraEnabled public final String namespace                     {get; private set;}
    @AuraEnabled public final List<RecordTypeMetadata> recordTypes {get; private set;}
    @AuraEnabled public final String tabIcon                       {get; private set;}

    public SObjectMetadata(Schema.SObjectType sobjectType) {
        this(sobjectType.getDescribe().getName());
    }

    public SObjectMetadata(String sobjectName) {
        this.name = sobjectName;

        Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(this.name).getDescribe();

        this.fields               = new Fields(sobjectDescribe);
        this.fieldSetNames        = this.getFieldSetNames(sobjectDescribe);
        this.hasMultiCurrency     = sobjectDescribe.fields.getMap().containsKey('CurrencyIsoCode');
        this.hasSubtypes          = sobjectDescribe.getHasSubtypes();
        this.isAccessible         = sobjectDescribe.isAccessible();
        this.isChatterFeedEnabled = sobjectDescribe.isFeedEnabled();
        this.isCreateable         = sobjectDescribe.isCreateable();
        this.isCustom             = sobjectDescribe.isCustom();
        this.isCustomSetting      = sobjectDescribe.isCustomSetting();
        this.isDeletable          = sobjectDescribe.isDeletable();
        this.isMergeable          = sobjectDescribe.isMergeable();
        this.isMRUEnabled         = sobjectDescribe.isMruEnabled();
        this.isQueryable          = sobjectDescribe.isQueryable();
        this.isSearchable         = sobjectDescribe.isSearchable();
        this.isUndeletable        = sobjectDescribe.isUndeletable();
        this.isUpdateable         = sobjectDescribe.isUpdateable();
        this.keyPrefix            = sobjectDescribe.getKeyPrefix();
        this.label                = sobjectDescribe.getLabel();
        this.labelPlural          = sobjectDescribe.getLabelPlural();
        this.localName            = sobjectDescribe.getLocalName();
        this.namespace            = this.getNamespace();
        this.recordTypes          = this.getRecordTypes(sobjectDescribe);
        this.tabIcon              = this.getTabIcon();
    }

    private List<String> getFieldSetNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldSetNames = new List<String>();
        for(Schema.FieldSet fieldSet : sobjectDescribe.fieldSets.getMap().values()) {
            this.fieldSetNames.add(fieldSet.getName());
        }
        return fieldSetNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private List<RecordTypeMetadata> getRecordTypes(Schema.DescribeSObjectResult sobjectDescribe) {
        List<RecordTypeMetadata> recordTypes = new List<RecordTypeMetadata>();
        for(Schema.RecordTypeInfo recordTypeInfo : sobjectDescribe.getRecordTypeInfos()) {
            this.recordTypes.add(new RecordTypeMetadata(recordTypeInfo));
        }
        return recordTypes;
    }

    private String getTabIcon() {
        String tabIcon;
        for(Schema.DescribeTabSetResult tabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult tabResult : tabSetResult.getTabs()) {
                if(tabResult.getSObjectName() != this.name) continue;

                String iconType = tabResult.isCustom() ? 'custom' : 'standard';
                String svgIconName;
                for(Schema.DescribeIconResult icon : tabResult.getIcons()) {
                    if(icon.getContentType() != 'image/svg+xml') continue;

                    svgIconName = icon.getUrl().substringAfterLast('/').replace('.svg', '');
                    tabIcon = iconType + ':' + svgIconName;
                    break;
                }
            }
        }
        // Hardcoded exceptions - Salesforce doesn't return SVGs for these objects, so hardcoding is necessary
        if(tabIcon == null && this.name == 'Asset') tabIcon = 'standard:maintenance_asset';
        if(tabIcon == null && this.name == 'AssetRelationship') tabIcon = 'standard:asset_relationship';

        return tabIcon;
    }

    public virtual class Fields {

        @AuraEnabled public final String nameField                  {get; private set;}
        @AuraEnabled public final List<String> accessibleFieldNames {get; private set;}
        @AuraEnabled public final List<String> allFieldNames        {get; private set;}
        @AuraEnabled public final List<String> createableFieldNames {get; private set;}
        @AuraEnabled public final List<String> requiredFieldNames   {get; private set;}
        @AuraEnabled public final List<String> updateableFieldNames {get; private set;}

        public Fields(Schema.DescribeSObjectResult sobjectDescribe) {
            this.accessibleFieldNames = new List<String>();
            this.allFieldNames        = new List<String>();
            this.createableFieldNames = new List<String>();
            this.requiredFieldNames   = new List<String>();
            this.updateableFieldNames = new List<String>();

            for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                String fieldName = fieldDescribe.getName();

                if(fieldDescribe.isNameField()) this.nameField = fieldDescribe.getName();

                this.allFieldNames.add(fieldName);
                if(fieldDescribe.isAccessible()) this.accessibleFieldNames.add(fieldName);
                if(fieldDescribe.isCreateable()) this.createableFieldNames.add(fieldName);
                if(fieldDescribe.isNillable() == false && fieldDescribe.isCreateable()) this.requiredFieldNames.add(fieldName);
                if(fieldDescribe.isUpdateable()) this.updateableFieldNames.add(fieldName);
            }
        }

    }

    public virtual class RecordTypeMetadata {

        @AuraEnabled public final Boolean isActive                   {get; private set;}
        @AuraEnabled public final Boolean isAvailable                {get; private set;}
        @AuraEnabled public final Boolean isDefaultRecordTypeMapping {get; private set;}
        @AuraEnabled public final Boolean isMaster                   {get; private set;}
        @AuraEnabled public final Id recordTypeId                    {get; private set;}
        @AuraEnabled public final String name                        {get; private set;}

        private RecordTypeMetadata(Schema.RecordTypeInfo recordTypeInfo) {
            this.isActive                   = recordTypeInfo.isActive();
            this.isAvailable                = recordTypeInfo.isAvailable();
            this.isDefaultRecordTypeMapping = recordTypeInfo.isDefaultRecordTypeMapping();
            this.isMaster                   = recordTypeInfo.isMaster();
            this.name                       = recordTypeInfo.getName();
            this.recordTypeId               = recordTypeInfo.getRecordTypeId();
        }

    }

}