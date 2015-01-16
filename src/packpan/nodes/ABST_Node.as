package packpan.nodes
{
	import cobaltric.ABST_ContainerGame;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	/**
	 * An abstract node, extended to create conveyor belts, ramps, bins, etc.
	 * @author Alexander Huynh
	 */
	public class ABST_Node 
	{		
		protected var cg:ABST_ContainerGame;	// the parent container
		
		public var type:String;					// the name of this Node
		public var clickable:Boolean;			// if a mouse click manipulates this Node
		public var position:Point;				// the grid square of this Node (0-indexed, origin top-left, L/R is x, U/D is y)
		public var facing:int;					// which direction this Node is facing, if applicable (PP constant)
		
		public var mc_node:MovieClip;			// the node MovieClip (SWC)

		public function ABST_Node(_cg:ABST_ContainerGame, _type:String, _position:Point,
								  _facing:int, _clickable:Boolean)
		{
			cg = _cg;
			type = _type;
			position = _position;
			facing = _facing;
			clickable = _clickable;
			
			mc_node = cg.addChildToGrid(new Node(), position);		// add the Node MovieClip to the game
			
			if (clickable)
				mc_node.addEventListener(MouseEvent.CLICK, onClick);
				
			/*if (facing != PP.DIR_NONE)
				switch (facing)
				{
					case PP.DIR_RIGHT: mc_node.rotation = 0; break;
					case PP.DIR_UP: mc_node.rotation = 90; break;
					case PP.DIR_LEFT: mc_node.rotation = 180; break;
					case PP.DIR_DOWN: mc_node.rotation = 270; break;
				}*/
		}
		
		/**
		 * Called by ContainerGame every frame to perform an action
		 */
		public function step():void
		{
			// -- OVERRIDE THIS FUNCTION
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object
		 * @param	mail	the Mail to be affected
		 */
		public function affectMail(mail:ABST_Mail):void
		{
			// -- OVERRIDE THIS FUNCTION
		}
		
		/**
		 * Called when this Node is clicked
		 * @param	e		the captured MouseEvent, unused, can be null
		 */
		public function onClick(e:MouseEvent):void
		{
			// -- OVERRIDE THIS FUNCTION
		}
		
		/**
		 * Remove the eventListeners on this node's mc_node.
		 * Called internally and externally by NodeGroup.
		 */
		public function removeListeners():void
		{
			mc_node.clickable = false;
			if (mc_node.hasEventListener(MouseEvent.CLICK))
				mc_node.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * Call to remove event listeners and clean up this Node
		 */
		public function destroy():void
		{
			if (!mc_node)
				return;
			if (cg)
				cg.removeChildFromGrid(mc_node);
			removeListeners();
			mc_node = null;
			cg = null;
		}
	}
}