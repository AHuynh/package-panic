package packpan 
{
	/**
	 * PackagePanic static physics helper
	 * 
	 * Contains useful physics functions.
	 * 
	 * @author Jay Fisher
	 */

	import flash.geom.Point;

	public class PhysicsUtils
	{
		/**
		 *	Computes a linear damping force.
		 *	@param	strength	the strength of the damping
		 *	@param	state	the physics entity of the object being damped
		 *	@param	velocityRelative	the velocity of the space, e.g, the underlying conveyor
		 *	@returns	the damping force
		 */
		public static function linearDamping(strength:Number, state:PhysicalEntity, velocityRelative:Point):Point
		{
			return new Point(
				strength*(velocityRelative.x-state.velocity.x),
				strength*(velocityRelative.y-state.velocity.y)
			);
		}

		/**
		 *	Computes a spring force that seeks to restore the x coordinate
		 *	@param	strength	the strength of the "spring"
		 *	@param	state	the physics entity of the object being restored
		 *	@param	x	the x coordinate to restore towards
		 *	@returns	the spring force
		 */
		public static function linearRestoreX(strength:Number, state:PhysicalEntity, x:Number):Point
		{
			return new Point(
				strength*(x-state.position.x),
				0
			);
		}

		/**
		 *	Computes a spring force that seeks to restore the y coordinate
		 *	@param	strength	the strength of the "spring"
		 *	@param	state	the physics state of the object being restored
		 *	@param	y	the y coordinate to restore towards
		 *	@returns	the spring force
		 */
		public static function linearRestoreY(strength:Number, state:PhysicalEntity, y:Number):Point
		{
			return new Point(
				0,
				strength*(y-state.position.y)
			);
		}

		/**
		 *      Converts a position from the grid frame to the screen frame.
		 *	@param	position	a point in the grid frame
		 *	@returns	that point in the screen frame
		 */
		public static function gridToScreen(position:Point):Point
		{
			var result:Point = new Point();
			result.x = PP.GRID_ORIGIN.x + PP.GRID_SIZE*position.x;
			result.y = PP.GRID_ORIGIN.y + PP.GRID_SIZE*position.y;
			return result;
		}

		/**
		 *	Converts a position from the screen frame to the grid frame.
		 *	@param	position	a point in the screen frame
		 *	@returns	that point in the grid frame
		 */
		public static function screenToGrid(position:Point):Point
		{
			var result:Point = new Point();
			result.x = (position.x-PP.GRID_ORIGIN.x)/PP.GRID_SIZE;
			result.y = (position.y-PP.GRID_ORIGIN.y)/PP.GRID_SIZE;
			return result;
		}

		public function PhysicsUtils() 
		{
			// -- Static class; do not instantiate
			trace("WARNING: DO NOT INSTANTIATE PP!");
		}
	}
}
