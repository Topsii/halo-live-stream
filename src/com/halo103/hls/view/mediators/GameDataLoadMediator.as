package com.halo103.hls.view.mediators {
	import com.halo103.hls.controller.signals.GameDataLoaded;
	import com.halo103.hls.controller.signals.GameDataLoadingProgressed;
	import com.halo103.hls.interfaces.IGameDataLoadProgressView;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameDataLoadMediator extends SignalMediator {
		
		[Inject] public var progressView:IGameDataLoadProgressView;
		
		[Inject] public var loadingGameDataCompleted:GameDataLoaded;
		[Inject] public var loadingGameDataProgressed:GameDataLoadingProgressed;
		
		private function handleGameDataLoadingProgressed(bytesLoaded:Number, bytesTotal:Number):void {
			progressView.setLoadGameDataProgress(bytesLoaded / bytesTotal);
		}
		
		private function handleGameDataLoaded():void {
			progressView.setLoadGameDataProgress(1);
			signalMap.removeFromSignal(loadingGameDataProgressed, handleGameDataLoadingProgressed);
		}
		
		override public function onRegister():void {
			addOnceToSignal(loadingGameDataCompleted, handleGameDataLoaded);
			addToSignal(loadingGameDataProgressed, handleGameDataLoadingProgressed);
		}
	}

}