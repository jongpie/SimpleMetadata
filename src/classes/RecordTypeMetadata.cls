/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class RecordTypeMetadata {

    // Stores cached query results
    private static final Map<Id, RecordType> QUERIED_RECORD_TYPES_BY_ID;
    private static final Map<String, RecordType> QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_NAME;

    static {
        // Query & cache Record_Types
        QUERIED_RECORD_TYPES_BY_ID                         = new Map<Id, RecordType>();
        QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_NAME = new Map<String, RecordType>();

        for(RecordType recordType : [SELECT Id, BusinessProcessId, Description, DeveloperName, NamespacePrefix, SObjectType FROM RecordType]) {
            QUERIED_RECORD_TYPES_BY_ID.put(recordType.Id, recordType);
            QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_NAME.put(recordType.SObjectType + recordType.DeveloperName, recordType);
        }
    }

    @AuraEnabled global final Id businessProcessId               {get; private set;}
    @AuraEnabled global final String description                 {get; private set;}
    @AuraEnabled global final Id id                              {get; private set;}
    @AuraEnabled global final Boolean isActive                   {get; private set;}
    @AuraEnabled global final Boolean isAvailable                {get; private set;}
    @AuraEnabled global final Boolean isDefaultRecordTypeMapping {get; private set;}
    @AuraEnabled global final Boolean isMaster                   {get; private set;}
    @AuraEnabled global final String label                       {get; private set;}
    @AuraEnabled global final String name                        {get; private set;}
    @AuraEnabled global final String namespace                   {get; private set;}
    @AuraEnabled global final String sobjectName                 {get; private set;}

    global RecordTypeMetadata(String sobjectName, String recordTypeName) {
        this(QUERIED_RECORD_TYPES_BY_SOBJECT_AND_DEVELOPER_NAME.get(sobjectName + recordTypeName).Id);
    }

    global RecordTypeMetadata(Id recordTypeId) {
        RecordType recordType                = QUERIED_RECORD_TYPES_BY_ID.get(recordTypeId);
        Schema.RecordTypeInfo recordTypeInfo = Schema.getGlobalDescribe().get(recordType.SObjectType).getDescribe().getRecordTypeInfosById().get(recordTypeId);

        this.businessProcessId          = recordType.BusinessProcessId;
        this.description                = recordType.Description;
        this.id                         = recordTypeInfo.getRecordTypeId();
        this.isActive                   = recordTypeInfo.isActive();
        this.isAvailable                = recordTypeInfo.isAvailable();
        this.isDefaultRecordTypeMapping = recordTypeInfo.isDefaultRecordTypeMapping();
        this.isMaster                   = recordTypeInfo.isMaster();
        this.label                      = recordTypeInfo.getName();
        this.name                       = recordType.DeveloperName;
        this.namespace                  = recordType.NamespacePrefix;
        this.sobjectName                = recordType.SObjectType;
    }

    global RecordTypeMetadata(Schema.SObjectType sobjectType, Schema.RecordTypeInfo recordTypeInfo) {
        RecordType recordType = QUERIED_RECORD_TYPES_BY_ID.get(recordTypeInfo.getRecordTypeId());

        this.businessProcessId          = recordType == null ? null : recordType.BusinessProcessId;
        this.description                = recordType == null ? null : recordType.Description;
        this.id                         = recordTypeInfo.getRecordTypeId();
        this.isActive                   = recordTypeInfo.isActive();
        this.isAvailable                = recordTypeInfo.isAvailable();
        this.isDefaultRecordTypeMapping = recordTypeInfo.isDefaultRecordTypeMapping();
        this.isMaster                   = recordTypeInfo.isMaster();
        this.label                      = recordTypeInfo.getName();
        this.name                       = recordType == null ? null : recordType.DeveloperName;
        this.namespace                  = recordType == null ? null : recordType.NamespacePrefix;
        this.sobjectName                = String.valueOf(sobjectType);
    }

    // Static method so it can be called from an overloaded constructor
    /*private static Id getRecordTypeId(String sobjectName, String recordTypeName) {
        new RecordTypeMetadata(); // Private constructor to Load cache
        for(RecordTypeMetadataCache__c cachedRecordType : RecordTypeMetadataCache__c.getAll().values()) {
            if(cachedRecordType.SObjectType__c != sobjectName) continue;
            if(cachedRecordType.DeveloperName__c != recordTypeName) continue;

            return (Id)cachedRecordType.Name; // Name field stores the record type ID as a string
        }
        return null;
    }*/

}