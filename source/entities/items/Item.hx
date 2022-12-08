package entities.items;

import haxepunk.Entity;
import haxepunk.graphics.Spritemap;
import entities.Player;

class Item extends Entity
{

	public var sprite:Spritemap;
	public var text:String;

	public function new(x:Float, y:Float, float:Bool = true)
	{
		super(x, y);
		sprite = new Spritemap("gfx/items/pickups.png", 8, 8);
        sprite.onAnimationComplete.bind(onSpriteEnd);
		graphic = sprite;

		_moveY = 0.1;
		_floating = float;
		_originalY = y - MOVE_VALUE;
		name = text = "";

		type = "item";
		setHitbox(8, 8);
	}

	public function apply(player:Player) { }
	public function onSpriteEnd(_) { }

	override public function update()
	{
		if (Math.abs(_originalY - y) > MOVE_VALUE)
			_moveY = -_moveY;

		y -= _moveY;
		super.update();
	}

	private var _floating:Bool;
	private var _originalY:Float;
	private static inline var MOVE_VALUE:Float = 2;

}
