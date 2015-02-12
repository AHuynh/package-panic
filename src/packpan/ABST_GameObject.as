package packpan 
{
	import cobaltric.ContainerGame;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * An abstract class containing functionality useful to all game objects.
	 * Extended by ABST_Mail and ABST_Node
	 * @author 	Alexander Huynh
	 */
	public class ABST_GameObject 
	{
		/// A reference to the active instance of ContainerGame.
		protected var cg:ContainerGame;

		/// Maps a String key to a property. See comments in ABST_GameObject for a list of valid keys.
		public var properties:Object;
		/*	Valid key list
		 * 
		 * 	Keys are always a String.
		 * 	If (+) is in valid?, this key is implemented in the game. Otherwise (-), it is not.
		 * 
		 * 	key			valid?	type		representation
		 * 	------------------------------------------------------------------------------------------
		 * 	color		+		uint		a hex color, 0xFFFFFF if not colored
		 * 	fireproof	-		boolean		true if affected by fire
		 * 	magnetic	-		int			1 if attractive, -1 if repulsive, 0 if not magnetic
		 */
		
		/// The grid square of this Node. (0-indexed, origin top-left, L/R is x, U/D is y)
		public var position:Point;
		/// The rotation of this Node, a PP.DIR_X constant. (Ex: PP.DIR_LEFT)
		public var facing:int = PP.DIR_NONE;
		
		/// The 'JSON' object passed into this GameObject.
		protected var json:Object;

		/**
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 * @param	_position	The grid coordinate of this object.
		 * @param	_json		Object created by parsing JSON.
		 */
		public function ABST_GameObject(_cg:ContainerGame, _json:Object) 
		{
			cg = _cg;
			json = _json;
			
			properties = new Object();
			
			///////////////////////////////////////////////////////////////////////////////////////
			//	now parse the "JSON" object for common properties all game objects could have
			///////////////////////////////////////////////////////////////////////////////////////
			
			trace(json);
			
			// grid position, guaranteed to exist
			position = new Point(json["x"], json["y"]);
		}
		
		/**
		 * Returns a random Number between min and max, inclusive.
		 * @param	min		The lower bound
		 * @param	max		The upper bound
		 * @return			A random Number between min and max
		 */
		public static function getRand(min:Number, max:Number):Number   
		{  
			return Math.random() * (max - min + 1) + min;  
		}
	}

}