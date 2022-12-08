package entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Spritemap;
import haxepunk.Sfx;
import haxepunk.input.Input;
import haxepunk.input.Key;
import entities.items.Item;
import entities.enemies.Enemy;
import entities.Physics;
import entities.weapons.Axe;
import entities.weapons.Knives;
import entities.weapons.Sword;
import entities.weapons.Weapon;
import entities.weapons.Whip;

class Player extends Character
{

	public var sprite:Spritemap;
	public var flags:Array<String>;

	public var climbing:Bool;
	public var crouching:Bool;
	public var onLadder:Bool;
	public var disableControls:Bool;

	public var maxJumps:Int;

	public function new(gfx:String, x:Int = 0, y:Int = 0)
	{
		super(x, y);

		sfx = new Map<String,Sfx>();
		sfx.set("jump", new Sfx(#if flash "sfx/player/jump.mp3" #else "sfx/player/jump.wav" #end));
		sfx.set("levelUp", new Sfx(#if flash "sfx/player/level_up.mp3" #else "sfx/player/level_up.wav" #end));
		sfx.set("death", new Sfx(#if flash "sfx/player/death.mp3" #else "sfx/player/death.wav" #end));
		sfx.set("hurt", new Sfx(#if flash "sfx/hurt.mp3" #else "sfx/hurt.wav" #end));

		flags = new Array<String>();
		_weapons = new Array<Weapon>();
		_weaponIndex = 0;

		sprite = new Spritemap(gfx, 8, 8);
		sprite.add("idle", [0]);
		sprite.add("idle_up", [17]);
		sprite.add("jump", [1]);
		sprite.add("fall", [2]);
		sprite.add("crouch", [3]);
		sprite.add("walk", [4, 5, 6, 5], 10);
		sprite.add("walk_up", [19, 20, 21, 20], 10);
		// Weapon animations
		sprite.add("knife", [16]);
		sprite.add("axe", [22, 17, 23, 24], 10, false);
		sprite.add("whip", [22, 17, 23, 6], 8, false);
		sprite.add("sword", [25, 0, 5, 6], 10, false);
		sprite.add("flip", [9, 10, 11, 12, 13, 14, 3], 8, false);

		sprite.add("climb", [7, 8], 12);
		sprite.add("climb_idle", [7]);

		graphic = sprite;

		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed;
		drag.x = kMoveSpeed * 3; // floor friction
		//drag.y = 0.02; // wall friction

		Input.define("left", [Key.LEFT]);
		Input.define("right", [Key.RIGHT]);
		Input.define("up", [Key.UP]);
		Input.define("down", [Key.DOWN]);
		Input.define("jump", [Key.X]);
		Input.define("switch", [Key.SPACE]);
		Input.define("attack", [Key.C]);

		type = "player";
		setHitbox(3, 8, -2);
		maxJumps = 1;
	}

	public var weapon(get, null):Weapon;
	private function get_weapon():Weapon { return _weapons[_weaponIndex]; }

	public function addWeapon(newWeapon:Weapon)
	{
		_weapons.push(newWeapon);
		switchWeapon(_weapons.length - 1);
	}

	public override function added()
	{
		//addWeapon(new Whip("whip"));
	}

	private function switchWeapon(?id:Int)
	{
		// Remove the old weapon
		if (weapon != null)
			weapon.removeFromScene();

		// Increment and wrap if needed
		if (id == null)
			_weaponIndex += 1;
		else
			_weaponIndex = id;

		if (_weaponIndex >= _weapons.length)
			_weaponIndex = 0;

		if (weapon != null)
			scene.may(s -> s.add(weapon));
	}

	public function hasFlag(flag:Dynamic):Bool
	{
		if (Std.is(flag, String))
		{
			for (name in flags)
			{
				if (name == flag)
					return true;
			}
		}
		else if (Std.is(flag, Array))
		{
			var array:Array<String> = flag;
			for (name in flags)
			{
				for (obj in array)
				{
					if (name == obj)
						return true;
				}
			}
		}
		return false;
	}

	public function registerFlag(flag:String)
	{
		flags.push(flag);
		switch (flag)
		{
			case "whip":
				addWeapon(new Whip(flag));
			case "chainWhip":
				addWeapon(new Whip(flag));
			case "sword":
				addWeapon(new Sword(flag));
			case "goldSword":
				addWeapon(new Sword(flag));
			case "knife":
				addWeapon(new Knives(flag));
			case "goldKnife":
				addWeapon(new Knives(flag));
			case "axe":
				addWeapon(new Axe());
			case "boots":
				maxJumps += 1;
		}
	}

	public override function kill()
	{
		if (dead) return;
		super.kill();
		sfx.get("death").play();
	}

	public override function update()
	{
		if (dead || disableControls) return;

		acceleration.x = 0;

		if (Input.check("left"))
		{
			facing = LEFT;
			acceleration.x = -drag.x;
		}

		if (Input.check("right"))
		{
			facing = RIGHT;
			acceleration.x = drag.x;
		}

		_up = false;
		if (Input.check("up"))
		{
			_up = true;
			climbing = true;
		}

		_down = false;
		if (Input.check("down"))
		{
			if (velocity.y != 0)
				_down = true;
			climbing = true;
		}

		if (Input.pressed("switch"))
		{
			switchWeapon();
		}

		checkCollisions();

		if (onLadder && climbing)
		{
			acceleration.y = 0;

			if (_up)
				velocity.y = -kLadderSpeed;
			else if (Input.check("down"))
				velocity.y = kLadderSpeed;
			else
				velocity.y = 0;
		}
		else
		{
			acceleration.y = kGravityAcceleration;
		}

		if (onGround)
		{
			_jumps = 0;

			if (Input.check("down"))
				crouching = true;
			else
				crouching = false;
		}

		// JUMP
		if (Input.pressed("jump"))
		{
			if (onWall && !onGround && hasFlag("oil"))
			{
				if (collide("solid", x - 1, y) != null)
					velocity.x = kJumpForce * 2;
				else if (collide("solid", x + 1, y) != null)
					velocity.x = -kJumpForce * 2;

				velocity.y = -kJumpForce;
				_jumps = maxJumps;
				sfx.get("jump").play();
			}
			else if (_jumps < maxJumps && (onGround || _jumps > 0 || onLadder))
			{
				velocity.y = -kJumpForce;
				_jumps += 1;
				climbing = false;
				sfx.get("jump").play();
			}
		}

		// ATTACK
		if (Input.pressed("attack") && !flickering)
		{
			doAttack();
		}

		setAnimation();

		if (!onLadder) climbing = false;
		onLadder = false;

		super.update();
		if (weapon != null) weapon.reposition();
	}

	private function doAttack()
	{
		if (weapon == null) return;

		if (_up)
			weapon.use(UP);
		else if (_down)
			weapon.use(DOWN);
		else
			weapon.use(facing);
	}

	private function checkCollisions()
	{
		// OUCH!
		var e = collide("enemy", x, y);
		if (e != null)
		{
			var enemy = cast(e, Enemy);
			if (!flickering && enemy != null)
			{
				sfx.get("hurt").play();
				hurt(enemy.damage);
				flicker(1);
			}
		}

		// ARE WE ON A LADDER?
		if (collide("ladder", x, y) != null ||
			(hasFlag("gloves") && collide("fence", x, y) != null))
		{
			onLadder = true;
		}

		// PICK UP ITEMS
		var e = collide("item", x, y);
		if (e != null)
		{
			var item = cast(e, Item);
			if (item != null)
			{
				item.apply(this);
				// player.updateStats();
                item.removeFromScene();
			}
		}
	}

	private function setAnimation()
	{
		if (facing == LEFT)
			sprite.flipped = true;
		else
			sprite.flipped = false;


		if (weapon != null && weapon.isUsing)
		{
		}
		else if (onLadder && climbing)
		{
			if (velocity.x != 0 || velocity.y != 0)
				sprite.play("climb");
			else
				sprite.play("climb_idle");
		}
		else if (crouching && velocity.x == 0)
		{
			sprite.play("crouch");
		}
		else if(velocity.y < 0)
		{
			sprite.play("jump");
		}
		else if (velocity.y > 0)
		{
			sprite.play("fall");
		}
		else if(velocity.x == 0)
		{
			if (_up) sprite.play("idle_up");
			else sprite.play("idle");
		}
		else
		{
			if (_up) sprite.play("walk_up");
			else sprite.play("walk");
		}
	}

	private var _jumps:Int;
	private var _up:Bool;
	private var _down:Bool;
	private var _weapons:Array<Weapon>;
	private var _weaponIndex:Int;

	private var sfx:Map<String,Sfx>;

	private static inline var kMoveSpeed:Float = 60;
	private static inline var kJumpForce:Float = 110;
	private static inline var kLadderSpeed:Float = 60;
	private static inline var kGravityAcceleration:Float = 420;

}
