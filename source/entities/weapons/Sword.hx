package entities.weapons;

import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
import haxepunk.Sfx;
import entities.Player;

class Sword extends Melee
{

	public function new(type:String)
	{
		super("Sword");
		_animName = "sword";

		sprite = new Spritemap("gfx/items/sword.png", 12, 8);
        sprite.onAnimationComplete.bind(onSpriteEnd);
		switch(type)
		{
			case "sword":		sprite.add(_animName, [0, 2, 4, 6], 10, false);
			case "goldSword":	sprite.add(_animName, [1, 3, 5, 7], 10, false);
		}
		sprite.visible = false;
		graphic = sprite;
	}

	public override function reposition()
	{
		super.reposition();
		if (sprite.visible)
		{
			x = _player.x;
			if (sprite.flipped) x -= 4;
			y = _player.y;
			switch(sprite.frame)
			{
				case 0:
					setHitbox(4, 3, (sprite.flipped) ? -8 : 0, -4);
				case 1:
					setHitbox(7, 3, (sprite.flipped) ? -3 : -2, -3);
				case 2:
					setHitbox(7, 3, (sprite.flipped) ? 0 : -5, -2);
				case 3:
					setHitbox(7, 3, (sprite.flipped) ? 0 : -5, -3);
			}
		}
	}

}
