package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import packpan.ABST_GameObject;
	import packpan.PP;
	import packpan.PhysicalEntity;
	import packpan.PhysicsUtils;
	/**
	 * An abstract Mail object, extended to become items that are manipulated by nodes.
	 * @author Alexander Huynh
	 */
	public class ABST_Mail extends ABST_GameObject
	{		
		public var state:PhysicalEntity;			// the physical state of the mail
		public var mailState:int = PP.MAIL_IDLE;	// is this mail in a idle, success, or failure state
		
		/**
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 * @param	_json		Object created by parsing JSON.
		 * @param	_bitmap		Optional: A Bitmap to use for graphics.
		 */
		public function ABST_Mail(_cg:ContainerGame, _json:Object, _bitmap:Bitmap = null) 
		{
			mc_object = new Mail();
			
			super(_cg, _json, _bitmap);

			state = new PhysicalEntity(1, new Point(position.x, position.y));
			
			cg.addChildToGrid(mc_object, position);		// add the MovieClip to the stage
			mc_object.stop();							// default mail frame
			mc_object.buttonMode = false;				// disable click captures
			mc_object.mouseEnabled = false;
			mc_object.mouseChildren = false;
		}
		
		/**
		 * Called by ABST_ContainerGame every frame to make this Mail do things.
		 * (OVERRIDE THIS FUNCTION TO PROVIDE CUSTOM FUNCTIONALITY)
		 * @return			The status of this Mail: PP.MAIL_IDLE, PP.MAIL_SUCCESS, or PP.MAIL_FAILURE.
		 */
		public function step():int
		{
			// -- OVERRIDE THIS FUNCTION TO PROVIDE CUSTOM FUNCTIONALITY
			
			position = findGridSquare();		// find the current grid coordinates
			
			if (position)						// if we are in bounds
			{
				if (!cg.nodeGrid[position.x][position.y])		// if we are not on a Node (we are on the ground)
				{
					mailState = PP.MAIL_FAILURE;	// TODO falling-off animation
				}
				else								// otherwise have the Node in this grid square affect us
					cg.nodeGrid[position.x][position.y].affectMail(this);
			}

			// step the physics and update the position of the movie clip
			state.step(cg.timerTick * .001);
			var mc_pos:Point = PhysicsUtils.gridToScreen(state.position);
			mc_object.x = mc_pos.x;
			mc_object.y = mc_pos.y;

			return mailState;
		}
		
		/**
		 * Returns the grid coordinates of this Mail object based on its actual coordinates.
		 * Sets state to failure if not on a valid point (out of bounds).
		 * 
		 * @return		The grid square as a Point, or null if invalid.
		 */
		protected function findGridSquare():Point
		{
			var p:Point = new Point(Math.round(state.position.x),Math.round(state.position.y));
			if (p.x < 0 || p.x > PP.DIM_X_MAX || p.y < 0 || p.y > PP.DIM_Y_MAX)
			{
				mailState = PP.MAIL_FAILURE;
				p = null;
			}
			return p;
		}
	}
}
