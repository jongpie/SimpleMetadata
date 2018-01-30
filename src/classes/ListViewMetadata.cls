global class ListViewMetadata {

    // Stores cached query results
    private static final Map<Id, ListView> QUERIED_LIST_VIEWS_BY_ID;
    private static final Map<String, ListView> QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME;
    private static final Map<String, List<String>> QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME;

    static {
        // Query & cache queues
        QUERIED_LIST_VIEWS_BY_ID                         = new Map<Id, ListView>();
        QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME = new Map<String, ListView>();
        QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME          = new Map<String, List<String>>();

        for(ListView listView : [SELECT Id, DeveloperName, IsSOQLCompatible, Name, NamespacePrefix, SObjectType FROM ListView]) {
            QUERIED_LIST_VIEWS_BY_ID.put(listView.Id, listView);
            QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME.put(listView.SObjectType + buildFullyQualifiedName(listView), listView);

            if(!QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.containsKey(listView.SObjectType)) {
                QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.put(listView.SObjectType, new List<String>{});
            }
            List<String> listViewNames = QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.get(listView.SObjectType);
            listViewNames.add((listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__') + listView.DeveloperName);
            QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.put(listView.SObjectType, listViewNames);
        }
    }

    public static List<String> getListViewNames(String sobjectName) {
        List<String> results = QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.get(sobjectName);
        return results != null ? results : new List<String>();
    }

    // Method is static so it can be used in static methods and instance methods
    private static String buildFullyQualifiedName(ListView listView) {
        return (listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__') + listView.DeveloperName;
    }

    @AuraEnabled global final Id id                    {get; private set;}
    @AuraEnabled global final Boolean isSOQLCompatible {get; private set;}
    @AuraEnabled global final String label             {get; private set;}
    @AuraEnabled global final String localName         {get; private set;}
    @AuraEnabled global final String name              {get; private set;}
    @AuraEnabled global final String namespace         {get; private set;}
    @AuraEnabled global final String sobjectName       {get; private set;}

    global ListViewMetadata(String sobjectName, String listViewName) {
        this(QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME.get(sobjectName + listViewName).Id);
    }

    global ListViewMetadata(Id listViewId) {
        ListView listView = QUERIED_LIST_VIEWS_BY_ID.get(listViewId);

        this.id               = listView.Id;
        this.isSOQLCompatible = listView.IsSOQLCompatible;
        this.label            = listView.Name;
        this.localName        = listView.DeveloperName;
        this.name             = buildFullyQualifiedName(listView);
        this.namespace        = listView.NamespacePrefix;
        this.sobjectName      = listView.SObjectType;
    }

}