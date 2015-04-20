package packpan
{
	import flash.geom.Point;

	/**
	 * A class representing the physical state of an object, i.e. position, velocity, etc.
	 * @author Jay Fisher
	 */
	public class PhysicalEntity 
	{
		public var mass:Number;		// (standard/default 1)
		public var position:Point;
		public var velocity:Point;
		public var force:Point;

		/**
		 * Constructor.
		 * @param	_mass			the mass of the entity
		 * @param	_position		the position of the entity
		 */
		public function PhysicalEntity(_mass:Number, _position:Point) 
		{
			mass = _mass;
			position = _position;
			velocity = new Point(0,0);
			force = new Point(0,0);
		}

		/**
		 * Adds a force to the object until next frame.
		 * @param	_force	the force to add
		 */
		public function addForce(_force:Point):void
		{
			force = force.add(_force);
		}
		
		/**
		 * Called every frame to update the state.
		 * @param	dt	the amount of time that has ellapsed
		 */
		public function step(dt:Number):void
		{
			// propogate the state using the forward Euler method
			position.x += velocity.x*dt;
			position.y += velocity.y*dt;
			velocity.x += force.x/mass*dt;
			velocity.y += force.y/mass*dt;
			//reset the force
			force = new Point(0,0);
		}
	}
}
