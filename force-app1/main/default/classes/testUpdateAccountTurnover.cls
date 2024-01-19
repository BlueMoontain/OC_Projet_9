// This class is used to test the update of Account turnover
@isTest
public class testUpdateAccountTurnover {
    @isTest static void testHandleOrderAction() {
        // Setup test data
        List<Account> testAccounts = testDataFactory.createAccounts(1);
        List<Product2> testProducts = new List<Product2>(testDataFactory.createTestProductsAndPricebookEntries(1).keySet());
        
        // Retrieve the PricebookEntry for the test product
        PricebookEntry testPriceBookEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :testProducts[0].Id LIMIT 1];
        
        // Create 300 test orders and order items for the same account
        List<Order> testOrders = testDataFactory.createOrders(testAccounts, 300);
        List<OrderItem> testOrderItems = testDataFactory.createOrderItems(testOrders, new List<PricebookEntry>{testPriceBookEntry}, 1);
        
        // Update the status of the test orders to 'Ordered'
        for (Order order : testOrders) {
            order.Status = 'Ordered';
        }
        update testOrders;

        // Start the test, call the method to be tested, and stop the test
        Test.startTest();
        AccountHandler.handleOrderAction(testOrders, new Map<Id, Order>());
        Test.stopTest();

        // Verify that Account turnover is updated with orders status update
        Decimal expectedTotalAmount = 0;
        for (OrderItem item : testOrderItems) {
            expectedTotalAmount += item.Quantity * item.UnitPrice;
        }
        
        // Retrieve the updated account and assert that the turnover is as expected
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccounts[0].Id];
        System.assertEquals(expectedTotalAmount, updatedAccount.Chiffre_d_affaire__c);
    }
}