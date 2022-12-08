package entities.weapons;

import haxepunk.Entity;
import haxepunk.HXP;
import scenes.Game;
import entities.Physics;
import entities.enemies.Enemy;
import entities.Player;

class Weapon extends Physics
{

	public var attack:Int;

	public function new(name:String)
	{
		super(0, 0);
		_player = Game.player;
		this.name = name;
		type = "weapon";
	}

	public var isUsing(get, null):Bool;
	private function get_isUsing():Bool { return false; }

	public function use(direction:Direction) { }

	public function reposition()
	{
		x = _player.x;
		y = _player.y;
	}

	private function hitEnemy():Bool
	{
		var e = collide("enemy", x, y);
		if (e != null)
		{
			var obj = cast(e, Enemy);
			if (obj != null && obj.dead == false)
			{
				obj.hurt(attack);
				_player.experience += obj.experience;
				return true;
			}
		}
		return false;
	}

	private var _player:Player;

}
