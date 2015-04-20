package packpan 
{
	/**
	 * PackagePanic static helper.
	 * Contains global consants.
	 * 
	 * @author Alexander Huynh
	 */

	import flash.geom.Point;

	public class PP 
	{
		public static const GRID_ORIGIN:Point = new Point(-350, -260);		// actual x, y coordinate of upper-left grid
		public static const GRID_SIZE:int = 50;								// grid square size

		public static const DIM_X_MAX:int = 14;			// max x (L/R) index of grid
		public static const DIM_Y_MAX:int = 9;			// max y (U/D) index of grid
		
		public static const DIM_LEVEL_MAX:int = 14;		// max index on level page
		
		public static const MAIL_IDLE:int = 20;			// arbitary constants
		public static const MAIL_SUCCESS:int = 21;
		public static const MAIL_FAILURE:int = 22;
		
		public static const GAME_IDLE:int = 10;			// arbitary constants
		public static const GAME_SUCCESS:int = 11;
		public static const GAME_FAILURE:int = 12;
		public static const GAME_SETUP:int = 15;
		
		public static const DIR_NONE:int = -1;			// directions in degrees
		public static const DIR_LEFT:int = 180;
		public static const DIR_UP:int = 270;
		public static const DIR_RIGHT:int = 0;
		public static const DIR_DOWN:int = 90;

		//color constants for matching objects. based on http://en.wikipedia.org/wiki/Web_colors#HTML_color_names
		public static const COLORS:Array = [
			0x000000,	//black		00
			0x000080,	//navy		01
			0x008000,	//green		02
			0x008080,	//cyan		03
			0xFFA500,	//orange	04
			0x800080,	//purple	05
			0x808000,	//olive		06
			0xC0C0C0,	//silver	07
			0x808080,	//gray		08
			0x0000FF,	//blue		09
			0x00FF00,	//lime		10
			0x00FFFF,	//aqua		11
			0xFF0000,	//red		12
			0xFF00FF,	//fuchsia	13
			0xFFFF00,	//yellow	14
			0xFFFFFF	//white		15
		];
		
		public function PP() 
		{
			// -- Static class; do not instantiate
			trace("WARNING: DO NOT INSTANTIATE PP!");
		}
	}
}
