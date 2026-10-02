local InventoryModule = {}

function InventoryModule:create()
    return {
        items = {},
        maxSlots = 20,
    }
end

function InventoryModule:addItem(inventory, itemId, quantity)
    quantity = quantity or 1
    
    for i, item in ipairs(inventory.items) do
        if item.id == itemId then
            item.quantity = item.quantity + quantity
            return true
        end
    end
    
    if #inventory.items >= inventory.maxSlots then
        return false
    end
    
    table.insert(inventory.items, {id = itemId, quantity = quantity})
    return true
end

function InventoryModule:removeItem(inventory, itemId, quantity)
    quantity = quantity or 1
    
    for i, item in ipairs(inventory.items) do
        if item.id == itemId then
            item.quantity = item.quantity - quantity
            if item.quantity <= 0 then
                table.remove(inventory.items, i)
            end
            return true
        end
    end
    
    return false
end

function InventoryModule:getItem(inventory, itemId)
    for i, item in ipairs(inventory.items) do
        if item.id == itemId then
            return item
        end
    end
    return nil
end

function InventoryModule:getQuantity(inventory, itemId)
    local item = InventoryModule:getItem(inventory, itemId)
    return item and item.quantity or 0
end

return InventoryModule
