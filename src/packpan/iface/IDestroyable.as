package packpan.iface 
{
	/**
	 * Mail that can be destroyed will implement this interface.
	 * @author James Liu
	 */
	public interface IDestroyable 
	{
		/**
		 * Is this object able to be destroyed by the given destructor?
		 * @param	Object destructor
		 * @return destroyed or not
		 */
		function DestroyedBy(destructor:Object) : Boolean;
		
		/**
		 * Destroy this object
		 */
		function Destroy() : void;
		
		/**
		 * Should this object be destroyed to win?
		 * @return
		 */
		function ShouldDestroy() : Boolean;
	}
	
}