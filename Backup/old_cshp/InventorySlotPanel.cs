using Godot;
using System;

public partial class InventorySlotPanel : Node
{
    private InventorySlot[] _slots = new InventorySlot[48];

    public override void _Ready()
    {
        for (int i = 0; i < 48; i++)
        {
            _slots[i] = GetNode("SlotContainer").GetChild(i) as InventorySlot;
        }
    }
    public void UpdateSlots()
    {
        for (int i = 0; i < 48; i++)
        {
            _slots[i].SetItem(Inventory.Instance.GetItemFromInventory(i));
        }
    }
}
