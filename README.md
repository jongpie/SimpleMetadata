# SimpleMetadata
[![Build Status](https://travis-ci.org/jongpie/SimpleMetadata.svg?branch=fieldset-metadata)](https://travis-ci.org/jongpie/SimpleMetadata)
<br />
A lightweight library of Apex classes for Salesforce that provide easy access to metadata information for frontend and backend Salesforce developers
<br />
<br />
<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## EnvironmentMetadata.cls
* Contains metadata information for the current environment. No parameters are needed to construct it.

    ```
    new EnvironmentMetadata()
    ```

    <details><summary>See Sample JSON</summary>

        {
            "baseURL": "https://mydomain.my.salesforce.com",
            "instanceName": "EU11",
            "isChatterEnabled": true,
            "isKnowledgeEnabled": false,
            "isMultiCurrencyEnabled": false,
            "isPersonAccountEnabled": false,
            "isProduction": true,
            "isSandbox": false,
            "isTerritoryManagementEnabled": false,
            "name": "Jonathan Gillespie",
            "organizationId": "00D0Y0000019999999",
            "organizationType": "Developer Edition",
            "sobjectTypeNames": [
                "Contract",
                "ContractHistory",
                "ContractFeed",
                "Order",
                "OrderShare",
                "OrderHistory",
                "OrderFeed",
                "OrderItem",
                "OrderItemHistory",
                "OrderItemFeed",
                "ContractContactRole",
                "OpportunityStage",
                "LeadStatus",
                "CaseStatus",
                "SolutionStatus",
                "PartnerRole",
                "TaskPriority",
                "TaskStatus",
                "ContractStatus",
                "RecordType",
                "RecordTypeLocalization",
                "BusinessProcess",
                "Organization",
                "MailmergeTemplate",
                "Scontrol",
                "ScontrolLocalization",
                "Document",
                "Folder",
                "EmailStatus",
                "WebLink",
                "WebLinkLocalization",
                "EmailTemplate",
                "DocumentAttachmentMap",
                "BrandTemplate",
                "Name",
                "RecentlyViewed",
                "LoginHistory",
                "LoginIp",
                "ClientBrowser",
                "Vote",
                "Community",
                "AggregateResult",
                "Campaign",
                "CampaignShare",
                "CampaignHistory",
                "CampaignFeed",
                "CampaignMemberStatus",
                "CampaignMember",
                "Account",
                "AccountShare",
                "AccountHistory",
                "AccountFeed",
                "Contact",
                "ContactShare",
                "ContactHistory",
                "ContactFeed",
                "Lead",
                "LeadShare",
                "LeadHistory",
                "LeadFeed",
                "Opportunity",
                "OpportunityShare",
                "OpportunityFieldHistory",
                "OpportunityFeed",
                "OpportunityContactRole",
                "OpportunityHistory",
                "OpportunityLineItem",
                "OpportunityCompetitor",
                "Partner",
                "AccountPartner",
                "OpportunityPartner",
                "ForecastShare",
                "Attachment",
                "FiscalYearSettings",
                "Period",
                "PricebookEntry",
                "Product2",
                "Product2History",
                "Product2Feed",
                "Asset",
                "AssetShare",
                "AssetHistory",
                "AssetFeed",
                "BusinessHours",
                "Case",
                "CaseShare",
                "CaseHistory",
                "CaseComment",
                "CaseTeamTemplate",
                "CaseTeamTemplateMember",
                "CaseTeamMember",
                "CaseTeamRole",
                "CaseTeamTemplateRecord",
                "CaseFeed",
                "CaseContactRole",
                "CaseSolution",
                "Solution",
                "SolutionHistory",
                "SolutionFeed",
                "Holiday",
                "AdditionalNumber",
                "CallCenter",
                "ContentVersion",
                "ContentVersionHistory",
                "ContentDocument",
                "ContentDocumentHistory",
                "ContentDocumentFeed",
                "ContentDocumentLink",
                "FolderedContentDocument",
                "ContentFolderItem",
                "ContentWorkspace",
                "ContentWorkspaceDoc",
                "ContentWorkspacePermission",
                "ContentWorkspaceMember",
                "ContentDistribution",
                "ContentDistributionView",
                "AttachedContentDocument",
                "CombinedAttachment",
                "OwnedContentDocument",
                "ContentFolderLink",
                "ContentFolderMember",
                "Note",
                "NoteAndAttachment",
                "CronJobDetail",
                "CronTrigger",
                "FeedItem",
                "FeedTrackedChange",
                "FeedComment",
                "FeedLike",
                "FeedAttachment",
                "FeedPollChoice",
                "FeedPollVote",
                "EntitySubscription",
                "CollaborationGroup",
                "CollaborationGroupFeed",
                "CollaborationGroupMember",
                "CollaborationGroupMemberRequest",
                "CollaborationInvitation",
                "ChatterActivity",
                "ChatterMessage",
                "ChatterConversation",
                "ChatterConversationMember",
                "DirectMessage",
                "DirectMessageFeed",
                "DirectMessageMember",
                "FeedRevision",
                "PushTopic",
                "Report",
                "ReportFeed",
                "Dashboard",
                "DashboardFeed",
                "DashboardComponent",
                "DashboardComponentFeed",
                "AssignmentRule",
                "ProcessDefinition",
                "ProcessNode",
                "ProcessInstance",
                "ProcessInstanceStep",
                "ProcessInstanceWorkitem",
                "ProcessInstanceHistory",
                "ApexClass",
                "ApexTrigger",
                "ApexLog",
                "ApexTestResult",
                "AsyncApexJob",
                "ApexTestQueueItem",
                "UserRole",
                "Group",
                "GroupMember",
                "QueueSobject",
                "UserRecordAccess",
                "ApexPage",
                "ApexComponent",
                "StaticResource",
                "UserLicense",
                "PackageLicense",
                "UserPackageLicense",
                "Profile",
                "PermissionSetAssignment",
                "ObjectPermissions",
                "FieldPermissions",
                "SetupEntityAccess",
                "SetupAuditTrail",
                "Task",
                "TaskFeed",
                "Event",
                "EventFeed",
                "EventRelation",
                "AcceptedEventRelation",
                "UndecidedEventRelation",
                "DeclinedEventRelation",
                "LookedUpFromActivity",
                "OpenActivity",
                "ActivityHistory",
                "CategoryNode",
                "CategoryNodeLocalization",
                "CategoryData",
                "Site",
                "SiteHistory",
                "SiteFeed",
                "Domain",
                "DomainSite",
                "OrgWideEmailAddress",
                "CustomBrand",
                "CustomBrandAsset",
                "ConnectedApplication",
                "AuthProvider",
                "IdpEventLog",
                "LoginGeo",
                "EmailServicesFunction",
                "EmailServicesAddress",
                "KnowledgeableUser",
                "Topic",
                "TopicLocalization",
                "TopicFeed",
                "TopicAssignment",
                "User",
                "UserShare",
                "UserFeed",
                "UserLogin",
                "UserPreference",
                "AuthSession",
                "ListView",
                "EmailMessage",
                "EmailMessageRelation",
                "VerificationHistory",
                "ContentBody",
                "FeedSignal",
                "ActivityExtension",
                "EventBusSubscriber",
                "EventLogFile",
                "EntityDefinition",
                "FieldDefinition",
                "EntityParticle",
                "PicklistValueInfo",
                "RelationshipInfo",
                "RelationshipDomain",
                "SearchLayout",
                "Publisher",
                "DataType",
                "UserFieldAccess",
                "UserEntityAccess",
                "OwnerChangeOptionInfo",
                "DataStatistics",
                "CorsWhitelistEntry",
                "SearchPromotionRule",
                "SearchActivity",
                "FileSearchActivity",
                "AccountContactRole",
                "QuoteTemplateRichTextData",
                "Pricebook2",
                "Pricebook2History",
                "Idea",
                "IdeaComment",
                "Macro",
                "MacroShare",
                "MacroHistory",
                "MacroInstruction",
                "ContentAsset",
                "ContentFolder",
                "CollaborationGroupRecord",
                "Announcement",
                "StreamingChannel",
                "StreamingChannelShare",
                "ActionLinkGroupTemplate",
                "ActionLinkTemplate",
                "ProcessInstanceNode",
                "FlexQueueItem",
                "ApexTestRunResult",
                "ApexTestResultLimits",
                "ApexEmailNotification",
                "ApexTestSuite",
                "TestSuiteMembership",
                "ApexPageInfo",
                "PermissionSetLicense",
                "PermissionSetLicenseAssign",
                "GrantedByLicense",
                "TenantUsageEntitlement",
                "PermissionSet",
                "CustomPermissionDependency",
                "CustomPermission",
                "SessionPermSetActivation",
                "FlowInterview",
                "FlowInterviewShare",
                "DandBCompany",
                "AccountCleanInfo",
                "ContactCleanInfo",
                "LeadCleanInfo",
                "DatacloudContact",
                "DatacloudPurchaseUsage",
                "DatacloudOwnedEntity",
                "DatacloudCompany",
                "DatacloudDandBCompany",
                "DatacloudAddress",
                "EmailDomainKey",
                "Stamp",
                "StampLocalization",
                "StampAssignment",
                "AuraDefinitionBundle",
                "AuraDefinitionBundleInfo",
                "AuraDefinition",
                "AuraDefinitionInfo",
                "CspTrustedSite",
                "UserAppInfo",
                "AppMenuItem",
                "UserAppMenuItem",
                "UserAppMenuCustomization",
                "UserAppMenuCustomizationShare",
                "AuthConfig",
                "SamlSsoConfig",
                "AuthConfigProviders",
                "OauthToken",
                "ThirdPartyAccountLink",
                "ExternalDataUserAuth",
                "UserProvisioningConfig",
                "AssetTokenEvent",
                "UserProvisioningRequest",
                "UserProvisioningRequestShare",
                "UserProvisioningLog",
                "UserProvMockTarget",
                "UserProvAccount",
                "UserProvAccountStaging",
                "TwoFactorTempCode",
                "TwoFactorInfo",
                "TwoFactorMethodsInfo",
                "EmailCapture",
                "CustomObjectUserLicenseMetrics",
                "WorkCoaching",
                "WorkCoachingShare",
                "WorkCoachingHistory",
                "WorkCoachingFeed",
                "Goal",
                "GoalShare",
                "GoalHistory",
                "GoalFeed",
                "Metric",
                "MetricShare",
                "MetricHistory",
                "MetricFeed",
                "GoalLink",
                "MetricDataLink",
                "MetricDataLinkHistory",
                "WorkPerformanceCycle",
                "WorkPerformanceCycleShare",
                "WorkPerformanceCycleHistory",
                "WorkPerformanceCycleFeed",
                "WorkFeedbackQuestionSet",
                "WorkFeedbackQuestionSetShare",
                "WorkFeedbackQuestionSetHistory",
                "WorkFeedbackQuestion",
                "WorkFeedbackQuestionShare",
                "WorkFeedbackQuestionHistory",
                "WorkFeedback",
                "WorkFeedbackShare",
                "WorkFeedbackHistory",
                "WorkFeedbackRequest",
                "WorkFeedbackRequestShare",
                "WorkFeedbackRequestHistory",
                "WorkFeedbackRequestFeed",
                "WorkFeedbackTemplate",
                "WorkFeedbackTemplateShare",
                "InstalledMobileApp",
                "UserListView",
                "UserListViewCriterion",
                "ListViewChart",
                "ListViewChartInstance",
                "TodayGoal",
                "TodayGoalShare",
                "DuplicateRule",
                "DuplicateRecordSet",
                "DuplicateRecordItem",
                "MatchingRule",
                "MatchingRuleItem",
                "SecureAgent",
                "SecureAgentsCluster",
                "SecureAgentPlugin",
                "SecureAgentPluginProperty",
                "ExternalDataSource",
                "NamedCredential",
                "BackgroundOperation",
                "TenantSecret",
                "PlatformAction",
                "OutgoingEmail",
                "OutgoingEmailRelation",
                "DataAssessmentMetric",
                "DataAssessmentFieldMetric",
                "DataAssessmentValueMetric",
                "PlatformCachePartition",
                "PlatformCachePartitionType",
                "SecurityCustomBaseline",
                "EmbeddedServiceDetail",
                "ChatterExtension",
                "ChatterExtensionLocalization",
                "VisualforceAccessMetrics",
                "AssetRelationship",
                "AssetRelationshipHistory",
                "AssetRelationshipFeed",
                "OrgLifecycleNotification",
                "ChatterExtensionConfig",
                "ListEmail",
                "ListEmailShare",
                "ListEmailRecipientSource",
                "ActivityRecurrence",
                "UserPermissionAccess",
                "ActivityRecurrenceException",
                "WaveCompatibilityCheckItem"
            ]
        }

    </details>

## SObjectMetadata.cls
* Contains metadata information for the specified SObject. There are 2 ways to create an instance of SObjectMetadata

    1. By passing the SObject's API name as a string in the constructor
    ```
    new SObjectMetadata('Account')
    ```

    2. By passing the SObject Type in the constructor
    ```
    new SObjectMetadata(Schema.Account.SObjectType)
    ```

    ### Sample Usage
    Scenario: if the user has access to delete an SObject, then delete it

    ```
    public class MyClass {

        public void deleteRecord(MyCustomObject__c myRecord) {
            // If the user does not have access to delete, then stop
            if(new SObjectMetadata('MyCustomObject__c').isDeletable == false) return;

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
            "doesIncludeBosses": true,
            "doesSendEmailToMembers": true,
            "email": "fake@test.com",
            "label": "My Queue",
            "name": "My_Queue",
            "ownerId": "0050Y0000000000000",
            "queueId": "00G0Y0000011111111",
            "queueMembers": [
                {
                    "queueId": "00G0Y0000011111111",
                    "queueMemberId": "0110Y000000fHUyQAM",
                    "type": "User",
                    "userOrGroupId": "0050Y000001LrM3QAK"
                },
                {
                    "queueId": "00G0Y0000011111111",
                    "queueMemberId": "0110Y0000000000000",
                    "type": "User",
                    "userOrGroupId": "0050Y0000000000000"
                },
                {
                    "queueId": "00G0Y0000011111111",
                    "queueMemberId": "0110Y000001q5sUQAQ",
                    "type": "Group",
                    "userOrGroupId": "00G0Y000001inOQUAY"
                }
            ],
            "supportedSObjectNames": [
                "Lead",
                "Case"
            ]
        }

    </details>