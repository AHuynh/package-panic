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
			super();
			eng = _eng;
			page = _page;
			
			// set up the MovieCllip
			swc = new SWC_ContainerMenu();
			addChild(swc);
			
			// set up the main menu
			swc.mc_main.bg.btn_credits.addEventListener(MouseEvent.CLICK, onCredits);
			swc.credits.btn_back.addEventListener(MouseEvent.CLICK, onCreditsBack);
			
			// attach listeners for each factory
			swc.mc_main.bg.btn_factory0.addEventListener(MouseEvent.CLICK, onFactory);
			swc.mc_main.bg.btn_factory1.addEventListener(MouseEvent.CLICK, onFactory);
			swc.mc_main.bg.btn_factory2.addEventListener(MouseEvent.CLICK, onFactory);
			
			// set up the level menu
			swc.credits.visible = false;
			swc.mc_levels.tf_levelname.text = "Pick a level!";
			
			swc.mc_levels.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			swc.mc_levels.gotoAndStop(1);
			swc.mc_levels.visible = _showLevels;		// hide/show level select screen		
			
			// set up level buttons in the level menu
			levelButtons = [swc.mc_levels.level_0, swc.mc_levels.level_1, swc.mc_levels.level_2,
							swc.mc_levels.level_3, swc.mc_levels.level_4, swc.mc_levels.level_5,
							swc.mc_levels.level_6, swc.mc_levels.level_7, swc.mc_levels.level_8,
							swc.mc_levels.level_9, swc.mc_levels.level_10, swc.mc_levels.level_11,
							swc.mc_levels.level_12, swc.mc_levels.level_13, swc.mc_levels.level_14];
			initLevels();
		}
		
		/**
		 * Called by the CREDITS button in the main menu; shows the credits
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onCredits(e:MouseEvent):void
		{
			swc.credits.visible = true;
		}
		
		/**
		 * Called by the BACK button in the credits screen; hides the credits
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onCreditsBack(e:MouseEvent):void
		{
			swc.credits.visible = false;
		}
		
		/**
		 * Called by a factory in the main menu; shows the relevant levels
		 * @param	e		the captured MouseEvent
		 */
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
				case "btn_factory2":
					swc.mc_main.gotoAndPlay("factoryThree");					
					page = 2;
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
				levelButtons[i].hitbox.addEventListener(MouseEvent.MOUSE_OVER, overLevel);
				levelButtons[i].hitbox.addEventListener(MouseEvent.MOUSE_OUT, outLevel);
				levelButtons[i].hitbox.addEventListener(MouseEvent.CLICK, onLevel);
				levelButtons[i].visible = eng.levels.hasLevel(page, i);	// hide the button if the level doesn't exist
				
				if (levelButtons[i].visible)
				{
					var obj:Object = eng.levels.getLevel(page, i);
					levelButtons[i].tf_level.text = String(i + 1);		// set number on the button
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
		 * Called when the mouse enters a level button.
		 * Lights up the elevator button, sets the title, and prepares internal variables relevant to level selection.
		 * 
		 * @param	e		the captured MouseEvent, unused
		 */
		private function overLevel(e:MouseEvent):void
		{			
			for (var i:int = 0; i < levelButtons.length; i++)	// turn off all lights
				levelButtons[i].gotoAndStop(1);
			e.target.parent.gotoAndStop(3);						// turn on this light

			// get the index of the button clicked (0-15)
			selectedLevel = int(MovieClip(e.target).parent.name.substring(6));		// name is in format of level_xx
			
			// set the level in the engine
			eng.level = eng.levels.getLevel(page, selectedLevel);
			
			// set title
			swc.mc_levels.tf_levelname.text = (eng.levels.getLevel(page, selectedLevel))["meta"]["name-external"];
		}
		
		/**
		 * Called when the mouse leaves a level button.
		 * Turns off the elevator button lights and resets the title.
		 * 
		 * @param	e		the captured MouseEvent, unused
		 */
		private function outLevel(e:MouseEvent):void
		{
			for (var i:int = 0; i < levelButtons.length; i++)		// turn off all lights
				levelButtons[i].gotoAndStop(1);
			swc.mc_levels.tf_levelname.text = "Pick a level!";		// reset title
		}
		
		/**
		 * Called by the QUIT button in the level menu.
		 * Hides the level screen.
		 * 
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onQuit(e:MouseEvent):void
		{
			swc.mc_levels.visible = false;
			outLevel(e);
		}
		
		/**
		 * Called by an elevator button in the level menu.
		 * Starts the level.
		 * @param	e		the captured MouseEvent, used to find out which button was pressed
		 */
		private function onLevel(e:MouseEvent):void
		{
			// clean up resources
			removeChild(swc);
			swc = null;
			for (var i:int = 0; i < levelButtons.length; i++)
			{
				levelButtons[i].hitbox.removeEventListener(MouseEvent.MOUSE_OVER, overLevel);
				levelButtons[i].hitbox.removeEventListener(MouseEvent.MOUSE_OUT, outLevel);
				levelButtons[i].hitbox.removeEventListener(MouseEvent.CLICK, onLevel);
			}
			levelButtons = null;

			// flag this Container as completed for the Engine
			completed = true;
			
			// remove reference to Engine
			eng = null;
		}
	}
}
