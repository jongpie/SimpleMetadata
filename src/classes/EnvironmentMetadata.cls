/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.              *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class EnvironmentMetadata {

    private static Organization organization;

    static {
        SObjectMetadata organizationMetadata = new SObjectMetadata(Schema.Organization.SObjectType);
        String query = 'SELECT ' + String.join(organizationMetadata.allFieldNames, ', ')
            + ' FROM Organization';

        organization = (Organization)Database.query(query);
    }

    // Aura-enabled member variables
    @AuraEnabled public String baseURL                        {get; private set;}
    @AuraEnabled public String instanceName                   {get; private set;}
    @AuraEnabled public Boolean isMultiCurrencyEnabled        {get; private set;}
    @AuraEnabled public Boolean isPersonAccountEnabled        {get; private set;}
    @AuraEnabled public Boolean isProduction                  {get; private set;}
    @AuraEnabled public Boolean isSandbox                     {get; private set;}
    @AuraEnabled public Boolean isTerritoryManagementEnabled  {get; private set;}
    @AuraEnabled public String name                           {get; private set;}
    @AuraEnabled public Id organizationId                     {get; private set;}
    @AuraEnabled public String organizationType               {get; private set;}
    @AuraEnabled public List<String> sobjectTypeNames         {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Map<String, Schema.SObjectType> sobjectTypes;

    public EnvironmentMetadata() {
        this.sobjectTypes = Schema.getGlobalDescribe();

        this.baseURL                      = URL.getSalesforceBaseUrl().toExternalForm();
        this.instanceName                 = organization.InstanceName;
        this.isMultiCurrencyEnabled       = this.sobjectTypes.containsKey('CurrencyType');
        this.isPersonAccountEnabled       = this.sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount');
        this.isProduction                 = organization.IsSandbox == false;
        this.isSandbox                    = organization.IsSandbox;
        this.isTerritoryManagementEnabled = this.sobjectTypes.containsKey('Territory');
        this.name                         = organization.Name;
        this.organizationId               = organization.Id;
        this.organizationType             = organization.OrganizationType;
        this.sobjectTypeNames             = new List<String>(this.sobjectTypes.keySet());
    }

    public override String toString() {
        return JSON.serialize(this);
    }

}