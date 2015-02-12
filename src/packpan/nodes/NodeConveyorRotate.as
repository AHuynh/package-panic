package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NodeConveyorRotate extends NodeConveyorNormal 
	{
		
		public function NodeConveyorRotate(_cg:ContainerGame, _json:Object)
		{
			//_type = "NodeConveyorNormal"
			super(_cg, _json);
			
		}
		
		override public function onClick(e:MouseEvent):void
		{
			// face the opposite direction
			switch (facing)
			{
				case PP.DIR_RIGHT:
					facing = PP.DIR_UP;
				break;
				case PP.DIR_UP:
					facing = PP.DIR_LEFT;
				break;
				case PP.DIR_LEFT:
					facing = PP.DIR_DOWN;
				break;
				case PP.DIR_DOWN:
					facing = PP.DIR_RIGHT;
				break;
				default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
			
			mc_node.rotation = facing;		// rotate the graphic appropriately
		}
		
	}

}