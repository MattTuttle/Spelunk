package entities;

import haxepunk.graphics.atlas.IAtlasRegion;
import haxepunk.Entity;
import haxepunk.assets.AssetCache;
import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import haxepunk.masks.Grid;
import haxepunk.math.Vector2;
import haxepunk.input.Key;
import haxepunk.HXP;
import haxepunk.graphics.tile.Tilemap;
import entities.enemies.boss.BossSlime;
import entities.enemies.Bat;
import entities.enemies.Slime;
import entities.enemies.Snake;
import entities.enemies.Spikes;
import entities.enemies.Zombie;
import entities.items.Coin;
import entities.items.Gem;
import entities.items.Orb;
import entities.items.Powerup;
import haxe.xml.Access;

class Room extends Entity
{

	public var exitBounds:Bounds;
	public var levelBounds:Bounds;
	public var mapID:String;
	public var tileWidth:Int;
	public var tileHeight:Int;

	public var start:Vector2;

	public function new(player:Player)
	{
		super(0, 0);

		_player = player;
		_tileset = AssetCache.global.getAtlasRegion("gfx/tilesets/cave.png");
		exitBounds = new Bounds();
		levelBounds = new Bounds();

		if (!backgrounds.exists("cave"))
		{
			backgrounds.set("cave", new Image("gfx/background/cave.png"));
			backgrounds.set("sky", new Image("gfx/background/mountains.png"));
		}

		layer = 500;
	}

	public function findExit(mapID:String)
	{
		var exit:Exit;
		for (exit in _exits)
		{
			if (mapID == exit.destination)
				return exit;
		}
		return null;
	}

	public function load(mapID:String)
	{
		var i:Int;
		var group:Access;
        var scene = scene.ensure();

		var ba:String = getRoom(mapID);
		if (ba == null)
			throw "Room id does not exist: " + mapID;
		_data = new Access(Xml.parse(ba));
		_data = _data.node.level;

		// BACKGROUND
		if (_data.has.background)
		{
			graphic = backgrounds.get(_data.att.background);
            graphic.may(g -> {
				g.scrollX = 0.2;
				g.scrollY = 0.15;
			});
		}

		// REMOVE OLD ENTITIES
		if (_entities != null)
			scene.removeList(_entities);
		_entities = new Array<Entity>();
		_exits = new Array<Exit>();

		// SET DIMENSIONS
		var mapWidth:Int = Std.parseInt(_data.node.width.innerData);
		var mapHeight:Int = Std.parseInt(_data.node.height.innerData);
		setHitbox(mapWidth, mapHeight);

		// TILEMAP
		if (_data.hasNode.background)
			loadTileLayer(_data.node.background, 500);
		if (_data.hasNode.main)
			loadTileLayer(_data.node.main, 450);
		if (_data.hasNode.foreground)
			loadTileLayer(_data.node.foreground, -50);

		if (_data.hasNode.collision)
			loadMask(_data.node.collision);

		// LADDER
		if (_data.hasNode.ladders)
			loadClimable(_data.node.ladders, "ladder");
		if (_data.hasNode.fence)
			loadClimable(_data.node.fence, "fence");

		// OBJECTS
		if (_data.hasNode.objects)
			loadObjects(_data.node.objects);

		// ADD TO SCENE
		scene.addList(_entities);

		// BOUNDS
		var hw:Int = Std.int(tileWidth / 2);
//		exitBounds.left = hw;
		exitBounds.right = mapWidth - hw;
		exitBounds.bottom = mapHeight - hw;
		levelBounds.right = mapWidth;
		levelBounds.bottom = mapHeight;
	}

	private function loadClimable(group:Access, graphicType:String)
	{
		for (obj in group.elements)
		{
			switch(obj.name)
			{
				case "rect":
					_entities.push(new Climbable(
						Std.parseFloat(obj.att.x),
						Std.parseFloat(obj.att.y),
						Std.parseInt(obj.att.w),
						Std.parseInt(obj.att.h),
						graphicType
				));
			}
		}
	}

	private function loadExit(x:Float, y:Float, obj:Access)
	{
		var exit:Exit = new Exit(x, y,
			Std.parseInt(obj.att.width),
			Std.parseInt(obj.att.height),
			obj.att.destination
		);
		_entities.push(exit);
		_exits.push(exit);
	}

