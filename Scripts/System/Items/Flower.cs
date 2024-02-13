using Godot;
using System;

public abstract partial class Flower : Item, IStackable, ISellable, IDisposable, ICompostable, IExtractable
{
    public int Quantity { get; }

    public abstract int MaxQuantity { get; }

    public abstract float SaleValue { get; }

    public bool AddToStack(int quantity)
    {
        throw new NotImplementedException();
    }

    public void Compost()
    {
        throw new NotImplementedException();
    }

    public void Dispose()
    {
        throw new NotImplementedException();
    }

    public void Extract()
    {
        throw new NotImplementedException();
    }

    public bool RemoveFromStack(int quantity)
    {
        throw new NotImplementedException();
    }
}
