package 
{
	import flash.display.LoaderInfo;  
    import flash.display.MovieClip;  
    import flash.events.Event;  
    import flash.events.ProgressEvent;  
	
	// UNUSED
	public class ContainerPreloader extends ABST_Container
	{
		private var HIGH:Number;
		
		public function ContainerPreloader()
		{
			//trace("CON1");
			super();
			//trace("CON2");
			HIGH = loadBar.height;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		public function setLoaderInfo(ldrInf:LoaderInfo):void  
        {  
			//trace("A1");
            //ldrInf.addEventListener(ProgressEvent.PROGRESS, onProgress);  
            //ldrInf.addEventListener(Event.COMPLETE, onComplete);  
			//trace("A2");
        }  
          
        private function onProgress(evt:ProgressEvent):void  
        {  
			//trace("B");
			var loaded:Number = evt.bytesLoaded / evt.bytesTotal; 
			percent_txt.text = (loaded*100).toFixed(0) + "%";
			loadBar.height = loaded*HIGH;
            /*var percent:int = Math.round(e.bytesLoaded / e.bytesTotal * 100);  
            progressBar.width = percent / 100 * progressArea.width;  
            percentageText.text = percent + "%";  */
        }  
          
        private function onComplete(e:Event):void  
        {  
			play();
			//MovieClip(root).gotoAndPlay(3);
            //dispatchEvent(e);  
        }  
	}
}
