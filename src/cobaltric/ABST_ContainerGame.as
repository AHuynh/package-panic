package cobaltric
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import packpan.mails.ABST_Mail;
	import packpan.mails.MailNormal;
	import packpan.nodes.ABST_Node;
	import packpan.nodes.NodeConveyorNormal;
	import packpan.PP;
	
	/**
	 * Primary game container and controller
	 * 
	 * @author Alexander Huynh
	 */
	public class ABST_ContainerGame extends ABST_Container
	{		
		public var engine:Engine;					// the game's Engine
		public var game:SWC_ContainerGame;			// the Game SWC, containing all the base assets

		public var cursor:MovieClip;
		
		// grid is 15 x 10
		protected const GRID_ORIGIN:Point = new Point(-350, -260);		// actual x, y coordinate of upper-left grid
		protected const GRID_SIZE:int = 50;								// grid square size
		
		public var nodeGrid:Array;		// a 2D array containing either null or the node at a (x, y) grid location
		public var nodeArray:Array;		// a 1D array containing all ABST_Node objects
		public var mailArray:Array;		// a 1D array containing all ABST_Mail objects
		
		protected var gameState:int;
		
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

			// cursor
			/*cursor = new GameCursor();
			game.mc_gui.addChild(cursor);
			cursor.visible = false;*/
			
			// setup nodeGrid
			nodeGrid = [];
			for (var i:int = 0; i < 10; i++)		// going top to bottom
			{
				nodeGrid.push([]);
				for (var j:int = 0; j < 15; j++)	// going from left to right		
					nodeGrid[i].push(null);
			}
			nodeArray = [];
			mailArray = [];
			
			setUp();
		}
		
		/**
		 * Level-specific constructor
		 */
		protected function setUp():void
		{
			// -- OVERRIDE THIS FUNCTION
			
			// TEMPORARY
			// populate all grid squares
			for (var i:int = 0; i < 15; i++)
				for (var j:int = 0; j < 10; j++)
				{					
					var d:int = (i+2+j) % 4 + 1;
					d += PP.DIR_NONE;
					//d = PP.DIR_RIGHT;
					//trace("Spawning " + i + "," + j + " " + d);
					nodeGrid[j][i] = new NodeConveyorNormal(this, "conveyor", new Point(i, j), d, true);
					nodeArray.push(nodeGrid[j][i]);
				}
				
			mailArray.push(new MailNormal(this, "default", new Point(5, 5)));
		}
		
		/**
		 * Adds the given MovieClip to holder_main aligned to the grid based on position.
		 * @param	mc			the MovieClip to add
		 * @param	position	the grid coordinate to use (0-based, top-left origin, L/R x, U/D y)
		 * @return				mc
		 */
		public function addChildToGrid(mc:MovieClip, position:Point):MovieClip
		{
			mc.x = GRID_ORIGIN.x + GRID_SIZE * position.x;
			mc.y = GRID_ORIGIN.y + GRID_SIZE * position.y;
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
		
		// called by Engine every frame
		override public function step():Boolean
		{
			//cursor.x = mouseX - game.x - game.mc_gui.x;
			//cursor.y = mouseY - game.y - game.mc_gui.y;
			
			// step all Mail
			var i:int;
			var mail:ABST_Mail;
			var allSuccess:Boolean = true;
			if (mailArray.length > 0)
			for (i = mailArray.length - 1; i >= 0; i--)
			{
				mail = mailArray[i];
				var mailState:int = mail.step();
				if (gameState != PP.GAME_FAILURE)
				{
					if (mailState != PP.MAIL_SUCCESS)
						allSuccess = false;
					if (mailState == PP.MAIL_FAILURE)
						gameState = PP.GAME_FAILURE;
				}
			}
			if (allSuccess)
				gameState = PP.GAME_SUCCESS;
			
			// step all (non-null) Node
			var node:ABST_Node;
			if (nodeArray.length > 0)
			for (i = nodeArray.length - 1; i >= 0; i--)
			{
				node = nodeArray[i];
				node.step();			// TODO check return state
			}
			
			//puzzleStep();
			
			return completed;
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
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			Mouse.show();
		}
	}
}
