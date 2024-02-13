using Godot;
using System;
using System.Collections.Generic;

public partial class Inventory : Node
{
    public static Inventory Instance { get; private set; }

    private Item[] _items = new Item[48];
    public InventoryPanel InventoryPanel => GetNode("InventoryPanel") as InventoryPanel;

    public delegate void ToggleInventoryPanelEventHandler();

    public override void _Ready()
    {
        if (Instance != null)
        {
            Instance = null;
        }

        Instance = this;
        for (int i = 0; i < _items.Length; i++)
        {
            _items[i] = new Item();
        }
        InventoryPanel.UpdateInventory();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (Input.IsActionJustPressed("inventory"))
        {
            ToggleInventoryPanel();
        }
    }

    public Item GetItemFromInventory(int i) => _items[i];

    public void ToggleInventoryPanel()
    {
        InventoryPanel.Visible = !InventoryPanel.Visible;
    }
}
