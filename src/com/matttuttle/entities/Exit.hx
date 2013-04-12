package com.matttuttle.entities;

import com.haxepunk.Entity;

class Exit extends Entity
{

	public var destination:String;

	public function new(x:Float, y:Float, width:Int, height:Int, mapID:String)
	{
		super(x, y);
		setHitbox(width, height);
		type = "exit";

		destination = mapID;
	}

}