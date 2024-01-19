@isTest
public with sharing class testUpdateNetAmount {
    @isTest public static void testNetAmountUpdate() {
        // Create test data
        List<Account> testAccounts = testDataFactory.createAccounts(1);
        Map<Product2, PricebookEntry> testProducts = testDataFactory.createTestProductsAndPricebookEntries(5);
        List<Order> testOrders = testDataFactory.createOrders(testAccounts);
        List<OrderItem> testOrderItems = testDataFactory.createOrderItems(testOrders, new List<PricebookEntry>(testProducts.values()), 5);
        
        // Update the status of the test orders to 'Ordered'
        for (Order order : testOrders) {
            order.Status = 'Ordered';
        }
        update testOrders;

        // Call the netAmountUpdate method in the AccountHandler class
        AccountHandler.netAmountUpdate(testOrders, new Map<Id, Order>());

        // Retrieve the updated orders
        List<Order> updatedOrders = [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id IN :testOrders];

        // Verify that NetAmount__c is updated correctly for each order
        for (Order updatedOrder : updatedOrders) {
            System.assertEquals(updatedOrder.TotalAmount - updatedOrder.ShipmentCost__c, updatedOrder.NetAmount__c);
        }
    }
}