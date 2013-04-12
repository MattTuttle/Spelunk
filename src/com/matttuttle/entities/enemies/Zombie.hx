package com.matttuttle.entities.enemies;

import com.haxepunk.HXP;
import com.matttuttle.entities.Physics;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Zombie extends Enemy
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float, target:Entity)
	{
		super(x, y, 40);
		sprite = new Spritemap("gfx/enemies/zombie.png", 8, 8, onSpriteEnd);
		sprite.add("idle", [0]);
		sprite.add("emerge", [0, 1, 2, 3, 4], 8, false);
		sprite.add("walk", [5, 6, 7, 6], 4);
		sprite.add("poof", [8, 9, 10], 6);
		sprite.play("idle");

		_target = target;
		_emerged = false;
		_moveSpeed = 10;

		drag.x = _moveSpeed * 4;
//		acceleration.y = GRAVITY_ACCELERATION;
		maxVelocity.x = _moveSpeed;
//		maxVelocity.y = JUMP_ACCELERATION;

		experience = 50;
		damage = 20;
		defense = 5;
	}

	public function onSpriteEnd()
	{
		switch(sprite.currentAnim)
		{
			case "emerge":
				// The zombie has emerged!!!
				_emerged = true;
			case "poof":
				scene.remove(this);
		}
	}

	override public function kill()
	{
		if(dead) return;
		velocity.x = 0;
		velocity.y = 0;

		acceleration.x = 0;
		acceleration.y = 0;

//		if (onCamera)
//			FlxG.play(Assets.SndDeath);
		dead = true;
//		solid = false;
		sprite.play("poof");
	}

	override public function update()
	{
		if (dead)
		{
			super.update();
			return;
		}

		if (distanceToTarget() < 70)
		{
			if(!_emerged)
				sprite.play("emerge");
		}

		if (_target.x < x)
		{
			facing = Direction.LEFT;
		}
		else
		{
			facing = Direction.RIGHT;
		}

		if (_emerged)
		{
			sprite.play("walk");
			if(_target.x > x)
				velocity.x = 15;
			else
				velocity.x = -15;
		}

		super.update();
	}

	private var _emerged:Bool;
	private var _moveSpeed:Int;

}