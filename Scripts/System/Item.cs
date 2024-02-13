using Godot;
using System;

public partial class Item
{
	public virtual int ID { get; protected set; }
	public virtual Image Icon { get; protected set; }
    public virtual string Description { get; protected set; }

	public Item()
	{
		ID = -1;
	}
	
}

/// <summary>
/// Pending Implementation Decision
/// </summary>
public interface IQuality
{
	public int Quality { get;}
	public void SetQuality(int quality);
}

public interface IStackable
{
	virtual int Quantity { get => 0; private set { } }
	int MaxQuantity { get; }
	bool IsMaxStack => Quantity == MaxQuantity;

	int RemoveFromStack(int quantity)
	{
		Quantity = Math.Max(0, Quantity - quantity);
		return Quantity;
	}

	int AddToStack(int quantity)
	{		
		Quantity = Math.Min(quantity + Quantity, MaxQuantity);
		return MaxQuantity - (Quantity + quantity);
    }

}

public interface IBuyable
{
	public float BuyValue { get; }
}

public interface ISellable
{
	public float SaleValue { get; }
}

public interface IDisposable
{
	public void Dispose();
}

public interface IExtractable
{
	public void Extract();
}

public interface ICompostable
{
	public void Compost();
}