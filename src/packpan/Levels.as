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
		
		//Tutorial levels (introducing nodes/mail)
		[Embed(source="../../json/level_tut_00.json", mimeType="application/octet-stream")]
		private var Level_Tut00:Class; //Normal mail, normal conveyor, normal bin, barrier
		[Embed(source="../../json/level_tut_02.json", mimeType="application/octet-stream")]
		private var Level_Tut02:Class; //Unclickable conveyor
		[Embed(source="../../json/level_rotate.json", mimeType="application/octet-stream")]
		private var Level_Rotate:Class; //Rotatable conveyor
		[Embed(source="../../json/level_color.json", mimeType="application/octet-stream")]
		private var Level_Color:Class; //Colored mail, colored bins
		[Embed(source="../../json/level_slide.json", mimeType="application/octet-stream")]
		private var Level_Slide:Class; //Air Table
		[Embed(source="../../json/level_magnetEasy.json", mimeType="application/octet-stream")]
		private var Level_MagnetEasy:Class; //Magnet, eletromagnetic, magnetic mail
		[Embed(source="../../json/level_chute.json", mimeType="application/octet-stream")]
		private var Level_Chute:Class; //Chute
		[Embed(source="../../json/level_garbage.json", mimeType="application/octet-stream")]
		private var Level_Garbage:Class; //Garbage, incinerator
		[Embed(source="../../json/level_contraband.json", mimeType="application/octet-stream")]
		private var Level_Contraband:Class; //Contraband, x-ray machine
		[Embed(source="../../json/level_holder.json", mimeType="application/octet-stream")]
		private var Level_Holder:Class; //Holder
		
		//Other easy levels
		[Embed(source="../../json/level_tut_01.json", mimeType="application/octet-stream")]
		private var Level_Tut01:Class;
		[Embed(source="../../json/level_tut_03.json", mimeType="application/octet-stream")]
		private var Level_Tut03:Class;
		[Embed(source="../../json/level_testT.json", mimeType="application/octet-stream")]
		private var Level_TestT:Class;
		[Embed(source="../../json/level_barrier.json", mimeType="application/octet-stream")]
		private var Level_Barrier:Class;
		[Embed(source="../../json/level_h.json", mimeType="application/octet-stream")]
		private var Level_H:Class;
		[Embed(source="../../json/level_airTut.json", mimeType="application/octet-stream")]
		private var Level_AirTut:Class;
		[Embed(source="../../json/level_blargh.json", mimeType="application/octet-stream")]
		private var Level_Blargh:Class;
		
		//Intermediate levels
		[Embed(source="../../json/level_chuteHard.json", mimeType="application/octet-stream")]
		private var Level_ChuteHard:Class;
		[Embed(source="../../json/level_random.json", mimeType="application/octet-stream")]
		private var Level_Random:Class;
		[Embed(source="../../json/level_islands.json", mimeType="application/octet-stream")]
		private var Level_Islands:Class;
		[Embed(source="../../json/level_swap.json", mimeType="application/octet-stream")]
		private var Level_Swap:Class;
		[Embed(source="../../json/level_sort.json", mimeType="application/octet-stream")]
		private var Level_Sort:Class;
		[Embed(source="../../json/level_propel.json", mimeType="application/octet-stream")]
		private var Level_Propel:Class;
		[Embed(source="../../json/level_needle.json", mimeType="application/octet-stream")]
		private var Level_Needle:Class;
		[Embed(source="../../json/level_rainbow.json", mimeType="application/octet-stream")]
		private var Level_Rainbow:Class;
		[Embed(source="../../json/level_lines.json", mimeType="application/octet-stream")]
		private var Level_Lines:Class;
		[Embed(source="../../json/level_roundabout.json", mimeType="application/octet-stream")]
		private var Level_Roundabout:Class;
		[Embed(source="../../json/level_claim.json", mimeType="application/octet-stream")]
		private var Level_Claim:Class;
		[Embed(source="../../json/level_clump.json", mimeType="application/octet-stream")]
		private var Level_Clump:Class;
		
		//Hard levels
		[Embed(source="../../json/level_magnet.json", mimeType="application/octet-stream")]
		private var Level_Magnet:Class;
		[Embed(source="../../json/level_circular.json", mimeType="application/octet-stream")]
		private var Level_Circular:Class;
		[Embed(source="../../json/level_air.json", mimeType="application/octet-stream")]
		private var Level_Air:Class;
		[Embed(source="../../json/level_grid.json", mimeType="application/octet-stream")]
		private var Level_Grid:Class;
		[Embed(source="../../json/level_knot.json", mimeType="application/octet-stream")]
		private var Level_Knot:Class;
		[Embed(source="../../json/level_mines.json", mimeType="application/octet-stream")]
		private var Level_Mines:Class;
		[Embed(source="../../json/level_bounce.json", mimeType="application/octet-stream")]
		private var Level_Bounce:Class;
		[Embed(source="../../json/level_multitask.json", mimeType="application/octet-stream")]
		private var Level_Multitask:Class;
		[Embed(source="../../json/level_magstack.json", mimeType="application/octet-stream")]
		private var Level_Magstack:Class;
		[Embed(source="../../json/level_slope.json", mimeType="application/octet-stream")]
		private var Level_Slope:Class;
		[Embed(source="../../json/level_junkyard.json", mimeType="application/octet-stream")]
		private var Level_Junkyard:Class;
		[Embed(source="../../json/level_journey.json", mimeType="application/octet-stream")]
		private var Level_Journey:Class;
		[Embed(source="../../json/level_panic.json", mimeType="application/octet-stream")]
		private var Level_Panic:Class;
		
		//Each element of the array is a 15-length array of levels - some of which may be undefined
		private var pages:Array;

		//Constructor called by the Engine on startup
		public function Levels() 
		{
			pages = new Array(3);
			pages[0] = new Array(15);
			pages[1] = new Array(15);
			pages[2] = new Array(15);

			// factory 1 - easy
			pages[0][0] = JSON.parse(new Level_Tut00());
			pages[0][1] = JSON.parse(new Level_Tut01());
			pages[0][2] = JSON.parse(new Level_Barrier());
			pages[0][3] = JSON.parse(new Level_Rotate());
			pages[0][4] = JSON.parse(new Level_Tut02());
			pages[0][5] = JSON.parse(new Level_Tut03());
			pages[0][6] = JSON.parse(new Level_H());
			pages[0][7] = JSON.parse(new Level_Slide());
			pages[0][8] = JSON.parse(new Level_AirTut());
			pages[0][9] = JSON.parse(new Level_TestT());
			pages[0][10] = JSON.parse(new Level_Color());
			pages[0][11] = JSON.parse(new Level_Swap());
			pages[0][12] = JSON.parse(new Level_Garbage());
			pages[0][13] = JSON.parse(new Level_Sort());
			
			// factory 2 - intermediate
			pages[1][0] = JSON.parse(new Level_Random());
			pages[1][1] = JSON.parse(new Level_Contraband());
			pages[1][2] = JSON.parse(new Level_Rainbow());
			pages[1][3] = JSON.parse(new Level_Chute());
			pages[1][4] = JSON.parse(new Level_ChuteHard());
			pages[1][5] = JSON.parse(new Level_Holder());
			pages[1][6] = JSON.parse(new Level_MagnetEasy());
			pages[1][7] = JSON.parse(new Level_Propel());
			pages[1][8] = JSON.parse(new Level_Islands());
			pages[1][9] = JSON.parse(new Level_Lines());
			pages[1][10] = JSON.parse(new Level_Roundabout());
			pages[1][11] = JSON.parse(new Level_Clump());
			pages[1][12] = JSON.parse(new Level_Claim());
			
			// factory 3 - difficult
			pages[2][0] = JSON.parse(new Level_Circular());
			pages[2][1] = JSON.parse(new Level_Knot());
			pages[2][2] = JSON.parse(new Level_Air());
			pages[2][3] = JSON.parse(new Level_Junkyard());
			pages[2][4] = JSON.parse(new Level_Needle());
			pages[2][5] = JSON.parse(new Level_Mines());
			pages[2][6] = JSON.parse(new Level_Grid());
			pages[2][7] = JSON.parse(new Level_Bounce());
			pages[2][8] = JSON.parse(new Level_Journey());
			pages[2][9] = JSON.parse(new Level_Slope());
			pages[2][10] = JSON.parse(new Level_Multitask());
			pages[2][11] = JSON.parse(new Level_Magstack());
			pages[2][12] = JSON.parse(new Level_Magnet());
			pages[2][13] = JSON.parse(new Level_Panic());
		}

		/**
		 *	Returns the number of level pages
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
		public function hasLevel(page:int, index:int):Boolean
		{
			return pages[page][index] != undefined;
		}

		/**
		 *	Returns the level on that page and index as a dictionary.
		 *	@param	page	The page the level is on
		 *	@param	index	The index of the level on its page, 0-14
		 *	@returns	The level on that page at that index
		 */
		public function getLevel(page:int, index:int):Object
		{
			return pages[page][index];
		}
		
		/**
		 *	Returns the next level on that page and index as an array.
		 *	@param	page	The page the level is on
		 *	@param	index	The index of the level on its page, 0-14
		 *	@returns	The level on that page at that index
		 */
		public function getNextLevel(page:int, index:int):Array
		{
			if (++index == pages[page].length || pages[page][index] == null)
				return null;
			return [pages[page][index], page, index];
		}
	}
}
