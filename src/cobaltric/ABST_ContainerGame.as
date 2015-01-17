package cobaltric
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import packpan.nodes.*;
	import packpan.levels.*;
	import packpan.mails.*;
	import packpan.PP;
	
	/**
	 * Primary game container and controller. The base class for a level.
	 * Extended into packpan/levels to create a level. (Override setUp()).
	 * 
	 * Note:	All coordinates except actual locations (i.e. movieclip.x) use x as up/down, y as left/right.
	 * 			Origin is top-left corner. Dimensions are 10 x 15 (indexes 0-9 and 0-14)
	 * 
	 * @author Alexander Huynh
	 */
	public class ABST_ContainerGame extends ABST_Container
	{		
		public var engine:Engine;					// the game's Engine
		public var game:SWC_ContainerGame;			// the Game SWC, containing all the base assets

		public var cursor:MovieClip;
		
		// grid is 10 (x as up/down) by 15 (y as left/right)
		protected const GRID_ORIGIN:Point = new Point(-350, -260);		// actual x, y coordinate of upper-left grid
		protected const GRID_SIZE:int = 50;								// grid square size
		
		public var nodeGrid:Array;		// a 2D array containing either null or the node at a (x, y) grid location
		public var nodeArray:Array;		// a 1D array containing all ABST_Node objects
		public var mailArray:Array;		// a 1D array containing all ABST_Mail objects
		
		protected var gameState:int;	// state of game using PP.as constants
		
		// allows getDefinitionByName to work
		private var ncn:NodeConveyorNormal;
		private var nb:NodeBin;
		
		// timer
		public var timerTick:Number = 1000 / 30;		// time to take off per frame
		public const SECOND:int = 1000;
		public var timeLeft:Number = 30 * SECOND;
		
		// TODO more definitions here
	
		public function ABST_ContainerGame(eng:Engine)
		{
			super();
			engine = eng;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			gameState = PP.GAME_IDLE;
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
			for (var i:int = 0; i < 10; i++)		// going top to bottom
			{
				nodeGrid.push([]);
				for (var j:int = 0; j < 15; j++)	// going from left to right		
					nodeGrid[i].push(null);
			}
			nodeArray = [];
			mailArray = [];
			
			// call level-specific constructir
			setUp();
		}
		
		/**
		 * Level-specific constructor
		 * Override this in individual levels to create Node and Mail objects.
		 */
		protected function setUp():void
		{
			// -- OVERRIDE THIS FUNCTION
			
			// -- examples
			
			// create a single conveyor at (2, 9) facing UP
			//addNode(new Point(2, 9), "packpan.nodes.NodeConveyorNormal", PP.DIR_UP, true);
			
			// create a long conveyor from (4, 4) to (4, 9) facing RIGHT
			//addLineOfNodes(new Point(4, 4), new Point(4, 9), "packpan.nodes.NodeConveyorNormal").setDirection(PP.DIR_RIGHT);
			
			// create a bin at (3, 3)
			//addNode(new Point(3, 3), "packpan.nodes.NodeBin");

			// create a package at (2, 0)
			//mailArray.push(new MailNormal(this, "default", new Point(2, 0)));
		}
		
		/**
		 * Creates a single Node
		 * @param	position	the grid coordinates to place this Node
		 * @param	type		the name of the ABST_Node class to use - must use fully-qualified name! (with package .'s) 
		 * @param	facing		OPTIONAL - the direction to face this Node in
		 * @return				the Node created
		 */
		public function addNode(position:Point, type:String, facing:int = PP.DIR_NONE, clickable:Boolean = false):ABST_Node
		{
			var NodeClass:Class = getDefinitionByName(type) as Class;
			var node:ABST_Node = new NodeClass(this, type.substring(type.lastIndexOf('.') + 1),
											   new Point(position.x, position.y), facing, clickable);
			nodeGrid[position.x][position.y] = node;
			nodeArray.push(node);
			return node;
		}
		
		/**
		 * Creates a line of grouped Nodes
		 * @param	start		the grid coordinates to begin from
		 * @param	end			the grid coordinates to end at, inclusive
		 * @param	type		the name of the ABST_Node class to use - must use fully-qualified name! (with package .'s)
		 * @return				the NodeGroup created
		 */
		public function addLineOfNodes(start:Point, end:Point, type:String):NodeGroup
		{
			var ng:NodeGroup = new NodeGroup();
			
			var NodeClass:Class = getDefinitionByName(type) as Class;
			var node:ABST_Node;
			
			for (var i:int = start.x; i <= end.x; i++)
				for (var j:int = start.y; j <= end.y; j++)
				{
					node = new NodeClass(this, type.substring(type.lastIndexOf('.') + 1), new Point(i, j), PP.DIR_NONE, false);
					nodeGrid[i][j] = node;
					nodeArray.push(node);
					ng.addToGroup(node);
				}
			ng.setupListeners();

			return ng;
		}
		
		/**
		 * Adds the given MovieClip to holder_main aligned to the grid based on position.
		 * @param	mc			the MovieClip to add
		 * @param	position	the grid coordinate to use (0-based, top-left origin, U/D x, L/R y)
		 * @return				mc
		 */
		public function addChildToGrid(mc:MovieClip, position:Point):MovieClip
		{
			mc.x = GRID_ORIGIN.x + GRID_SIZE * position.y;
			mc.y = GRID_ORIGIN.y + GRID_SIZE * position.x;
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
			
			// step all Mail
			var i:int;
			var mail:ABST_Mail;
			var allSuccess:Boolean = true;					// check if all Mail is in success state
			if (mailArray.length > 0)
				for (i = mailArray.length - 1; i >= 0; i--)
				{
					mail = mailArray[i];
					var mailState:int = mail.step();		// step this Mail
					if (gameState != PP.GAME_FAILURE)		// check and update states
					{
						if (mailState != PP.MAIL_SUCCESS)
							allSuccess = false;
						if (mailState == PP.MAIL_FAILURE)
						{
							gameState = PP.GAME_FAILURE;		// TODO move this code into a method
							game.mc_overlay.visible = true;
							game.mc_overlay.tf_status.text = "Failure!";
							timerTick = 0;			// halt the timer
							
						}
					}
				}
			if (allSuccess && timerTick != 0)	// if all packages are in a success state and the level isn't done
			{
				gameState = PP.GAME_SUCCESS;	// mark the level as done
				game.mc_overlay.visible = true;	// show the success screen
				timerTick = 0;					// halt the timer
			}
			
			// step all (non-null) Node
			var node:ABST_Node;
			if (nodeArray.length > 0)
				for (i = nodeArray.length - 1; i >= 0; i--)
				{
					node = nodeArray[i];
					node.step();			// TODO check return state
				}
			
			// update the timer
			timeLeft -= timerTick;
			if (timeLeft <= 0)
			{
				timeLeft = 0;				// TODO move this code into a method
				gameState = PP.GAME_FAILURE;
				game.mc_overlay.visible = true;
				game.mc_overlay.tf_status.text = "Failure!";
			}
						
			game.tf_timer.text = updateTime();
				
			//puzzleStep();
			
			return completed;
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
