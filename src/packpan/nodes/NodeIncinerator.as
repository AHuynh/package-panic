package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import cobaltric.SoundManager;
	import packpan.mails.ABST_Mail;
	
	/**
	 * A Node that destroys all Mail that falls into it.
	 * @author James LIu
	 */
	public class NodeIncinerator extends ABST_NodeProcessor
	{
		public function NodeIncinerator(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);
			
			// set up custom graphics
			mc_object.gotoAndStop("NodeIncinerator");
		}
		
		override public function affectMail(mail:ABST_Mail):void 
		{
			DestroyMail(mail);
			SoundManager.play("sfx_incinerate");
		}
	}
}