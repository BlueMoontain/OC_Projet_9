trigger UpdateNetAmount on Order (before update) {
    // The trigger will call netAmountUpdate to update the Net Amount
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Call the netAmountUpdate method in the AccountHandler class
        AccountHandler.netAmountUpdate(Trigger.new, Trigger.oldMap); 
    }
}