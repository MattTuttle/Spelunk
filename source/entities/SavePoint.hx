package entities;

import haxepunk.Entity;
import haxepunk.graphics.Spritemap;

class SavePoint extends Entity
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		sprite = new Spritemap("gfx/save_point.png", 8, 8);
		sprite.add("sparkle", [0, 1, 2, 3], 8);
		sprite.add("zoom", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4], 12);
		sprite.play("sparkle");
		graphic = sprite;
	}

}
