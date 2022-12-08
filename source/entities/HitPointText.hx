package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import haxepunk.math.Rectangle;
import haxepunk.math.Vector2;

class HitPointText extends Entity
{

	private var dead:Bool;

	public function new(x:Float, y:Float, damage:Int)
	{
		var text:String;
		var textY:Int;

		super(x, y);
		text = Std.string(damage);
		if (damage >= 0)
		{
			text = "-" + text;
			textY = 0;
		}
		else
		{
			textY = 5;
		}

        // TODO: fix hit point creation
#if false
		var fontSet:BitmapData = HXP.getBitmap("gfx/gui/hit_points.png");
		var tmp:BitmapData = HXP.createBitmap(text.length * 5, 5, true, 0xf);

		var grabData:Array<Rectangle> = new Array<Rectangle>();
		var chars:String = "-0123456789";
		var c:Int;
		for (c in 0...chars.length)
			grabData[chars.charCodeAt(c)] = new Rectangle(c * 4, textY, 4, 5);

		for (c in 0...text.length)
		{
			//	If it's a space then there is no point copying, so leave a blank space
			if (text.charAt(c) != " ")
			{
				//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
				if (grabData[text.charCodeAt(c)] != null)
				{
					tmp.copyPixels(fontSet, grabData[text.charCodeAt(c)], new Vector2(c * 5, 0));
				}
			}
		}

		graphic = _image = new Image(tmp);
#else
		graphic = _image = new Image("gfx/gui/hit_points.png");
#end
		_timer = kLife;
	}

	public override function update()
	{
		if (dead)
		{
            removeFromScene();
			return;
		}

		y -= 2;
		_timer -= HXP.elapsed;
		_image.alpha = _timer / kLife;
		if (_timer < 0)
			dead = true;

		super.update();
	}

	private var _image:Image;
	private var _timer:Float;
	private static inline var kLife:Float = 0.6;

}
