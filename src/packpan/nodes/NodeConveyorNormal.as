package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	
	/**
	 * A normal conveyor belt that moves Mail in the direction it is facing.
	 * Can be clicked to invert the direction.
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeConveyorNormal extends ABST_Node 
	{
		public var speed:Number = 2;		// how fast to move Mail
		
		public function NodeConveyorNormal(_cg:ContainerGame, _type:String, _position:Point,
										   _facing:int, _clickable:Boolean, _color:uint)
		{
			super(_cg, _type, _position, _facing, _clickable, _color);
			
			if (facing != PP.DIR_NONE)
				mc_node.rotation = facing;
			// if facing is not set here, it must be set through a NodeGroup
		}
		
		/**
		 * Called when this Node is clicked, if this Node is clickable.
		 * @param	e		the captured MouseEvent, unused
		 */
		override public function onClick(e:MouseEvent):void
		{
			// face the opposite direction
			switch (facing)
			{
				case PP.DIR_RIGHT:
					facing = PP.DIR_LEFT;
				break;
				case PP.DIR_UP:
					facing = PP.DIR_DOWN;
				break;
				case PP.DIR_LEFT:
					facing = PP.DIR_RIGHT;
				break;
				case PP.DIR_DOWN:
					facing = PP.DIR_UP;
				break;
				default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
			
			mc_node.rotation = facing;		// rotate the graphic appropriately
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object
		 * @param	mail	the Mail to be affected
		 */
		override public function affectMail(mail:ABST_Mail):void
		{
			switch (facing)
			{
				case PP.DIR_RIGHT:
					mail.mc_mail.x += speed;										// primary movement
					if (Math.abs(mail.mc_mail.y - mc_node.y) < 1.5 * speed)			// center the package for other axis
						mail.mc_mail.y = mc_node.y;
					else if (mail.mc_mail.y > mc_node.y)
						mail.mc_mail.y -= speed;
					else
						mail.mc_mail.y += speed;
				break;
				case PP.DIR_UP:
					if (Math.abs(mail.mc_mail.x - mc_node.x) < 1.5 * speed)
						mail.mc_mail.x = mc_node.x;
					else if (mail.mc_mail.x > mc_node.x)
						mail.mc_mail.x -= speed;
					else
						mail.mc_mail.x += speed;
					mail.mc_mail.y -= speed;
				break;
				case PP.DIR_LEFT:
					mail.mc_mail.x -= speed;
					if (Math.abs(mail.mc_mail.y - mc_node.y) < 1.5 * speed)
						mail.mc_mail.y = mc_node.y;
					else if (mail.mc_mail.y > mc_node.y)
						mail.mc_mail.y -= speed;
					else
						mail.mc_mail.y += speed;
				break;
				case PP.DIR_DOWN:
					if (Math.abs(mail.mc_mail.x - mc_node.x) < 1.5 * speed)
						mail.mc_mail.x = mc_node.x;
					else if (mail.mc_mail.x > mc_node.x)
						mail.mc_mail.x -= speed;
					else
						mail.mc_mail.x += speed;
					mail.mc_mail.y += speed;
				break;
				default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
		}
	}
}