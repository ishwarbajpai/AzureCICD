@IsTest
private class OpportunityServiceTest {
    @TestSetup
    static void setup() {
        Account acc = new Account(Name = 'Opp Demo Account');
        insert acc;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 3; i++) {
            opps.add(new Opportunity(
                Name = 'Demo Opp ' + i,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opps;
    }

    @IsTest
    static void testCloseWonOpenOpps() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Integer updated = OpportunityService.closeWonOpenOpps(new Set<Id>{ acc.Id });
        Test.stopTest();

        System.Assert.areEqual(3, updated, 'All 3 opps should be updated');
        System.Assert.areEqual(3, [SELECT COUNT() FROM Opportunity WHERE IsWon = true]);
    }

      @isTest
    static void pastDate_onOpenOpp_returnsError() {
        Opportunity opp = new Opportunity(Name = 'Past', StageName = 'Prospecting', CloseDate = Date.today().addDays(-1));
 
        List<String> errors = OpportunityService.validate(new List<Opportunity>{ opp });
 
        System.assertEquals(1, errors.size(), 'Past close date should return an error');
        System.assert(errors[0].contains('Close Date cannot be in the past'));
    }
 
    @isTest
    static void futureDate_returnsNoError() {
        Opportunity opp = new Opportunity(Name = 'Future', StageName = 'Prospecting', CloseDate = Date.today().addDays(10));
 
        List<String> errors = OpportunityService.validate(new List<Opportunity>{ opp });
 
        System.assertEquals(0, errors.size());
    }
 
    @isTest
    static void closedStage_pastDate_returnsNoError() {
        Opportunity opp = new Opportunity(Name = 'Closed', StageName = 'Closed Won', CloseDate = Date.today().addDays(-5));
 
        List<String> errors = OpportunityService.validate(new List<Opportunity>{ opp });
 
        System.assertEquals(0, errors.size(), 'Closed opps may have past dates');
    }
}