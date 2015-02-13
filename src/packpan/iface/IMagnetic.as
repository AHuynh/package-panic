package packpan.iface 
{
	/**
	 * Magnetic polarity of mail
	 * @author Cheng Hann Gan
	 */
	public interface IMagnetic 
	{
		/**
		 * Gets polarity of object
		 * @return 		1 (positive), -1 (negative), or 0 (no polarity)
		 */
		function getPolarity():int;
		
		/**
		 * Sets polarity of object
		 * @param	pol		the polarity to set
		 */
		function setPolarity(pol:int):void;
		
		/**
		 * Whether to repel, attract, or ignore the object based on the polarity of the two objects
		 * @param	pol		the polarity of the other object
		 * @return		1 (repel), -1 (attract), 0 (ignore)
		 */
		function getInteraction(pol:int):int;
		
	}

}