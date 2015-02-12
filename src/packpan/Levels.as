package packpan 
{
	import JSON;

	/**
	 * A container for embedded levels.
	 * 
	 * @author Jay Fisher
	 */

	public class Levels
	{
		//Embed each level as a json String here
		[Embed(source = "../../json/level000.json", mimeType = 'application/octet-stream')] private static const Level000:Class;
		[Embed(source = "../../json/level001.json", mimeType = 'application/octet-stream')] private static const Level001:Class;

		//Each element of the array is a 15-length array of levels - some of which may be undefined
		private var:Array pages;

		//Constructor called by the Engine on startup
		public function Levels() 
		{
			pages = new Array(1);
			pages[0] = new Array(15));
			pages[0][0] = JSON.parse(new Level000() as String);
			pages[0][1] = JSON.parse(new Level001() as String);
		}

		/**
		 *	Returns the number of pages
		 *	@returns	The number of pages
		 */
		public function numPages():uint
		{
			return pages.length;
		}

		/**
		 *	Returns whether or not a level exists on that page at that index
		 *	@param	page	The page the level is on
		 *	@param	index	The index of the level on its page, 0-14
		 *	@returns	true if a level exists on that page at that index
		 */
		public function hasLevel(page:int, index:int):String
		{
			return pages[page][index] != undefined;
		}

		/**
		 *	Returns the level on that page and index as a dictionary.
		 *	@param	page	The page the level is on
		 *	@param	index	The index of the level on its page, 0-14
		 *	@returns	The level on that page at that index
		 */
		public function getLevel(page:int, index:int):String
		{
			return pages[page][index];
		}
	}
}
