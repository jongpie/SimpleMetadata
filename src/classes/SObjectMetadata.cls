/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class SObjectMetadata {

    // Stores cached query results
    private static final Map<Id, ListView> QUERIED_LIST_VIEWS_BY_ID;

    static {
        // Query & cache queues
        QUERIED_LIST_VIEWS_BY_ID = new Map<Id, ListView>();
        for(ListView listView : [SELECT Id, NameSpacePrefix, DeveloperName FROM ListView]) {
            QUERIED_LIST_VIEWS_BY_ID.put(listView.Id, listView);
        }
    }

    @AuraEnabled global final String displayFieldName              {get; private set;}
    @AuraEnabled global final Boolean hasMultiCurrency             {get; private set;}
    @AuraEnabled global final Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled global final Boolean isAccessible                 {get; private set;}
    @AuraEnabled global final Boolean isChatterFeedEnabled         {get; private set;}
    @AuraEnabled global final Boolean isCreateable                 {get; private set;}
    @AuraEnabled global final Boolean isCustom                     {get; private set;}
    @AuraEnabled global final Boolean isCustomSetting              {get; private set;}
    @AuraEnabled global final Boolean isDeletable                  {get; private set;}
    @AuraEnabled global final Boolean isMruEnabled                 {get; private set;}
    @AuraEnabled global final Boolean isMergeable                  {get; private set;}
    @AuraEnabled global final Boolean isQueryable                  {get; private set;}
    @AuraEnabled global final Boolean isSearchable                 {get; private set;}
    @AuraEnabled global final Boolean isUndeletable                {get; private set;}
    @AuraEnabled global final Boolean isUpdateable                 {get; private set;}
    @AuraEnabled global final List<String> fieldNames              {get; private set;}
    @AuraEnabled global final List<String> fieldSetNames           {get; private set;}
    @AuraEnabled global final String keyPrefix                     {get; private set;}
    @AuraEnabled global final String label                         {get; private set;}
    @AuraEnabled global final String labelPlural                   {get; private set;}
    @AuraEnabled global final List<String> listViewNames           {get; private set;}
    @AuraEnabled global final String localName                     {get; private set;}
    @AuraEnabled global final String name                          {get; private set;}
    @AuraEnabled global final String namespace                     {get; private set;}
    @AuraEnabled global final List<RecordTypeMetadata> recordTypes {get; private set;}
    @AuraEnabled global final String tabIcon                       {get; private set;}

    global SObjectMetadata(String sobjectName) {
        this(Schema.getGlobalDescribe().get(sobjectName));
    }

    global SObjectMetadata(Schema.SObjectType sobjectType) {
        DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();

        this.displayFieldName     = this.getDisplayFieldName(sobjectDescribe);
        this.fieldNames           = this.getFieldNames(sobjectDescribe);
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
        this.listViewNames        = this.getListViewNames(sobjectType);
        this.localName            = sobjectDescribe.getLocalName();
        this.name                 = String.valueOf(sobjectType);
        this.namespace            = this.getNamespace();
        this.recordTypes          = this.getRecordTypes(sobjectType, sobjectDescribe);
        this.tabIcon              = this.getTabIcon();
    }

    private String getDisplayFieldName(Schema.DescribeSObjectResult sobjectDescribe) {
        // There are several commonly used names for the display field name - typically, Name
        // Check the common names first before resorting to looping through all SObject fields
        List<String> educatedGuesses = new List<String>{
            'Name', 'Subject', 'Title', 'CaseNumber', 'OrderNumber', 'OrderItemNumber'
        };
        for(String fieldName : educatedGuesses) {
            Schema.DescribeFieldResult fieldDescribe = sobjectDescribe.fields.getMap().get(fieldName).getDescribe();

            if(fieldDescribe.isNameField()) return fieldDescribe.getName();
        }

        // If we still don't have the displayFieldName, then loop through all fields to find it
        for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(fieldDescribe.isNameField()) return fieldDescribe.getName();
        }

        return null;
    }

    private List<String> getFieldNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
            fieldNames.add(String.valueOf(field));
        }
        return fieldNames;
    }

    private List<String> getFieldSetNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldSetNames = new List<String>();
        for(Schema.FieldSet fieldSet : sobjectDescribe.fieldSets.getMap().values()) {
            fieldSetNames.add(fieldSet.getName());
        }
        return fieldSetNames;
    }

    private List<String> getListViewNames(Schema.SObjectType sobjectType) {
        String query = 'SELECT Id FROM ' + sobjectType + ' LIMIT 0';
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));

        List<String> listViewNames = new List<String>();
        for(SelectOption selectOption : stdSetController.getListViewOptions()) {
            ListView listView = QUERIED_LIST_VIEWS_BY_ID.get(selectOption.getValue());
            String listViewName = (listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__') + listView.DeveloperName;
            listViewNames.add(listViewName);
        }
        return listViewNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private List<RecordTypeMetadata> getRecordTypes(Schema.SObjectType sobjectType, Schema.DescribeSObjectResult sobjectDescribe) {
        List<RecordTypeMetadata> recordTypes = new List<RecordTypeMetadata>();
        for(Schema.RecordTypeInfo recordTypeInfo : sobjectDescribe.getRecordTypeInfos()) {
            recordTypes.add(new RecordTypeMetadata(sobjectType, recordTypeInfo));
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

}