package cobaltric
{
	import flash.automation.StageCapture;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import packpan.PP;
	
	/** 
	 * Primary game loop event firer and state machine.
	 * 
	 * @author Alexander Huynh
	 */
	public class Engine extends MovieClip
	{
		private var gameState:int;				// 0:Intro, 1:Game, 2:Outro
		private var container:ABST_Container;	// the currently active container
		
		public var levelName:String;			// the name of the level XML to load next
		
		// save data
		public const SAVE_DATA:String = "PACK_PAN";
		public var saveData:SharedObject = SharedObject.getLocal(SAVE_DATA, "/");
		
		// XML
		private var loader:URLLoader;
		private var xml:XML;
		
		// A 2D array of arrays corresponding to levels
		// first index is page (0+)
		// second index is slot (0-15)
		// element is [file_name, level_title], both strings
		public var levelArray:Array;
		
		public function Engine()
		{
			// try to load save data
			/*if (saveData.data.sd_isValid)
			{
				scoreData = [];
				for (var i:int = 0; i < 8; i++)
				{
					scoreData.push([saveData.data.sd_name[i],
									saveData.data.sd_day[i],
									saveData.data.sd_money[i]]);
				}
			}
			else
				newGame();*/
				
			gameState = 0;
			
			//SoundPlayer.playBGM(true);
			
			// start loading XML
			loader = new URLLoader();
			loader.load(new URLRequest("../xml/master_level_list.xml"));
			loader.addEventListener(Event.COMPLETE, parseXML);
		}

		/**
		 * Create the level based off of XML.
		 * @param	e		the captured Event, used to access XML data
		 */
		private function parseXML(e:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, parseXML);
			
			xml = new XML(e.target.data);
			levelArray = [];
			for (var i:int = 0; i < xml.puzzle.length(); i++)
			{
				trace(xml.puzzle[i]);
				var file:String = xml.puzzle[i].id;
				var title:String = xml.puzzle[i].name;
				var page:int = xml.puzzle[i].page - 1;
				var slot:int = xml.puzzle[i].slot - 1;
				if (slot < 0 || slot > PP.DIM_LEVEL_MAX)
					trace("ERROR: Slot for " + int(title + 1) + " is out of bounds! (0-" + PP.DIM_LEVEL_MAX);
				while (levelArray.length <= page)
					levelArray.push([null, null, null, null, null, null, null, null,
									 null, null, null, null, null, null, null]);
				levelArray[page][slot] = [file, title];
			}
			
			// finish setup
			addEventListener(Event.ENTER_FRAME, step);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			container = new ContainerIntro(this, false);
			addChild(container);

			// center the container
			container.x = 0;
			container.y = 0;
		}
		
		/*public function newGame():void
		{
			save();
			// new data here
		}*/
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * to the next one if the current container is complete.
		 * 
		 * Begins after XML is parsed.
		 * 
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			if (!container.step())		// step the current container, quit if it's not done
				return;
				
			removeChild(container);		// remove the current, completed container
			
			switch (gameState)			// determine which new container to go to next
			{
				case 0:
					container = new ContainerGame(this, "../xml/" + levelName + ".xml");
					gameState = 1;
					//SoundPlayer.stopBGM();
				break;
				case 1:
					container = new ContainerIntro(this, true);
					gameState = 0;
				break;
			}
			
			addChild(container);		// add the new container
		}
		
		/**
		 * Helper to init the global keyboard listener (quality buttons)
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		/**
		 * Global keyboard listener, used to listen for quality buttons
		 * 
		 * @param	e	the captured KeyboardEvent, used to find the pressed key
		 */
		private function onKeyPress(e:KeyboardEvent):void
		{
			if (!container.stage)
				return;
			if (e.keyCode == 76)		// -- l
				container.stage.quality = StageQuality.LOW;
			else if (e.keyCode == 77)	// -- m
				container.stage.quality = StageQuality.MEDIUM;
			else if (e.keyCode == 72)	// -- h
				container.stage.quality = StageQuality.HIGH;
		}
		
		/*public function save(scoreData:Array = null):void
		{ 
			saveData.clear();
			if (!scoreData)
				// init new score Data
			saveData.data.sd_isValid = true;
			saveData.flush();
		}*/
	}
	
}
