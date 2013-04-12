package com.matttuttle.entities.enemies;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.matttuttle.entities.Character;
import com.matttuttle.entities.items.Coin;
import com.matttuttle.entities.items.Consumable;
import com.matttuttle.entities.items.Gem;
import com.matttuttle.entities.Player;

class Enemy extends Character
{

	public var damage:Int;

	public function new(x:Float, y:Float, hp:Int, gravity:Bool = true)
	{
		super(x, y, hp);
		setHitbox(8, 8);
		type = "enemy";

		if (gravity)
		{
			acceleration.y = GRAVITY_ACCELERATION;
		}
	}

	private function distanceToTarget():Float
	{
		var xDist:Float = Math.abs(x - _target.x);
		var yDist:Float = Math.abs(y - _target.y);
		return Math.sqrt((xDist * xDist) + (yDist * yDist));
	}

	public override function hurt(damage:Int)
	{
		damage = damage - defense;
		if (damage < 1)
			damage = 1; // at least do 1 point of damage

		scene.add(new HitPointText(x, y, damage));

		super.hurt(damage);
	}

	public override function kill()
	{
		// Item Drops
		var drop:Float = Math.random();
		if (drop < 0.3)
			scene.add(new Consumable(x, y));
		else if (drop < 0.5)
			scene.add(new Coin(x, y));
		else if (drop < 0.6)
			scene.add(new Gem(x, y));
		super.kill();
	}

	private var _target:Entity;

	public static inline var GRAVITY_ACCELERATION:Float = 420;

}