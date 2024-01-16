// This class handles operations related to Order in Salesforce
public without sharing class OrderController {

    // Constructor for the OrderController class
    public OrderController(ApexPages.StandardController controller){}

    // Property for the total sum of all orders
    public decimal totalOrderSum{
        get{
            // Aggregate query to calculate the total sum of all orders
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
            
            // Return the total sum (as a decimal)
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}