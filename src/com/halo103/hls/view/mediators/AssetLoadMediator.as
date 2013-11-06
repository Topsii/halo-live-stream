package com.halo103.hls.view.mediators {
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import com.halo103.hls.controller.signals.AllAssetResourcesLoaded;
	import com.halo103.hls.controller.signals.AssetLoaded;
	import com.halo103.hls.controller.signals.AssetResourceLoaded;
	import com.halo103.hls.interfaces.IAssetLoadProgressView;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class AssetLoadMediator extends SignalMediator {
		
		[Inject] public var progressView:IAssetLoadProgressView;
		
		[Inject] public var assetLoaded:AssetLoaded;
		[Inject] public var resourceLoaded:AssetResourceLoaded;
		[Inject] public var allResourcesLoaded:AllAssetResourcesLoaded;
		
		private var assetsLoaded:int;
		
		private function handleAllAssetResourcesLoaded():void {
			signalMap.removeFromSignal(assetLoaded, handleAssetLoaded);
			signalMap.removeFromSignal(resourceLoaded, handleAssetResourceLoaded);
		}
		
		private function handleAssetResourceLoaded(resourceUrl:String, resourcesLoaded:int, resourcesTotal:int):void {
			progressView.setLoad3dFilesProgress(resourcesLoaded / resourcesTotal);
		}
		
		private function handleAssetLoaded(event:AssetEvent):void {
			assetsLoaded++;
			progressView.setLoadedAssets(assetsLoaded);
		}
		
		override public function onRegister():void {
			assetsLoaded = 0;
			addOnceToSignal(allResourcesLoaded, handleAllAssetResourcesLoaded);
			addToSignal(resourceLoaded, handleAssetResourceLoaded);
			addToSignal(assetLoaded, handleAssetLoaded);
		}
		
	}

}