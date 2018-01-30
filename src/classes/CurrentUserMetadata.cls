/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class CurrentUserMetadata {

    @AuraEnabled global final String defaultCurrency    {get; private set;}
    @AuraEnabled global final String email              {get; private set;}
    @AuraEnabled global final String firstName          {get; private set;}
    @AuraEnabled global final Id id                     {get; private set;}
    @AuraEnabled global final String language           {get; private set;}
    @AuraEnabled global final String lastName           {get; private set;}
    @AuraEnabled global final String locale             {get; private set;}
    @AuraEnabled global final String name               {get; private set;}
    //@AuraEnabled global final Id organizationId         {get; private set;}
    //@AuraEnabled global final String organizationName   {get; private set;}
    @AuraEnabled global final Id profileId              {get; private set;}
    //@AuraEnabled global final ProfileMetadata profile   {get; private set;}
    //@AuraEnabled global final TimeZoneMetadata timeZone {get; private set;}
    @AuraEnabled global final String username           {get; private set;}
    @AuraEnabled global final Id userRoleId             {get; private set;}
    @AuraEnabled global final String userType           {get; private set;}

    global CurrentUserMetadata() {
        this.defaultCurrency  = UserInfo.getDefaultCurrency();
        this.email            = UserInfo.getUserEmail();
        this.firstName        = UserInfo.getFirstName();
        this.id               = UserInfo.getUserId();
        this.language         = UserInfo.getLanguage();
        this.lastName         = UserInfo.getLastName();
        this.locale           = UserInfo.getLocale();
        this.name             = UserInfo.getName();
        //this.organizationId   = UserInfo.getOrganizationId();
        //this.organizationName = UserInfo.getOrganizationName();
        this.profileId        = UserInfo.getProfileId();
        //this.profile          = new ProfileMetadata(UserInfo.getProfileId());
        //this.timeZone         = new TimeZoneMetadata(UserInfo.getTimeZone());
        this.username         = UserInfo.getUsername();
        this.userRoleId       = UserInfo.getUserRoleId();
        this.userType         = UserInfo.getUserType();
    }

    /*global virtual class TimeZoneMetadata {

        @AuraEnabled global final String label      {get; private set;}
        @AuraEnabled global final String id             {get; private set;}
        @AuraEnabled global final Decimal gmtOffset {get; private set;}

        private TimeZoneMetadata(TimeZone timeZone) {
            this.label     = timeZone.getDisplayName();
            this.id        = timeZone.getId();
            this.gmtOffset = this.getGMTOffset(timeZone);
        }

        private Decimal getGMTOffset(TimeZone timeZone) {
            // 1000 ms/sec  * 60 sec/min * 60 min/hr  =3600000 ms/hour
            Decimal offset = (Decimal)TimeZone.getOffset(this.getNowGMT()) ;
            Decimal gmtOffset = offset / 3600000;
            //gmtOffset = gmtOffset.setScale(2);
            return gmtOffset;
        }

        private Datetime getNowGMT() {
            return Datetime.newInstanceGmt(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute(), System.now().second());
        }

    }*/

}