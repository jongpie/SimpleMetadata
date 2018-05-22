/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class FieldSetMetadata {

    @AuraEnabled global final String ApiName                               {get; private set;}
    @AuraEnabled global final String Description                           {get; private set;}
    @AuraEnabled global final List<FieldSetMemberMetadata> FieldSetMembers {get; private set;}
    @AuraEnabled global final String Label                                 {get; private set;}
    @AuraEnabled global final String LocalApiName                          {get; private set;}
    @AuraEnabled global final String Namespace                             {get; private set;}
    @AuraEnabled global final String SobjectApiName                        {get; private set;}

    global FieldSetMetadata(String sobjectApiName, String fieldSetApiName) {
        this(Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fieldSets.getMap().get(fieldSetApiName));
    }

    global FieldSetMetadata(Schema.FieldSet fieldSet) {
        // Sobject name & field name are used to set other values, so set them first
        this.SobjectApiName = String.valueOf(fieldSet.getSobjectType());
        this.ApiName        = (fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__') + fieldSet.getName();

        this.Description     = fieldSet.getDescription();
        this.FieldSetMembers = this.getFieldSetMembers(fieldSet);
        this.Label           = fieldSet.getLabel();
        this.LocalApiName    = this.getLocalApiName();
        this.Namespace       = fieldSet.getNamespace();
    }

    private List<FieldSetMemberMetadata> getFieldSetMembers(Schema.FieldSet fieldSet) {
        List<FieldSetMemberMetadata> fieldSetMembers = new List<FieldSetMemberMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(this.sobjectApiName, fieldSetMember);

            fieldSetMembers.add(fieldSetMemberMetadata);
        }
        return fieldSetMembers;
    }

    private String getLocalApiName() {
        Integer localNameIndex = this.apiName.replace('__c', '').indexOf('__');
        // Add to to the localNameIndex to compensate for the '__' part of the namespace
        return localNameIndex < 0 ? null : this.apiName.substring(localNameIndex + 2, this.apiName.length());
    }

    global class FieldSetMemberMetadata {

        @AuraEnabled global final String DisplayType    {get; private set;}
        @AuraEnabled global final FieldMetadata Field   {get; private set;}
        @AuraEnabled global final String FieldPath      {get; private set;}
        @AuraEnabled global final Boolean IsDbRequired  {get; private set;}
        @AuraEnabled global final Boolean IsRequired    {get; private set;}
        @AuraEnabled global final String Label          {get; private set;}
        @AuraEnabled global final String SobjectApiName {get; private set;}

        private FieldSetMemberMetadata(String sobjectApiName, Schema.FieldSetMember fieldSetMember) {
            this.SobjectApiName = sobjectApiName;

            this.DisplayType  = fieldSetMember.getType().name();
            this.Field        = this.getFieldMetadata(fieldSetMember);
            this.FieldPath    = fieldSetMember.getFieldPath();
            this.IsDbRequired = fieldSetMember.getDbRequired();
            this.IsRequired   = fieldSetMember.getRequired();
            this.Label        = fieldSetMember.getLabel();
        }

        private FieldMetadata getFieldMetadata(Schema.FieldSetMember fieldSetMember) {
            FieldMetadata fieldMetadata;

            List<String> fieldChain = fieldSetMember.getFieldPath().split('\\.');

            if(fieldChain.size() == 0) return fieldMetadata;

            Schema.SobjectType currentFieldSobjectType = Schema.getGlobalDescribe().get(this.sobjectApiName);
            String currentFieldSobjectApiName = this.sobjectApiName;
            String currentFieldApiName;

            for(Integer i = 0; i < fieldChain.size(); i++) {
                currentFieldApiName = fieldChain[i];

                for(Schema.SobjectField sobjectField : Schema.getGlobalDescribe().get(currentFieldSobjectApiName).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult fieldDescribe = sobjectField.getDescribe();

                    if(fieldDescribe.getRelationshipName() == currentFieldApiName && !fieldDescribe.getReferenceTo().isEmpty()) {
                        currentFieldSobjectType = fieldDescribe.getReferenceTo()[0];
                        currentFieldSobjectApiName = currentFieldSobjectType.getDescribe().getName();

                        break;
                    }

                }
            }

            return new FieldMetadata(currentFieldSobjectApiName, currentFieldApiName);
        }

    }

}