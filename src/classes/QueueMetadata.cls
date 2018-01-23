/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
public virtual class QueueMetadata {

    // Stores cached query results
    private static Map<Id, Group> queriedQueuesById;
    private static Map<String, Group> queriedQueuesByDeveloperName;

    static {
        // Query & cache queues
        queriedQueuesById            = new Map<Id, Group>();
        queriedQueuesByDeveloperName = new Map<String, Group>();

        for(Group queue : [
            SELECT DeveloperName, DoesIncludeBosses, DoesSendEmailToMembers, Email, Id, Name, OwnerId, RelatedId,
                (SELECT Id, SObjectType FROM QueueSObjects),
                (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers)
            FROM Group
            WHERE Type = 'Queue'
        ]) {
            queriedQueuesById.put(queue.Id, queue);
            queriedQueuesByDeveloperName.put(queue.DeveloperName, queue);
        }
    }

    @AuraEnabled public final Boolean doesIncludeBosses              {get; private set;}
    @AuraEnabled public final Boolean doesSendEmailToMembers         {get; private set;}
    @AuraEnabled public final String email                           {get; private set;}
    @AuraEnabled public final String label                           {get; private set;}
    @AuraEnabled public final String name                            {get; private set;}
    @AuraEnabled public final Id ownerId                             {get; private set;}
    @AuraEnabled public final Id queueId                             {get; private set;}
    @AuraEnabled public final List<String> supportedSObjectNames     {get; private set;}
    @AuraEnabled public final List<QueueMemberMetadata> queueMembers {get; private set;}

    public QueueMetadata(Id queueId) {
        this(queriedQueuesById.get(queueId).DeveloperName);
    }

    public QueueMetadata(String queueName) {
        // Since ID is a type of String, calling QueueMetadata('00G0Y000003ASYI') treats the string as the name, instead of the intended ID
        // To compensate, check if the 'queueName' is really the 'queueId'
        Group queue;
        if(queueName instanceOf Id) queue = queriedQueuesById.get(queueName);
        else queue = queriedQueuesByDeveloperName.get(queueName);

        this.doesIncludeBosses      = queue.DoesIncludeBosses;
        this.doesSendEmailToMembers = queue.DoesSendEmailToMembers;
        this.email                  = queue.Email;
        this.label                  = queue.Name;
        this.name                   = queue.DeveloperName;
        this.ownerId                = queue.OwnerId;
        this.queueId                = queue.Id;
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

    public class QueueMemberMetadata {

        @AuraEnabled public final Id queueId       {get; private set;}
        @AuraEnabled public final Id queueMemberId {get; private set;}
        @AuraEnabled public final String type      {get; private set;}
        @AuraEnabled public final Id userOrGroupId {get; private set;}

        private QueueMemberMetadata(GroupMember groupMember) {
            this.queueId       = groupMember.GroupId;
            this.queueMemberId = groupMember.Id;
            this.type          = String.valueOf(groupMember.UserOrGroupId.getSObjectType());
            this.userOrGroupId = groupMember.UserOrGroupId;
        }

    }

}