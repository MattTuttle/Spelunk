package com.matttuttle.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledImage;
import flash.geom.Rectangle;

class Climbable extends Entity
{

	public function new(x:Float, y:Float, width:Int, height:Int, graphicType:String)
	{
		var clipRect:Rectangle = new Rectangle(0, 0, 8, 8);
		switch(graphicType)
		{
			case "ladder":
				clipRect.x = 0;
			case "fence":
				clipRect.x = 8;
			case "grate":
				clipRect.x = 16;
		}
		super(x, y, new TiledImage("gfx/tilesets/climbable.png", width, height, clipRect));
		setHitbox(width, height);
		type = "ladder";
		layer = 150;
	}

}