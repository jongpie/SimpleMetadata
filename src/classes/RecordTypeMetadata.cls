/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class RecordTypeMetadata {

    // Stores cached query results
    private static final Map<Id, RecordType> QUERIED_RECORD_TYPES_BY_ID;
    private static final Map<String, RecordType> QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_API_NAME;
    private static final Map<String, List<String>> QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME;

    static {
        // Query & cache Record_Types
        QUERIED_RECORD_TYPES_BY_ID                         = new Map<Id, RecordType>();
        // Salesforce enforces the combination of sobject name + record type developer name to be unique,
        // so we can use the combination as the key in a map
        QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_API_NAME = new Map<String, RecordType>();
        QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME            = new Map<String, List<String>>();

        for(RecordType recordType : [SELECT Id, DeveloperName, NamespacePrefix, SobjectType FROM RecordType]) {
            String namespace = recordType.NamespacePrefix == null ? '' : recordType.NamespacePrefix + '__';
            QUERIED_RECORD_TYPES_BY_ID.put(recordType.Id, recordType);
            QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_API_NAME.put(recordType.SobjectType + namespace + recordType.DeveloperName, recordType);

            if(!QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME.containsKey(recordType.SobjectType)) {
                QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME.put(recordType.SobjectType, new List<String>{});
            }
            List<String> recordTypeApiNames = QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME.get(recordType.SobjectType);
            recordTypeApiNames.add(namespace + recordType.DeveloperName);
            QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME.put(recordType.SobjectType, recordTypeApiNames);
        }
    }

    public static List<String> getRecordTypeApiNames(String sobjectApiName) {
        List<String> results = QUERIED_RECORD_TYPE_NAMES_BY_SOBJECT_API_NAME.get(sobjectApiName);
        if(results != null) results.sort();
        return results != null ? results : new List<String>();
    }

    @AuraEnabled global final String ApiName        {get; private set;}
    @AuraEnabled global final Id Id                 {get; private set;}
    @AuraEnabled global final Boolean IsActive      {get; private set;}
    @AuraEnabled global final Boolean IsAvailable   {get; private set;}
    @AuraEnabled global final Boolean IsDefault     {get; private set;}
    @AuraEnabled global final Boolean IsMaster      {get; private set;}
    @AuraEnabled global final String Label          {get; private set;}
    @AuraEnabled global final String LocalApiName   {get; private set;}
    @AuraEnabled global final String Namespace      {get; private set;}
    @AuraEnabled global final String SobjectApiName {get; private set;}

    global RecordTypeMetadata(String sobjectApiName, String recordTypeApiName) {
        this(QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_API_NAME.get(sobjectApiName + recordTypeApiName).Id);
    }

    global RecordTypeMetadata(Id recordTypeId) {
        this(
            Schema.getGlobalDescribe().get(QUERIED_RECORD_TYPES_BY_ID.get(recordTypeId).SobjectType),
            Schema.getGlobalDescribe().get(QUERIED_RECORD_TYPES_BY_ID.get(recordTypeId).SobjectType).getDescribe().getRecordTypeInfosById().get(recordTypeId)
        );
    }

    global RecordTypeMetadata(Schema.SobjectType sobjectType, Schema.RecordTypeInfo recordTypeInfo) {
        // recordType can be null because default master record types do not exist in the RecordType object that's queried with SOQL
        RecordType recordType = QUERIED_RECORD_TYPES_BY_ID.get(recordTypeInfo.getRecordTypeId());

        this.ApiName           = this.getApiName(recordType);
        this.Id                = recordTypeInfo.getRecordTypeId();
        this.IsActive          = recordTypeInfo.isActive();
        this.IsAvailable       = recordTypeInfo.isAvailable();
        this.IsDefault         = recordTypeInfo.isDefaultRecordTypeMapping();
        this.IsMaster          = recordTypeInfo.isMaster();
        this.Label             = recordTypeInfo.getName();
        this.LocalApiName      = recordType == null ? null : recordType.DeveloperName;
        this.Namespace         = recordType == null ? null : recordType.NamespacePrefix;
        this.SobjectApiName    = String.valueOf(sobjectType);
    }

    private String getApiName(RecordType recordType) {
        if(recordType == null) return null;

        String namespacePrefix = '';
        if(recordType.NamespacePrefix != null) namespacePrefix = recordType.NamespacePrefix + '__';

        return namespacePrefix + recordType.DeveloperName;
    }

}