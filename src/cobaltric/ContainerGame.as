package cobaltric
{	
	import packpan.nodes.*;
	import packpan.mails.*;
	import packpan.PP;
	import packpan.PhysicsUtils;
	import packpan.ABST_GameObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	
	/**
	 * Primary game container and controller.
	 * 
	 * Note:	All coordinates use x positive right and y positive down. GRID_ORIGIN is the top left corner.
	 * 
	 * @author Alexander Huynh, various
	 */
	public class ContainerGame extends ABST_Container
	{		
		public var engine:Engine;				// the game's Engine
		public var game:SWC_ContainerGame;		// the Game SWC, containing all the base assets
		protected var gameState:int;			// state of game using PP.as constants

		// game objects
		public var nodeGrid:Array;				// a 2D array containing either null or the node at a (x, y) grid location
		public var nodeArray:Array;				// a 1D array containing all ABST_Node objects
		public var mailArray:Array;				// a 1D array containing all ABST_Mail objects
		
		// allows getDefinitionByName to work; variable name is arbitary and is not ever used
		private var GDN_01:NodeConveyorNormal;
		private var GDN_02:NodeConveyorRotate;
		private var GDN_03:NodeBarrier;
		private var GDN_04:NodeAirTable;
		private var GDN_05:NodeBin;
		private var GDN_06:MailNormal;
		private var GDN_07:MailMagnetic;
		private var GDN_08:NodeMagnet;
		private var GDN_09:NodeUnknown;
		private var GDN_10:MailUnknown;
		private var GDN_11:NodeChute;
		private var GDN_12:MailGarbage;
		private var GDN_13:MailContraband;
		private var GDN_14:NodeIncinerator;
		private var GDN_15:NodeXRay;
		private var GDN_16:NodeHolder
		
		// display list
		public var lowestPackageDepth:int = 1;		// lowest childIndex to set packages as, used externally
		
		// general time
		public var timerTick:Number = 1000 / 30;	// time to add per frame
		public const SECOND:int = 1000;				// 1000ms
		public var timePassed:int = 0;				// total time elapsed in this level
		
		// star time
		public var timesArray:Array;                // completion times for star rewards, fastest times at lowest indices
		public var stars:int = 3;					// number of remaining stars
		private var star3Blink:Boolean = false;		// flag to toggle blinking
		private var star2Blink:Boolean = false;		// flag to toggle blinking

		// double time
		private var timeFactor:int = 1;				// game speed; 1x or 2x
		private var timeFlag:Boolean = true;		// used with 2x game speed

		// the JSON object defining this level
		private var json:Object;

		// helpers to delay starting the game if there is a transition
		private var startDelay:Timer;
		private var useDelay:Boolean;
		
		/**
		 * A MovieClip containing all of a PP level.
		 * @param	eng			A reference to the Engine.
		 * @param	_json		JSON containing level data.
		 * @param	_useDelay	If true, wait 1 second before starting the game.
		 */
		public function ContainerGame(eng:Engine, _json:Object, _useDelay:Boolean)
		{
			super();
			engine = eng;
			json = _json;
			useDelay = _useDelay;
			
			// set up after added to stage
			addEventListener(Event.ADDED_TO_STAGE, init);
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
	
			// -- setup the Game SWC ---------------------------------------------------
			game = new SWC_ContainerGame();
			game.x = 400; game.y = 300;
			addChild(game);
			
			game.bg_main.gotoAndStop(engine.page + 1);
			
			game.holder_above.buttonMode = game.holder_above.mouseEnabled = game.holder_above.mouseChildren = false;	
			game.holder_above.y -= 3;	// offset to make it appear above
			
			game.btn_retry.addEventListener(MouseEvent.CLICK, onRetry);
			game.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			game.btn_fast.addEventListener(MouseEvent.CLICK, onSlow);
			game.btn_slow.addEventListener(MouseEvent.CLICK, onFast);
			game.btn_fast.visible = false;
			game.mc_overlaySuccess.visible = false;
			game.mc_overlayFailure.visible = false;
			
			game.mc_overlaySuccess.btn_next.addEventListener(MouseEvent.CLICK, nextLevel);
			game.mc_overlayFailure.btn_retry.addEventListener(MouseEvent.CLICK, onRetry);
			game.spotlight.visible = false;
			game.spotlight.mouseEnabled = game.spotlight.buttonMode = game.spotlight.mouseChildren = false;
			// -- end Game SWC setup ---------------------------------------------------
			
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
			timesArray = [];
			
			// -- start reading JSON ---------------------------------------------------

			// validate list of nodes
			if (!json["nodes"])
			{
				trace("ERROR: When setting up level, JSON file is missing \"nodes\"!");
				completed = true;
				return;
			}
			
			// show tutorial graphic if appropriate
			var tut:String;
			switch (json["meta"]["name-internal"])
			{
				case "level_tut_00":		tut = "first";		break;
				case "level_tut_02":		tut = "clickable";	break;
				case "level_garbage":		tut = "incinerate";	break;
				case "level_holder":		tut = "holder";		break;
				case "level_contraband":	tut = "contraband";	break;
			}
			if (tut)
				game.tutorial.gotoAndStop(tut);

			// prepare to add objects
			var NodeClass:Class;
			var MailClass:Class;
			var node:ABST_Node;
			
			// for each entry in "nodes", add the object
			for each (var nodeJSON:Object in json["nodes"])
			{
				try
				{
					if (nodeJSON["type"] == "NodeGroupRect")
					{
						NodeClass = getDefinitionByName("packpan.nodes." + nodeJSON["subtype"]) as Class;
						addNodeGroupRect(NodeClass, nodeJSON);
					}
					else if (nodeJSON["type"] == "NodeGroupList")
					{
						NodeClass = getDefinitionByName("packpan.nodes." + nodeJSON["subtype"]) as Class;
						addNodeGroupList(NodeClass, nodeJSON);
					}
					else
					{
						NodeClass = getDefinitionByName("packpan.nodes." + nodeJSON["type"]) as Class;
						addNode(new NodeClass(this, nodeJSON));
					}
				} catch (e:Error)
				{
					addNode(new NodeUnknown(this, nodeJSON));
					trace("ERROR: When setting up level, invalid node.\n" + e.getStackTrace());
				}
			}
			
			// validate list of mail
			if (!json["mail"])
			{
				trace("ERROR: When setting up level, JSON file is missing \"mail\"!");
				completed = true;
				return;
			}
			
			// for each entry in "mail", add the object
			for each (var mailJSON:Object in json["mail"])
			{
				try
				{
					MailClass = getDefinitionByName("packpan.mails." + mailJSON["type"]) as Class;
					addMail(new MailClass(this, mailJSON));
				} catch (e:Error)
				{
					addMail(new MailUnknown(this, mailJSON));
					trace("ERROR: When setting up level, invalid mail.\n" + e.getStackTrace());
				}
			}
			if (mailArray.length == 0)
				trace("WARNING: When setting up level, no mail was added!");
			
			// validate star completion times
			if (!json["meta"]["times"])
			{
				trace("ERROR: When setting up level, JSON file is missing \"times\"!");
				completed = true;
				return;
			}
			
			// add completion times to timesArray
			for each (var timeJSON:Number in json["meta"]["times"])
			{
				try
				{
					addTime(timeJSON);
				} catch (e:Error)
				{
					addTime(-1);
					trace("ERROR: When setting up level, invalid star completion time.\n" + e.getStackTrace());
				}
			}
			
			// delay the start of the game by 1 second if the menu out animation is playing
			if (useDelay)
			{
				startDelay = new Timer(1000);
				startDelay.addEventListener(TimerEvent.TIMER, onDelayDone);
				startDelay.start();
				haltAllAnimations();
			}
			else
				gameState = PP.GAME_IDLE;
		}
		
		/**
		 * Starts the game after a brief waiting period
		 * @param	e		The TimerEvent, unused.
		 */
		private function onDelayDone(e:TimerEvent):void
		{
			startDelay.removeEventListener(TimerEvent.TIMER, onDelayDone);
			startDelay = null;
			gameState = PP.GAME_IDLE;
			playAllAnimations();
		}

		/**
		 * Adds a single Node to the level.
		 * @param	node	The Node to add to the level.
		 * @return			The Node that was added (node).
		 */
		public function addNode(node:ABST_Node):ABST_Node
		{
			nodeGrid[node.position.x][node.position.y] = node;
			nodeArray.push(node);
			lowestPackageDepth++;
			return node;
		}
		
		/**
		 * Adds a single Mail to mailArray.
		 * @param	mail	The Mail to add.
		 */
		public function addMail(mail:ABST_Mail):void
		{
			mailArray.push(mail);
		}
		
		/**
		 * Adds a completion time to timesArray
		 * @param	time	The completion time to add
		 */
		private function addTime(time:Number):void
		{
			timesArray.push(time);
		}
		
		/**
		 * Add a rectangle of grouped Nodes to the level.
		 * @param	nodeClass	The name of the Node to create a rectangle out of.
		 * @param	json		The JSON information for this NodeGroupRect.
		 */
		private function addNodeGroupRect(nodeClass:Class, json:Object):void
		{
			var start:Point = new Point(json["x1"], json["y1"]);
			var end:Point = new Point(json["x2"], json["y2"]);
			
			var ng:NodeGroup = new NodeGroup();
			for (var i:int = start.x; i <= end.x; i++)
				for (var j:int = start.y; j <= end.y; j++)
				{
					json["x"] = i; json["y"] = j;		// set position
					// NOTE: json["type"] is still NodeGroupRect!
					ng.addToGroup(addNode(new nodeClass(this, json)));
				}
			ng.initGroup();
		}

		/**
		 * Add a group of arbitrarily located Nodes to the level.
		 * @param	nodeClass	The name of the Node to create a group out of.
		 * @param	json		The JSON information for this NodeGroupList.
		 */
		private function addNodeGroupList(nodeClass:Class, json:Object):void
		{
			var ng:NodeGroup = new NodeGroup();
			for each (var coord:Object in json["list"])
			{
				json["x"] = coord["x"]; json["y"] = coord["y"];	// set position
				// NOTE: json["type"] is still NodeGroupList!
				ng.addToGroup(addNode(new nodeClass(this, json)));
			}
			ng.initGroup();
		}
		
		/**
		 * Adds the given MovieClip to holder_main aligned to the grid based on position.
		 * Usually called by ABST_Mail in its constructor.
		 * @param	mc			the MovieClip to add
		 * @param	position	the grid coordinate to use (0-based, top-left origin, U/D x, L/R y)
		 * @param	layer		the layer to add this child to: "main" or "above"
		 * @return				mc
		 */
		public function addChildToGrid(mc:MovieClip, position:Point, layer:String = "main"):MovieClip
		{
			var positionOnScreen:Point = PhysicsUtils.gridToScreen(position);
			mc.x = positionOnScreen.x;
			mc.y = positionOnScreen.y;
			switch (layer)
			{
				case "main":	game.holder_main.addChild(mc);		break;
				case "above":	game.holder_above.addChild(mc);		break;
			}
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
			else if (game.holder_above.contains(mc))
				game.holder_above.removeChild(mc);
			return mc;
		}
		
		/**
		 * called by Engine every frame
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{			
			// if still loading, quit
			if (gameState == PP.GAME_SETUP)
				return completed;

			// if the game state is idle, update everything and check for failure/success
			if (gameState == PP.GAME_IDLE)
			{
				// update the timer
				timePassed += timerTick;
				game.tf_timer.text = updateTime();
				
				// update stars
				if (timePassed >= timesArray[0])
				{
					stars = 2;
					game.star3.gotoAndStop("off");
					star3Blink = false;
				}
				else if (!star3Blink && timePassed >= timesArray[0] - 5000)
				{
					game.star3.gotoAndPlay("blink");
					star3Blink = true;
				}
				if (timePassed >= timesArray[1])
				{
					stars = 1;
					game.star2.gotoAndStop("off");
					star2Blink = false;
				}
				else if (!star2Blink && timePassed >= timesArray[1] - 5000)
				{
					game.star2.gotoAndPlay("blink");
					star2Blink = true;
				}
				
				// step all nodes
				for each (var node:ABST_Node in nodeArray)
					node.step();

				// step all Mail
				var allSuccess:Boolean = true;			// check if all Mail is in success state				
				var mailFailure:Boolean = false;		// check if any Mail is in failure state
				var culprit:ABST_Mail;					// if a failure occurs, identify which Mail caused it
				for each (var mail:ABST_Mail in mailArray)
				{
					var mailState:int = mail.mailState;
					if (!mail.destroyed)
						mailState = mail.step();
					if (mailState != PP.MAIL_SUCCESS)
						allSuccess = false;
					if (mailState == PP.MAIL_FAILURE)
					{
						mailFailure = true;
						culprit = mail;
					}
				}

				// check for success
				if (allSuccess)
					setStateSuccess();

				// check for failure
				if (mailFailure)
					setStateFailure(culprit);
			}
			
			// handle 2x time
			if (timeFactor == 2)
			{
				if (timeFlag)			// perform the double step
				{
					timeFlag = false;
					step();
					stepAllAnimations();
				}
				else					// flag the game to double step next
					timeFlag = true;
			}
			
			return completed;			// return the state of the container (if true, it is done)
		}

		/**
		 * Changes the state of the game to success and displays the overlay
		 */
		private function setStateSuccess():void
		{
			gameState = PP.GAME_SUCCESS;			// mark the level as done
			game.mc_overlaySuccess.visible = true;	// show the success screen
			game.mc_overlaySuccess.play();
			timerTick = 0;							// halt the timer
			
			if (star3Blink)
			{
				star3Blink = false;
				game.star3.gotoAndStop("blink");
			}
			if (star2Blink)
			{
				star2Blink = false;
				game.star2.gotoAndStop("blink");
			}
			
			haltAllAnimations();
			SoundManager.stopBGM();
			SoundManager.play(stars == 3 ? "sfx_successSuper" : "sfx_success");
		}

		/**
		 * Changes the state of the game to failure and displays the overlay
		 * 
		 * @param	culprit		Optional; the ABST_Mail that caused the failure
		 */
		private function setStateFailure(culprit:ABST_Mail = null):void
		{
			gameState = PP.GAME_FAILURE;			// mark the level as lost
			game.mc_overlayFailure.visible = true;	// show the failure screen
			game.mc_overlayFailure.play();
			timerTick = 0;							// halt the timer

			if (culprit)		// if we know which Mail caused the failure
			{
				game.spotlight.visible = true;				// point it out to the user
				game.spotlight.x = culprit.mc_object.x;
				game.spotlight.y = culprit.mc_object.y;
				game.spotlight.play();
			}
			
			haltAllAnimations();
			SoundManager.stopBGM();
			SoundManager.play("sfx_failure");
		}
		
		/**
		 * Stops all Node animations (those using Node.swc)
		 */
		private function haltAllAnimations():void
		{
			for each (var node:ABST_Node in nodeArray)
				if (node.animatable && node.mc_object.mc)
					node.mc_object.mc.stop();
		}
		
		/**
		 * Play all Node animations (those using Node.swc)
		 */
		private function playAllAnimations():void
		{
			for each (var node:ABST_Node in nodeArray)
				if (node.animatable && node.mc_object.mc)
					node.mc_object.mc.play();
		}
		
		/**
		 * Step all Node animations by 1 frame (those using Node.swc)
		 * Used for 2x time
		 */
		private function stepAllAnimations():void
		{
			var clip:MovieClip;
			for each (var node:ABST_Node in nodeArray)
			{
				clip = node.mc_object.mc;
				if (node.animatable && clip && !node is NodeXRay)
				{
					if (clip.currentFrame == clip.totalFrames)
						clip.gotoAndPlay(1);
					else
						clip.gotoAndPlay(clip.currentFrame + 1);
				}
			}
		}
		
		/**
		 * Provides a formatted string based on the current time left (timeLeft)
		 * @return		a M:SS.ms formatted-string
		 */
		private function updateTime():String
		{
			var timeMin:int = int(timePassed / 60000);
			var timeSec:int = int((timePassed - timeMin * 60000) * .001);
			var timeMSec:int = int((timePassed - timeMin * 60000 - timeSec * 1000) * .1);
			return timeMin + ":" +
				  (timeSec < 10 ? "0" : "" ) + timeSec + "." +
				  (timeMSec < 10 ? "0" : "" ) + timeMSec;
		}
		
		/**
		 * Called when the Retry button is clicked.
		 * @param	e		the captured MouseEvent, unused
		 */
		protected function onRetry(e:MouseEvent):void
		{
			engine.retryFlag = true;
			onQuit(null);
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
		 * Called by the button in the success screen.
		 * @param	e		the captured MouseEvent, unused
		 */
		public function nextLevel(e:MouseEvent):void
		{
			engine.nextFlag = true;
			onQuit(null);
		}
		
		/**
		 * Called by the 2x speed button.
		 * Enables double time.
		 * @param	e
		 */
		public function onFast(e:MouseEvent):void
		{
			game.btn_slow.visible = false;
			game.btn_fast.visible = true;
			timeFactor = 2;
			timeFlag = true;
		}
		
		/**
		 * Called by the 1x speed button.
		 * Reverts to normal time.
		 * @param	e
		 */
		public function onSlow(e:MouseEvent):void
		{
			game.btn_slow.visible = true;
			game.btn_fast.visible = false;
			timeFactor = 1;
		}
		
		/**
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			game.btn_retry.removeEventListener(MouseEvent.CLICK, onRetry);
			game.btn_quit.removeEventListener(MouseEvent.CLICK, onQuit);
			game.btn_fast.removeEventListener(MouseEvent.CLICK, onSlow);
			game.btn_slow.removeEventListener(MouseEvent.CLICK, onFast);
			game.mc_overlaySuccess.btn_next.removeEventListener(MouseEvent.CLICK, nextLevel);
			game.mc_overlayFailure.btn_retry.removeEventListener(MouseEvent.CLICK, onRetry);
			
			nodeGrid = null;
			nodeArray = null;
			mailArray = null;	
		}
	}
}
