package com.matttuttle.entities.weapons;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.matttuttle.entities.Player;

class Whip extends Melee
{

	public function new(type:String)
	{
		super("Whip");
		_animName = "whip";

		sprite = new Spritemap("gfx/items/whip.png", 24, 8, onSpriteEnd);
		switch (type)
		{
			case "whip":		sprite.add(_animName, [0, 2, 4, 6, 8, 10], 10, false);
			case "chainWhip":	sprite.add(_animName, [1, 3, 5, 7, 9, 11], 10, false);
		}
		sprite.visible = false;
		graphic = sprite;
	}

	public override function reposition()
	{
		super.reposition();
		if (sprite.visible)
		{
			x = _player.x - ((sprite.flipped) ? 13 : 3);
			y = _player.y;
			switch(sprite.frame)
			{
				case 1:
					setHitbox(5, 7, (sprite.flipped) ? -19 : 0, -2);
				case 2:
					setHitbox(9, 4, (sprite.flipped) ? -10 : -3, 0);
				case 3:
					setHitbox(15, 4, (sprite.flipped) ? 0 : -9, -2);
				case 4:
					setHitbox(15, 4, (sprite.flipped) ? 0 : -9, -2);
				case 5:
					setHitbox(15, 4, (sprite.flipped) ? 0 : -9, -4);
				case 6:
					setHitbox(6, 3, (sprite.flipped) ? -9 : -9, -5);
			}
		}
	}

}