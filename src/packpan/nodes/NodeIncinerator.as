package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import packpan.mails.ABST_Mail;
	/**
	 * ...
	 * @author James LIu
	 */
	public class NodeIncinerator extends ABST_NodeProcessor
	{
		[Embed(source="../../../img/nodeIncinerator.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class;						// must be directly below the embed code
		
		public function NodeIncinerator(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json, new CustomBitmap());
		}
		
		override public function affectMail(mail:ABST_Mail):void 
		{
			DestroyMail(mail);
		}
	}

}