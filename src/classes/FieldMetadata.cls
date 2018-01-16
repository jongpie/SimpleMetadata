public class FieldMetadata {

    @AuraEnabled public Boolean isAccessible                         {get;private set;}
    @AuraEnabled public Boolean isCalculated                         {get;private set;}
    @AuraEnabled public Boolean isCreateable                         {get;private set;}
    @AuraEnabled public Boolean isCustom                             {get;private set;}
    @AuraEnabled public Boolean isDefaultedOnCreate                  {get;private set;}
    @AuraEnabled public Boolean isFilterable                         {get;private set;}
    @AuraEnabled public Boolean isGroupable                          {get;private set;}
    @AuraEnabled public Boolean isNameField                          {get;private set;}
    @AuraEnabled public Boolean isSortable                           {get;private set;}
    @AuraEnabled public Boolean isUpdateable                         {get;private set;}
    @AuraEnabled public Boolean required                             {get;private set;}
    @AuraEnabled public Integer maxLength                            {get;private set;}
    @AuraEnabled public List<PicklistEntryMetadata> picklistOptions  {get;private set;}
    @AuraEnabled public Object defaultValue                          {get;private set;}
    //@AuraEnabled public SObjectMetadata sobjectMetadata              {get;private set;}
    @AuraEnabled public String displayType                           {get;private set;}
    @AuraEnabled public String inlineHelpText                        {get;private set;}
    @AuraEnabled public String label                                 {get;private set;}
    @AuraEnabled public String name                                  {get;private set;}
    @AuraEnabled public String relationshipName                      {get;private set;}
    @AuraEnabled public List<SObjectMetadata> relationshipReferences {get;private set;}
    @AuraEnabled public String sobjectName                           {get;private set;}

    public Schema.DescribeFieldResult fieldDescribe {get;private set;}

    public FieldMetadata(String sobjectName, String fieldName) {
        this.sobjectName     = sobjectName;
        this.name            = fieldName;
        //this.sobjectMetadata = new SObjectMetadata(sobjectName);
        this.picklistOptions = new List<PicklistEntryMetadata>();

        this.fieldDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();

        this.defaultValue        = this.fieldDescribe.getDefaultValue();
        this.displayType         = this.fieldDescribe.getType().name();
        this.inlineHelpText      = this.fieldDescribe.getInlineHelpText();
        this.isAccessible        = this.fieldDescribe.isAccessible();
        this.isCalculated        = this.fieldDescribe.isCalculated();
        this.isCreateable        = this.fieldDescribe.isCreateable();
        this.isCustom            = this.fieldDescribe.isCustom();
        this.isDefaultedOnCreate = this.fieldDescribe.isDefaultedOnCreate();
        this.isFilterable        = this.fieldDescribe.isFilterable();
        this.isGroupable         = this.fieldDescribe.isGroupable();
        this.isNameField         = this.fieldDescribe.isNameField();
        this.isSortable          = this.fieldDescribe.isSortable();
        this.isUpdateable        = this.fieldDescribe.isUpdateable();
        this.label               = this.fieldDescribe.getLabel();
        this.maxLength           = this.fieldDescribe.getLength();
        this.relationshipName    = this.fieldDescribe.getRelationshipName();
        this.required            = this.fieldDescribe.isNillable() == false; // If a field is NOT nillable, then it's required

        this.setPicklistOptions();
        this.setRelationshipReferences();
    }

    private void setPicklistOptions() {
        Schema.DisplayType fieldDisplayType = this.fieldDescribe.getType();
        if(fieldDisplayType != Schema.DisplayType.Picklist && fieldDisplayType != Schema.DisplayType.MultiPicklist) return;

        this.picklistOptions.add(new PicklistEntryMetadata()); // Empty picklist value
        for(Schema.PicklistEntry picklistEntry : this.fieldDescribe.getPickListValues()) {
            this.picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
        }
    }

    private void setRelationshipReferences() {
        this.relationshipReferences = new List<SObjectMetadata>();
        for(Schema.SObjectType sobjectType : this.fieldDescribe.getReferenceTo()) {
            this.relationshipReferences.add(new SObjectMetadata(sobjectType));
        }
    }

    public class PicklistEntryMetadata {

        @AuraEnabled public String label           {get;private set;}
        @AuraEnabled public String value           {get;private set;}
        @AuraEnabled public Boolean isDefaultValue {get;private set;}

        private Schema.PicklistEntry picklistEntry;

        public PicklistEntryMetadata() {
            this.label          = '--None--';
            this.value          = '';
            this.isDefaultValue = false;
        }

        public PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.picklistEntry  = picklistEntry;

            this.label          = picklistEntry.getLabel();
            this.value          = picklistEntry.getValue();
            this.isDefaultValue = picklistEntry.isDefaultValue();
        }

    }

}