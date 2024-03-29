package entities;

import haxepunk.math.MathUtil;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.math.Vector2;

enum Direction
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
}

class Physics extends Entity
{

	public var velocity:Vector2;
	public var acceleration:Vector2;
	public var drag:Vector2;
	public var maxVelocity:Vector2;

	public var facing:Direction;

	public var onGround:Bool;
	public var onWall:Bool;

	private static inline var solid:String = "solid";

	public function new(x:Float, y:Float)
	{
		super(x, y);

		velocity = new Vector2();
		acceleration = new Vector2();
		drag = new Vector2();
		maxVelocity = new Vector2(10000, 10000);

		facing = RIGHT;
	}

	public function hitLeft() { }
	public function hitRight() { }
	public function hitTop() { }
	public function hitBottom() { }

	public override function update()
	{
		var vc:Float;
		var i:Int;

		onWall = false;
		onGround = false;

		vc = (compute(velocity.x, acceleration.x, drag.x, maxVelocity.x) - velocity.x) / 2;
		velocity.x += vc;
		var xd:Float = velocity.x * HXP.elapsed;
		velocity.x += vc;

		vc = (compute(velocity.y, acceleration.y, drag.y, maxVelocity.y) - velocity.y) / 2;
		velocity.y += vc;
		var yd:Float = velocity.y * HXP.elapsed;
		velocity.y += vc;

		i = 0;
		if (xd != 0)
		do
		{
			if (collide("solid", x + MathUtil.sign(xd), y) != null)
			{
				onWall = true;
				velocity.x = 0;
				if (xd < 0)
				{
					hitLeft();
				}
				else
				{
					hitRight();
				}
				break;
			}
			else
			{
				x += MathUtil.sign(xd);
			}
			i += 1;
		} while (i < Math.abs(xd));

		i = 0;
		if (yd != 0)
		do
		{
			if (collide("solid", x, y + MathUtil.sign(yd)) != null)
			{
				velocity.y = 0;
				if (yd > 0)
				{
					hitBottom();
					onGround = true;
				}
				else
				{
					hitTop();
				}
				break;
			}
			else if (yd > 0 && collide("ledge", x, y + MathUtil.sign(yd)) != null)
			{
				velocity.y = 0;
				hitBottom();
				onGround = true;
			}
			else
			{
				y += MathUtil.sign(yd);
			}
			i += 1;
		} while (i < Math.abs(yd));

		super.update();
	}

	public function compute(Velocity:Float, Acceleration:Float = 0, Drag:Float = 0, Max:Float = 10000):Float
	{
		if (Acceleration != 0)
			Velocity += Acceleration * HXP.elapsed;
		else if (Drag != 0)
		{
			var d:Float = Drag * HXP.elapsed;
			if(Velocity - d > 0)
				Velocity = Velocity - d;
			else if(Velocity + d < 0)
				Velocity += d;
			else
				Velocity = 0;
		}
		if ((Velocity != 0) && (Max != 10000))
		{
			if(Velocity > Max)
				Velocity = Max;
			else if(Velocity < -Max)
				Velocity = -Max;
		}
		return Velocity;
	}

}
