package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.geom.ColorTransform;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicalEntity;
	import packpan.PP;
	import packpan.PhysicsUtils;
	import flash.geom.Point;
	
	/**
	 * A goal bin.
	 * @author Alexander Huynh
	 */
	public class NodeBin extends ABST_Node 
	{
		//the strength of the forces that center the package
		private var friction:Number = 5;
		private var spring:Number = 10;
		
		public var occupied:Boolean;		// if true, there is a package in this bin
		
		[Embed(source="../../../img/binNormal.png")]
		private var imgLayer:Class;
		private var img:Bitmap = new imgLayer();	
		
		public function NodeBin(_cg:ContainerGame, _type:String, _position:Point,
								_facing:int, _clickable:Boolean, _color:uint = 0x000001) 
		{
			super(_cg, "NodeBin", _position, PP.DIR_NONE, false, _color);
			occupied = false;
			
			mc_node.gotoAndStop("none");		// switch to an empty mail image
			mc_node.addChild(img);				// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object
		 * Draws Mail objects to its center
		 * 
		 * @param	mail	the Mail to be affected
		 */
		override public function affectMail(mail:ABST_Mail):void
		{
			if (occupied)
			{
				return;		// TODO failure state
			}
			
			mail.state.addForce(PhysicsUtils.linearDamping(friction, mail.state, new Point(0, 0)));
			mail.state.addForce(PhysicsUtils.linearRestoreX(spring, mail.state, position.x));
			mail.state.addForce(PhysicsUtils.linearRestoreY(spring, mail.state, position.y));
				
			// once snapping animation is complete
			if (Point.distance(position,mail.state.position) < 0.1)
			{
				mail.state = new PhysicalEntity(1, new Point(position.x, position.y));
				mail.mc_mail.scaleX = mail.mc_mail.scaleY = .8;
				occupied = true;
				// Fail if mail and bin are colored and colors don't match.
				if (colored && mail.colored) {
					if (color != mail.color) {
						mail.mailState = PP.MAIL_FAILURE;
						return;
					}
				}
				// success state
				mail.mailState = PP.MAIL_SUCCESS;
			}
		}
	}
}