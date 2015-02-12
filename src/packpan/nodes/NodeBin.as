package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.geom.ColorTransform;
	import packpan.iface.IColorable;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicalEntity;
	import packpan.PP;
	import packpan.PhysicsUtils;
	import flash.geom.Point;
	
	/**
	 * A goal bin.
	 * @author Alexander Huynh
	 */
	public class NodeBin extends ABST_Node implements IColorable 
	{
		//the strength of the forces that center the package
		private var friction:Number = 5;
		private var spring:Number = 10;
		
		public var occupied:Boolean;			// if true, there is a package in this bin
		public var color:uint = PP.COLOR_NONE;	// the color of this bin if it is colored
		
		[Embed(source="../../../img/binNormal.png")]
		private var imgLayer:Class;
		private var img:Bitmap = new imgLayer();	
		
		public function NodeBin(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
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
				
				// fail if mail and bin are colored and colors don't match.
				if (mail is IColorable && !isSameColor(IColorable(mail).getColor()))
				{
					trace("Failing!");
					mail.mailState = PP.MAIL_FAILURE;
					return;
				}
				// success state
				mail.mailState = PP.MAIL_SUCCESS;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isColored():Boolean
		{
			return color != PP.COLOR_NONE;
		}
		
		public function isSameColor(col:uint):Boolean
		{
			return !isColored() || color == col;
		}
		
		public function setColor(col:uint):void
		{
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = int(col / 0x10000) / 255;
			ct.greenMultiplier = int(col % 0x10000 / 0x100) / 255;
			ct.blueMultiplier = col % 0x100 / 255;
			mc_node.transform.colorTransform = ct;
			
			color = col;
		}
		
		public function getColor():uint
		{
			return color;
		}
	}
}