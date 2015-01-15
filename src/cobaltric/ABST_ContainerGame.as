package cobaltric
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	/**
	 * Primary game container and controller
	 * 
	 * @author Alexander Huynh
	 */
	public class ABST_ContainerGame extends ABST_Container
	{		
		public var engine:Engine;
		public var game:SWC_ContainerGame;	// the Game SWC, containing all the base assets
		
		private var managers:Array;			// array of all managers
		private var manLen:int;				// length of the manager array
		// TODO define managers here

		public var cursor:MovieClip;
		
		protected const GRID_ORIGIN:Point = new Point(-100, -100);
		//protected const GRID_ORIGIN:Point = new Point(24.2, 15.8);
		protected const GRID_SIZE:int = 50;
		
		// TODO more definitions here
	
		public function ABST_ContainerGame(eng:Engine)
		{
			super();
			engine = eng;
			addEventListener(Event.ADDED_TO_STAGE, init);
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
			//game.x -= XXX;
			//game.y -= XXX;
			//game.bg.cacheAsBitmap = true;
			
			// initialize managers
			// TODO manager instantiation here
			managers = [];
			manLen = managers.length - 1;

			// cursor
			/*cursor = new GameCursor();
			game.mc_gui.addChild(cursor);
			cursor.visible = false;*/
			
			// temp
			var pos:Array = [new Point(4, 3), new Point(5, 3), new Point(6, 3)];
			for (var i:int = 0; i < pos.length; i++)
			{
				var node:Node = new Node();
				node.x = GRID_ORIGIN.x + GRID_SIZE * pos[i].x;
				node.y = GRID_ORIGIN.y + GRID_SIZE * pos[i].y;
				game.holder_main.addChild(node);
			}
		}
		
		// called by Engine every frame
		override public function step():Boolean
		{
			//cursor.x = mouseX - game.x - game.mc_gui.x;
			//cursor.y = mouseY - game.y - game.mc_gui.y;
			
			// update each manager
			for (var i:int = manLen; i >= 0; i--)
				managers[i].step();
			
			return puzzleStep();
		}
		
		/**
		 * The to-be-implemented step() function for this specific puzzle.
		 * @return	completed, true if this container is done
		 */
		protected function puzzleStep():Boolean
		{
			// -- OVERRIDE THIS FUNCTION
			return completed;
		}
		
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
			for (var i:int = manLen; i >= 0; i--)
				managers[i].destroy();
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			Mouse.show();
		}
	}
}
