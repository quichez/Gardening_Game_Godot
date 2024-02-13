using Godot;
using System;

public partial class InventoryPanel : Panel
{
    public static Item SelectedItem { get; set; }
    public InventorySlotPanel SlotPanel => GetNode("InventorySlotPanel") as InventorySlotPanel;
    public Label LabelText => GetNode("DetailPanel/LabelPanel/LabelText") as Label;
    public TextureRect Image => GetNode("DetailPanel/ImagePanel/Image") as TextureRect;
    public ItemActionPanel ActionPanel => GetNode("DetailPanel/ItemActionPanel") as ItemActionPanel;

    public delegate void InventorySlotSelect(Item item);
    public InventorySlotSelect OnInventorySlotSelect;

    public override void _Ready()
    {
        OnInventorySlotSelect += ctx => UpdateDetailPanel(ctx);
        OnInventorySlotSelect += ctx => ActionPanel.ToggleButtons(ctx);
    }

    public void UpdateInventory()
    {
        SlotPanel.UpdateSlots();
    }
    

    public void UpdateDetailPanel(Item item)
    {
        if (item == null)
        {
            LabelText.Text = "item";
            Image.Texture = null;
        }
        else
        {
            Image.Texture = ImageTexture.CreateFromImage(item.Icon);
            LabelText.Text = item.ToString();
        }
    }
}
