// This class is used to test the update of all Accounts
@isTest
public class testUpdateAllAccounts {

    // This test method tests the handleBatch method in the AccountHandler class
    @isTest static void testHandleBatch() {
        // Set up test data
        List<Account> testAccounts = testDataFactory.createAccounts(1);
        Map<Product2, PricebookEntry> productToPricebookEntry = testDataFactory.createTestProductsAndPricebookEntries(5);
        List<PricebookEntry> testPricebookEntries = productToPricebookEntry.values();
        List<Order> testOrders = testDataFactory.createOrders(testAccounts, 1);
        List<OrderItem> testOrderItems = testDataFactory.createOrderItems(testOrders, testPricebookEntries, 5);
        
        // Start the test, call the method to be tested, and stop the test
        Test.startTest();
        AccountHandler.handleBatch(testAccounts);
        Test.stopTest();

        // Retrieve the updated accounts
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        
        // Retrieve all orders for the updated accounts 
        List<Order> allOrders = [SELECT TotalAmount, AccountId FROM Order WHERE AccountId IN :testAccounts];
        
        // Create a map that associate each account with its orders
        Map<Id, List<Order>> accountToOrders = new Map<Id, List<Order>>();
        for (Order ord : allOrders) {
            if (!accountToOrders.containsKey(ord.AccountId)) {
                accountToOrders.put(ord.AccountId, new List<Order>());
            }
            accountToOrders.get(ord.AccountId).add(ord);
        }
        
        // For each updated account, calculate expected turnover and assert that turnover is as expected
        for (Account acc : updatedAccounts) {
            Decimal expectedTurnover = 0;
            for (Order ord : accountToOrders.get(acc.Id)) {
                expectedTurnover += ord.TotalAmount;
            }
            System.assertEquals(expectedTurnover, acc.Chiffre_d_affaire__c);
        }
    }
}
