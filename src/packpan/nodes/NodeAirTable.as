package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	
	/**
	 * A node that does nothing to Mail crossing over it, effectively making it
	 * like classic "ice" tiles in puzzle games.
	 * 
	 * @author Alexander Huynh
	 */
	public class NodeAirTable extends ABST_Node 
	{
		[Embed(source="../../../img/airTable.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class;				// must be directly below the embed code
		
		public function NodeAirTable(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
	}
}