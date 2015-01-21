package packpan.levels 
{
	import cobaltric.ABST_ContainerGame;
	import cobaltric.Engine;
	import flash.geom.Point;
	import packpan.mails.MailNormal;
	import packpan.PP;
	
	/**
	 * Temporary testing/demonstration level
	 * @author Alexander Huynh
	 */
	public class level2 extends ABST_ContainerGame 
	{
		
		public function level2(eng:Engine) 
		{
			super(eng);
		}
		
		override protected function setUp():void
		{
			timeLeft = 15 * SECOND;
			
			addLineOfNodes(new Point(2, 9), new Point(8, 9), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_DOWN);
			addLineOfNodes(new Point(2, 3), new Point(2, 8), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_LEFT);
			addLineOfNodes(new Point(5, 2), new Point(5, 8), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_RIGHT);
			addLineOfNodes(new Point(8, 10), new Point(8, 14), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_RIGHT);
			
			addNode(new Point(1, 9), PP.NODE_BIN_NORMAL);
			addNode(new Point(9, 9), PP.NODE_BIN_NORMAL);
			addNode(new Point(5, 1), PP.NODE_BIN_NORMAL);
			
			mailArray.push(new MailNormal(this, "default", new Point(2, 7)));
			mailArray.push(new MailNormal(this, "default", new Point(5, 3)));
			mailArray.push(new MailNormal(this, "default", new Point(8, 10)));
		}
	}
}