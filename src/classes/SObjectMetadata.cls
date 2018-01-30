/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class SObjectMetadata {

    @AuraEnabled global final String displayFieldName              {get; private set;}
    @AuraEnabled global final Boolean hasMultiCurrency             {get; private set;}
    @AuraEnabled global final Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled global final Boolean isAccessible                 {get; private set;}
    @AuraEnabled global final Boolean isChatterFeedEnabled         {get; private set;}
    @AuraEnabled global final Boolean isCreateable                 {get; private set;}
    @AuraEnabled global final Boolean isCustom                     {get; private set;}
    @AuraEnabled global final Boolean isCustomSetting              {get; private set;}
    @AuraEnabled global final Boolean isDeletable                  {get; private set;}
    @AuraEnabled global final Boolean isMRUEnabled                 {get; private set;}
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
    @AuraEnabled global final List<String> recordTypeNames         {get; private set;}
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
        this.isMRUEnabled         = sobjectDescribe.isMRUEnabled();
        this.isQueryable          = sobjectDescribe.isQueryable();
        this.isSearchable         = sobjectDescribe.isSearchable();
        this.isUndeletable        = sobjectDescribe.isUndeletable();
        this.isUpdateable         = sobjectDescribe.isUpdateable();
        this.keyPrefix            = sobjectDescribe.getKeyPrefix();
        this.label                = sobjectDescribe.getLabel();
        this.labelPlural          = sobjectDescribe.getLabelPlural();
        this.listViewNames        = ListViewMetadata.getListViewNames(String.valueOf(sobjectType));
        this.localName            = sobjectDescribe.getLocalName();
        this.name                 = String.valueOf(sobjectType);
        this.namespace            = this.getNamespace();
        this.recordTypeNames      = RecordTypeMetadata.getRecordTypeNames(String.valueOf(sobjectType));//this.getRecordTypeNames(sobjectType, sobjectDescribe);
        this.tabIcon              = this.getTabIcon();
    }

    private String getDisplayFieldName(Schema.DescribeSObjectResult sobjectDescribe) {
        // There are several commonly used names for the display field name - typically, Name
        // Check the common names first before resorting to looping through all SObject fields
        // The order of the field names has been sorted based on number of objects in a dev org with that field
        List<String> educatedGuesses = new List<String>{
            'Name', 'DeveloperName', 'ApiName', 'Title', 'Subject',
            'AssetRelationshipNumber', 'CaseNumber', 'ContractNumber',
            'Domain', 'FriendlyName', 'FunctionName', 'Label', 'LocalPart',
            'OrderItemNumber', 'OrderNumber', 'SolutionName', 'TestSuiteName'
        };
        for(String fieldName : educatedGuesses) {
            Schema.SObjectField field = sobjectDescribe.fields.getMap().get(fieldName);

            if(field == null) continue;

            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

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
            String namespace = fieldSet.getNameSpace() == null ? '' : FieldSet.getNamespace() + '__';
            fieldSetNames.add(namespace + fieldSet.getName());
        }
        return fieldSetNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
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