package packpan 
{
	import cobaltric.ABST_ContainerGame;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		
		public var mc_node:MovieClip;			// the node MovieClip (SWC)

		public function ABST_Node(_cg:ABST_ContainerGame, _type:String, _position:Point, _clickable:Boolean)
		{
			cg = _cg;
			type = _type;
			position = _position;
			clickable = _clickable;
			
			mc_node = cg.addChildToGrid(new Node(), position);		// add the Node MovieClip to the game
			
			if (clickable)
				mc_node.addEventListener(MouseEvent.CLICK, onClick);
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
		 * @param	e
		 */
		protected function onClick(e:MouseEvent):void
		{
			// -- OVERRIDE THIS FUNCTION
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
			if (mc_node.hasEventListener(MouseEvent.CLICK))
				mc_node.removeEventListener(MouseEvent.CLICK, onClick);
			mc_node = null;
			cg = null;
		}
	}
}