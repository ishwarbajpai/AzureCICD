public with sharing class OpportunityService {
    public static Integer closeWonOpenOpps(Set<Id> accountIds) {
        List<Opportunity> opps = [
            SELECT Id, StageName FROM Opportunity
            WHERE AccountId IN :accountIds AND IsClosed = false
        ];
        for (Opportunity o : opps) {
            o.StageName = 'Closed Won';
        }
        update opps;
        return opps.size();
    }

     public static List<String> validate(List<Opportunity> opps) {
        List<String> errors = new List<String>();
        for (Opportunity opp : opps) {
            Boolean isOpen = opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost';
            if (isOpen && opp.CloseDate != null && opp.CloseDate < Date.today()) {
                errors.add(opp.Name + ': Close Date cannot be in the past for an open opportunity.');
            }
        }
        //System.debug('opps : ' + opps);
        return errors;
    }

    }