package com.matttuttle.entities.weapons;

import com.haxepunk.HXP;
import com.matttuttle.entities.Player;
import com.matttuttle.entities.Physics;
import com.matttuttle.entities.weapons.projectile.Knife;
import flash.geom.Point;

class Knives extends Weapon
{

	public function new(type:String)
	{
		super("Knives");

		switch (type)
		{
			case "knife":		_offset = 0;
			case "goldKnife":	_offset = 4;
			default: _offset = 0;
		}
		_animating = 0;
	}

	private override function get_isUsing():Bool
	{
		if (_animating < 0)
			return false;
		return true;
	}

	public override function update()
	{
		_animating -= HXP.elapsed;
		super.update();
	}

	public override function use(direction:Direction)
	{
		// Flip hand up if we're just standing idle
		if (_player.sprite.currentAnim == "idle")
		{
			_animating = 0.1;
			_player.sprite.play("knife");
		}
		var knifeVel:Point = new Point();
		var knifePos:Point = new Point(x, y);
		var knifeVelocity:Int = 360;
		switch(direction)
		{
			case UP:
				knifePos.y -= 6;
				knifePos.x += 2;
				knifeVel.y = -knifeVelocity;
			case DOWN:
				knifePos.y += 8;
				knifePos.x += 2;
				knifeVel.y = knifeVelocity;
			case RIGHT:
				knifePos.y += 1;
				knifePos.x += 4;
				knifeVel.x = knifeVelocity;
			case LEFT:
				knifePos.y += 1;
				knifePos.x -= 2;
				knifeVel.x = -knifeVelocity;
		}
		if (_player.crouching) knifePos.y += 2;
		HXP.scene.add(new Knife(knifePos.x, knifePos.y, knifeVel, _offset));
	}

	private var _offset:Int;
	private var _animating:Float;

}