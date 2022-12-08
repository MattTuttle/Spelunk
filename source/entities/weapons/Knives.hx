package entities.weapons;

import haxepunk.HXP;
import haxepunk.math.Vector2;
import entities.Player;
import entities.Physics;
import entities.weapons.projectile.Knife;

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
        _player.sprite.currentAnimation.may(anim -> {
            if (anim.name == "idle")
            {
                _animating = 0.1;
                _player.sprite.play("knife");
            }
        });
		var knifeVel = new Vector2();
		var knifePos = new Vector2(x, y);
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
