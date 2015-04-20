package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import cobaltric.SoundManager;
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
	 * A single-capacity goal bin.
	 * Occupied bins allow other items to slide over it.
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeBin extends ABST_Node implements IColorable
	{
		[Embed(source="../../../img/binNormal.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class;					// must be directly below the embed code

		/// The color of this object
		private var color:uint;
		
		// the strength of the forces that center the package
		private var friction:Number = 5;
		private var spring:Number = 10;
		
		/// if true, there is a package in this bin
		public var occupied:Boolean;					

		public function NodeBin(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
			
			occupied = false;
			
			// the color of this mail if it is colored (default white/none)
			color = 15;	
			if (json["color"])
				setColor(json["color"]);
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
				return;
			
			// ease the mail to the center
			mail.state.addForce(PhysicsUtils.linearDamping(friction, mail.state, new Point(0, 0)));
			mail.state.addForce(PhysicsUtils.linearRestoreX(spring, mail.state, position.x));
			mail.state.addForce(PhysicsUtils.linearRestoreY(spring, mail.state, position.y));
				
			// once snapping animation is complete
			if (Point.distance(position,mail.state.position) < 0.2)
			{
				mail.state = new PhysicalEntity(1, new Point(position.x, position.y));
				mail.mc_object.scaleX = mail.mc_object.scaleY = .8;							// visually shrink the mail
				cg.game.holder_main.setChildIndex(mail.mc_object, cg.lowestPackageDepth);	// send to back of display list
				occupied = true;
				
				// fail if mail and bin are colored and colors don't match.
				// also fail if the mail should have been destroyed
				if (mail.ShouldDestroy() || (mail is IColorable && !isSameColor(IColorable(mail).getColor())))
				{
					mail.mailState = PP.MAIL_FAILURE;
					return;
				}
				// success state
				mail.mailState = PP.MAIL_SUCCESS;
				SoundManager.play("sfx_bin");
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isSameColor(col:uint):Boolean
		{
			return getColor() == col;
		}
		
		public function setColor(coli:int):void
		{
			var col:uint = PP.COLORS[coli];
			
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = int(col / 0x10000) / 255;
			ct.greenMultiplier = int(col % 0x10000 / 0x100) / 255;
			ct.blueMultiplier = col % 0x100 / 255;
			mc_object.transform.colorTransform = ct;
			
			color = col;
		}
		
		public function getColor():uint
		{
			return color;
		}
	}
}
