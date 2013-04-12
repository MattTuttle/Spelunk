package com.matttuttle;

import flash.geom.Point;
import com.haxepunk.HXP;

enum Collision
{
	NONE;
	LEFT;
	RIGHT;
	TOP;
	BOTTOM;
}

class Bounds 
{
	
	public var left:Int;
	public var right:Int;
	public var top:Int;
	public var bottom:Int;
	
	public function new (l:Int = 0, r:Int = 0, t:Int = 0, b:Int = 0)
	{
		left = l;
		right = r;
		top = t;
		bottom = b;
	}
	
	public function toString():String
	{
		return "[" + left + ", " + right + ", " + top + ", " + bottom + "]";
	}
	
	public function camera()
	{
		if (HXP.camera.x < left)
			HXP.camera.x = left;
		else if (HXP.camera.x > right - HXP.screen.width)
			HXP.camera.x = right - HXP.screen.width;
		
		if (HXP.camera.y < top)
			HXP.camera.y = top;
		else if (HXP.camera.y > bottom - HXP.screen.height)
			HXP.camera.y = bottom - HXP.screen.height;
	}
	
	public function clamp(p:Point)
	{
		if (p.x <= left)
			p.x = left;
		else if (p.x >= right)
			p.x = right;
		
		if (p.y <= top)
			p.y = top;
		else if (p.y >= bottom)
			p.y = bottom;
	}
	
	public function check(px:Float, py:Float):Collision
	{
		if (px <= left)
			return LEFT;
		else if (px >= right)
			return RIGHT;
		
		if (py <= top)
			return TOP;
		else if (py >= bottom)
			return BOTTOM;
		
		return NONE;
	}
	
}