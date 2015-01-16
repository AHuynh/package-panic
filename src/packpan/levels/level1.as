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
	public class level1 extends ABST_ContainerGame 
	{
		
		public function level1(eng:Engine) 
		{
			super(eng);
		}
		
		override protected function setUp():void
		{
			timeLeft = 90 * SECOND;
			
			addLineOfNodes(new Point(2, 0), new Point(2, 8), "packpan.nodes.NodeConveyorNormal").setDirection(PP.DIR_RIGHT);
			addNode(new Point(2, 9), "packpan.nodes.NodeConveyorNormal", PP.DIR_UP, true);
			addNode(new Point(3, 9), "packpan.nodes.NodeConveyorNormal", PP.DIR_DOWN, true);
			addLineOfNodes(new Point(4, 4), new Point(4, 9), "packpan.nodes.NodeConveyorNormal").setDirection(PP.DIR_RIGHT);
			addNode(new Point(4, 3), "packpan.nodes.NodeConveyorNormal", PP.DIR_DOWN, true);
			addLineOfNodes(new Point(4, 10), new Point(8, 10), "packpan.nodes.NodeConveyorNormal").setDirection(PP.DIR_DOWN);
			
			addNode(new Point(3, 3), "packpan.nodes.NodeBin");

			mailArray.push(new MailNormal(this, "default", new Point(2, 0)));
		}
	}
}