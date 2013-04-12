import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		HXP.screen.scale = 3;
		HXP.scene = new com.matttuttle.scenes.Game();
	}

	public static function main()
	{
		new Main();
	}

}