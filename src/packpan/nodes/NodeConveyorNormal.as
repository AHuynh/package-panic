package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import packpan.PhysicsUtils;
	
	/**
	 * A normal conveyor belt that moves Mail in the direction it is facing.
	 * Can be clicked to invert the direction.
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeConveyorNormal extends ABST_Node 
	{
		protected var speed:Number = 1;
		protected var friction:Number = 10; //the strength of the friction
		protected var spring: Number = 60; //the strength of the "spring" that centers the package
	
		public function NodeConveyorNormal(_cg:ContainerGame, _type:String, _position:Point,
										   _facing:int, _clickable:Boolean)
		{
			super(_cg, _type, _position, _facing, _clickable);
			
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
			//provide a force to make the velocity of the mail match that of the conveyor
			switch (facing)
			{
				case PP.DIR_RIGHT:
					mail.state.addForce(PhysicsUtils.linearDamping(friction,mail.state,new Point(speed,0)));
				break;
				case PP.DIR_UP:
					mail.state.addForce(PhysicsUtils.linearDamping(friction,mail.state,new Point(0,-speed)));
				break;
				case PP.DIR_LEFT:
					mail.state.addForce(PhysicsUtils.linearDamping(friction,mail.state,new Point(-speed,0)));
				break;
				case PP.DIR_DOWN:
					mail.state.addForce(PhysicsUtils.linearDamping(friction,mail.state,new Point(0,speed)));
				break;
				default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
			//provide a force to "spring" the position to the middle of the conveyor
			switch (facing)
			{
				case PP.DIR_RIGHT:
				case PP.DIR_LEFT:
					mail.state.addForce(PhysicsUtils.linearRestoreY(spring,mail.state,position.y));
				break;
				case PP.DIR_UP:
				case PP.DIR_DOWN:
					mail.state.addForce(PhysicsUtils.linearRestoreX(spring,mail.state,position.x));
				break;
			default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
		}
	}
}
