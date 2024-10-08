/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Malcolm Philips
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        List<Lead> leadList = new List<Lead>([SELECT Id, LastName, Company, Phone, Email FROM Lead]);
        return leadList;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String contactName) {
        List<Contact> contactList = new List<Contact>([ SELECT Id, Name 
                                                        FROM Contact 
                                                        WHERE FirstName = :contactName]);
        return contactList;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName(String lastName1, String lastName2) {
        List<Contact> contactList = new List<Contact>([SELECT Id 
                                                        FROM Contact 
                                                        WHERE LastName 
                                                        IN (:lastName1, :lastName2)]);
        List<Id> contactIds = new List<Id>();
        for(Contact contact : contactList){
            contactIds.add(contact.Id);
        }
        return contactIds;

    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Name, Amount, StageName, CloseDate, AccountId 
                                                            FROM Opportunity 
                                                            WHERE AccountId = :accountId AND StageName = 'Closed Won']);
        return oppList;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        Integer count = [SELECT COUNT() FROM Account];
        return count;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        List<Task> taskList = new List<Task>([SELECT Id, Subject, ActivityDate, WhoId, Priority, Status, WhatId 
                                                FROM Task 
                                                WHERE ActivityDate = NEXT_N_DAYS:7]);
        Map<Id, Task> taskMap = new Map<Id, Task>();
        for (Task task : taskList){
            taskMap.put(task.Id, task);            
        }
        return taskMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain(String emailDomain) {       
        List<Contact> contactList = new List<Contact>([SELECT Id, Name, Email 
                                                        FROM Contact 
                                                        WHERE Email LIKE :('%' + emailDomain)]);
        return contactList;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Name, AccountId, Amount 
                                                            FROM Opportunity 
                                                            WHERE Name LIKE :('%'+ keyword +'%')]);
        return oppList;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> caseList = new List<Case>([SELECT Id, Origin, Subject, Status 
                                                FROM Case 
                                                WHERE Origin 
                                                NOT IN ('Web', 'Email', '', null)]);
        return caseList;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String leadTitle) {
        List<Lead> leadList = new List<Lead>([SELECT Id, LeadSource, Title, Company, Phone, Email, LastName 
                                                FROM Lead 
                                                WHERE LeadSource =:leadSource OR Title LIKE :('%'+leadTitle+'%')]);
        return leadList;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String> contactLastNames = new List<String>();   // Create a list to hold the Contact LastNames

        List<Contact> contactList = new List<Contact>([SELECT Id, LastName, AccountId 
                                                        FROM Contact 
                                                        WHERE AccountId = :accountId]); // Query the Contacts
        for (Contact contact : contactList) {           //loop through Contacts
            contactLastNames.add(contact.LastName);     // add contact Last Name to contactLastNames list
        }        
        return contactLastNames; 
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        AggregateResult[] totalList = [SELECT SUM(Amount)summedAmount 
                                        FROM Opportunity 
                                        WHERE StageName = :stage OR Amount > 10000]; // Use AggregateQuery to get the total revenue        
        return (Decimal)totalList[0].get('summedAmount');        
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List<Account> accountList = new List<Account>([SELECT Id, Name FROM Account ORDER BY Name LIMIT 10]);
        return accountList;
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Amount, CloseDate 
                                                            FROM Opportunity 
                                                            WHERE Amount > 100000 
                                                            ORDER BY CloseDate 
                                                            LIMIT 5]);
        return oppList;
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> birthdayList = new List<Contact>([SELECT Id, Name, Birthdate 
                                                        FROM Contact 
                                                        WHERE Birthdate != null 
                                                        ORDER BY Birthdate DESC 
                                                        LIMIT 3]);
        return birthdayList;
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> caseList = new List<Case>([SELECT Id, Status, CreatedDate 
                                                FROM Case 
                                                WHERE Status != 'Closed' 
                                                ORDER BY CreatedDate 
                                                LIMIT 10 
                                                OFFSET 5]);
        return caseList;
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> caseIds = new Set<Id>();                                        // Create a set to hold the Case Ids        
        List<Case> caseList = new List<Case>([SELECT Id, AccountId 
                                                FROM CASE 
                                                WHERE AccountId = :accountId]); // Query the Cases
        for (Case caseItem : caseList){                                         // Loop through each Case and add the Id to the set
            caseIds.add(caseItem.Id);
        }
        return caseIds;      
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        List<Account> accountList = new List<Account>([SELECT Id, Name, BillingCountry 
                                                        FROM Account 
                                                        WHERE BillingCountry != :country]); // Query the Accounts
        for (Account accountItem : accountList){
            accountIdsToNames.put(accountItem.Id, accountItem.Name);
        }
        return accountIdsToNames;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        Contact contactItem = [SELECT Id, Account.Name FROM Contact WHERE Id = :contactId];
        return contactItem.Account.Name; 
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        Account acct = [SELECT Id, Name, 
                            (SELECT Id, Name, CloseDate, StageName 
                            FROM Opportunities) 
                        FROM Account 
                        WHERE Id = :accountId];
        return acct;
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        Account acct = [SELECT Id, BillingState 
                        FROM Account 
                        WHERE Id = :accountId];  // Query the Account
        String acctState = acct.BillingState;  // Store the Account's BillingState       

        List<Contact> contactList = new List<Contact>([SELECT Id, MailingState 
                                                        FROM Contact 
                                                        WHERE MailingState = :acctState]);  // Query the Contacts
        return contactList; 
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        List<Lead> leadList = new List<Lead>([SELECT Id, Email 
                                                FROM Lead 
                                                WHERE Id IN :leadIds]);  // Query the Leads
        Set<String> websiteSet = new Set<String>(); // Create a set to hold website addresses from the lead email domains
        for (Lead leadInstance : leadList){     // Loop through each Lead
            If (leadInstance.Email != null) {    // Check if the email is not null
                websiteSet.add('www.' + leadInstance.email.substringAfter('@')); // Get the email from the Lead, extract domain, add website to the set
            }    
        }        
        List<Account> accts = new List<Account>([SELECT Id, Website, Name 
                                                    FROM Account 
                                                    WHERE Website IN :websiteSet]);// Query the Accounts
        return accts;
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>([SELECT Id, Quantity, UnitPrice, PricebookEntryId 
                                                                                    FROM OpportunityLineItem 
                                                                                    WHERE OpportunityId = :origOppId]);   // Query the original Opportunity Line Items

        
        List<OpportunityLineItem> clonedOppLineItemList = new List<OpportunityLineItem>();          // Create a list to hold the new line items         
        
        for (Id oppCloneId : cloneOppIds){                                                       // Loop through each cloned Opportunity Id            
            for (OpportunityLineItem oppLineItem : oppLineItemList){                            // Loop through each original line item
                Integer randomNumber = (Integer)(Math.random() * (3-1+1)) +1;   // Generate a random number between 1 and 3 >>(Integer)(Math.random() *(Max-Min+1)) + Min
                OpportunityLineItem newOLI = oppLineItem.clone(false, false, false, false);     // Clone the original line item 
                newOLI.OpportunityId = OppCloneId;                           // associate current cloned OLI with current cloned Opportunity
                newOLI.Quantity += randomNumber;                             // add the random number to the quantity
                clonedOppLineItemList.add(newOLI);                          // add cloned OLI to list
            }
        }
        insert clonedOppLineItemList;  // Insert the new OLI list
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() { 
        List<Opportunity> oppList = new List<Opportunity>([ SELECT Id, Name, StageName, Account.Name, Owner.Name, Primary_Contact__c 
                                                            FROM Opportunity 
                                                            WHERE StageName = 'Closed Won']);       
        return oppList;
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        List<Opportunity> oppList = getOpportunityDetailsForClosedWon();   //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id, Contact> contactAccountMap = new Map<Id, Contact>();

        for (Opportunity opp : oppList){        // Create a set of Account Ids from the Opportunities
            if (opp.AccountId != null){
                accountIdSet.add(opp.AccountId);
            }
        }        
        List<Contact> contactList = [SELECT Id, Name, CreatedDate, AccountId        
                                    FROM Contact 
                                    WHERE AccountId 
                                    IN :accountIdSet];         
        for (Contact cont : contactList){// Loop through each Contact and add the Account Id and Contact to the map  
            contactAccountMap.put(cont.AccountId, cont);
        }
        for (Opportunity opp : oppList){                        // Loop through each Opportunity
            Contact primeContact = contactAccountMap.get(opp.AccountId);
            opp.Primary_Contact__c = primeContact.Id;           // Update the Opportunity primary contact from accountToContactMap            
        }       
        update oppList;                                     // Update the Opportunities        
    }
}