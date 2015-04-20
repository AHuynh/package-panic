package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import cobaltric.SoundManager;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	
	/**
	 * Similar to NodeConveyorNormal, but rotates in all 4 directions.
	 * @author James Lee
	 */
	public class NodeConveyorRotate extends NodeConveyorNormal 
	{
		public function NodeConveyorRotate(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);
			mc_object.gotoAndStop("NodeConveyorRotate");
		}
		
		override public function onClick(e:MouseEvent):void
		{
			// rotate counter-clockwise
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
					trace("WARNING: NodeConveyorRotate at " + position + " has an invalid facing!");
			}
			
			mc_object.rotation = facing;		// rotate the graphic appropriately
			SoundManager.play("sfx_rotate");
		}
		
	}

}