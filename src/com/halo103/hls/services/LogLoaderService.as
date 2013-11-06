package com.halo103.hls.services {
	
	import com.halo103.hls.interfaces.IGameDataService;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import com.halo103.hls.interfaces.IGameDataParser;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.halo103.hls.controller.signals.GameDataLoaded;
	import com.halo103.hls.controller.signals.GameDataLoadingProgressed;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * 
	 * @author Topsi
	 */
	public class LogLoaderService implements IGameDataService {
		
		[Inject] public var parser:IGameDataParser;
		
		//inform the rest of the application by dispatching these signals
		[Inject] public var loadingCompleted:GameDataLoaded;
		[Inject] public var loadingProgressed:GameDataLoadingProgressed;
		
		//listen to these signals to get information from the loader
		private var loaderCompleted:NativeSignal;
		private var loaderProgressed:NativeSignal;
		
		private var loader:URLLoader;
		
		public function LogLoaderService() {
			loader = new URLLoader();
			loaderCompleted = new NativeSignal(loader, Event.COMPLETE, Event);
			loaderProgressed = new NativeSignal(loader, ProgressEvent.PROGRESS, ProgressEvent);
		}
		
		public function getGameData(logfile:String):void {
			loaderCompleted.add(handleLoadComplete);
			loaderProgressed.addOnce(handleLoadProgress);
			loader.load(new URLRequest(logfile));
		}
		
		private function handleLoadProgress(event:ProgressEvent):void {
			loadingProgressed.dispatchValues(event.bytesLoaded, event.bytesTotal);
		}
		
		private function handleLoadComplete(event:Event):void {
			parser.parse(String(loader.data));
			loadingCompleted.dispatch();
			loaderProgressed.remove(handleLoadProgress);
		}
	}

}