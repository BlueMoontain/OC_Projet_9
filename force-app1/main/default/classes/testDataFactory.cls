// This class is used to generate test data for unit tests
@isTest
public class testDataFactory {
    // Constants used for tests
    public static final String PRODUCT_FAMILY = 'Chemise';
    public static final List<String> PRODUCT_NAMES = new List<String>{'Chemise Verte', 'Chemise Bleue', 'Chemise Rouge', 'Chemise Noire'};
    public static final List<Integer> PRICES = new List<Integer>{10, 20, 50, 100, 10000};
    public static final List<Integer> QUANTITIES = new List<Integer>{1, 2, 3, 5, 10};

    // Method to create test accounts
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> testAccounts = new List<Account>();
        
        // Create each test account
        for (Integer i = 0; i < numAccounts; i++) {
            Account testAccount = new Account(Name = 'Test Account ' + i);
            testAccounts.add(testAccount);
        }
        // Try-catch block
        try {
            insert testAccounts;
        } catch (DmlException e) {
            System.debug('Failed to insert test accounts: ' + e.getMessage());
        }
        return testAccounts;
    }

    // Method to create test products (and their pricebook entries)
    public static Map<Product2, PricebookEntry> createTestProductsAndPricebookEntries(Integer numProducts) {
        List<Product2> testProducts = new List<Product2>();
        List<PricebookEntry> testPriceBookEntries = new List<PricebookEntry>();
        Map<Product2, PricebookEntry> productToPricebookEntry = new Map<Product2, PricebookEntry>();
        
        // Create each test product
        for (Integer i = 0; i < numProducts; i++) {
            Integer index = Math.mod(i, PRODUCT_NAMES.size());
            String productName = PRODUCT_NAMES.get(index);
            Product2 testProduct = new Product2(Name = productName + ' ' + i, Family = PRODUCT_FAMILY);
            testProducts.add(testProduct);
        }
        // Try-catch block
        try {
            insert testProducts;
        } catch (DmlException e) {
            System.debug('Failed to insert test products: ' + e.getMessage());
        }
        // Counter to cycle through the PRICES list
        Integer counter = 0;
        // Create each test pricebook entry
        for (Product2 product : testProducts) {
            PricebookEntry testPriceBookEntry = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), //pb
                Product2Id = product.Id,
                UnitPrice = PRICES[Math.mod(counter, PRICES.size())],
                IsActive = true
            );
            // Add new PricebookEntry to testPriceBookEntries list and product (and its corresponding PricebookEntry) to the productToPricebookEntry map
            testPriceBookEntries.add(testPriceBookEntry);
            productToPricebookEntry.put(product, testPriceBookEntry);
            
            counter++;
        }
        // Try-catch block 
        try {
            insert testPriceBookEntries;
        } catch (DmlException e) {
            System.debug('Failed to insert test pricebook entries: ' + e.getMessage());
        }

        return productToPricebookEntry;
    }
 
    // Method to create test orders
    public static List<Order> createOrders(List<Account> accounts) {
        // Get the ID of the standard price book
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> testOrders = new List<Order>();
        // Create each test order
        for (Account account : accounts) {
            Order testOrder = new Order(AccountId = account.Id, EffectiveDate = System.today(), Status = 'Draft', Pricebook2Id = standardPricebookId );
            testOrders.add(testOrder);
        }
        // Try-catch block
        try {
            insert testOrders;
        } catch (DmlException e) {
            System.debug('Failed to insert test orders: ' + e.getMessage());
        }

        return testOrders;
    }

    // Method to create test order items
    public static List<OrderItem> createOrderItems(List<Order> orders, List<PricebookEntry> pricebookEntries, Integer numItems) {
        List<OrderItem> orderItems = new List<OrderItem>();
        Integer counter = 0;

        // Loop through the number of items to be created
        for (Integer i = 0; i < numItems; i++) {
            // Get the order and pricebook entry for the current item
            Order order = orders[Math.mod(i, orders.size())];
            PricebookEntry pricebookEntry = pricebookEntries[Math.mod(i, pricebookEntries.size())];         
            // Create a new OrderItem
            OrderItem testOrderItem = new OrderItem (
                OrderId = order.Id,
                PricebookEntryId = pricebookEntry.Id,
                Quantity = QUANTITIES[Math.mod(counter, QUANTITIES.size())],
                UnitPrice = PRICES[Math.mod(counter, PRICES.size())]
            );          
            // Add the new OrderItem to the orderItems list
            orderItems.add(testOrderItem);
            counter++;
        }      
        // Try-catch block 
        try {
            // Debug log before inserting the order items
            System.debug(orderItems);           
            // Insert the order items
            insert orderItems;           
            // Debug log after inserting the order items
            System.debug(orderItems);
        } catch (DmlException e) {
            System.debug('Failed to insert test order items: ' + e.getMessage());
        }

        return orderItems;
    }
}