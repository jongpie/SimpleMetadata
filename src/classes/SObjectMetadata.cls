/*************************************************************************************************
* This file is part of the Simple Metadata project, released under the MIT License.              *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public class SObjectMetadata {

    // Aura enabled member variables
    @AuraEnabled public Boolean isAccessible    {get;private set;}
    @AuraEnabled public Boolean isCreateable    {get;private set;}
    @AuraEnabled public Boolean isCustom        {get;private set;}
    @AuraEnabled public Boolean isCustomSetting {get;private set;}
    @AuraEnabled public Boolean isDeletable     {get;private set;}
    @AuraEnabled public Boolean isMergeable     {get;private set;}
    @AuraEnabled public Boolean isQueryable     {get;private set;}
    @AuraEnabled public Boolean isSearchable    {get;private set;}
    @AuraEnabled public Boolean isUndeletable   {get;private set;}
    @AuraEnabled public Boolean isUpdateable    {get;private set;}
    @AuraEnabled public String keyPrefix        {get;private set;}
    @AuraEnabled public String label            {get;private set;}
    @AuraEnabled public String labelPlural      {get;private set;}
    @AuraEnabled public String localName        {get;private set;}
    @AuraEnabled public String name             {get;private set;}
    @AuraEnabled public String nameField        {get;private set;}
    @AuraEnabled public String tabIcon          {get;private set;}

    // Non-aura enabled member variables
    public Schema.DescribeSObjectResult sobjectDescribe {get;private set;}
    public Schema.SObjectType sobjectType               {get;private set;}

    public SObjectMetadata(Schema.SObjectType sobjectType) {
        this(sobjectType.getDescribe().getName());
    }

    public SObjectMetadata(String sobjectName) {
        this.name            = sobjectName;

        this.sobjectType     = Schema.getGlobalDescribe().get(sobjectName);
        this.sobjectDescribe = this.sobjectType.getDescribe();

        this.isAccessible    = this.sobjectDescribe.isAccessible();
        this.isCreateable    = this.sobjectDescribe.isCreateable();
        this.isCustom        = this.sobjectDescribe.isCustom();
        this.isCustomSetting = this.sobjectDescribe.isCustomSetting();
        this.isDeletable     = this.sobjectDescribe.isDeletable();
        this.isMergeable     = this.sobjectDescribe.isMergeable();
        this.isQueryable     = this.sobjectDescribe.isQueryable();
        this.isSearchable    = this.sobjectDescribe.isSearchable();
        this.isUndeletable   = this.sobjectDescribe.isUndeletable();
        this.isUpdateable    = this.sobjectDescribe.isUpdateable();
        this.keyPrefix       = this.sobjectDescribe.getKeyPrefix();
        this.label           = this.sobjectDescribe.getLabel();
        this.labelPlural     = this.sobjectDescribe.getLabelPlural();
        this.localName       = this.sobjectDescribe.getLocalName();

        this.setNameField();
        this.setTabIcon();
    }

    private void setNameField() {
        for(Schema.SObjectField field : this.sobjectDescribe.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(!fieldDescribe.isNameField()) continue;

            this.nameField = fieldDescribe.getName();
            break;
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
        // Hardcoded exceptions - Salesforce doesn't return SVGs for the objects, so hardcoding is necessary
        if(this.tabIcon == null && this.name == 'Asset') this.tabIcon = 'standard:maintenance_asset';
        if(this.tabIcon == null && this.name == 'AssetRelationship') this.tabIcon = 'standard:asset_relationship';
    }

}