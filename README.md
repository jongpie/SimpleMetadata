# SimpleMetadata
[![Build Status](https://travis-ci.org/jongpie/SimpleMetadata.svg?branch=fieldset-metadata)](https://travis-ci.org/jongpie/SimpleMetadata)
<br />
A lightweight library of Apex classes for Salesforce that provide easy access to metadata information
<br />
<br />
<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Overview
Each class has at least 2 contstructors
1. Constructor that accepts strings parameters - ideal for Lightning components/Javascript where strings are needed
2. Constructor that accepts Apex metadata classes, like Schema.SObjectType and Schema.SObjectField - ideal for Apex development where you want something safer than strings

Each class returns an immutable DTO with no public methods. Each member variables follows these naming conventions:
1. Variables are named using camelCase - this is less important in Apex development since Apex is case-insensitive, but important to note for Lightning development since Javascript is case-sensitive.
2. Variables called 'apiName' refer to the API name or Developer Name, including the namespace prefix. Example: sobjectName = 'MyNameSpace__MyObject__c';
3. Variables called 'localApiName' refer to the API name or Developer Name, excluding the namespace prefix. Example: sobjectName = 'MyObject__c';
4. Variables called 'label' refer to the label displayed to the user - if translations are available, then the label is translated to the user's language. Example: new SobjectMetadata('MyObject__c').label; // Gets the localized/translated label for your custom object
5. Variables called 'displayFieldApiName' refer to the name field of an SObject - typically, the field is actually called Name, but there are exceptions, like Case.CaseNumber, Task.Subject, Order.OrderNumber, etc.

## EnvironmentMetadata.cls
* Contains metadata information for the current environment. No parameters are needed to construct it.

    ```
    new EnvironmentMetadata()
    ```

    <details><summary>See Sample JSON</summary>

        {
            "BaseUrl": "https://mydomain.my.salesforce.com",
            "InstanceName": "EU11",
            "IsChatterEnabled": true,
            "IsKnowledgeEnabled": false,
            "IsMultiCurrencyEnabled": false,
            "IsPersonAccountEnabled": false,
            "IsProduction": true,
            "IsSandbox": false,
            "IsTerritoryManagementEnabled": false,
            "Name": "Jonathan Gillespie's Org",
            "OrganizationId": "00D0Y0000019999999",
            "OrganizationType": "Developer Edition",
            "QueueApiNames": [
                "My_Queue"
            ]
            "SobjectApiNames": [
                "AcceptedEventRelation",
                "Account",
                "AccountCleanInfo",
                "AccountContactRole",
                "AccountFeed",
                "AccountHistory",
                "AccountPartner",
                "AccountShare",
                "ActionLinkGroupTemplate",
                "ActionLinkTemplate",
                "ActivityExtension",
                "ActivityHistory",
                "ActivityRecurrence",
                "ActivityRecurrenceException",
                "AdditionalNumber",
                "AggregateResult",
                "Announcement",
                "ApexClass",
                "ApexComponent",
                "ApexEmailNotification",
                "ApexLog",
                "ApexPage",
                "ApexPageInfo",
                "ApexTestQueueItem",
                "ApexTestResult",
                "ApexTestResultLimits",
                "ApexTestRunResult",
                "ApexTestSuite",
                "ApexTrigger",
                "AppMenuItem",
                "Asset",
                "AssetFeed",
                "AssetHistory",
                "AssetRelationship",
                "AssetRelationshipFeed",
                "AssetRelationshipHistory",
                "AssetShare",
                "AssetTokenEvent",
                "AssignmentRule",
                "AsyncApexJob",
                "AttachedContentDocument",
                "Attachment",
                "AuraDefinition",
                "AuraDefinitionBundle",
                "AuraDefinitionBundleInfo",
                "AuraDefinitionInfo",
                "AuthConfig",
                "AuthConfigProviders",
                "AuthProvider",
                "AuthSession",
                "BackgroundOperation",
                "BrandTemplate",
                "BusinessHours",
                "BusinessProcess",
                "CallCenter",
                "Campaign",
                "CampaignFeed",
                "CampaignHistory",
                "CampaignMember",
                "CampaignMemberStatus",
                "CampaignShare",
                "Case",
                "CaseComment",
                "CaseContactRole",
                "CaseFeed",
                "CaseHistory",
                "CaseShare",
                "CaseSolution",
                "CaseStatus",
                "CaseTeamMember",
                "CaseTeamRole",
                "CaseTeamTemplate",
                "CaseTeamTemplateMember",
                "CaseTeamTemplateRecord",
                "CategoryData",
                "CategoryNode",
                "CategoryNodeLocalization",
                "ChatterActivity",
                "ChatterConversation",
                "ChatterConversationMember",
                "ChatterExtension",
                "ChatterExtensionConfig",
                "ChatterExtensionLocalization",
                "ChatterMessage",
                "ClientBrowser",
                "CollaborationGroup",
                "CollaborationGroupFeed",
                "CollaborationGroupMember",
                "CollaborationGroupMemberRequest",
                "CollaborationGroupRecord",
                "CollaborationInvitation",
                "CombinedAttachment",
                "Community",
                "ConnectedApplication",
                "Contact",
                "ContactCleanInfo",
                "ContactFeed",
                "ContactHistory",
                "ContactShare",
                "ContentAsset",
                "ContentBody",
                "ContentDistribution",
                "ContentDistributionView",
                "ContentDocument",
                "ContentDocumentFeed",
                "ContentDocumentHistory",
                "ContentDocumentLink",
                "ContentFolder",
                "ContentFolderItem",
                "ContentFolderLink",
                "ContentFolderMember",
                "ContentVersion",
                "ContentVersionHistory",
                "ContentWorkspace",
                "ContentWorkspaceDoc",
                "ContentWorkspaceMember",
                "ContentWorkspacePermission",
                "ContractContactRole",
                "Contract",
                "ContractFeed",
                "ContractHistory",
                "ContractStatus",
                "CorsWhitelistEntry",
                "CronJobDetail",
                "CronTrigger",
                "CspTrustedSite",
                "CustomBrand",
                "CustomBrandAsset",
                "CustomObjectUserLicenseMetrics",
                "CustomPermission",
                "CustomPermissionDependency",
                "DandBCompany",
                "Dashboard",
                "DashboardComponent",
                "DashboardComponentFeed",
                "DashboardFeed",
                "DataAssessmentFieldMetric",
                "DataAssessmentMetric",
                "DataAssessmentValueMetric",
                "DatacloudAddress",
                "DatacloudCompany",
                "DatacloudContact",
                "DatacloudDandBCompany",
                "DatacloudOwnedEntity",
                "DatacloudPurchaseUsage",
                "DataStatistics",
                "DataType",
                "DeclinedEventRelation",
                "DirectMessage",
                "DirectMessageFeed",
                "DirectMessageMember",
                "Document",
                "DocumentAttachmentMap",
                "Domain",
                "DomainSite",
                "DuplicateRecordItem",
                "DuplicateRecordSet",
                "DuplicateRule",
                "EmailCapture",
                "EmailDomainKey",
                "EmailMessage",
                "EmailMessageRelation",
                "EmailServicesAddress",
                "EmailServicesFunction",
                "EmailStatus",
                "EmailTemplate",
                "EmbeddedServiceDetail",
                "EntityDefinition",
                "EntityParticle",
                "EntitySubscription",
                "Event",
                "EventBusSubscriber",
                "EventFeed",
                "EventLogFile",
                "EventRelation",
                "ExternalDataSource",
                "ExternalDataUserAuth",
                "FeedAttachment",
                "FeedComment",
                "FeedItem",
                "FeedLike",
                "FeedPollChoice",
                "FeedPollVote",
                "FeedRevision",
                "FeedSignal",
                "FeedTrackedChange",
                "FieldDefinition",
                "FieldPermissions",
                "FileSearchActivity",
                "FiscalYearSettings",
                "FlexQueueItem",
                "FlowInterview",
                "FlowInterviewShare",
                "Folder",
                "FolderedContentDocument",
                "ForecastShare",
                "Goal",
                "GoalFeed",
                "GoalHistory",
                "GoalLink",
                "GoalShare",
                "GrantedByLicense",
                "Group",
                "GroupMember",
                "Holiday",
                "Idea",
                "IdeaComment",
                "IdpEventLog",
                "InstalledMobileApp",
                "KnowledgeableUser",
                "Lead",
                "LeadCleanInfo",
                "LeadFeed",
                "LeadHistory",
                "LeadShare",
                "LeadStatus",
                "ListEmail",
                "ListEmailRecipientSource",
                "ListEmailShare",
                "ListView",
                "ListViewChart",
                "ListViewChartInstance",
                "LoginGeo",
                "LoginHistory",
                "LoginIp",
                "LookedUpFromActivity",
                "Macro",
                "MacroHistory",
                "MacroInstruction",
                "MacroShare",
                "MailmergeTemplate",
                "MatchingRule",
                "MatchingRuleItem",
                "Metric",
                "MetricDataLink",
                "MetricDataLinkHistory",
                "MetricFeed",
                "MetricHistory",
                "MetricShare",
                "Name",
                "NamedCredential",
                "Note",
                "NoteAndAttachment",
                "OauthToken",
                "ObjectPermissions",
                "OpenActivity",
                "Opportunity",
                "OpportunityCompetitor",
                "OpportunityContactRole",
                "OpportunityFeed",
                "OpportunityFieldHistory",
                "OpportunityHistory",
                "OpportunityLineItem",
                "OpportunityPartner",
                "OpportunityShare",
                "OpportunityStage",
                "Order",
                "OrderFeed",
                "OrderHistory",
                "OrderItem",
                "OrderItemFeed",
                "OrderItemHistory",
                "OrderShare",
                "Organization",
                "OrgLifecycleNotification",
                "OrgWideEmailAddress",
                "OutgoingEmail",
                "OutgoingEmailRelation",
                "OwnedContentDocument",
                "OwnerChangeOptionInfo",
                "PackageLicense",
                "Partner",
                "PartnerRole",
                "Period",
                "PermissionSet",
                "PermissionSetAssignment",
                "PermissionSetLicense",
                "PermissionSetLicenseAssign",
                "PicklistValueInfo",
                "PlatformAction",
                "PlatformCachePartition",
                "PlatformCachePartitionType",
                "Pricebook2",
                "Pricebook2History",
                "PricebookEntry",
                "ProcessDefinition",
                "ProcessInstance",
                "ProcessInstanceHistory",
                "ProcessInstanceNode",
                "ProcessInstanceStep",
                "ProcessInstanceWorkitem",
                "ProcessNode",
                "Product2",
                "Product2Feed",
                "Product2History",
                "Profile",
                "Publisher",
                "PushTopic",
                "QueueSobject",
                "QuoteTemplateRichTextData",
                "RecentlyViewed",
                "RecordType",
                "RecordTypeLocalization",
                "RelationshipDomain",
                "RelationshipInfo",
                "Report",
                "ReportFeed",
                "SamlSsoConfig",
                "Scontrol",
                "ScontrolLocalization",
                "SearchActivity",
                "SearchLayout",
                "SearchPromotionRule",
                "SecureAgent",
                "SecureAgentPlugin",
                "SecureAgentPluginProperty",
                "SecureAgentsCluster",
                "SecurityCustomBaseline",
                "SessionPermSetActivation",
                "SetupAuditTrail",
                "SetupEntityAccess",
                "Site",
                "SiteFeed",
                "SiteHistory",
                "Solution",
                "SolutionFeed",
                "SolutionHistory",
                "SolutionStatus",
                "Stamp",
                "StampAssignment",
                "StampLocalization",
                "StaticResource",
                "StreamingChannel",
                "StreamingChannelShare",
                "Task",
                "TaskFeed",
                "TaskPriority",
                "TaskStatus",
                "TenantSecret",
                "TenantUsageEntitlement",
                "TestSuiteMembership",
                "ThirdPartyAccountLink",
                "TodayGoal",
                "TodayGoalShare",
                "Topic",
                "TopicAssignment",
                "TopicFeed",
                "TopicLocalization",
                "TwoFactorInfo",
                "TwoFactorMethodsInfo",
                "TwoFactorTempCode",
                "UndecidedEventRelation",
                "User",
                "UserAppInfo",
                "UserAppMenuCustomization",
                "UserAppMenuCustomizationShare",
                "UserAppMenuItem",
                "UserEntityAccess",
                "UserFeed",
                "UserFieldAccess",
                "UserLicense",
                "UserListView",
                "UserListViewCriterion",
                "UserLogin",
                "UserPackageLicense",
                "UserPermissionAccess",
                "UserPreference",
                "UserProvAccount",
                "UserProvAccountStaging",
                "UserProvisioningConfig",
                "UserProvisioningLog",
                "UserProvisioningRequest",
                "UserProvisioningRequestShare",
                "UserProvMockTarget",
                "UserRecordAccess",
                "UserRole",
                "UserShare",
                "VerificationHistory",
                "VisualforceAccessMetrics",
                "Vote",
                "WaveCompatibilityCheckItem",
                "WebLink",
                "WebLinkLocalization",
                "WorkCoaching",
                "WorkCoachingFeed",
                "WorkCoachingHistory",
                "WorkCoachingShare",
                "WorkFeedback",
                "WorkFeedbackHistory",
                "WorkFeedbackQuestion",
                "WorkFeedbackQuestionHistory",
                "WorkFeedbackQuestionSet",
                "WorkFeedbackQuestionSetHistory",
                "WorkFeedbackQuestionSetShare",
                "WorkFeedbackQuestionShare",
                "WorkFeedbackRequest",
                "WorkFeedbackRequestFeed",
                "WorkFeedbackRequestHistory",
                "WorkFeedbackRequestShare",
                "WorkFeedbackShare",
                "WorkFeedbackTemplate",
                "WorkFeedbackTemplateShare",
                "WorkPerformanceCycle",
                "WorkPerformanceCycleFeed",
                "WorkPerformanceCycleHistory",
                "WorkPerformanceCycleShare"
            ]
        }

    </details>

## SobjectMetadata.cls
* Contains metadata information for the specified SObject. There are 2 ways to create an instance of SobjectMetadata

    1. By passing the SObject's API name as a string in the constructor
    ```
    new SobjectMetadata('Account')
    ```

    2. By passing the SObject Type in the constructor
    ```
    new SobjectMetadata(Schema.Account.SObjectType)
    ```

    ### Sample Usage
    Scenario: if the user has access to delete an SObject, then delete it

    ```
    public class MyClass {

        public void deleteRecord(MyCustomObject__c myRecord) {
            // If the user does not have access to delete, then stop
            if(new SobjectMetadata('MyCustomObject__c').isDeletable == false) return;

            //Otherwise, delete the record
            delete myRecord.MyCustomField__c;
        }

    }
    ```

## FieldMetadata.cls
* Contains metadata information for the specified field. There are 2 ways to create an instance of FieldMetadata

    1. By passing the SObject's API name and the field's API name as strings in the constructor
    ```
    new FieldMetadata('Account', 'Type')
    ```

    2. By passing the SObject Type and the SObject Field in the constructor
    ```
    new FieldMetadata(Schema.Account.SObjectType, Schema.Account.Type)
    ```

    ### Sample Usage
    Scenario: if the user has access to edit a field, set the value

    ```
    public class MyClass {

        public void setMyField(MyCustomObject__c myRecord) {
            // If the user does not have access to delete, then stop
            if(new FieldMetadata('MyCustomObject__c', 'MyCustomField__c').isUpdateable) {

            // Otherwise, set the field
            myRecord.MyCustomField__c = 'some value';
        }

    }
    ```

## FieldSetMetadata.cls
* Contains metadata information for the specified field set, as well as the field set's SObject and the field metadata for each field set member. There are 2 ways to create an instance of FieldMetadata

    1. By passing the SObject's API name and the field set's API name as strings in the constructor
    ```
    new FieldSetMetadata('Lead', 'MyFieldSet')
    ```

    2. By passing the FieldSet in the constructor
    ```
    new FieldSetMetadata(SObjectType.Lead.FieldSets.MyFieldSet);
    ```

## RecordTypeMetadata.cls
* Contains metadata information for a record type by combinging RecordTypeInfo and RecordType objects together. There are 3 ways to create an instance of RecordTypeMetadata

    1. By passing the SObject's API name and the RecordType's API name (DeveloperName) in the constructor
    ```
    new RecordTypeMetadata('Account', 'My_RecordType_Developer_Name');
    ```

    2. By passing the RecordType's ID in the constructor
    ```
    new RecordTypeMetadata(myAccountRecord.RecordTypeId);
    ```

    3. By passing the Schema.SObjectType and the Schema.RecordTypeInfo in the constructor
    ```
    Schema.SObjectType accountSObjectType = Schema.Account.SObjectType;
    Schema.RecordTypeInfo someAccountRecordTypeInfo;
    new RecordTypeMetadata(accountSObjectType, someAccountRecordTypeInfo);
    ```

    <details><summary>See Sample JSON</summary>

        {
          "ApiName": "MyNamespace__My_RecordType_Developer_Name"
          "Id": "0120Y000000EEEEE",
          "IsActive": true,
          "IsAvailable": true,
          "IsDefaultRecordTypeMapping": true,
          "IsMaster": false,
          "Label": "My Record Type",
          "LocalName": "My_RecordType_Developer_Name"
          "Namespace": "MyNamespace",
          "SobjectApiName": "Account"
        }

    </details>

## QueueMetadata.cls
* Contains metadata information for a queue, including the queue members and the supported SObject names. There are 2 ways to create an instance of QueueMetadata

    1. By passing the Queue's API name (DeveloperName) in the constructor
    ```
    new QueueMetadata('My_Queue_Developer_Name');
    ```

    2. By passing the Queue's ID in the constructor
    ```
    Id myQueueId = '00G0Y0000000000';
    new QueueMetadata(myQueueId);
    ```

    <details><summary>See Sample JSON</summary>

        {
            "ApiName": "My_Queue",
            "DoesIncludeBosses": true,
            "DoesSendEmailToMembers": true,
            "Email": "fake@test.com",
            "Label": "My Queue",
            "Id": "00G0Y0000011111111",
            "QueueMembers": [
                {
                    "QueueId": "00G0Y0000011111111",
                    "QueueMemberId": "0110Y000000fHUyQAM",
                    "Type": "User",
                    "UserOrGroupId": "0050Y000001LrM3QAK"
                },
                {
                    "QueueId": "00G0Y0000011111111",
                    "QueueMemberId": "0110Y0000000000000",
                    "Type": "User",
                    "UserOrGroupId": "0050Y0000000000000"
                },
                {
                    "QueueId": "00G0Y0000011111111",
                    "QueueMemberId": "0110Y000001q5sUQAQ",
                    "Type": "Group",
                    "UserOrGroupId": "00G0Y000001inOQUAY"
                }
            ],
            "SobjectApiNames": [
                "Case",
                "Lead"
            ]
        }

    </details>