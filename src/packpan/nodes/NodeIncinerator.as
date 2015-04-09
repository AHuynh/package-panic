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
		
		public function NodeIncinerator(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);
			
			// set up custom graphics
			mc_object.gotoAndStop("NodeIncinerator");
		}
		
		override public function affectMail(mail:ABST_Mail):void 
		{
			DestroyMail(mail);
		}
	}

}