package packpan.iface 
{
	/**
	 * Color-tinted Mail or Node will implement this interface
	 * @author Alexander Huynh
	 */
	public interface IColorable 
	{
		function setColor(col:uint):void;
		function getColor():uint;
	}
	
}