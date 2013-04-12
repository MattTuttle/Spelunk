package com.matttuttle.entities.enemies;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

enum State
{
	SLEEP;
	CHASE;
	FLEE;
}

class Bat extends Enemy
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float, target:Entity)
	{
		super(x, y, 4, false);
		sprite = new Spritemap("gfx/enemies/bat.png", 8, 8, onSpriteEnd);
		sprite.add("sleep", [0]);
		sprite.add("open", [0, 1], 2);
		sprite.add("fly", [2, 3], 6);
		sprite.add("swoop", [4]);
		graphic = sprite;

		_state = SLEEP;
		_target = target;

		_fleeTime = 0;
		_moveSpeed = 5;

		damage = 2;
		experience = 15;

		setHitbox(5, 8);
	}

	private function onSpriteEnd()
	{
		switch(sprite.currentAnim)
		{
			case "open":
				_state = CHASE;
		}
	}

	override public function hitTop()
	{
		if (distanceToTarget() > 80 || _target.y > y)
		{
			_state = SLEEP;
			velocity.x = 0;
			sprite.play("sleep");
		}
	}

	override public function hitLeft()   { _state = FLEE; _fleeTime = 2; }
	override public function hitRight()  { _state = FLEE; _fleeTime = 2; }
	override public function hitBottom() { _state = FLEE; _fleeTime = 2; }

	override public function kill()
	{
		super.kill();
		scene.remove(this);
	}

	override public function update()
	{
		var distance:Float = distanceToTarget();
		switch(_state)
		{
			case SLEEP:
				// Make sure the player is underneath the bat
				if(distance < 80 && _target.y > y)
					sprite.play("open");
			case CHASE:
				if (distance > 120)
					_state = FLEE;

				if(_target.x > x)
					velocity.x = _moveSpeed;
				else
					velocity.x = -_moveSpeed;

				velocity.y = _moveSpeed + 20;

				sprite.play("swoop");

			case FLEE:
				_fleeTime -= HXP.elapsed;
				if (distance > 30 && distance < 50 && _fleeTime < 0)
					_state = CHASE;

				sprite.play("fly");
				velocity.y = -_moveSpeed;
		}

		super.update();
	}

	private var _state:State;
	private var _fleeTime:Float;
	private var _moveSpeed:Int;

}