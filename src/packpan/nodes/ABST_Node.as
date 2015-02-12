package packpan.nodes
{
	import cobaltric.ContainerGame;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import packpan.ABST_GameObject;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	/**
	 * An abstract node, extended to create conveyor belts, ramps, bins, etc.
	 * @author Alexander Huynh
	 */
	public class ABST_Node extends ABST_GameObject
	{				
		/// If a mouse click manipulates this Node, clickable is true.
		public var clickable:Boolean;	
		
		/// The node MovieClip (a SWC).
		public var mc_node:MovieClip;

		/**
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 * @param	_json		Object created by parsing JSON.
		 */
		public function ABST_Node(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);
			
			///////////////////////////////////////////////////////////////////////////////////////
			//	now parse the "JSON" object for common properties all game objects could have
			///////////////////////////////////////////////////////////////////////////////////////

			mc_node = cg.addChildToGrid(new Node(), position);		// add the Node MovieClip to the game

			/*try {
				mc_node.gotoAndStop(type);
			} catch (e:ArgumentError) {
				trace("Sprite not found: " + type);
			}*/

			if (json["dir"])
				facing = rotateToDir(json["dir"], mc_node);
				
			if (json["clickable"])
				clickable = json["clickable"];

			
			if (clickable)		// attach a listener for clicks if this Node can be clicked
				mc_node.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * Rotates this object's graphic (MovieClip) to the given facing.
		 * @param	dir		A PP.DIR_X value to be rotated to, ex: PP.DIR_LEFT.
		 * @param	mc		The MovieClip to rotate, ex: mc_mail.
		 * @return			The new direction, a PP.DIR_X value.
		 */
		public function rotateToDir(dir:String, mc:MovieClip):int
		{
			facing = PP.DIR_NONE;
			switch (dir.toLowerCase())
			{
				case "right":	facing = PP.DIR_RIGHT;	break;
				case "up":		facing = PP.DIR_UP;		break;
				case "left":	facing = PP.DIR_LEFT;	break;
				case "down":	facing = PP.DIR_DOWN;	break;
			}
			if (facing != PP.DIR_NONE)
				mc.rotation = facing;		// rotate the graphic appropriately
			return facing;
		}
		
		/**
		 * Called by ContainerGame every frame to perform an action.
		 */
		public function step():void
		{
			// -- OVERRIDE THIS FUNCTION as needed
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object.
		 * @param	mail	The Mail to be affected.
		 */
		public function affectMail(mail:ABST_Mail):void
		{
			// -- OVERRIDE THIS FUNCTION
		}
		
		/**
		 * Called when this Node is clicked.
		 * @param	e		The captured MouseEvent, unused, can be null.
		 */
		public function onClick(e:MouseEvent):void
		{
			// -- OVERRIDE THIS FUNCTION as needed
		}
		
		/**
		 * Returns true if the given Node is in the same grid position
		 * as this Node.
		 * @param	node	The Node to compare against; if null, function returns false.
		 * @return			True if both Nodes are in the same grid position.
		 */
		public function isSameNode(node:ABST_Node):Boolean
		{
			return node &&	node.position.x == position.x &&
							node.position.y == position.y;
		}
		
		/**
		 * Remove the eventListeners on this Node's mc_node.
		 * Called internally and externally by NodeGroup.
		 */
		public function removeListeners():void
		{
			mc_node.clickable = false;
			if (mc_node.hasEventListener(MouseEvent.CLICK))
				mc_node.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * Called to remove event listeners and clean up this Node.
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