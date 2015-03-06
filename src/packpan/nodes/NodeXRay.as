package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import packpan.mails.ABST_Mail;
	import packpan.mails.MailContraband;
	/**
	 * ...
	 * @author James Liu
	 */
	public class NodeXRay extends ABST_Node
	{
		private var currentList : Array;
		
		private var foundMail : Boolean;
		private var foundContraband : Boolean;
		private var isConfused : Boolean;
		
		public function NodeXRay(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);
			
			mc_object.gotoAndStop("NodeXray");
			
			currentList = new Array();
			foundMail = false;
			foundContraband = false;
			isConfused = false;
		}
		
		override public function step():void 
		{
			if (foundMail) {
				if (isConfused) {
					mc_object.mc.gotoAndStop("confused");
				} else {
					if (foundContraband) {
						mc_object.mc.gotoAndStop("warn");
					} else {
						mc_object.mc.gotoAndStop("clear");
					}
				}
			} else {
				mc_object.mc.gotoAndStop("none");	
			}
			foundMail = foundContraband = isConfused = false;
		}
		
		override public function affectMail(mail:ABST_Mail):void 
		{
			var temp : Boolean = false;
			if (mail is MailContraband) {
				temp = temp || (mail as MailContraband).ShouldDestroy();
			}
			if (!foundMail) {
				foundContraband = temp;
			} else {
				if ((!foundContraband && temp) || (foundContraband && !temp)) {
					isConfused = true;
				}
			}
			currentList.push(mail);
			foundMail = true;
		}
	}

}