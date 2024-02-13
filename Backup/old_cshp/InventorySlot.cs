using Godot;
using System;

public partial class InventorySlot : Button
{
    private TextureRect _icon => GetNode("Icon") as TextureRect;
    private Panel _quantity => GetNode("QuantityPanel") as Panel;
    private Label _quantityText => GetNode("QuantityPanel/QuantityText") as Label;

    private Item _item;

    public override void _Ready()
    {
        Pressed += InventorySlot_Pressed;
    }

    private void InventorySlot_Pressed()
    {
        Inventory.Instance.InventoryPanel.OnInventorySlotSelect.Invoke(_item);
    }

    public void SetItem(Item item)
    {
        if (item.ID == -1)
        {
            _icon.Visible = false;
            _quantity.Visible = false;
            _quantityText.Text = string.Empty;
        }
        else
        {
            _item = item;
            _icon.Texture = ImageTexture.CreateFromImage(item.Icon);
        }
    }
}
