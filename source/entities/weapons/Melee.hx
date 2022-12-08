package entities.weapons;

import haxepunk.graphics.Spritemap;
import entities.Physics;
import entities.Player;

class Melee extends Weapon
{

	public var sprite:Spritemap;

	public function new(name:String)
	{
		super(name);
		_canHitEnemy = false;
	}

	public function onSpriteEnd(_)
	{
		sprite.visible = false;
		_canHitEnemy = false;
	}

	public override function use(direction:Direction)
	{
		if (sprite.visible) return;
		sprite.flipped = (_player.facing == Direction.LEFT);
		sprite.play(_animName, true);
		_player.sprite.play(_animName, true);
		sprite.visible = true;
		_canHitEnemy = true;
	}

	public override function reposition()
	{
		sprite.flipped = (_player.facing == Direction.LEFT);
	}

	private override function get_isUsing():Bool
	{
		return sprite.visible;
	}

	public override function update()
	{
		reposition();
		if (_canHitEnemy && hitEnemy())
			_canHitEnemy = false;
		super.update();
	}

	private var _canHitEnemy:Bool;
	private var _animName:String;

}
