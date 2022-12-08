package entities.items;

import haxepunk.HXP;
import entities.Player;

class Gem extends Item
{

	public var shineWait:Float;

	public function new(x:Float, y:Float, ?colorName:String)
	{
		super(x, y);

		if (colorName == null)
		{
			var type:Int = Math.floor(Math.random() * 6);
			var types:Array<String> = ["blue", "purple", "red", "yellow", "green", "orange"];
			colorName = types[type];
		}

		switch(colorName)
		{
			case "blue":
				sprite.add("gem", [42]);
				sprite.add("shine", [43, 44, 45, 46], 12);
			case "purple":
				sprite.add("gem", [48]);
				sprite.add("shine", [49, 50, 51, 52], 12);
			case "red":
				sprite.add("gem", [54]);
				sprite.add("shine", [55, 56, 57, 58], 12);
			case "yellow":
				sprite.add("gem", [60]);
				sprite.add("shine", [61, 62, 63, 64], 12);
			case "green":
				sprite.add("gem", [66]);
				sprite.add("shine", [67, 68, 69, 70], 12);
			case "orange":
				sprite.add("gem", [72]);
				sprite.add("shine", [73, 74, 75, 76], 12);
		}
		sprite.play("gem");

		shineWait = Math.random() * 4 + 2;
	}

	public override function apply(player:Player)
	{
	}

	public override function onSpriteEnd(anim)
	{
		if (anim.name == "shine")
			sprite.play("gem");
	}

	public override function update()
	{
		shineWait -= HXP.elapsed;
		if (shineWait < 0)
		{
			sprite.play("shine");
			shineWait = Math.random() * 4 + 2;
		}
		super.update();
	}

}
