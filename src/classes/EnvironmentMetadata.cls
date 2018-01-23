/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class EnvironmentMetadata {

    // Some info must be queried from the Organization object, so cache the results to limit query count to 1
    private static Organization organization;

    static {
        organization = [SELECT Id, Name, InstanceName, OrganizationType, IsSandbox FROM Organization LIMIT 1];
    }

    @AuraEnabled public final String baseURL                       {get; private set;}
    @AuraEnabled public final String instanceName                  {get; private set;}
    @AuraEnabled public final Boolean isChatterEnabled             {get; private set;}
    @AuraEnabled public final Boolean isKnowledgeEnabled           {get; private set;}
    @AuraEnabled public final Boolean isMultiCurrencyEnabled       {get; private set;}
    @AuraEnabled public final Boolean isPersonAccountEnabled       {get; private set;}
    @AuraEnabled public final Boolean isProduction                 {get; private set;}
    @AuraEnabled public final Boolean isSandbox                    {get; private set;}
    @AuraEnabled public final Boolean isTerritoryManagementEnabled {get; private set;}
    @AuraEnabled public final String name                          {get; private set;}
    @AuraEnabled public final Id organizationId                    {get; private set;}
    @AuraEnabled public final String organizationType              {get; private set;}
    @AuraEnabled public final List<String> sobjectTypeNames        {get; private set;}

    public EnvironmentMetadata() {
        Map<String, Schema.SObjectType> sobjectTypes = Schema.getGlobalDescribe();

        this.baseURL                      = URL.getSalesforceBaseUrl().toExternalForm();
        this.instanceName                 = organization.InstanceName;
        this.isChatterEnabled             = sobjectTypes.containsKey('FeedItem');
        this.isKnowledgeEnabled           = sobjectTypes.containsKey('KnowledgeArticle');
        this.isMultiCurrencyEnabled       = sobjectTypes.containsKey('CurrencyType');
        this.isPersonAccountEnabled       = sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount');
        this.isProduction                 = organization.IsSandbox == false;
        this.isSandbox                    = organization.IsSandbox;
        this.isTerritoryManagementEnabled = sobjectTypes.containsKey('Territory');
        this.name                         = organization.Name;
        this.organizationId               = organization.Id;
        this.organizationType             = organization.OrganizationType;
        this.sobjectTypeNames             = this.getSObjectTypeNames(sobjectTypes);
    }

    private List<String> getSObjectTypeNames(Map<String, Schema.SObjectType> sobjectTypes) {
        // We could just use this.sobjectTypeNames = new List<String>(sobjectTypes.keySet());
        // However, it returns the names in lowercase, which can cause problems with Javascript/Lightning since it's case-sensitive
        List<String> sobjectTypeNames  = new List<String>();
        for(Schema.SObjectType sobjectType : sobjectTypes.values()) {
            this.sobjectTypeNames.add(String.valueOf(sobjectType));
        }
        sobjectTypeNames.sort();
        return sobjectTypeNames;
    }

}