// This class handles operations related to Account
public with sharing class AccountHandler {
    // This method handles a batch of accounts
    public static void handleBatch(List<Account> accountList){
        // Query accounts and related orders, and calculate the total order amount for each account
        List<AggregateResult> aggregatedResults = [SELECT AccountId, SUM(TotalAmount) total FROM Order WHERE AccountId IN :accountList GROUP BY AccountId];
        Map<Id, Account> accountToUpdateMap = new Map<Id, Account>();
        // Loop through the aggregated results
        for (AggregateResult result : aggregatedResults) {
            Id accountId = (Id)result.get('AccountId');
            Decimal totalOrderAmount = (Decimal)result.get('total');
            // Update the account's field with the calculated total order amount
            accountToUpdateMap.put(accountId, new Account(Id=accountId, Chiffre_d_affaire__c=totalOrderAmount));
        }
        // Try-catch block
        try {
            update accountToUpdateMap.values();
        } catch (DmlException e) {
            System.debug('Failed to update accounts: ' + e.getMessage());
        }
    }
    // This method handles order actions and updates the account's field when status is changed to 'ordered'
    public static void handleOrderAction(List<Order> orders, Map<Id, Order> prevOrders) {
        // Retrieve the account IDs from the orders where the status has changed to 'Ordered'
        Set<Id> accountIds = new Set<Id>();
        for (Order order : orders) {
            Order prevOrder = prevOrders.get(order.Id);
            if (order.Status == 'Ordered' && (prevOrder == null || prevOrder.Status != 'Ordered')) {
                accountIds.add(order.AccountId);
            }
        }
        // Retrieve the corresponding accounts
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);
        // Update the account's field based on the order status
        for (Order order : orders) {
            Account acc = accountsToUpdate.get(order.AccountId);
            if (acc != null) {
                Order prevOrder = prevOrders.get(order.Id);
                // If the order status is changed to 'Ordered', add the order amount to the account turnover
                if (order.Status == 'Ordered' && (prevOrder == null || prevOrder.Status != 'Ordered')) {
                    if (order.TotalAmount != null) {
                        if (acc.Chiffre_d_affaire__c == null) {
                            acc.Chiffre_d_affaire__c = 0;
                        }
                        acc.Chiffre_d_affaire__c += order.TotalAmount;
                    }
                }
            }
        }
        // Save the changes
        update accountsToUpdate.values();
    }
}
