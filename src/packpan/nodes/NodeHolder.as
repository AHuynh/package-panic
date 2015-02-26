package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.geom.ColorTransform;
	import packpan.iface.IColorable;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicalEntity;
	import packpan.PP;
	import packpan.PhysicsUtils;
	import flash.geom.Point;
	
	/**
	 * Holder that holds packages in a stack with a maximum capacity
	 * 
	 * @author Jesse Chen
	 */
	public class NodeHolder extends ABST_Node implements IColorable 
	{
		//Embed image
		
		//The color of this chute
		private var color:uint;
		
		//the strength of the forces that center the package
		private var friction:Number = 5;
		private var spring:Number = 10;
		
		private var packages:Array;				//Stack of packages in Holder
		private var capacity:int;				//Max capacity of Holder
		private var remaining:int;				//Remaining capacity of Holder
		private var isFull:Boolean = false;		//Whether Holder is full
		
		public function NodeHolder(_cg:ContainerGame, _json:Object, _bitmap:Bitmap=null, _capacity:int) 
		{
			super(_cg, _json, _bitmap);
			capacity = _capacity;
			remaining = capacity;
			
			//The color of this chute if it is colored
			color = 15;	
			if (json["color"])
				setColor(json["color"]);
		}
		
		override public function affectMail(mail:ABST_Mail):void
		{
			//If Holder is full, Holder overflows and player fails
			if (isFull)
			{
				mail.mailState = PP.MAIL_FAILURE;
				return;
			}
			
			mail.state.addForce(PhysicsUtils.linearDamping(friction, mail.state, new Point(0, 0)));
			mail.state.addForce(PhysicsUtils.linearRestoreX(spring, mail.state, position.x));
			mail.state.addForce(PhysicsUtils.linearRestoreY(spring, mail.state, position.y));
			
			//Once snapping animation is complete, push package onto Holder stack
			if (Point.distance(position, mail.state.position) < 0.2)
			{
				mail.state = new PhysicalEntity(1, new Point(position.x, position.y));
				mail.mc_object.scaleX = mail.mc_object.scaleY = .8;
				packages.push(mail);
			}
			
			//Decrement remaining and check if full
			remaining--;;
			if (remaining <= 0)
			{
				isFull = true;
			}
		}
		
		override public function onClick(e:MouseEvent):void
		{
			//Pops package from Holder stack
			switch (facing)
			{
				case PP.DIR_RIGHT:
					Mail.state.velocity = new Point(0, 0);
				break;
				case PP.DIR_UP:
					Mail.state.velocity = new Point(0, 0);
				break;
				case PP.DIR_LEFT:
					Mail.state.velocity = new Point(0, 0);
				break;
				case PP.DIR_DOWN:
					Mail.state.velocity = new Point(0, 0);
				break;
				default:
					trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
			}
		}
		
		/* INTERFACE packpan.iface.IColorable */
		
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