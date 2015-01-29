package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.ColorCorrection;
	import flash.geom.ColorTransform;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import flash.geom.Point;
	
	/**
	 * A goal bin.
	 * @author Alexander Huynh
	 */
	public class NodeBin extends ABST_Node 
	{
		private const SPEED:int = 2;		// speed at which to move Mail towards the center
		
		public var occupied:Boolean;		// if true, there is a package in this bin
		
		public function NodeBin(_cg:ContainerGame, _type:String, _position:Point,
								_facing:int, _clickable:Boolean, _color:uint = 0x000001) 
		{
			super(_cg, "NodeBin", _position, PP.DIR_NONE, false, _color);
			occupied = false;
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
			
			// move towards center of x axis, snapping when close
			if (Math.abs(mail.mc_mail.x - mc_node.x) < 5)
				mail.mc_mail.x = mc_node.x;
			else if (mail.mc_mail.x > mc_node.x)
				mail.mc_mail.x -= SPEED;
			else
				mail.mc_mail.x += SPEED;
			
			// move towards center of y axis, snapping when close
			if (Math.abs(mail.mc_mail.y - mc_node.y) < 5)
				mail.mc_mail.y = mc_node.y;
			else if (mail.mc_mail.y > mc_node.y)
				mail.mc_mail.y -= SPEED;
			else
				mail.mc_mail.y += SPEED;
				
			// once snapping animation is complete
			if (mail.mc_mail.x == mc_node.x && mail.mc_mail.y == mc_node.y)
			{
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