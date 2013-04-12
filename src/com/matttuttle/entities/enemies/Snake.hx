package com.matttuttle.entities.enemies;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Snake extends Enemy
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float, colorName:String)
	{
		switch (colorName)
		{
			case "green":
				level = 0;
			case "yellow":
				level = 1;
			case "brown":
				level = 2;
			case "black":
				level = 3;
		}

		super(x, y, 8 * level + 8);
		var anim:Int = level * 6;
		sprite = new Spritemap("gfx/enemies/snake.png", 8, 8, onSpriteEnd);
		sprite.add("slither", [anim + 0, anim + 1, anim + 2], 12);
		sprite.add("poof", [anim + 3, anim + 4, anim + 5], 6);
		graphic = sprite;

		_moveSpeed = 20 + level * 5;

		maxVelocity.x = _moveSpeed;
		velocity.x = _moveSpeed;

		experience = 26;
		damage = 4 + level * 6;
		defense = 0;
	}

	override public function kill()
	{
		if(dead) return;
		velocity.x = 0;
		velocity.y = 0;

		dead = true;
		sprite.play("poof");
	}

	override public function hitLeft()
	{
		velocity.x = _moveSpeed;
	}

	override public function hitRight()
	{
		velocity.x = -_moveSpeed;
	}

	public function onSpriteEnd()
	{
		switch(sprite.currentAnim)
		{
			case "poof":
				scene.remove(this);
		}
	}

	override public function update()
	{
		if (dead)
		{
			super.update();
			return;
		}

		if (velocity.x > 0)
		{
			sprite.flipped = true;
		}
		else if (velocity.x < 0)
		{
			sprite.flipped = false;
		}

		sprite.play("slither");

		super.update();
	}

	private var _moveSpeed:Int;

}