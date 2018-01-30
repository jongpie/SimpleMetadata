/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private  class SObjectMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_account_sobject_token() {
        SObjectMetadata accountMetadata = new SObjectMetadata(Schema.Account.SObjectType);
        validateAttributesAreSet(accountMetadata);
    }

    @isTest
    static void it_should_return_metadata_for_account_sobject_name() {
        SObjectMetadata accountMetadata = new SObjectMetadata('Account');
        validateAttributesAreSet(accountMetadata);
    }

    private static void validateAttributesAreSet(SObjectMetadata sobjectMetadata) {
        Schema.DescribeSObjectResult accountDescribe = Schema.Account.SObjectType.getDescribe();

        System.assertEquals('Name', sobjectMetadata.displayFieldName);
        System.assertEquals(accountDescribe.fields.getMap().size(), sobjectMetadata.fieldNames.size());
        System.assertEquals(accountDescribe.getHasSubtypes(), sobjectMetadata.hasSubtypes);
        System.assertEquals(accountDescribe.isAccessible(), sobjectMetadata.isAccessible);
        System.assertEquals(accountDescribe.isFeedEnabled(), sobjectMetadata.isChatterFeedEnabled);
        System.assertEquals(accountDescribe.isCreateable(), sobjectMetadata.isCreateable);
        System.assertEquals(accountDescribe.isCustom(), sobjectMetadata.isCustom);
        System.assertEquals(accountDescribe.isCustomSetting(), sobjectMetadata.isCustomSetting);
        System.assertEquals(accountDescribe.isDeletable(), sobjectMetadata.isDeletable);
        System.assertEquals(accountDescribe.isMergeable(), sobjectMetadata.isMergeable);
        System.assertEquals(accountDescribe.isMruEnabled(), sobjectMetadata.isMRUEnabled);
        System.assertEquals(accountDescribe.isQueryable(), sobjectMetadata.isQueryable);
        System.assertEquals(accountDescribe.isSearchable(), sobjectMetadata.isSearchable);
        System.assertEquals(accountDescribe.isUndeletable(), sobjectMetadata.isUndeletable);
        System.assertEquals(accountDescribe.isUpdateable(), sobjectMetadata.isUpdateable);
        System.assertEquals(accountDescribe.getKeyPrefix(), sobjectMetadata.keyPrefix);
        System.assertEquals(accountDescribe.getLabel(), sobjectMetadata.label);
        System.assertEquals(accountDescribe.getLabelPlural(), sobjectMetadata.labelPlural);
        System.assertEquals(accountDescribe.getLocalName(), sobjectMetadata.localName);
        System.assertEquals('standard:account', sobjectMetadata.tabIcon);

        System.assertNotEquals(null, sobjectMetadata.displayFieldName);
        System.assertNotEquals(null, sobjectMetadata.hasMultiCurrency);
        System.assertNotEquals(null, sobjectMetadata.hasSubtypes);
        System.assertNotEquals(null, sobjectMetadata.isAccessible);
        System.assertNotEquals(null, sobjectMetadata.isChatterFeedEnabled);
        System.assertNotEquals(null, sobjectMetadata.isCreateable);
        System.assertNotEquals(null, sobjectMetadata.isCustom);
        System.assertNotEquals(null, sobjectMetadata.isCustomSetting);
        System.assertNotEquals(null, sobjectMetadata.isDeletable);
        System.assertNotEquals(null, sobjectMetadata.isMruEnabled);
        System.assertNotEquals(null, sobjectMetadata.isMergeable);
        System.assertNotEquals(null, sobjectMetadata.isQueryable);
        System.assertNotEquals(null, sobjectMetadata.isSearchable);
        System.assertNotEquals(null, sobjectMetadata.isUndeletable);
        System.assertNotEquals(null, sobjectMetadata.isUpdateable);
        System.assertNotEquals(null, sobjectMetadata.fieldNames);
        System.assertNotEquals(null, sobjectMetadata.fieldSetNames);
        System.assertNotEquals(null, sobjectMetadata.keyPrefix);
        System.assertNotEquals(null, sobjectMetadata.label);
        System.assertNotEquals(null, sobjectMetadata.labelPlural);
        System.assertNotEquals(null, sobjectMetadata.localName);
        System.assertNotEquals(null, sobjectMetadata.name);
        System.assertNotEquals(null, sobjectMetadata.tabIcon);
    }

}