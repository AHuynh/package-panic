package cobaltric
{
	import flash.events.MouseEvent;
	/**
	 * Main menu screen.
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerIntro extends ABST_Container
	{
		public var swc:SWC_ContainerMenu;
		private var eng:Engine;		// a reference to the Engine
		
		public function ContainerIntro(_eng:Engine)
		{
			super();
			eng = _eng;
			
			swc = new SWC_ContainerMenu();
			addChild(swc);
			
			swc.btn_start.addEventListener(MouseEvent.CLICK, onStart);
			swc.btn_level1.addEventListener(MouseEvent.CLICK, onStart);
			swc.btn_level2.addEventListener(MouseEvent.CLICK, onStart);
			swc.btn_level3.addEventListener(MouseEvent.CLICK, onStart);
		}
		
		/*private function onButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip");
		}*/
		
		/*private function overButton(e:MouseEvent):void
		{
			SoundPlayer.play("sfx_menu_blip_over");
		}*/
		
		private function onStart(e:MouseEvent):void
		{
			swc.removeEventListener(MouseEvent.CLICK, onStart);
			removeChild(swc);
			swc = null;
			
			eng.levelClass = "packpan.levels." + e.target.name.substring(4);
			trace(eng.levelClass);
			
			completed = true;
		}
	}
}
