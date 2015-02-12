package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicsUtils;
	import flash.display.Bitmap;
	
	/**
	 * A chute that sends mail from this chute to a matching chute
	 * @author Jesse Chen
	 */
	public class NodeChute extends ABST_Node 
	{
		[Embed(source = "../../../img/chute.png")]
		private var CustomBitmap:Class;
		
		private var relativePosition:Point;
		private var movedMail:Array;
		
		public function NodeChute(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
		
		override public function step():void
		{
			blockedMail = PhysicsUtils.cullRectangle(ContainerGame.mailArray, new Point(position.x - .92, position.y - .82), new Point(position.x + .92, position.y + .82));
			
			for each (var mail:ABST_Mail in movedMail) {
				relativePosition = new Point(position.x - mail.state.position.x, position.y - mail.state.position.y);
				if (relativePosition.x > 0 && mail.state.velocity.x > 0 || 
					relativePosition.x < 0 && mail.state.velocity.x < 0) {
					mail.state.velocity.x *= -1;
				}
				if (relativePosition.y > 0 && mail.state.velocity.y > 0 || 
					relativePosition.y < 0 && mail.state.velocity.y < 0) {
					mail.state.velocity.y *= -1;
				}
			}
		}
	}

}