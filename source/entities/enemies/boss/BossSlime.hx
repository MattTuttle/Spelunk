package entities.enemies.boss;

import haxepunk.Entity;
import haxepunk.graphics.Spritemap;

class BossSlime extends Enemy
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y, 50);
		sprite = new Spritemap("gfx/enemies/boss/slime.png", 32, 32);
		sprite.add("death", [6, 5, 4, 3, 2, 1, 0], 12, false);
		sprite.add("idle", [1, 2, 3, 2], 6);
		sprite.add("emerge", [4, 5, 6], 12, false);
		sprite.add("attack", [7, 8, 9], 12);
		sprite.play("idle");

		damage = 10;
	}

}
