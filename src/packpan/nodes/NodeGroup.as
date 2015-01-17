package packpan.nodes 
{
	import flash.events.MouseEvent;
	/**
	 * A group of Nodes that work as one object
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeGroup 
	{
		public var nodeArray:Array;				// array of all Nodes in this group
		
		public function NodeGroup() 
		{
			nodeArray = [];
		}
		
		/**
		 * Adds the given Node to the NodeGroup.
		 * Must call setupListeners() after all Nodes have been added.
		 * @param	node		the ABST_Node to add to the group
		 */
		public function addToGroup(node:ABST_Node):void
		{
			nodeArray.push(node);
		}
		
		/**
		 * Redirects individual Node listeners to this NodeGroup.
		 * Must be called after adding all Nodes to the group.
		 */
		public function setupListeners():void
		{
			if (nodeArray.length == 0) return;
			
			var node:ABST_Node;
			for (var i:int = 0; i < nodeArray.length; i++)
			{
				node = nodeArray[i];
				node.removeListeners();
				node.mc_node.addEventListener(MouseEvent.CLICK, onNodeGroup);
			}
		}
		
		/**
		 * When one Node of this group is clicked, apply this action to all Nodes in the group.
		 * @param	e		the captured MouseEvent, unused
		 */
		public function onNodeGroup(e:MouseEvent):void
		{
			if (nodeArray.length == 0) return;
			
			for (var i:int = 0; i < nodeArray.length; i++)
				nodeArray[i].onClick(e);
		}
		
		/**
		 * Sets the direction of all Nodes in this group to facing.
		 * @param	facing		the (PP) direction to face all Nodes in this group
		 */
		public function setDirection(facing:int):void
		{
			if (nodeArray.length == 0) return;
			
			for (var i:int = 0; i < nodeArray.length; i++)
			{
				nodeArray[i].facing = facing;
				nodeArray[i].mc_node.rotation = facing;
			}
		}
		
		/**
		 * Returns a list of the Nodes in this group
		 * @return			Array of Nodes
		 */
		public function getNodes():Array
		{
			return nodeArray;
		}
	}
}