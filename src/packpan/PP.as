package packpan 
{
	/**
	 * PackagePanic static helper
	 * 
	 * Contains global consants
	 * 
	 * @author Alexander Huynh
	 */

	import flash.geom.Point;

	public class PP 
	{
		public static const GRID_ORIGIN:Point = new Point(-350, -260);		// actual x, y coordinate of upper-left grid
		public static const GRID_SIZE:int = 50;								// grid square size

		public static const DIM_X_MAX:int = 14;			// max x (U/D) index of grid
		public static const DIM_Y_MAX:int = 9;			// max y (L/R) index of grid
		
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
		
		public static const NODE_CONV_NORMAL:String = "packpan.nodes.NodeConveyorNormal";
		public static const NODE_CONV_ROTATE:String = "packpan.nodes.NodeConveyorRotate";
		public static const NODE_AIRTABLE:String = "packpan.nodes.NodeAirTable";
		public static const NODE_BIN_NORMAL:String = "packpan.nodes.NodeBin";
		
		public static const COLOR_NONE:uint = 0xFFFFFF;
		
		// arbitary non-negative integer constants for indexing into GameObject.properties
		public static const PROP_COLOR:int = 0;
		
		public function PP() 
		{
			// -- Static class; do not instantiate
			trace("WARNING: DO NOT INSTANTIATE PP!");
		}
	}
}
