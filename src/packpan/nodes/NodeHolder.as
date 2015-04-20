package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import cobaltric.SoundManager;
	import flash.display.Bitmap;
	import flash.display.ColorCorrection;
	import flash.events.MouseEvent;
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
		// The color of this bin
		private var color:uint;
		
		// the strength of the forces that center the package
		private var friction:Number = 5;
		private var spring:Number = 10;
		
		private var packages:Array = [];		//Stack of packages in Holder
		private var velocities:Array = [];		//Stack of packages' velocities in Holder
		private var capacity:int;				//Max capacity of Holder
		private var remaining:int;				//Remaining capacity of Holder
		private var isFull:Boolean = false;		//Whether Holder is full
		
		private const RANGE:Number = 0.25;		// the range of cullRectangle
		
		public function NodeHolder(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			animatable = false;		// don't animate this object
			
			// set up custom graphics
			mc_object.gotoAndStop("nodeHolder");
			
			//The color of this bin if it is colored
			color = 15;	
			if (json["color"])
				setColor(json["color"]);
			if (json["capacity"])
				capacity = json["capacity"];
				
			remaining = capacity;
			mc_object.mc.gotoAndStop(capacity >= 10 ? 2 : 1);	// handle counter GFX
			setRemaining(remaining);
		}
		
		override public function affectMail(mail:ABST_Mail):void
		{
			//If Holder is full, Holder overflows and player fails
			if (isFull)
			{
				mail.mailState = PP.MAIL_FAILURE;
				mc_object.mc.tf_cap.text = "X";
				return;
			}
			
			//Once snapping animation is complete, push package onto Holder stack
			if (Point.distance(position, mail.state.position) < 0.2 && packages.indexOf(mail) == -1)
			{
				packages.push(mail);
				velocities.push(mail.state.velocity);

				mail.state = new PhysicalEntity(1, new Point(position.x, position.y));
				mail.mc_object.scaleX = mail.mc_object.scaleY = .8;
				
				// move package to top of display list
				cg.game.holder_main.setChildIndex(mail.mc_object, cg.lowestPackageDepth + (capacity - remaining));

				//Decrement remaining and check if full
				setRemaining(--remaining);
				SoundManager.play("sfx_bin");
				
				if (remaining < 0)
				{
					isFull = true;
				}
			}
		}
		
		override public function onClick(e:MouseEvent):void
		{
			if (packages.length == 0)
			{
				return;
			}
			
			//Pops package from Holder stack
			var mail:ABST_Mail = packages.pop();
			var vel:Point = velocities.pop();
			mail.mc_object.scaleX = mail.mc_object.scaleY = 1;
			setRemaining(++remaining);
			
			vel.normalize(-1);
			mail.state.velocity = vel;
			
			var posOffset:Point = vel.clone();
			posOffset.normalize(RANGE + 0.01);
			
			mail.state.position = mail.state.position.add(posOffset);
		}
		
		/**
		 * Updates the counter on the Holder to display how many more packages it can hold.
		 * @param	rem		The number to display (capacity left)
		 */
		private function setRemaining(rem:int):void
		{
			mc_object.mc.tf_cap.text = rem;
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