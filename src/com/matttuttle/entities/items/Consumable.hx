package com.matttuttle.entities.items;

import com.matttuttle.entities.Player;

class Consumable extends Item
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		foodValue = Math.floor(Math.random() * kMaxFoodTypes);
		
		sprite.add("food", [12 + foodValue]);
		sprite.play("food");
	}
	
	public override function apply(player:Player)
	{
		player.hurt( -foodValue - 1);
	}
	
	private var foodValue:Int;
	private static inline var kMaxFoodTypes:Int = 6;
	
}