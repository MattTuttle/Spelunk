package com.matttuttle.entities.enemies;

import com.haxepunk.graphics.Spritemap;

class Rat extends Enemy
{
	
	public var sprite:Spritemap;

	public function new(x:Float, y:Float) 
	{
		super(x, y, 10);
		sprite = new Spritemap(gfx.enemies.Rat, 8, 8, onSpriteEnd);
		sprite.add("idle", [0]);
		sprite.play("idle");
		graphic = sprite;
	}
	
	public function onSpriteEnd()
	{
		
	}
	
}