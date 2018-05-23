/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class SobjectMetadata {

    @AuraEnabled global final String ApiName                  {get; private set;}
    @AuraEnabled global final String DisplayFieldApiName      {get; private set;}
    @AuraEnabled global final List<String> FieldApiNames      {get; private set;}
    @AuraEnabled global final List<String> FieldSetApiNames   {get; private set;}
    @AuraEnabled global final Boolean HasMultiCurrency        {get; private set;}
    @AuraEnabled global final Boolean HasSubtypes             {get; private set;}
    @AuraEnabled global final Boolean IsAccessible            {get; private set;}
    @AuraEnabled global final Boolean IsChatterFeedEnabled    {get; private set;}
    @AuraEnabled global final Boolean IsCreateable            {get; private set;}
    @AuraEnabled global final Boolean IsCustom                {get; private set;}
    @AuraEnabled global final Boolean IsCustomSetting         {get; private set;}
    @AuraEnabled global final Boolean IsDeletable             {get; private set;}
    @AuraEnabled global final Boolean IsMruEnabled            {get; private set;}
    @AuraEnabled global final Boolean IsMergeable             {get; private set;}
    @AuraEnabled global final Boolean IsQueryable             {get; private set;}
    @AuraEnabled global final Boolean IsSearchable            {get; private set;}
    @AuraEnabled global final Boolean IsUndeletable           {get; private set;}
    @AuraEnabled global final Boolean IsUpdateable            {get; private set;}
    @AuraEnabled global final String KeyPrefix                {get; private set;}
    @AuraEnabled global final String Label                    {get; private set;}
    @AuraEnabled global final String LabelPlural              {get; private set;}
    @AuraEnabled global final String LocalApiName             {get; private set;}
    @AuraEnabled global final String Namespace                {get; private set;}
    @AuraEnabled global final List<String> RecordTypeApiNames {get; private set;}
    @AuraEnabled global final String TabIcon                  {get; private set;}

    global SobjectMetadata(String sobjectApiName) {
        this(Schema.getGlobalDescribe().get(sobjectApiName));
    }

    global SobjectMetadata(Schema.SobjectType sobjectType) {
        DescribeSobjectResult sobjectDescribe = sobjectType.getDescribe();

        this.ApiName              = String.valueOf(sobjectType);
        this.DisplayFieldApiName  = this.getDisplayFieldApiName(sobjectDescribe);
        this.FieldApiNames        = this.getFieldApiNames(sobjectDescribe);
        this.FieldSetApiNames     = this.getFieldSetApiNames(sobjectDescribe);
        this.HasMultiCurrency     = sobjectDescribe.fields.getMap().containsKey('CurrencyIsoCode');
        this.HasSubtypes          = sobjectDescribe.getHasSubtypes();
        this.IsAccessible         = sobjectDescribe.isAccessible();
        this.IsChatterFeedEnabled = sobjectDescribe.isFeedEnabled();
        this.IsCreateable         = sobjectDescribe.isCreateable();
        this.IsCustom             = sobjectDescribe.isCustom();
        this.IsCustomSetting      = sobjectDescribe.isCustomSetting();
        this.IsDeletable          = sobjectDescribe.isDeletable();
        this.IsMergeable          = sobjectDescribe.isMergeable();
        this.IsMruEnabled         = sobjectDescribe.isMruEnabled();
        this.IsQueryable          = sobjectDescribe.isQueryable();
        this.IsSearchable         = sobjectDescribe.isSearchable();
        this.IsUndeletable        = sobjectDescribe.isUndeletable();
        this.IsUpdateable         = sobjectDescribe.isUpdateable();
        this.KeyPrefix            = sobjectDescribe.getKeyPrefix();
        this.Label                = sobjectDescribe.getLabel();
        this.LabelPlural          = sobjectDescribe.getLabelPlural();
        this.LocalApiName         = sobjectDescribe.getLocalName();
        this.Namespace            = this.getNamespace();
        this.RecordTypeApiNames   = RecordTypeMetadata.getRecordTypeApiNames(String.valueOf(sobjectType));
        this.TabIcon              = this.getTabIcon();
    }

    private String getDisplayFieldApiName(Schema.DescribeSobjectResult sobjectDescribe) {
        // There are several commonly used names for the display field name - typically, Name
        // Check the common names first before resorting to looping through all Sobject fields
        // The order of the field names has been sorted based on number of objects in a dev org with that field
        List<String> educatedGuesses = new List<String>{
            'Name', 'DeveloperName', 'ApiName', 'Title', 'Subject',
            'AssetRelationshipNumber', 'CaseNumber', 'ContractNumber',
            'Domain', 'FriendlyName', 'FunctionName', 'Label', 'LocalPart',
            'OrderItemNumber', 'OrderNumber', 'SolutionName', 'TestSuiteName'
        };
        for(String fieldName : educatedGuesses) {
            Schema.SobjectField field = sobjectDescribe.fields.getMap().get(fieldName);

            if(field == null) continue;

            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(fieldDescribe.isNameField()) return fieldDescribe.getName();
        }

        return null;
    }

    private List<String> getFieldApiNames(Schema.DescribeSobjectResult sobjectDescribe) {
        List<String> fieldApiNames = new List<String>();
        for(Schema.SobjectField field : sobjectDescribe.fields.getMap().values()) {
            fieldApiNames.add(String.valueOf(field));
        }
        fieldApiNames.sort();
        return fieldApiNames;
    }

    private List<String> getFieldSetApiNames(Schema.DescribeSobjectResult sobjectDescribe) {
        List<String> fieldSetApiNames = new List<String>();
        for(Schema.FieldSet fieldSet : sobjectDescribe.fieldSets.getMap().values()) {
            String namespace = fieldSet.getNameSpace() == null ? '' : FieldSet.getNamespace() + '__';
            fieldSetApiNames.add(namespace + fieldSet.getName());
        }
        fieldSetApiNames.sort();
        return fieldSetApiNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.apiName.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.apiName.substring(0, localNameIndex);
    }

    private String getTabIcon() {
        String tabIcon;
        for(Schema.DescribeTabSetResult tabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult tabResult : tabSetResult.getTabs()) {
                if(tabResult.getSobjectName() != this.apiName) continue;

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
        if(tabIcon == null && this.apiName == 'Asset') tabIcon = 'standard:maintenance_asset';
        if(tabIcon == null && this.apiName == 'AssetRelationship') tabIcon = 'standard:asset_relationship';

        return tabIcon;
    }

}