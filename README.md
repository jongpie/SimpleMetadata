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
            "name": "Jonathan Gillespie's Org",
            "organizationId": "00D0Y0000019999999",
            "organizationType": "Developer Edition",
            "sobjectTypeNames": [
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