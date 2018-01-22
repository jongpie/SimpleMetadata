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

    // Aura-enabled member variables
    @AuraEnabled public Boolean doesIncludeBosses              {get; private set;}
    @AuraEnabled public Boolean doesSendEmailToMembers         {get; private set;}
    @AuraEnabled public String email                           {get; private set;}
    @AuraEnabled public String label                           {get; private set;}
    @AuraEnabled public String name                            {get; private set;}
    @AuraEnabled public Id ownerId                             {get; private set;}
    @AuraEnabled public Id queueId                             {get; private set;}
    @AuraEnabled public List<String> supportedSObjectNames     {get; private set;}
    @AuraEnabled public List<QueueMemberMetadata> queueMembers {get; private set;}

    // Private variables - marked as transient so they aren't included during JSON.serialize()
    private transient Group queue;

    public QueueMetadata(Id queueId) {
        this(queriedQueuesById.get(queueId).DeveloperName);
    }

    public QueueMetadata(String queueName) {
        // Since ID is a type of String, calling QueueMetadata('00G0Y000003ASYI') treats the string as the name, instead of the intended ID
        // To compensate, check if the 'queueName' is really the 'queueId'
        if(queueName instanceOf Id) this.queue = queriedQueuesById.get(queueName);
        else this.queue = queriedQueuesByDeveloperName.get(queueName);

        this.doesIncludeBosses      = this.queue.DoesIncludeBosses;
        this.doesSendEmailToMembers = this.queue.DoesSendEmailToMembers;
        this.email                  = this.queue.Email;
        this.label                  = this.queue.Name;
        this.name                   = this.queue.DeveloperName;
        this.ownerId                = this.queue.OwnerId;
        this.queueId                = this.queue.Id;

        this.setQueueMembers();
        this.setSupportedSObjectNames();
    }

    public override String toString() {
        return JSON.serialize(this);
    }

    private void setSupportedSObjectNames() {
        this.supportedSObjectNames = new List<String>();
        for(QueueSObject queueSObject : this.queue.QueueSObjects) {
            this.supportedSObjectNames.add(queueSObject.SObjectType);
        }
    }

    private void setQueueMembers() {
        this.queueMembers = new List<QueueMemberMetadata>();
        for(GroupMember queueMember : this.queue.GroupMembers) {
            this.queueMembers.add(new QueueMemberMetadata(queueMember));
        }
    }

    public class QueueMemberMetadata {

        // Aura-enabled member variables
        @AuraEnabled public Id queueId       {get; private set;}
        @AuraEnabled public Id queueMemberId {get; private set;}
        @AuraEnabled public String type      {get; private set;}
        @AuraEnabled public Id userOrGroupId {get; private set;}

        // Private variables - marked as transient so they aren't included during JSON.serialize()
        private transient GroupMember groupMember;

        private QueueMemberMetadata(GroupMember groupMember) {
            this.groupMember = groupMember;

            this.queueId       = this.groupMember.GroupId;
            this.queueMemberId = this.groupMember.Id;
            this.type          = String.valueOf(this.groupMember.UserOrGroupId.getSObjectType());
            this.userOrGroupId = this.groupMember.UserOrGroupId;
        }

    }

}