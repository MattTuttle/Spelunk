package entities.items;

import haxepunk.Sfx;
import entities.Player;

class Powerup extends Item
{

	public function new(x:Float, y:Float, name:String)
	{
		super(x, y);

		_powerupName = name;
		switch(_powerupName)
		{
			case "whip":		sprite.add("powerup", [0]);
			case "chainWhip":	sprite.add("powerup", [1]);
			case "boots":		sprite.add("powerup", [2]);
			case "knife":		sprite.add("powerup", [3]);
			case "goldKnife":	sprite.add("powerup", [4]);
			case "sword":		sprite.add("powerup", [5]);
			case "axe":			sprite.add("powerup", [6]);
			case "hook":		sprite.add("powerup", [7]);
			case "gun":			sprite.add("powerup", [8]);
			case "bullets":		sprite.add("powerup", [9]);
			case "lantern":		sprite.add("powerup", [10]);
			case "oil":			sprite.add("powerup", [11]);
			case "blueKey":		sprite.add("powerup", [47]);
			case "purpleKey":	sprite.add("powerup", [53]);
			case "redKey":		sprite.add("powerup", [59]);
			case "yellowKey":	sprite.add("powerup", [65]);
			case "greenKey":	sprite.add("powerup", [71]);
			case "orangeKey":	sprite.add("powerup", [77]);
		}
		sprite.play("powerup");
	}

	override public function apply(player:Player)
	{
		player.registerFlag(_powerupName);
		var sfx:Sfx = new Sfx("sfx/powerups/knife");
		sfx.play();
	}

	private var _powerupName:String;

}
