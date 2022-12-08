package entities;

import haxepunk.HXP;
import haxepunk.math.Vector2;

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
        graphic.may(g -> {
			_flickerTimer -= HXP.elapsed;
			if (_flickerTimer > 0)
				g.visible = !g.visible;
			else
				g.visible = true;
		});

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
	private var _spawnPoint:Vector2;
	private var _flickerTimer:Float;

}
