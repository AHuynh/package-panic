package packpan 
{
	/**
	 * PackagePanic static helper
	 * @author Alexander Huynh
	 */
	public class PP 
	{
		// values are meaningless (other than unique) unless otherwise stated

		public static const MAIL_IDLE:int = 20;
		public static const MAIL_SUCCESS:int = 21;
		public static const MAIL_FAILURE:int = 22;
		
		public static const GAME_IDLE:int = 10;
		public static const GAME_SUCCESS:int = 11;
		public static const GAME_FAILURE:int = 12;
		
		public static const DIR_NONE:int = -1;			// meaningful numbers
		public static const DIR_LEFT:int = 180;
		public static const DIR_UP:int = 270;
		public static const DIR_RIGHT:int = 0;
		public static const DIR_DOWN:int = 90;
		
		public function PP() 
		{
			// -- Static class; do not instantiate
			trace("DO NOT INSTANTIATE PP!");
		}
	}
}