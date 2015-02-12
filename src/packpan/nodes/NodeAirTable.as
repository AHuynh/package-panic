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
		[Embed(source="../../../img/airTable.png")]				// image embed code, auto-generated
		private var imgLayer:Class;									// needed to instantiate your image
		private var img:Bitmap = new imgLayer();					// reference to your image
		
		public function NodeAirTable(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			
			mc_node.gotoAndStop("none");		// switch to an empty mail image
			mc_node.addChild(img);				// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;
		}
	}
}