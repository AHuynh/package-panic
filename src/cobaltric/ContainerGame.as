package cobaltric
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import packpan.ABST_GameObject;
	import packpan.nodes.*;
	import packpan.mails.*;
	import packpan.PP;
	import packpan.PhysicsUtils;
	
	/**
	 * Primary game container and controller.
	 * Reads the given XML file to create a level.
	 * 
	 * Note:	All coordinates use x positive right and y positive down. GRID_ORIGIN is the top left corner.
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerGame extends ABST_Container
	{		
		public var engine:Engine;					// the game's Engine
		public var game:SWC_ContainerGame;			// the Game SWC, containing all the base assets

		public var cursor:MovieClip;
		
		public var nodeGrid:Array;		// a 2D array containing either null or the node at a (x, y) grid location
		public var nodeArray:Array;		// a 1D array containing all ABST_Node objects
		public static var mailArray:Array;		// a 1D array containing all ABST_Mail objects
		
		protected static var gameState:int;		// state of game using PP.as constants
		
		// allows getDefinitionByName to work
		private var ncn:NodeConveyorNormal;
		private var ncr:NodeConveyorRotate;
		private var nbr:NodeBarrier;
		private var at:NodeAirTable;
		private var nb:NodeBin;
		private var nc:NodeChute;
		
		// timer
		public var timerTick:Number = 1000 / 30;		// time to take off per frame
		public const SECOND:int = 1000;
		public var timeLeft:Number = 30 * SECOND;
		
		// XML
		private var levelXML:String;
		private var loader:URLLoader;
		private var xml:XML;
		
		public function ContainerGame(eng:Engine, _levelXML:String)
		{
			super();
			engine = eng;
			levelXML = _levelXML;
			addEventListener(Event.ADDED_TO_STAGE, init);		// set up after added to stage

			gameState = PP.GAME_SETUP;
		}
		
		/**
		 *	Sets up the game.
		 * 	Called after this Container is added to the stage.
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			// disable right click menu
			stage.showDefaultContextMenu = false;
	
			// setup the Game SWC
			game = new SWC_ContainerGame();
			game.x = 400; game.y = 300;
			addChild(game);
			
			game.btn_retry.addEventListener(MouseEvent.CLICK, onRetry);
			game.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			game.mc_overlay.visible = false;
			// end Game SWC setup

			// cursor
			/*cursor = new GameCursor();
			game.mc_gui.addChild(cursor);
			cursor.visible = false;*/
			
			// setup node and mail arrays
			nodeGrid = [];
			for (var i:int = 0; i <= PP.DIM_X_MAX; i++)		// going from left to right
			{
				nodeGrid.push([]);
				for (var j:int = 0; j <= PP.DIM_Y_MAX; j++)	// going from top to bottom		
					nodeGrid[i].push(null);
			}
			nodeArray = [];
			mailArray = [];
			
			// ----------------------------------------------------------------------------------------
			// TODO: remove this hack
			var temp:Array = [];
			temp.push(new NodeBarrier(this, 
				{"type": "NodeBarrier", "x": 1, "y": 5}));
			temp.push(new NodeConveyorNormal(this, 
				{"type": "NodeConveyorNormal", "x": 2, "y": 5, "dir": "left", "clickable": "true"}));
			temp.push(new NodeConveyorNormal(this, 
				{"type": "NodeConveyorNormal", "x": 3, "y": 5, "dir": "right", "clickable": "true"}));
			temp.push(new NodeConveyorNormal(this, 
				{"type": "NodeConveyorNormal", "x": 4, "y": 5, "dir": "left", "clickable": "true"}));
			temp.push(new NodeBin(this, 	
				{"type": "NodeBin", "x": 5, "y": 5, "color": "blue"}));
				
			var tempN:ABST_GameObject;
			for (i = 0; i < temp.length; i++)
			{
				tempN = temp[i];
				nodeGrid[tempN.position.x][tempN.position.y] = tempN;
				nodeArray.push(tempN);
			}
			
			mailArray.push(new MailColored(this, { "type": "MailColored", "x": 2, "y": 5, "color": "blue"} ));
			
			// -- <time>
			var timeRaw:String = "1:00";
			timeLeft = int(timeRaw.substring(0, 1)) * 60000 + int(timeRaw.substring(2)) * 1000;
			
			// start the game
			gameState = PP.GAME_IDLE;
			
			// end testing hack
			// ----------------------------------------------------------------------------------------
			
			loader = new URLLoader();								// TODO: Change to JSON - disabled for testing!
			loader.load(new URLRequest("../json/level1.json"));
			loader.addEventListener(Event.COMPLETE, parseJSON);
			
			
			// start loading XML
			/*loader = new URLLoader();								// TODO: Change to JSON - disabled for testing!
			loader.load(new URLRequest(levelXML));
			loader.addEventListener(Event.COMPLETE, parseXML);*/
		}
		
		/**
		 * Create the level based off of JSON.
		 * @param	e		the captured Event, used to access JSON data
		 */
		private function parseJSON(e:Event):void
		{
			var json:Object = JSON.parse(e.target.data);
			
			// validate list of nodes
			if (!json["nodes"])
			{
				trace("ERROR: JSON file is missing \"nodes\"!");
				completed = true;
				return;
			}
			// for each entry in "nodes", add the object
			for each (var nodeRaw:Object in json["nodes"])
			{
				try
				{
					if (nodeRaw["type"] == "NodeGroupRect")
					{
						var NodeClass:Class = getDefinitionByName(nodeRaw["subtype"]) as Class;
						var node:ABST_Node = new NodeClass(this, nodeRaw);
					}
					else
					{
						var NodeClass:Class = getDefinitionByName(nodeRaw["type"]) as Class;
						var node:ABST_Node = new NodeClass(this, nodeRaw);
					}
				} catch (e:Error)
				{
					trace("ERROR: Invalid node.\n" + e.getStackTrace());
				}
			}
		}

		/**
		 * Adds a single Node to the level.
		 * @param	node	The Node to add to the level.
		 */
		public function addNode(node:ABST_Node):void
		{
			nodeGrid[node.position.x][node.position.y] = node;
			nodeArray.push(node);
		}
		
		/**
		 * 
		 * @param	nodeClass
		 * @param	json
		 * @param	start		the grid coordinates to begin from
		 * @param	end			the grid coordinates to end at, inclusive
		 */
		public function addNodeGroupRect(nodeClass:Class, json:Object, start:Point, end:Point):void
		{
			// ensure we go from low to high for the for loops to work
			if (start.x > end.x)
			{
				var tx:int = start.x;
				start.x = end.x;
				end.x = tx;
			}
			if (start.y > end.y)
			{
				var ty:int = start.y;
				start.y = end.y;
				end.y = ty;
			}
			
			var ng:NodeGroup = new NodeGroup();
			for (var i:int = start.x; i <= end.x; i++)
				for (var j:int = start.y; j <= end.y; j++)
					ng.addToGroup(new nodeClass(this, json));
			ng.setupListeners();
		}
		
		/**
		 * Adds the given MovieClip to holder_main aligned to the grid based on position.
		 * @param	mc			the MovieClip to add
		 * @param	position	the grid coordinate to use (0-based, top-left origin, U/D x, L/R y)
		 * @return				mc
		 */
		public function addChildToGrid(mc:MovieClip, position:Point):MovieClip
		{
			var positionOnScreen:Point = PhysicsUtils.gridToScreen(position);
			mc.x = positionOnScreen.x;
			mc.y = positionOnScreen.y;
			game.holder_main.addChild(mc);
			return mc;
		}
		
		/**
		 * Removes the given MovieClip from holder_main, if applicable
		 * @param	mc			the MovieClip to remove
		 * @return				mc
		 */
		public function removeChildFromGrid(mc:MovieClip):MovieClip
		{
			if (game.holder_main.contains(mc))
				game.holder_main.removeChild(mc);
			return mc;
		}
		
		/**
		 * called by Engine every frame
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{
			// TODO use custom cursor
			//cursor.x = mouseX - game.x;
			//cursor.y = mouseY - game.y;
			
			if (gameState == PP.GAME_SETUP)		// if still loading, quit
				return completed;

			// if the game state is idle, update everything and check for failure/success
			if(gameState == PP.GAME_IDLE) {

				// update the timer and check for time up
				timeLeft = Math.max(timeLeft-timerTick,0);
				game.tf_timer.text = updateTime();
				if(timeLeft == 0)
					setStateFailure();

				// step all nodes
				for each (var node:ABST_Node in nodeArray)
					node.step(); // TODO - check return state	

				// step all Mail
				var allSuccess:Boolean = true;			// check if all Mail is in success state				
				var mailFailure:Boolean = false;		// check if any Mail is in failure state
				for each (var mail:ABST_Mail in mailArray)
				{
					var mailState:int = mail.step();
					if (mailState != PP.MAIL_SUCCESS)
						allSuccess = false;
					if (mailState == PP.MAIL_FAILURE)
						mailFailure = true;
				}

				// check for success
				if (allSuccess)
					setStateSuccess();

				// check for failure
				if(mailFailure)
					setStateFailure();

			}

			//puzzleStep();
			
			return completed;
		}

		/**
		 * Changes the state of the game to success and displays the overlay
		 */
		private function setStateSuccess():void
		{
			gameState = PP.GAME_SUCCESS;	// mark the level as done
			game.mc_overlay.visible = true;	// show the success screen
			timerTick = 0;			// halt the timer
		}

		/**
		 * Changes the state of the game to failure and displays the overlay
		 */
		private function setStateFailure():void
		{
			gameState = PP.GAME_FAILURE;	// mark the level as done
			game.mc_overlay.visible = true;	// show the failure screen
			game.mc_overlay.tf_status.text = "Failure!";
			timerTick = 0;			// halt the timer
		}
		
		/**
		 * Provides a formatted string based on the current time left (timeLeft)
		 * @return		a M:SS.ms formatted-string
		 */
		private function updateTime():String
		{
			var timeMin:int = int(timeLeft / 60000);
			var timeSec:int = int((timeLeft - timeMin * 60000) * .001);
			var timeMSec:int = int((timeLeft - timeMin * 60000 - timeSec * 1000) * .1);
			return timeMin + ":" +
				  (timeSec < 10 ? "0" : "" ) + timeSec + "." +
				  (timeMSec < 10 ? "0" : "" ) + timeMSec;
		}
		
		/**
		 * The to-be-implemented step() function for this specific puzzle.
		 * @return	completed, true if this container is done
		 */
		/*protected function puzzleStep():void
		{
			// -- OVERRIDE THIS FUNCTION
		}*/
		
		/*protected function overButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip_over");
		}*/
		
		/*protected function onButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip");
		}*/
		
		/**
		 * Called when the Retry button is clicked.
		 * @param	e		the captured MouseEvent, unused
		 */
		protected function onRetry(e:MouseEvent):void
		{
			completed = true;
			// TODO retry logic
			destroy(null);
		}
		
		/**
		 * Called when the Quit button is clicked.
		 * @param	e		the captured MouseEvent, unused
		 */
		protected function onQuit(e:MouseEvent):void
		{
			completed = true;
			destroy(null);
		}
		
		/**
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			game.btn_retry.removeEventListener(MouseEvent.CLICK, onRetry);
			game.btn_quit.removeEventListener(MouseEvent.CLICK, onQuit);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			Mouse.show();
			
			// TODO additional cleanup
		}
	}
}
