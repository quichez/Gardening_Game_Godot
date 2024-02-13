using Godot;
using System;

public abstract partial class Tool : Item, IBuyable, ISellable
{
    public abstract float BuyValue { get; }

    public abstract float SaleValue { get; }
}
