package packpan.iface 
{
	/**
	 * Mail that can be modified by a Node will implement this interface.
	 * @author James Liu
	 */
	public interface IProcessable 
	{
		/**
		 * Is this object able to be processed by the given processor?
		 * @param	Object processor
		 * @return destroyed or not
		 */
		function ProcessedBy(processor : Object) : Boolean;
		
		
		/**
		 * Process this object
		 * @param	Object processor
		 */
		function Process(processor : Object) : void;
		
		/**
		 * Should this object be processed to win?
		 * @return
		 */
		function ShouldProcess() : Boolean;
	}
	
}