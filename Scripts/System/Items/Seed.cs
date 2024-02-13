using Godot;
using System;

public abstract partial class Seed : Item, IStackable, IBuyable, ISellable, IDisposable
{
    public int Quantity { get;}

    public int MaxQuantity => throw new NotImplementedException();

    public abstract float BuyValue { get; }

    public abstract float SaleValue { get; }

    public void Dispose()
    {
        throw new NotImplementedException();
    }

    public Seed(int quantity)
    {
        Quantity = quantity;
    }
}

public interface IPlantable
{
     void OnPlant();
}
