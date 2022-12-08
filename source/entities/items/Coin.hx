package entities.items;

import entities.Player;

class Coin extends Item
{

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite.add("turn", [28, 9, 10, 11], 10);
		sprite.play("turn");
	}

	public override function apply(player:Player)
	{
		player.maxJumps += 1;
	}

}
