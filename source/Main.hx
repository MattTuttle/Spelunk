import haxepunk.screen.UniformScaleMode;
import haxepunk.Engine;
import haxepunk.HXP;

class Main extends Engine
{

    @:preload("assets/graphics","gfx")
    @:preload("assets/audio","sfx")
    @:preload("assets/font" ,"font")
    @:preload("assets/levels" ,"levels")
	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		HXP.screen.scaleMode = new UniformScaleMode();
		HXP.scene = new scenes.Game();
	}

	public static function main() new Main(210, 120);

}
