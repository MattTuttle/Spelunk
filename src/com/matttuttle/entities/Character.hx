package com.matttuttle.entities;

import flash.geom.Point;
import com.haxepunk.HXP;

class Character extends Physics
{

	public var attack:Int;
	public var defense:Int;
	public var level:Int;
	public var health:Int;
	public var experience:Int;

	public var maxHealth:Int;

	// Properties
	public var flickering(get, null):Bool;
	private function get_flickering():Bool
	{
		if (_flickerTimer > 0)
			return true;
		return false;
	}

	public function new(x:Float, y:Float, hp:Int = 10)
	{
		super(x, y);

		health = maxHealth = hp;
		level = 1;
		experience = 0;
		attack = 1;
		defense = 0;

		_flickerTimer = 0;
	}

	public override function update()
	{
		if (graphic != null)
		{
			_flickerTimer -= HXP.elapsed;
			if (_flickerTimer > 0)
				graphic.visible = !graphic.visible;
			else
				graphic.visible = true;
		}

		super.update();
	}

	public function flicker(duration:Float)
	{
		_flickerTimer = duration;
	}

	public function hurt(damage:Int)
	{
		health -= damage;
		if (health <= 0)
		{
			kill();
		}
	}

	public function revive()
	{
		x = _spawnPoint.x;
		y = _spawnPoint.y;
		health = maxHealth;
		acceleration.x = 0;
		velocity.y = velocity.x = 0;
	}

	public function kill()
	{
		health = 0;
		dead = true;
	}

	public var dead:Bool;
	private var _spawnPoint:Point;
	private var _flickerTimer:Float;

}