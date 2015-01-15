package packpan 
{
	import cobaltric.ABST_ContainerGame;
	import flash.geom.Point;
	/**
	 * An abstract Mail object, extended to become items that are manipulated by nodes.
	 * @author Alexander Huynh
	 */
	public class ABST_Mail 
	{
		protected var cg:ABST_ContainerGame;		// the parent container
		
		public var type:String;						// the name of this Mail
		public var position:Point;					// the current grid square of this Mail (0-indexed, origin top-left, L/R is x, U/D is y)
		
		public var mc_node:Mail;					// the mail MovieClip (SWC)
		public var mailState:int = PP.MAIL_IDLE;	// is this mail in a idle, success, or failure state
		
		/**
		 * Constructor.
		 * @param	_cg			the parent container (ABST_ContainerGame)
		 * @param	_type		the type of this mail (String)
		 * @param	_position	the starting grid location of this mail (Point)
		 */
		public function ABST_Mail(_cg:ABST_ContainerGame, _type:String, _position:Point) 
		{
			cg = _cg;
			type = _type;
			position = _position;
		}
		
		/**
		 * Called by ABST_ContainerGame every frame to make this Mail do things
		 * @return				PP.MAIL_IDLE, PP.MAIL_SUCCESS, or PP.MAIL_FAILURE
		 */
		public function step():int
		{
			// OVERRIDE THIS FUNCTION
			return mailState;
		}
	}
}