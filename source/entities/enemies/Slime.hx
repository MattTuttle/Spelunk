package entities.enemies;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Spritemap;

class Slime extends Enemy
{

	public var sprite:Spritemap;
	public var color:Int;

	public function new(x:Float, y:Float, colorName:String)
	{
		switch (colorName)
		{
			case "purple":	color = 0;
			case "green":	color = 1;
			case "blue":	color = 2;
			case "pink":	color = 3;
		}

		super(x, y, color * 2 + 1);

		var anim:Int = color * 6;
		sprite = new Spritemap("gfx/enemies/slime.png", 8, 8);
        sprite.onAnimationComplete.bind(onFinished);
		sprite.add("idle", [anim + 0, anim + 1], 8);
		sprite.add("jump", [anim + 0, anim + 1, anim + 2], 8);
		sprite.add("fall", [anim + 2]);
		sprite.add("poof", [anim + 3, anim + 4, anim + 5], 12);
		sprite.play("idle");

		graphic = sprite;

		experience = color * 6 + 7; // 7, 13, 19, 25, 31
		damage = color * 3 + 1; // 1, 4, 7, 10, 13

		maxVelocity.y = JUMP_ACCELERATION;
	}

	public function onFinished(anim)
	{
		if (anim.name == "poof") {
            removeFromScene();
        }
	}

	public override function kill()
	{
		if (dead) return;
		super.kill();
		// TODO: play death sound
		sprite.play("poof");
	}

	public override function update()
	{
		if (dead) return;

		if (onGround)
		{
			velocity.y = -JUMP_ACCELERATION;
		}

		if (velocity.y < 0)
		{
			sprite.play("jump");
		}
		else if (velocity.y > 0)
		{
			sprite.play("fall");
		}
		else
		{
			sprite.play("idle");
		}

		super.update();
	}

	public static inline var JUMP_ACCELERATION:Float = 120;

}
