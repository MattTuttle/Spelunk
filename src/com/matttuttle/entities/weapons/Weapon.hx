package com.matttuttle.entities.weapons;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.matttuttle.scenes.Game;
import com.matttuttle.entities.Physics;
import com.matttuttle.entities.enemies.Enemy;
import com.matttuttle.entities.Player;

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

	public var isUsing(getUsing, null):Bool;
	private function getUsing():Bool { return false; }

	public function use(direction:Direction) { }

	public function reposition()
	{
		x = _player.x;
		y = _player.y;
	}

	private function hitEnemy():Bool
	{

		var obj:Enemy = cast(collide("enemy", x, y), Enemy);
		if (obj != null && obj.dead == false)
		{
			obj.hurt(attack);
			_player.experience += obj.experience;
			return true;
		}
		return false;
	}

	private var _player:Player;

}