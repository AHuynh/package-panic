package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicsUtils;
	import flash.display.Bitmap;
	
	/**
	 * A chute that sends mail from this chute to a matching chute
	 * 
	 * @author Jesse Chen
	 */
	public class NodeChute extends ABST_Node 
	{
		[Embed(source = "../../../img/chute.png")]
		private var CustomBitmap:Class;
		private var chuteGroup:NodeGroup;
		
		public function NodeChute(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
		
		override public function step():void
		{
			var targetMail:Array = PhysicsUtils.cullRectangle(ContainerGame.mailArray, new Point(position.x - .5, position.y - .5), new Point(position.x + .5, position.y + .5));
			
			for each (var mail:ABST_Mail in targetMail) {
				var tragetChute:NodeChute = chuteGroup.getRandomNode(this);
				var mailVel:Point = mail.state.velocity;
				var newPos:Point = new Point(targetChute.position.x, targetChute.position.y);
				
				if (mailVel.x < 0)
				{
					newPos.x -= 0.51;
				}
				else if (mailVel.x > 0)
				{
					newPos.x += 0.51;
				}
				
				if (mailVel.y < 0)
				{
					newPos.y -= 0.51;
				}
				else if (mailVel.y > 0)
				{
					newPos.y += 0.51;
				}
				
				mail.state.position = newPos;
			}
		}
	}

}