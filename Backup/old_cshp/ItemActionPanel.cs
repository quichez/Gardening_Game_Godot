using Godot;
using System;
using System.Diagnostics;

public partial class ItemActionPanel : Node
{
    public Button DetailsButton => GetNode("ButtonContainer/DetailsButton") as Button;
    public Button SellButton => GetNode("ButtonContainer/SellButton") as Button;
    public Button ExtractButton => GetNode("ButtonContainer/ExtractButton") as Button;
    public Button CompostButton => GetNode("ButtonContainer/CompostButton") as Button;
    public Button DisposeButton => GetNode("ButtonContainer/DisposeButton") as Button;

    public override void _Ready()
    {        
        ToggleButtons(InventoryPanel.SelectedItem);
    }

    public void ToggleButtons(Item item)
    {
        if (item == null)
        {
            DetailsButton.Disabled = true;
            SellButton.Disabled = true;
            ExtractButton.Disabled = true;
            CompostButton.Disabled = true;
            DisposeButton.Disabled = true;
        }

        else
        {
            DetailsButton.Disabled = false;
            if (item is ISellable) { SellButton.Disabled = false; }
            if (item is IExtractable) { ExtractButton.Disabled = false; }
            if (item is ICompostable) { CompostButton.Disabled = false; }
            if (item is IDisposable) { DisposeButton.Disabled = false; }
        }
    }     
}