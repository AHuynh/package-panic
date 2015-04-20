package cobaltric
{
	import cobaltric.SoundManager;
	import packpan.Levels;
	import packpan.PP;
	import flash.automation.StageCapture;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/** 
	 * Primary game loop event firer and state machine.
	 * 
	 * @author Alexander Huynh
	 */
	public class Engine extends MovieClip
	{
		private var gameState:int;					// state machine helper
		private var containerMenu:ContainerIntro;	// the menu container
		private var containerGame:ABST_Container;	// the game container
		
		private var nextState:Boolean = false;		// if true, proceed to the next state

		// Levels
		public var levels:Levels;		// Level manager class
		public var level:Object;		// dictionary read from json
		public var page:int = 1;		// remember the page
		public var levelInd:int = 1;	// remember the level
		public var retryFlag:Boolean;	// if true, retry the level
		public var nextFlag:Boolean;	// if true, move on to the next level
		
		/**
		 * MovieClip holding and controlling everything.
		 */
		public function Engine()
		{				
			gameState = 0;

			// parse the embedded levels
			levels = new Levels();
			
			// finish setup
			addEventListener(Event.ENTER_FRAME, step);				// primary game loop firer
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			containerMenu = new ContainerIntro(this, false, page);
			addChild(containerMenu);

			// center the container
			containerMenu.x = 0;
			containerMenu.y = 0;
			
			// play BGM
			SoundManager.playBGM("main");
		}
		
		/**
		 * Called by ContainerIntro to signal that a level is starting.
		 */
		public function menuOver():void
		{
			gameState = 0;
			nextState = true;
		}
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * to the next one if the current container is complete.
		 * 
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			if (containerMenu && containerMenu.step())
			{
				removeChild(containerMenu);
				containerMenu = null;
			}
		
			if (containerGame && containerGame.step())
			{
				removeChild(containerGame);
				containerGame = null;
				nextState = true;
			}
			
			if (!nextState)
				return;
			nextState = false;
			
			SoundManager.shutUp();
				
			switch (gameState)			// determine which new container to go to next
			{
				case 0:
					containerGame = new ContainerGame(this, level, true);
					gameState = 1;
					SoundManager.play("sfx_elevator");
					startBGM();
					addChildAt(containerGame, 0);
				break;
				case 1:
					if (retryFlag)
					{
						containerGame = new ContainerGame(this, level, false);
						addChildAt(containerGame, 0);
						startBGM();
					}
					else if (nextFlag)
					{
						var next:Array = levels.getNextLevel(page, levelInd);
						if (next == null)
						{
							containerMenu = new ContainerIntro(this, true, page);
							addChild(containerMenu);
							gameState = 0;
							levelInd = 0;
							SoundManager.playBGM("main");
							return;
						}
						page = next[1];
						levelInd = next[2];
						level = next[0];
						containerGame = new ContainerGame(this, level, false);
						addChildAt(containerGame, 0);
						startBGM();
					}
					else
					{
						containerMenu = new ContainerIntro(this, true, page);
						addChild(containerMenu);
						SoundManager.playBGM("main");
						gameState = 0;
					}
					retryFlag = nextFlag = false;
				break;
			}		
		}
		
		/**
		 * Helper to init the global keyboard listener (quality buttons)
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		/**
		 * Global keyboard listener, used to listen for quality hotkeys.
		 * 
		 * @param	e	the captured KeyboardEvent, used to find the pressed key
		 */
		private function onKeyPress(e:KeyboardEvent):void
		{
			if (!stage)
				return;
			if (e.keyCode == 76)		// -- l
				stage.quality = StageQuality.LOW;
			else if (e.keyCode == 77)	// -- m
				stage.quality = StageQuality.MEDIUM;
			else if (e.keyCode == 72)	// -- h
				stage.quality = StageQuality.HIGH;
		}
		
		/**
		 * Starts the BGM for a level, based on what factory we were in.
		 */
		private function startBGM():void
		{
			switch (page)
			{
				case 0:		SoundManager.playBGM("bgm_cb");		break;
				case 1:		SoundManager.playBGM("bgm_pp");		break;
				case 2:		SoundManager.playBGM("bgm_pl");		break;
			}
		}
	}
	
}
