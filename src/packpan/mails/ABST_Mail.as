package packpan.mails
{
	import cobaltric.ABST_ContainerGame;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import packpan.PP;
	/**
	 * An abstract Mail object, extended to become items that are manipulated by nodes.
	 * @author Alexander Huynh
	 */
	public class ABST_Mail 
	{
		protected var cg:ABST_ContainerGame;		// the parent container
		
		public var type:String;						// the name of this Mail
		public var position:Point;					// the current grid square of this Mail (0-indexed, origin top-left, L/R is x, U/D is y)
		
		public var mc_mail:MovieClip;				// the mail MovieClip (SWC)
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
			
			mc_mail = cg.addChildToGrid(new Mail(), position);		// create the MovieClip
			mc_mail.stop();											// default mail frame
			mc_mail.buttonMode = false;								// disable click captures
			mc_mail.mouseEnabled = false;
			mc_mail.mouseChildren = false;
		}
		
		/**
		 * Called by ABST_ContainerGame every frame to make this Mail do things
		 * @return				PP.MAIL_IDLE, PP.MAIL_SUCCESS, or PP.MAIL_FAILURE
		 */
		public function step():int
		{
			// -- OVERRIDE THIS FUNCTION TO PROVIDE CUSTOM FUNCTIONALITY
			
			position = findGridSquare();		// find the current grid coordinates
			
			if (position)						// if we are in bounds
			{
				if (!cg.nodeGrid[position.x][position.y])		// if we are not on a Node (we are on the ground)
				{
					trace("OFF NODE!");			// TODO falling-off animation
					mailState = PP.MAIL_FAILURE;
				}
				else							// otherwise have the Node in this grid square affect us
					cg.nodeGrid[position.x][position.y].affectMail(this);
			}
				  
			return mailState;
		}
		
		/**
		 * Returns the grid coordinates of this Mail object based on its actual coordinates
		 * Sets state to failure if not on a valid point (out of bounds)
		 * 
		 * @return		the grid square as a Point, or null if invalid
		 */
		protected function findGridSquare():Point
		{
			// black magic; but don't worry, I'm a Super High-School Level Electromage
			var p:Point = new Point(Math.round((mc_mail.y + 260) / 50), Math.round((mc_mail.x + 350) / 50));
			if (p.x < 0 || p.x > PP.DIM_X_MAX || p.y < 0 || p.y > PP.DIM_Y_MAX)
			{
				mailState = PP.MAIL_FAILURE;
				p = null;
			}
			return p;
		}
	}
}