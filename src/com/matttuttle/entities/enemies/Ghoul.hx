package com.matttuttle.entities.enemies;

import com.haxepunk.graphics.Spritemap;

class Ghoul extends Enemy
{
	
	public var sprite:Spritemap;

	public function new(x:Float, y:Float) 
	{
		super(x, y, 10);
		sprite = new Spritemap(gfx.enemies.Ghosts, 8, 8, onSpriteEnd);
		sprite.add("idle", [4, 5]);
		sprite.play("idle");
		graphic = sprite;
	}
	
	public function onSpriteEnd()
	{
		
	}
	
}