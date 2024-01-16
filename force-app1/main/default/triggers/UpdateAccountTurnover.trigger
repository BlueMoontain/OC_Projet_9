// This trigger updates the Account turnover when an Order is updated (to status'ordered')
trigger UpdateAccountTurnover on Order (after update) {
    // The trigger will call handleOrderAction to update the Account's turnover
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountHandler.handleOrderAction(Trigger.new, Trigger.oldMap); 
    }
}
