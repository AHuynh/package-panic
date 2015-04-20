package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import cobaltric.SoundManager;
	import flash.display.MovieClip;
	import packpan.mails.ABST_Mail;
	import packpan.mails.MailContraband;

	/**
	 * When mail passes through this Node, detects if there is contraband.
	 * If there is more than 1 mail on this Node with conflicting statuses, XRay will become confused.
	 * @author James Liu
	 */
	public class NodeXRay extends ABST_Node
	{
		private var currentList : Array;
		
		private var foundMail : Boolean;
		private var foundContraband : Boolean;
		private var isConfused : Boolean;
		
		private var cbGFX:int;	// graphic to display on contraband
		
		public function NodeXRay(_cg:ContainerGame, _json:Object)
		{
			_json["layer"] = "above";			// place this Node'd graphic on elevated layer
			
			super(_cg, _json);
			
			mc_object.gotoAndStop("NodeXray");	// use SWC image
			
			var base:MovieClip = new Node();	// place base graphic on default layer
			base.gotoAndStop("NodeXrayBase");
			cg.addChildToGrid(base, position);
			
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
						mc_object.mc.contraband.gotoAndStop(cbGFX);
						SoundManager.play("sfx_xbad");
					} else {
						mc_object.mc.gotoAndStop("clear");
						//SoundManager.play("sfx_xgood");
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
				temp = (mail as MailContraband).ShouldDestroy();
				// read or assign a specific contraband graphic
				if (!mail.mc_object.cb_id)
					mail.mc_object.cb_id = int(getRand(1, 7));
				cbGFX = mail.mc_object.cb_id;
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