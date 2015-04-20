package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import packpan.mails.ABST_Mail;

	/**
	 * A Node that modifies a given Mail object
	 * @author James LIu
	 */
	public class ABST_NodeProcessor extends ABST_Node
	{
		public function ABST_NodeProcessor(_cg:ContainerGame, _json:Object, _bitmap:Bitmap = null)
		{
			super(_cg, _json, _bitmap);
		}
		
		override public function affectMail(mail:ABST_Mail):void 
		{
			if (mail.ProcessedBy(this))
				ProcessMail(mail);
			if (mail.DestroyedBy(this))
				DestroyMail(mail);
		}
		
		public function DestroyMail(mail : ABST_Mail) : void
		{
			mail.Destroy();
		}
		
		public function ProcessMail(mail : ABST_Mail) : void
		{
			mail.Process(this);
		}
	}

}