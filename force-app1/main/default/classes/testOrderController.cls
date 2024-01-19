@isTest
public class testOrderController {
    @isTest static void testTotalOrderSum() {
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

        // Instantiate OrderController
        ApexPages.StandardController standardController = new ApexPages.StandardController(testAccounts[0]);
        OrderController orderControllerInstance = new OrderController(standardController);

        // Start the test
        Test.startTest();
        Decimal totalOrderSum = orderControllerInstance.totalOrderSum;
        Test.stopTest();

        // Calculate the expected total amount
        Decimal expectedTotalAmount = 0;
        for (OrderItem item : testOrderItems) {
            expectedTotalAmount += item.Quantity * item.UnitPrice;
        }

        // Verify that totalOrderSum is correct
        System.assertEquals(expectedTotalAmount, totalOrderSum);
    }
}
