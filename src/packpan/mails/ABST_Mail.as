package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
<<<<<<< HEAD
	import flash.display.Bitmap;
=======
	import packpan.ABST_GameObject;
>>>>>>> upstream/master
	import packpan.PP;
	import packpan.PhysicalEntity;
	import packpan.PhysicsUtils;
	/**
	 * An abstract Mail object, extended to become items that are manipulated by nodes.
	 * @author Alexander Huynh
	 */
<<<<<<< HEAD
	public class ABST_Mail 
	{
		[Embed(source="../../../img/packagePlus.png")]				// image embed code, auto-generated
		private var imgLayer:Class;									// needed to instantiate your image
		private var plus:Bitmap = new imgLayer();					// reference to your image
		
		[Embed(source="../../../img/packageMinus.png")]				// image embed code, auto-generated
		private var imgLayer2:Class;								// needed to instantiate your image
		private var minus:Bitmap = new imgLayer2();					// reference to your image
		
		protected var cg:ContainerGame;		// the parent container
		
		public var type:String;						// the name of this Mail
		public var position:Point;					// the current grid square of this Mail (0-indexed, origin top-left, L/R is x, U/D is y)
		public var colored:Boolean;					// whether or not this Mail is colored
		public var color:uint;						// the color of this Mail if applicable
		public var polarity:int;					// the magnetic polarity (or lack thereof) of the mail

		public var state:PhysicalEntity;	//The physical state of the mail
=======
	public class ABST_Mail extends ABST_GameObject
	{		
		public var state:PhysicalEntity;			// the physical state of the mail
>>>>>>> upstream/master
		
		public var mc_mail:MovieClip;				// the mail MovieClip (SWC)
		public var mailState:int = PP.MAIL_IDLE;	// is this mail in a idle, success, or failure state
		
		/**
<<<<<<< HEAD
		 * Constructor.
		 * @param	_cg			the parent container (ABST_ContainerGame)
		 * @param	_type		the type of this mail (String)
		 * @param	_position	the starting grid location of this mail (Point)
		 * @param   _color		the color of the mail
		 * @param	_polarity	the magnetic polarity of the mail
		 */
		public function ABST_Mail(_cg:ContainerGame, _type:String, _position:Point, _color:uint = 0x000001, _polarity:int = 0) 
		{
			cg = _cg;
			type = _type;
			position = _position;
			color = _color;
			polarity = _polarity;
			
			state = new PhysicalEntity(1,new Point(_position.x,_position.y));
=======
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 * @param	_json		Object created by parsing JSON.
		 */
		public function ABST_Mail(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);

			state = new PhysicalEntity(1, new Point(position.x, position.y));
>>>>>>> upstream/master
			
			mc_mail = cg.addChildToGrid(new Mail(), position);		// create the MovieClip
			mc_mail.stop();											// default mail frame
			mc_mail.buttonMode = false;								// disable click captures
			mc_mail.mouseEnabled = false;
			mc_mail.mouseChildren = false;
<<<<<<< HEAD
			
			if (polarity > 0) {
				mc_mail.gotoAndStop("none");
				mc_mail.addChild(plus);
				//plus.x -= plus.width * .5;
				plus.y -= plus.height * .5;
			} else if (polarity < 0) {
				mc_mail.gotoAndStop("none");
				mc_mail.addChild(minus);
				//minus.x -= minus.width * .5;
				minus.y -= minus.height * .5;
			}
			
			if (color == 0x000001) {
				colored = false;
			} else {
				colored = true;
				var ct:ColorTransform = new ColorTransform();
				ct.redMultiplier = int(color / 0x10000) / 255;
				ct.greenMultiplier = int(color % 0x10000 / 0x100) / 255;
				ct.blueMultiplier = color % 0x100 / 255;
				mc_mail.transform.colorTransform = ct;
			}
=======
>>>>>>> upstream/master
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
			mc_mail.x = mc_pos.x;
			mc_mail.y = mc_pos.y;

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
