package packpan.iface 
{
	/**
	 * Color-tinted Mail or Node will implement this interface.
	 * @author Alexander Huynh
	 */
	public interface IColorable 
	{
		/**
		 * Compares a color against the color of this Object.
		 * If this Object is not colored, returns true.
		 * @param	col		the color to compare against
		 * @return			true if this Object has the same color or if this Object is not colored
		 */
		function isSameColor(col:uint):Boolean;
		
		/**
		 * Gives this Object a color.
		 * @param	coli	the color to set, an int, 0-15
		 */
		function setColor(coli:int):void;
		
		/**
		 * Gets this Object's color
		 * @return			this object's color, PP.COLOR_NONE if not colored
		 */
		function getColor():uint;
	}
	
}
