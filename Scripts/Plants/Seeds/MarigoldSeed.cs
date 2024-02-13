using Godot;

public class MarigoldSeed : Seed
{
    public override float SaleValue => 5;

    public override Image Icon => throw new System.NotImplementedException();

    public override string Description => "Seeds to grow nice marigolds!";

    public override float BuyValue => 10;

    public MarigoldSeed(int quantity) : base(quantity) { }
}
