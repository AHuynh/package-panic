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
	import packpan.mails.ABST_Mail;

	public class PhysicsUtils
	{
		/**
		 *	Computes a linear damping force.
		 *	@param	strength	the strength of the damping (1~10)
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
		 *	Computes an inverse power law force
		 *	@param	strength	the coefficient of the power law
		 *	@param	state	the physics state of the object being restored
		 *	@param	origin	the origin of the attractor
		 *	@param	power	the power (positive for decreasing with distance)
		 *	@returns	the power law force
		 */
		public static function inversePower(strength:Number, state:PhysicalEntity, origin:Point, pow:Number):Point
		{
			var diff:Point = origin.subtract(state.position);
			var length:Number = diff.length;
			diff.normalize(1); //set the lenth to 1 to use as direction
			if(length < 0.1) return new Point(0.0,0.0); //prevent huge forces near origin
			return new Point(
				strength*diff.x/Math.pow(length,pow),
				strength*diff.y/Math.pow(length,pow)
			);
		}

		/**
		 *	Reduces a list of mail objects to those with their center in a rectangular region.
		 *	@param	mails	an array of mail objects to cull from
		 *	@param	upperleft	the upper left corner of the rectangle
		 *	@param	lowerright	the lower right corner of the rectangle
		 *	@returns	an array of mail objects that are within the culling region
		 */
		public static function cullRectangle(mails:Array, upperleft:Point, lowerright:Point):Array
		{
			var result:Array = [];
			for each(var mail:ABST_Mail in mails)
			{
				if(upperleft.x <= mail.state.position.x &&
				   mail.state.position.x < lowerright.x &&
				   upperleft.y <= mail.state.position.y &&
				   mail.state.position.y < lowerright.y)
				{
					result[result.length] = mail;
				}
			}
			return result;
		}

		/**
		 *	Reduces a list of mail objects to those with their center in a rectangular region.
		 *	@param	mails	an array of mail objects to cull from
		 *	@param	center	the center of the circle
		 *	@param	radius	the radius of the circle
		 *	@returns	an array of mail objects that are within the culling region
		 */
		public static function cullCircle(mails:Array, center:Point, radius:Number):Array
		{
			var result:Array = [];
			for each(var mail:ABST_Mail in mails)
			{
				if(mail.state.position.subtract(center).length <= radius)
				{
						result[result.length] = mail;
				}
			}
			return result;
		}

		/**
		 *  Converts a position from the grid frame to the screen frame.
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
			trace("WARNING: DO NOT INSTANTIATE PhysicsUtils!");
		}
	}
}
