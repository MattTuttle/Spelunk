package entities.enemies;

import entities.Character;
import entities.Player;
import entities.items.Coin;
import entities.items.Consumable;
import entities.items.Gem;
import haxepunk.Entity;
import haxepunk.HXP;

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

        scene.may(s -> s.add(new HitPointText(x, y, damage)));

		super.hurt(damage);
	}

	public override function kill()
	{
		// Item Drops
        scene.may(s -> {
            var drop:Float = Math.random();
            if (drop < 0.3)
                s.add(new Consumable(x, y));
            else if (drop < 0.5)
                s.add(new Coin(x, y));
            else if (drop < 0.6)
                s.add(new Gem(x, y));
        });
		super.kill();
	}

	private var _target:Entity;

	public static inline var GRAVITY_ACCELERATION:Float = 420;

}
