package cobaltric
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * Main menu and level select screen.
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerIntro extends ABST_Container
	{
		public var swc:SWC_ContainerMenu;	// the actual MovieClip
		private var eng:Engine;				// a reference to the Engine
		
		private var levelButtons:Array;		// list of level buttons
		private var page:int = 0;			// current page of 15 levels; also the first index into eng.levelArray
		
		public function ContainerIntro(_eng:Engine, _showLevels:Boolean)
		{
			super();
			eng = _eng;
			
			// set up the MovieCLlip
			swc = new SWC_ContainerMenu();
			addChild(swc);
			
			swc.mc_levels.visible = _showLevels;		// hide/show level select screen
			
			swc.mc_main.btn_start.addEventListener(MouseEvent.CLICK, onStart);
			swc.mc_levels.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			
			// set up level buttons
			levelButtons = [swc.mc_levels.level_0, swc.mc_levels.level_1, swc.mc_levels.level_2,
							swc.mc_levels.level_3, swc.mc_levels.level_4, swc.mc_levels.level_5,
							swc.mc_levels.level_6, swc.mc_levels.level_7, swc.mc_levels.level_8,
							swc.mc_levels.level_9, swc.mc_levels.level_10, swc.mc_levels.level_11,
							swc.mc_levels.level_12, swc.mc_levels.level_13, swc.mc_levels.level_14];
							
			// attach listeners to each level button's hitbox and set text fields
			for (var i:int = 0; i < levelButtons.length; i++)
			{
				levelButtons[i].hitbox.addEventListener(MouseEvent.CLICK, onLevel);
				levelButtons[i].tf_level.text = (i + 1);						// TODO get actual level name
				levelButtons[i].visible = i < eng.levelArray[page].length;		// hide button if level doesn't exist for this index
			}
		}
		
		/*private function onButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip");
		}*/
		
		/*private function overButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip_over");
		}*/
		
		/**
		 * Called when the Start button is clicked, from the main menu
		 * Displays the level screen
		 * 
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onStart(e:MouseEvent):void
		{
			swc.mc_levels.visible = true;
		}
		
		/**
		 * Called when the Quit button is clicked, from the level menu
		 * Hides the level screen
		 * 
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onQuit(e:MouseEvent):void
		{
			swc.mc_levels.visible = false;
		}
		
		/**
		 * Called when a level button is clicked, from the level menu
		 * @param	e		the captured MouseEvent, used to find out which button was pressed
		 */
		private function onLevel(e:MouseEvent):void
		{
			// clean up resources
			swc.removeEventListener(MouseEvent.CLICK, onStart);
			removeChild(swc);
			swc = null;
			for (var i:int = 0; i < levelButtons.length; i++)
				levelButtons[i].hitbox.removeEventListener(MouseEvent.CLICK, onLevel);
			levelButtons = null;
			
			// get the index of the button clicked (0-15)
			var ind:int = int(MovieClip(e.target).parent.name.substring(6));		// level_xx
			
			// get the name of the level AS3 file
			eng.levelClass = "packpan.levels." + eng.levelArray[page][ind];
			
			// flag this Container as completed for the Engine
			completed = true;
			
			// remove reference to Engine
			eng = null;
		}
	}
}
