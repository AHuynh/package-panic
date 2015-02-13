package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.geom.ColorTransform;
	import packpan.iface.IColorable;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicalEntity;
	import packpan.PP;
	import flash.geom.Point;
	
	/**
	 * A node that is created when the node type is unidentified.
	 * @author Jay Fisher
	 */
	public class NodeUnknown extends ABST_Node
	{
		[Embed(source="../../../img/nodeUnknown.png")]
		private var CustomBitmap:Class;	
		
		public function NodeUnknown(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
	}
}
