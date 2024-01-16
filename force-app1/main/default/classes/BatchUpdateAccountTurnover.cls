global class BatchUpdateAccountTurnover implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        // Query only accounts with minimum one order with "ordered" status
        return Database.getQueryLocator('SELECT Id, (SELECT TotalAmount FROM Order WHERE Status = \'Ordered\') FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
    }
    // Method updates the account turnover for the given scope of accounts
    global void execute(Database.BatchableContext info, List<Account> scope){ 
        AccountHandler.handleBatch(scope);
    }    
    // Method called after batch is processed -could be used to send email notifications 
    global void finish(Database.BatchableContext info){     

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'mailrecipient@.com'};
    mail.setToAddresses(toAddresses);
    mail.setSubject('Batch processing complete');
    mail.setPlainTextBody('The batch "UpdateAccountTurnover" processing job has completed successfully.');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }     
} 