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
		
		private var selectedLevel:int = -1;
		
		public function ContainerIntro(_eng:Engine, _showLevels:Boolean, _page:int)
		{
			trace("_showLevels = " + _showLevels);
			
			super();
			eng = _eng;
			page = _page;
			
			// set up the MovieCllip
			swc = new SWC_ContainerMenu();
			addChild(swc);
			
			swc.mc_levels.tf_levelname.text = "Pick a level!";
			
			// attach listeners for each factory
			swc.mc_main.bg.btn_factory0.addEventListener(MouseEvent.CLICK, onFactory);
			swc.mc_main.bg.btn_factory1.addEventListener(MouseEvent.CLICK, onFactory);
			
			swc.mc_levels.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			
			swc.mc_levels.gotoAndStop(1);
			swc.mc_levels.visible = _showLevels;		// hide/show level select screen
			
			swc.mc_levels.btn_start.addEventListener(MouseEvent.CLICK, onStart);
			//swc.mc_levels.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			
			// set up level buttons
			levelButtons = [swc.mc_levels.level_0, swc.mc_levels.level_1, swc.mc_levels.level_2,
							swc.mc_levels.level_3, swc.mc_levels.level_4, swc.mc_levels.level_5,
							swc.mc_levels.level_6, swc.mc_levels.level_7, swc.mc_levels.level_8,
							swc.mc_levels.level_9, swc.mc_levels.level_10, swc.mc_levels.level_11,
							swc.mc_levels.level_12, swc.mc_levels.level_13, swc.mc_levels.level_14];
			initLevels();
		}
		
		private function onFactory(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "btn_factory0":
					swc.mc_main.gotoAndPlay("factoryOne");
					page = 0;
				break;
				case "btn_factory1":
					swc.mc_main.gotoAndPlay("factoryTwo");					
					page = 1;
				break;
			}
			swc.mc_levels.gotoAndPlay(2);
			initLevels();
		}
		
		private function initLevels():void
		{
			// attach listeners to each level button's hitbox and set text fields
			for (var i:int = 0; i < levelButtons.length; i++)
			{
				levelButtons[i].hitbox.addEventListener(MouseEvent.CLICK, onLevel);
				levelButtons[i].visible = eng.levels.hasLevel(page, i);	// hide the button if the level doesn't exist
				
				if (levelButtons[i].visible)
				{
					var obj:Object = eng.levels.getLevel(page, i);
					levelButtons[i].tf_level.text = String(i + 1);
					//levelButtons[i].tf_level.text = (eng.levels.getLevel(page, i))["meta"]["name-external"];
				}
			}
			
			eng.page = page;
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
		private function onLevel(e:MouseEvent):void
		{			
			for (var i:int = 0; i < levelButtons.length; i++)
				levelButtons[i].gotoAndStop(1);
			e.target.parent.gotoAndStop(2);

			// get the index of the button clicked (0-15)
			selectedLevel = int(MovieClip(e.target).parent.name.substring(6));		// name is in format of level_xx
			
			// set the level in the engine
			eng.level = eng.levels.getLevel(page, selectedLevel);
			
			swc.mc_levels.tf_levelname.text = (eng.levels.getLevel(page, selectedLevel))["meta"]["name-external"];
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
			for (var i:int = 0; i < levelButtons.length; i++)
				levelButtons[i].gotoAndStop(1);
			swc.mc_levels.tf_levelname.text = "Pick a level!";
		}
		
		/**
		 * Called when a level button is clicked, from the level menu
		 * @param	e		the captured MouseEvent, used to find out which button was pressed
		 */
		private function onStart(e:MouseEvent):void
		{
			// clean up resources
			swc.removeEventListener(MouseEvent.CLICK, onStart);
			removeChild(swc);
			swc = null;
			for (var i:int = 0; i < levelButtons.length; i++)
				levelButtons[i].hitbox.removeEventListener(MouseEvent.CLICK, onLevel);
			levelButtons = null;

			// flag this Container as completed for the Engine
			completed = true;
			
			// remove reference to Engine
			eng = null;
		}
	}
}
