public virtual class QueueMetadata {

    // Stores cached query results
    private static Map<String, Group> queriedQueuesMap;

    static {
        // Query for caching queues
        queriedQueuesMap = new Map<String, Group>();
        for(Group queue : [
            SELECT DeveloperName, DoesIncludeBosses, DoesSendEmailToMembers, Email, Id, Name, OwnerId, RelatedId,
                (SELECT Id, SObjectType FROM QueueSObjects),
                (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers)
            FROM Group
            WHERE Type = 'Queue'
        ]) {
            queriedQueuesMap.put(queue.DeveloperName, queue);
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

    public QueueMetadata(String queueName) {
        this.name = queueName;
        this.queue = queriedQueuesMap.get(queueName);

        this.doesIncludeBosses      = this.queue.DoesIncludeBosses;
        this.doesSendEmailToMembers = this.queue.DoesSendEmailToMembers;
        this.email                  = this.queue.Email;
        this.label                  = this.queue.Name;
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