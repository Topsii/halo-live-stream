package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.view.components.MDRR3D;
	import flash.display.Sprite;
	import org.robotlegs.mvcs.SignalMediator;
	import com.halo103.hls.controller.signals.GameDataLoaded;
	import com.halo103.hls.controller.signals.AllAssetResourcesLoaded;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class LoadCompleteMediator extends SignalMediator {
		
		[Inject] public var view:MDRR3D;
		
		[Inject] public var allResourcesLoaded:AllAssetResourcesLoaded;
		[Inject] public var loadingGameDataCompleted:GameDataLoaded;
		
		private var allAssetResourcesLoaded:Boolean;
		private var gameDataLoaded:Boolean;
		
		private function handleGameDataLoaded():void {
			gameDataLoaded = true;
			checkAllFilesLoaded();
		}
		
		private function handleAllAssetResourcesLoaded():void {
			allAssetResourcesLoaded = true;
			checkAllFilesLoaded();
		}
		
		private function checkAllFilesLoaded():void {
			if (gameDataLoaded && allAssetResourcesLoaded) {
				view.showContent();
			}
		}
		
		override public function onRegister():void {
			gameDataLoaded = false;
			allAssetResourcesLoaded = false;
			view.initView();
			addOnceToSignal(allResourcesLoaded, handleAllAssetResourcesLoaded);
			addOnceToSignal(loadingGameDataCompleted, handleGameDataLoaded);
		}
		
	}
	
}