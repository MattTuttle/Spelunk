package entities.weapons.projectile;

import haxepunk.math.Vector2;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
import haxepunk.Sfx;

class Knife extends Weapon
{

	public var sprite:Spritemap;

	public function new(x:Float, y:Float, vel:Vector2, offset:Int)
	{
		super("Knife");
		this.x = x;
		this.y = y;

		sfx = new Map<String,Sfx>();
		sfx.set("throw", new Sfx("sfx/knife/throw"));
		sfx.set("hit", new Sfx("sfx/knife/knife_hit"));
		sfx.set("thud", new Sfx("sfx/knife/thud"));
		sfx.get("throw").play();

		sprite = new Spritemap("gfx/items/knife.png", 5, 5);
		sprite.add("up", [offset + 0]);
		sprite.add("right", [offset + 1]);
		sprite.add("down", [offset + 2]);
		sprite.add("left", [offset + 3]);
		sprite.add("spin", [offset + 0, offset + 1, offset + 2, offset + 3], 12);
		graphic = sprite;

		velocity = vel;
		if(velocity.y < 0)
			sprite.play("up");
		else if(velocity.y > 0)
			sprite.play("down");
		else if(velocity.x < 0)
			sprite.play("left");
		else if(velocity.x > 0)
			sprite.play("right");

		acceleration.y = 100;
		setHitbox(5, 3);
	}

	private function createEmitter()
	{
		removeFromScene();
	}

	override public function hitLeft() { hitWall("hit"); }
	override public function hitRight() { hitWall("hit"); }
	override public function hitBottom() { hitWall("thud"); createEmitter(); }
	override public function hitTop() { hitWall("hit"); }

	public function hitWall(sound:String)
	{
		sfx.get(sound).play();
		sprite.play("spin");
	}

	public override function update()
	{
		if (hitEnemy())
		{
			removeFromScene();
		}

		super.update();

		// CHECK BOUNDS
		var dx:Float = x - HXP.camera.x;
		var dy:Float = y - HXP.camera.y;
		if (dx < -10 || dx > HXP.screen.width + 10 ||
			dy < -10 || dy > HXP.screen.height + 10)
		{
			if (scene != null)
				removeFromScene();
		}
	}

	private var sfx:Map<String,Sfx>;

}
