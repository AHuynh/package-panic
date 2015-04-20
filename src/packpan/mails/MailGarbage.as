package packpan.mails 
{
	import cobaltric.ContainerGame;
	import packpan.iface.IDestroyable;
	
	/**
	 * A Mail object that always needs to be destroyed.
	 * Will cause failure if placed in a non-Holder bin.
	 * @author James Liu
	 */
	public class MailGarbage extends ABST_Mail
	{
		[Embed(source="../../../img/mailGarbage.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class					// must be directly after the embed code
		
		public function MailGarbage(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json, new CustomBitmap());
		}
		
		override public function ShouldDestroy():Boolean 
		{
			return true;
		}
	}
}