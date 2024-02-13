using Godot;
using System;

public abstract partial class Fruit : Item, IStackable, ISellable, IDisposable, ICompostable, IExtractable
{
    public int Quantity { get; }

    public abstract int MaxQuantity { get; protected set; }

    public abstract float SaleValue { get; }

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
}
