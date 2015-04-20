package packpan 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * An abstract class containing functionality useful to all game objects.
	 * Extended by ABST_Mail and ABST_Node.
	 * @author 	Alexander Huynh
	 */
	public class ABST_GameObject 
	{
		/// A reference to the active instance of ContainerGame.
		protected var cg:ContainerGame;
		
		/// The MovieClip associated with this object. (The actual graphic on the stage.)
		public var mc_object:MovieClip;
		
		/// The grid square of this Node. (0-indexed, origin top-left, L/R is x, U/D is y)
		public var position:Point;
		/// The rotation of this Node, a PP.DIR_X constant. (Ex: PP.DIR_LEFT)
		public var facing:int = PP.DIR_NONE;
		
		/// The 'JSON' object passed into this GameObject See comments in ABST_GameObject for more details.
		protected var json:Object;
		/*	Expected values of JSON list
		 * 
		 * 	"x"			REQUIRED	int		The x, or left-right, grid coordinate.
		 * 	"y"			REQUIRED	int		The y, or up-down, grid coordinate.
		 */

		/**
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 * @param	_position	The grid coordinate of this object.
		 * @param	_json		Object created by parsing JSON.
		 * @param	_bitmap		Optional: A Bitmap to use for graphics.
		 */
		public function ABST_GameObject(_cg:ContainerGame, _json:Object, _bitmap:Bitmap = null) 
		{
			cg = _cg;
			json = _json;
			
			///////////////////////////////////////////////////////////////////////////////////////
			//	now parse the "JSON" object for common properties all game objects could have
			///////////////////////////////////////////////////////////////////////////////////////
						
			// grid position, guaranteed to exist
			position = new Point(json["x"], json["y"]);
			
			// error check
			if (position.x < 0 || position.x > PP.DIM_X_MAX)
				trace("ERROR: in " + this + ", x = " + position.x + " is out of bounds!");
			if (position.y < 0 || position.y > PP.DIM_Y_MAX)
				trace("ERROR: in " + this + ", y = " + position.y + " is out of bounds!");
			
			///////////////////////////////////////////////////////////////////////////////////////
			//	handle imported image, if applicable
			///////////////////////////////////////////////////////////////////////////////////////
			
			if (_bitmap)
				addImage(_bitmap);
		}
		
		/**
		 * Use an image from the img folder instead of one from the SWC.
		 * @param	img		The Bitmap to display for this object.
		 */
		protected function addImage(img:Bitmap):void
		{
			mc_object.gotoAndStop("none");		// switch to the empty SWC sprite
			mc_object.addChild(img);			// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;
		}
		
		/**
		 * Returns a random Number between min and max, inclusive.
		 * @param	min		The lower bound
		 * @param	max		The upper bound
		 * @return			A random Number between min and max
		 */
		public function getRand(min:Number, max:Number):Number   
		{  
			return Math.random() * (max - min + 1) + min;  
		}
	}

}
