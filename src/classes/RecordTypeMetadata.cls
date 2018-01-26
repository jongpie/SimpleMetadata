/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class RecordTypeMetadata {

    @AuraEnabled global final Id businessProcessId               {get; private set;}
    @AuraEnabled global final String description                 {get; private set;}
    @AuraEnabled global final Boolean isActive                   {get; private set;}
    @AuraEnabled global final Boolean isAvailable                {get; private set;}
    @AuraEnabled global final Boolean isDefaultRecordTypeMapping {get; private set;}
    @AuraEnabled global final Boolean isMaster                   {get; private set;}
    @AuraEnabled global final String label                       {get; private set;}
    @AuraEnabled global final String name                        {get; private set;}
    @AuraEnabled global final String namespace                   {get; private set;}
    @AuraEnabled global final Id recordTypeId                    {get; private set;}
    @AuraEnabled global final String sobjectName                 {get; private set;}

    global RecordTypeMetadata(Schema.RecordTypeInfo recordTypeInfo) {
        this(recordTypeInfo.getRecordTypeId());
    }

    global RecordTypeMetadata(String sobjectName, String recordTypeName) {
        this(getRecordTypeId(sobjectName, recordTypeName));
    }

    global RecordTypeMetadata(Id recordTypeId) {
        this.loadCache();

        Schema.RecordTypeInfo recordTypeInfo               = this.getRecordTypeInfo(recordTypeId);
        RecordTypeMetadataCache__c recordTypeMetadataCache = RecordTypeMetadataCache__c.getValues(recordTypeId);

        this.businessProcessId          = recordTypeMetadataCache.BusinessProcessId__c;
        this.description                = recordTypeMetadataCache.Description__c;
        this.isActive                   = recordTypeInfo.isActive();
        this.isAvailable                = recordTypeInfo.isAvailable();
        this.isDefaultRecordTypeMapping = recordTypeInfo.isDefaultRecordTypeMapping();
        this.isMaster                   = recordTypeInfo.isMaster();
        this.label                      = recordTypeInfo.getName();
        this.name                       = recordTypeMetadataCache.DeveloperName__c;
        this.namespace                  = recordTypeMetadataCache.NamespacePrefix__c;
        this.recordTypeId               = recordTypeInfo.getRecordTypeId();
        this.sobjectName                = recordTypeMetadataCache.SObjectType__c;
    }

    private RecordTypeMetadata() {
        this.loadCache();
    }

    private void loadCache() {
        // Check if cache is still valid
        Datetime lastCacheDatetime = this.getLastCacheDatetime();
        Integer uncachedRecordTypes = [SELECT COUNT() FROM RecordType WHERE LastModifiedDate < :lastCacheDatetime];
        if(lastCacheDatetime != null && uncachedRecordTypes == 0) return;

        // When cache is out of date, rebuild it
        delete RecordTypeMetadataCache__c.getAll().values();

        List<RecordTypeMetadataCache__c> recordsToCache = new List<RecordTypeMetadataCache__c>();
        for(RecordType recordType : [SELECT Id, SObjectType, DeveloperName, BusinessProcessId, Description, NamespacePrefix FROM RecordType]) {
            RecordTypeMetadataCache__c cachedRecordType = new RecordTypeMetadataCache__c(
                BusinessProcessId__c = recordType.BusinessProcessId,
                Description__c       = recordType.Description,
                DeveloperName__c     = recordType.DeveloperName,
                Name                 = recordType.Id,
                NamespacePrefix__c   = recordType.NamespacePrefix,
                SObjectType__c       = recordType.SObjectType
            );
            recordsToCache.add(cachedRecordType);
        }
        insert recordsToCache;
    }

    private Datetime getLastCacheDatetime() {
        Datetime lastCacheDatetime;
        for(RecordTypeMetadataCache__c cachedRecordType : RecordTypeMetadataCache__c.getAll().values()) {
            if(cachedRecordType.LastModifiedDate < lastCacheDatetime) lastCacheDatetime = lastCacheDatetime;
        }
        return lastCacheDatetime;
    }

    private Schema.RecordTypeInfo getRecordTypeInfo(Id recordTypeId) {
        String sobjectName = RecordTypeMetadataCache__c.getValues(recordTypeId).SObjectType__c;
        Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
        return sobjectDescribe.getRecordTypeInfosById().get(recordTypeId);
    }

    private static Id getRecordTypeId(String sobjectName, String recordTypeName) {
        new RecordTypeMetadata(); // Private constructor to Load cache
        for(RecordTypeMetadataCache__c cachedRecordType : RecordTypeMetadataCache__c.getAll().values()) {
            System.debug('cachedRecordType=');
            System.debug(cachedRecordType);
            if(cachedRecordType.SObjectType__c != sobjectName) continue;
            if(cachedRecordType.DeveloperName__c != recordTypeName) continue;

            return (Id)cachedRecordType.Name; // Name field stores the record type ID as a string
        }
        return null;
    }

}