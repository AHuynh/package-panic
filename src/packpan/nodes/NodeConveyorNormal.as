package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import cobaltric.SoundManager;
	import packpan.PhysicsUtils;
	
	/**
	 * A normal conveyor belt that moves Mail in the direction it is facing.
	 * Can be clicked to invert the direction.
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeConveyorNormal extends ABST_Node 
	{
		protected var speed:Number = 1;		// speed at which to move mail objects
		protected var friction:Number = 10;	// the strength of the friction
		protected var spring: Number = 60;	// the strength of the "spring" that centers the package
		
		protected var cap:int = 0; 
		/*	keeps track of special graphics cases
		 * 	0	No special case
		 * 	1	Graphic is begin cap
		 * 	-1	Graphic is end cap
		 */
	
		public function NodeConveyorNormal(_cg:ContainerGame, _json:Object)
		{
			tintable = true;
			super(_cg, _json);
			
			// set up custom graphics
			mc_object.gotoAndStop("NodeConveyorNormalSingle");
		}
		
		/**
		 * Called by a NodeGroup when adding this Node to the group.
		 * Do not call from classes other than NodeGroup.
		 * Override to do something after being added to a group. Ex: Update graphics.
		 * @param	group		The NodeGroup that this Node is being added to.
		 */
		override public function addToGroup(group:NodeGroup, index:int):void
		{
			nodeGroup = group;		// keep this line
			
			// determine special graphics cases (start, center, or end piece)
			if (index == 0)
			{
				if (facing == PP.DIR_UP || facing == PP.DIR_LEFT)
				{
					cap = -1;
					mc_object.gotoAndStop("NodeConveyorNormalEnd");
				}
				else
				{
					cap = 1;
					mc_object.gotoAndStop("NodeConveyorNormalStart");
				}
			}
			else if (index == nodeGroup.getNodes().length - 1)
			{
				if (facing == PP.DIR_UP || facing == PP.DIR_LEFT)
				{
					cap = 1;
					mc_object.gotoAndStop("NodeConveyorNormalStart");
				}
				else
				{
					cap = -1;
					mc_object.gotoAndStop("NodeConveyorNormalEnd");
				}
			}
			else
				mc_object.gotoAndStop("NodeConveyorNormal");
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
			
			// handle end caps
			if (cap != 0)
			{
				var oldFrame:int = mc_object.mc.currentFrame;
				cap *= -1;
				mc_object.gotoAndStop("NodeConveyorNormal" + (cap > 0 ? "Start" : "End"));
				mc_object.mc.gotoAndPlay(oldFrame);
			}
			
			mc_object.rotation = facing;		// rotate the graphic appropriately
			SoundManager.play("sfx_rotate");
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
