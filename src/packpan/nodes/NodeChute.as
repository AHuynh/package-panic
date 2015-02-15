package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import packpan.iface.IColorable;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicsUtils;
	import flash.display.Bitmap;
	import packpan.PP;
	
	/**
	 * A chute that sends mail from this chute to a matching chute
	 * 
	 * @author Jesse Chen
	 */
	public class NodeChute extends ABST_Node implements IColorable
	{
		[Embed(source = "../../../img/chute.png")]
		private var CustomBitmap:Class;
		
		/// The color of this chute
		private var color:uint;
		
		private const RANGE:Number = 0.25;		// the range of cullRectangle
		private const THRESHOLD:Number = 0.25;	// the min velocity to trigger a displacement
		
		public function NodeChute(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
			
			// the color of this chute if it is colored
			color = 15;	
			if (json["color"])
				setColor(json["color"]);
		}
		
		override public function step():void
		{
			var targetMail:Array = PhysicsUtils.cullRectangle(cg.mailArray, new Point(position.x - RANGE, position.y - RANGE),
																			new Point(position.x + RANGE, position.y + RANGE));
			
			for each (var mail:ABST_Mail in targetMail) {
				var targetChute:NodeChute = nodeGroup.getRandomNode(this) as NodeChute;
				var mailVel:Point = mail.state.velocity;
				var newPos:Point = new Point(targetChute.position.x, targetChute.position.y);
				
				if (mailVel.x < -THRESHOLD)
				{
					newPos.x -= (RANGE + 0.01);
				}
				else if (mailVel.x > THRESHOLD)
				{
					newPos.x += (RANGE + 0.01);
				}
				
				if (mailVel.y < -THRESHOLD)
				{
					newPos.y -= (RANGE + 0.01);
				}
				else if (mailVel.y > THRESHOLD)
				{
					newPos.y += (RANGE + 0.01);
				}
				
				mail.state.position = newPos;
			}
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isSameColor(col:uint):Boolean
		{
			return getColor() == col;
		}
		
		public function setColor(coli:int):void
		{
			var col:uint = PP.COLORS[coli];
			
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = int(col / 0x10000) / 255;
			ct.greenMultiplier = int(col % 0x10000 / 0x100) / 255;
			ct.blueMultiplier = col % 0x100 / 255;
			mc_object.transform.colorTransform = ct;
			
			color = col;
		}
		
		public function getColor():uint
		{
			return color;
		}
	}

}