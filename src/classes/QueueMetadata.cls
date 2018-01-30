/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class QueueMetadata {

    // Stores cached query results
    private static final Map<Id, Group> QUERIED_QUEUES_BY_ID;
    private static final Map<String, Group> QUERIED_QUEUES_BY_DEVELOPER_NAME;

    static {
        // Query & cache queues
        QUERIED_QUEUES_BY_ID             = new Map<Id, Group>();
        QUERIED_QUEUES_BY_DEVELOPER_NAME = new Map<String, Group>();

        for(Group queue : [
            SELECT DeveloperName, DoesIncludeBosses, DoesSendEmailToMembers, Email, Id, Name, OwnerId, RelatedId,
                (SELECT Id, SObjectType FROM QueueSObjects),
                (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers)
            FROM Group
            WHERE Type = 'Queue'
        ]) {
            QUERIED_QUEUES_BY_ID.put(queue.Id, queue);
            QUERIED_QUEUES_BY_DEVELOPER_NAME.put(queue.DeveloperName, queue);
        }
    }

    @AuraEnabled global final Boolean doesIncludeBosses              {get; private set;}
    @AuraEnabled global final Boolean doesSendEmailToMembers         {get; private set;}
    @AuraEnabled global final String email                           {get; private set;}
    @AuraEnabled global final Id id                                  {get; private set;}
    @AuraEnabled global final String label                           {get; private set;}
    @AuraEnabled global final String name                            {get; private set;}
    @AuraEnabled global final Id ownerId                             {get; private set;}
    @AuraEnabled global final List<String> supportedSObjectNames     {get; private set;}
    @AuraEnabled global final List<QueueMemberMetadata> queueMembers {get; private set;}

    global QueueMetadata(String queueName) {
        this(QUERIED_QUEUES_BY_DEVELOPER_NAME.get(queueName).Id);
    }

    global QueueMetadata(Id queueId) {
        Group queue = QUERIED_QUEUES_BY_ID.get(queueId);

        this.doesIncludeBosses      = queue.DoesIncludeBosses;
        this.doesSendEmailToMembers = queue.DoesSendEmailToMembers;
        this.email                  = queue.Email;
        this.id                     = queue.Id;
        this.label                  = queue.Name;
        this.name                   = queue.DeveloperName;
        this.ownerId                = queue.OwnerId;
        this.queueMembers           = this.getQueueMembers(queue);
        this.supportedSObjectNames  = this.getSupportedSObjectNames(queue);
    }

    private List<QueueMemberMetadata> getQueueMembers(Group queue) {
        List<QueueMemberMetadata> queueMembers = new List<QueueMemberMetadata>();
        for(GroupMember queueMember : queue.GroupMembers) {
            queueMembers.add(new QueueMemberMetadata(queueMember));
        }
        return queueMembers;
    }

    private List<String> getSupportedSObjectNames(Group queue) {
        List<String> supportedSObjectNames = new List<String>();
        for(QueueSObject queueSObject : queue.QueueSObjects) {
            supportedSObjectNames.add(queueSObject.SObjectType);
        }
        return supportedSObjectNames;
    }

    global class QueueMemberMetadata {

        @AuraEnabled global final Id queueId       {get; private set;}
        @AuraEnabled global final Id queueMemberId {get; private set;}
        @AuraEnabled global final String type      {get; private set;}
        @AuraEnabled global final Id userOrGroupId {get; private set;}

        private QueueMemberMetadata(GroupMember groupMember) {
            this.queueId       = groupMember.GroupId;
            this.queueMemberId = groupMember.Id;
            this.type          = String.valueOf(groupMember.UserOrGroupId.getSObjectType());
            this.userOrGroupId = groupMember.UserOrGroupId;
        }

    }

}