	private function loadTileLayer(group:Access, layer:Int = 0)
	{
		tileWidth = Std.parseInt(group.att.tileWidth);
		tileHeight = Std.parseInt(group.att.tileHeight);
		var map:Tilemap = new Tilemap("gfx/tilesets/cave.png", width, height, tileWidth, tileHeight);

		for (obj in group.elements)
		{
			switch (obj.name)
			{
				case "tile":
					map.setTile(
						Std.int(Std.parseInt(obj.att.x) / map.tileWidth),
						Std.int(Std.parseInt(obj.att.y) / map.tileHeight),
						Std.parseInt(obj.att.id)
					);
				case "rect":
					map.setRect(
						Std.int(Std.parseInt(obj.att.x) / map.tileWidth),
						Std.int(Std.parseInt(obj.att.y) / map.tileHeight),
						Std.int(Std.parseInt(obj.att.w) / map.tileWidth),
						Std.int(Std.parseInt(obj.att.h) / map.tileHeight),
						Std.parseInt(obj.att.id)
					);
			}
		}

		var e:Entity = new Entity(0, 0, (map));
		e.layer = layer;
		_entities.push(e);
	}

	private function loadMask(group:Access)
	{
		var mask:Grid = new Grid(width, height, tileWidth, tileHeight);

		for (obj in group.elements)
		{
			switch (obj.name)
			{
				case "tile":
					mask.setTile(
						Std.int(Std.parseInt(obj.att.x) / mask.tileWidth),
						Std.int(Std.parseInt(obj.att.y) / mask.tileHeight),
						true
					);
				case "rect":
					mask.setRect(
						Std.int(Std.parseInt(obj.att.x) / mask.tileWidth),
						Std.int(Std.parseInt(obj.att.y) / mask.tileHeight),
						Std.int(Std.parseInt(obj.att.w) / mask.tileWidth),
						Std.int(Std.parseInt(obj.att.h) / mask.tileHeight),
						true
					);
			}
		}

		var e:Entity = new Entity(0, 0, null, mask);
		e.type = "solid";
		_entities.push(e);
	}

	private function loadObjects(group:Access)
	{
		var x:Float, y:Float;
		for (obj in group.elements)
		{
			x = Std.parseFloat(obj.att.x);
			y = Std.parseFloat(obj.att.y);
			switch (obj.name)
			{
				// ENEMIES
				case "purpleSlime":	_entities.push(new Slime(x, y, "purple"));
				case "greenSlime":	_entities.push(new Slime(x, y, "green"));
				case "blueSlime":	_entities.push(new Slime(x, y, "blue"));
				case "pinkSlime":	_entities.push(new Slime(x, y, "pink"));
				case "greenSnake":	_entities.push(new Snake(x, y, "green"));
				case "blackSnake":	_entities.push(new Snake(x, y, "black"));
				case "brownSnake":	_entities.push(new Snake(x, y, "brown"));
				case "yellowSnake":	_entities.push(new Snake(x, y, "yellow"));
				case "bat":			_entities.push(new Bat(x, y, _player));
				case "zombie":		_entities.push(new Zombie(x, y, _player));
				case "slimeBoss":	_entities.push(new BossSlime(x, y));
				case "spikes":		_entities.push(new Spikes(x, y));

				// PLAYER
				case "player":		start = new Vector2(); start.x = x; start.y = y;
				case "savePoint":	_entities.push(new SavePoint(x, y));
				case "exit":		loadExit(x, y, obj);

				// ORBS
				case "blueOrb":		_entities.push(new Orb(x, y, "blue"));
				case "purpleOrb":	_entities.push(new Orb(x, y, "purple"));
				case "redOrb":		_entities.push(new Orb(x, y, "red"));
				case "yellowOrb":	_entities.push(new Orb(x, y, "yellow"));
				case "greenOrb":	_entities.push(new Orb(x, y, "green"));
				case "orangeOrb":	_entities.push(new Orb(x, y, "orange"));

				// GEMS
//				case "blueGem":		_entities.push(new Gem(x, y, "blue"));
//				case "purpleGem":	_entities.push(new Gem(x, y, "purple"));
//				case "redGem":		_entities.push(new Gem(x, y, "red"));
//				case "yellowGem":	_entities.push(new Gem(x, y, "yellow"));
//				case "greenGem":	_entities.push(new Gem(x, y, "green"));
//				case "orangeGem":	_entities.push(new Gem(x, y, "orange"));

				// ITEMS
				default:
					// only show powerups we don't have
					if (!_player.hasFlag(obj.name))
					{
						_entities.push(new Powerup(x, y, obj.name));
					}
			}
		}
	}

	private function getRoom(id:String):String
	{
		mapID = id;
		return AssetCache.global.getText("levels/" + id + ".oel");
	}

	private var _data:Access;
	private var _tileset:IAtlasRegion;
	private var _player:Player;
	private var _entities:Array<Entity>;
	private var _exits:Array<Exit>;

	private static var backgrounds:Map<String,Image> = new Map<String,Image>();

}
