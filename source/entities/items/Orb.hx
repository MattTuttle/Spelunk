package entities.items;

import entities.Player;

class Orb extends Item
{

	public function new(x:Float, y:Float, colorName:String)
	{
		super(x, y);

		switch(colorName)
		{
			case "yellow":
				sprite.add("orb", [24, 25, 26], 12);
			case "green":
				sprite.add("orb", [27, 28, 29], 12);
			case "red":
				sprite.add("orb", [30, 31, 32], 12);
			case "blue":
				sprite.add("orb", [33, 34, 35], 12);
			case "purple":
				sprite.add("orb", [36, 37, 38], 12);
			case "orange":
				sprite.add("orb", [39, 40, 41], 12);
		}
		sprite.play("orb");
	}

	public override function apply(player:Player)
	{
	}

}
