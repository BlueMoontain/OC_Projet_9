// This trigger is executed before an Order record is updated to calculate the net amount (TotalAmount - ShipmentCost_c)
trigger UpdateNetAmount on Order (before update) {
    // The trigger will call netAmountUpdate to update the Net Amount
    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountHandler.netAmountUpdate(Trigger.new, Trigger.oldMap); 
    }
}