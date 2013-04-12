package com.matttuttle.entities.weapons;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.matttuttle.entities.Player;
import com.matttuttle.entities.Physics;

class Axe extends Melee
{

	public function new()
	{
		super("Axe");
		_animName = "axe";

		sprite = new Spritemap("gfx/items/axe.png", 16, 16, onSpriteEnd);
		sprite.add(_animName, [0, 1, 2, 3], 10, false);
		sprite.visible = false;
		graphic = sprite;
	}

	public override function reposition()
	{
		super.reposition();
		if (sprite.visible)
		{
			x = _player.x - 4;
			y = _player.y - 8;
			var offX:Int = 0, offY:Int = 0;
			switch(sprite.frame)
			{
				case 0:
					offY = -4;
					if (sprite.flipped) offX = -9;
				case 1:
					offX = -4;
				case 2:
					offY = -4;
					if (!sprite.flipped) offX = -9;
				case 3:
					offY = -8;
					if (!sprite.flipped) offX = -9;
			}
			setHitbox(7, 7, offX, offY);
		}
	}

}