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
	import packpan.nodes.*;
	import packpan.mails.*;
	import packpan.PP;
	
	/**
	 * Primary game container and controller.
	 * Reads the given XML file to create a level.
	 * 
	 * Note:	All coordinates except actual locations (i.e. movieclip.x) use x as up/down, y as left/right.
	 * 			Origin is top-left corner. Dimensions are 10 x 15 (indexes 0-9 and 0-14)
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerGame extends ABST_Container
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
			for (var i:int = 0; i < 10; i++)		// going top to bottom
			{
				nodeGrid.push([]);
				for (var j:int = 0; j < 15; j++)	// going from left to right		
					nodeGrid[i].push(null);
			}
			nodeArray = [];
			mailArray = [];
			
			// start loading XML
			loader = new URLLoader();
			loader.load(new URLRequest(levelXML));
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
			
			var i:int;
			
			if (xml.node.length() > 0)
				for (i = 0; i < xml.node.length(); i++)
				{
					// -- <type>
					var typeRaw:String = xml.node[i].type;
					var type:String;
					switch (typeRaw.toLowerCase())
					{
						case "bin_normal":		type = PP.NODE_BIN_NORMAL;		break;
						case "conveyor_normal":	type = PP.NODE_CONV_NORMAL;		break;
						default:				trace("WARNING: invalid type in XML! (" + typeRaw + ")");
					}
					// -- <facing>
					var dirRaw:String = xml.node[i].facing;
					var dir:int = PP.DIR_NONE;
					if (dirRaw)
						switch (dirRaw.toLowerCase())
						{
							case "up":		dir = PP.DIR_UP;	break;
							case "left":	dir = PP.DIR_LEFT;	break;
							case "right":	dir = PP.DIR_RIGHT;	break;
							case "down":	dir = PP.DIR_DOWN;	break;
							default:		trace("WARNING: invalid direction in XML! (" + dirRaw + ")");
						}
					// -- <position>
					var posRaw:String = xml.node[i].position;
					var posX:int = int(posRaw.substring(0, posRaw.indexOf(",")));
					if (posX < 0 || posX > PP.DIM_X_MAX)
						trace("WARNING: position of X is not within 0-" + PP.DIM_X_MAX + "! (" + posX + ")");
					var posY:int = int(posRaw.substring(posRaw.indexOf(",") + 1));
					if (posY < 0 || posX > PP.DIM_Y_MAX)
						trace("WARNING: position of Y is not within 0-" + PP.DIM_Y_MAX + "! (" + posY + ")");
					// -- <tail>
					var tailRaw:String = xml.node[i].tail;
					if (tailRaw)
					{
						var tailX:int = int(tailRaw.substring(0, tailRaw.indexOf(",")));
						if (tailX < 0 || tailX > PP.DIM_X_MAX)
							trace("WARNING: tail of X is not within 0-" + PP.DIM_X_MAX + "! (" + tailX + ")");
						var tailY:int = int(tailRaw.substring(tailRaw.indexOf(",") + 1));
						if (tailY < 0 || tailY > PP.DIM_Y_MAX)
							trace("WARNING: tail of Y is not within 0-" + PP.DIM_Y_MAX + "! (" + tailY + ")");
					}
					// -- <clickable>
					var clickableRaw:String = xml.node[i].clickable;
					var clickable:Boolean;
					if (!clickableRaw)
						clickable = false;
					else
						clickable = (clickableRaw == "true");
					// -- <color>
					var colorRaw:String = xml.node[i].color;
					var color:uint = 0x000001;
					if (colorRaw)
						color = uint(colorRaw);

					switch (String(xml.node[i].@type))
					{
						case "single":
							addNode(new Point(posX, posY), type, dir, clickable, color);
							trace("Created " + type + " at " + posX + "," + posY);
						break;
						case "group":
							addLineOfNodes(new Point(posX, posY), new Point(tailX, tailY), type, clickable, color).setDirection(dir);
							trace("Created " + type + " from " + posX + "," + posY + " to " + tailX + "," + tailY);
						break;
					}
				}
			else
				trace("WARNING: No nodes found in XML!");
				
				
			if (xml.mail.length() > 0)
				for (i = 0; i < xml.mail.length(); i++)
				{
					// -- <type>
					var typeRawM:String = xml.mail[i].type;
					var ClassM:Class;
					switch (typeRawM.toLowerCase())
					{
						case "mail_normal":		ClassM = MailNormal;		break;
						case "mail_png":		ClassM = MailPNG;			break;
						default:				trace("WARNING: invalid type in XML! (" + typeRawM + ")");
					}
					// -- <position>
					var posRawM:String = xml.mail[i].position;
					var posXM:int = int(posRawM.substring(0, posRawM.indexOf(",")));
					if (posXM < 0 || posXM > PP.DIM_X_MAX)
						trace("WARNING: position of X is not within 0-" + PP.DIM_X_MAX + "! (" + posXM + ")");
					var posYM:int = int(posRawM.substring(posRawM.indexOf(",") + 1));
					if (posYM < 0 || posXM > PP.DIM_Y_MAX)
						trace("WARNING: position of Y is not within 0-" + PP.DIM_Y_MAX + "! (" + posYM + ")");
					// -- <color>
					var colorRawM:String = xml.mail[i].color;
					var colorM:uint = 0x000001;
					if (colorRawM)
						colorM = uint(colorRawM);
						
					mailArray.push(new ClassM(this, "default", new Point(posXM, posYM), colorM));
					trace("Created " + ClassM + " at " + posXM + "," + posYM);
				}
			else
				trace("WARNING: No mail found in XML!");
				
			// -- <time>
			var timeRaw:String = xml.time.value;
			timeLeft = int(timeRaw.substring(0, 1)) * 60000 + int(timeRaw.substring(2)) * 1000;
			
			// start the game
			gameState = PP.GAME_IDLE;
		}
		
		/**
		 * Creates a single Node
		 * @param	position	the grid coordinates to place this Node
		 * @param	type		the name of the ABST_Node class to use - must use fully-qualified name! (with package .'s) 
		 * @param	facing		OPTIONAL - the direction to face this Node in
		 * @param	clickable	OPTIONAL - if this Node can be clicked
		 * @param	color		OPTIONAL - the Node's color
		 * @return				the Node created
		 */
		public function addNode(position:Point, type:String, facing:int = PP.DIR_NONE, clickable:Boolean = false, color:uint = 0x000001):ABST_Node
		{
			var NodeClass:Class = getDefinitionByName(type) as Class;
			var node:ABST_Node = new NodeClass(this, type.substring(type.lastIndexOf('.') + 1),
											   new Point(position.x, position.y), facing, clickable, color);
									
			// error check
			if (position.x < 0 || position.x > PP.DIM_X_MAX)
			{
				trace("ERROR: in addNode, x = " + position.x + " is out of bounds!");
				return null;
			}
			if (position.y < 0 || position.y > PP.DIM_Y_MAX)
			{
				trace("ERROR: in addNode, y = " + position.y + " is out of bounds!");
				return null;
			}
											   
			nodeGrid[position.x][position.y] = node;
			nodeArray.push(node);
			return node;
		}
		
		/**
		 * Creates a line of grouped Nodes
		 * @param	start		the grid coordinates to begin from
		 * @param	end			the grid coordinates to end at, inclusive
		 * @param	type		the name of the ABST_Node class to use - must use fully-qualified name! (with package .'s)
		 * @param	clickable	OPTIONAL - if this NodeGroup can be clicked
		 * @param	color		OPTIONAL - the NodeGroup's color
		 * @return				the NodeGroup created
		 */
		public function addLineOfNodes(start:Point, end:Point, type:String, clickable:Boolean = false, color:uint = 0x000001):NodeGroup
		{
			var ng:NodeGroup = new NodeGroup();
			
			var NodeClass:Class = getDefinitionByName(type) as Class;
			var node:ABST_Node;
			
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
			
			for (var i:int = start.x; i <= end.x; i++)
				for (var j:int = start.y; j <= end.y; j++)
				{
					node = new NodeClass(this, type.substring(type.lastIndexOf('.') + 1), new Point(i, j), PP.DIR_NONE, clickable, color);
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
			
			if (gameState == PP.GAME_SETUP)		// if still loading, quit
				return completed;
			
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
