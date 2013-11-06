package com.halo103.hls.services {
	import away3d.library.AssetLibrary;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.IAsset;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD5AnimParser;
	import com.halo103.hls.controller.signals.AllAssetResourcesLoaded;
	import com.halo103.hls.controller.signals.AssetLoaded;
	import com.halo103.hls.controller.signals.AssetResourceLoaded;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.robotlegs.mvcs.Actor;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Topsi
	 */
	public class Away3DAssetsService {
		
		//inform the rest of the application by dispatching these signals
		[Inject] public var assetLoaded:AssetLoaded;
		[Inject] public var resourceLoaded:AssetResourceLoaded;
		[Inject] public var allResourcesLoaded:AllAssetResourcesLoaded;
		
		private var resourcesLoaded:uint;
		private var resourcesToLoad:uint;
		
		private var _names:Vector.<String>;
		
		private var _loaders:Vector.<AssetLoader>;
		
		public function getAway3DAssets(resources:Vector.<String>, parsers:Vector.<Class>, names:Vector.<String>= null):void {
			
			AssetLoader.enableParsers(parsers);
			
			addLoaderListeners();
			
			resourcesToLoad = resources.length;
			resourcesLoaded = 0;
			if (names != null) {
				if (names.length != resourcesToLoad) {
					throw ArgumentError("The length of the resources vector and the names vector is not the same.");
				}
				_names = names;
				_loaders = new Vector.<AssetLoader>(resourcesToLoad);
				for (var i:int = 0; i < resources.length; i++) {
						//trace(resources[i]);
					if (names[i] == null) {
						AssetLibrary.load(new URLRequest(resources[i]));
					} else {
						_loaders[i] = new AssetLoader();
						_loaders[i].addEventListener(AssetEvent.ASSET_COMPLETE, onAssetCompleteChangeName)
						_loaders[i].addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete)
						_loaders[i].addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
						_loaders[i].addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
						var fileExt:String = resources[i].substring(resources[i].lastIndexOf(".") + 1, resources[i].length);
						if (MD5AnimParser.supportsType(fileExt)) {
							var md5AnimParser:MD5AnimParser = new MD5AnimParser(Vector3D.Y_AXIS, Math.PI * .5);
							_loaders[i].load(new URLRequest(resources[i]), null, null, md5AnimParser);
						} else {
							_loaders[i].load(new URLRequest(resources[i]));
						}
					}
				}
			} else {
				for (var k:int = 0; k < resources.length; k++) {
					AssetLibrary.load(new URLRequest(resources[k]));
				}
			}
		}
		
		private function onLoadError(event:LoaderEvent):void {
			trace("fail: " + event.message);
			removeLoaderListeners();
		}
		
		private function onAssetCompleteChangeName(event:AssetEvent):void {
			event.asset.name = _names[_loaders.indexOf(event.target)] + event.asset.assetType;
			AssetLibrary.addAsset(event.asset);
		}
		
		private function onAssetComplete(event:AssetEvent):void {
			//trace(event.asset.name);
			assetLoaded.dispatchValue(event);
		}
		
		private function onResourceComplete(event:LoaderEvent):void {
			resourcesLoaded++;
			//trace("URL: " + event.url);
			resourceLoaded.dispatchValues(event.url, resourcesLoaded, resourcesToLoad);
			if (resourcesLoaded == resourcesToLoad) {
				removeLoaderListeners();
				allResourcesLoaded.dispatch();
			}
		}
		
		private function addLoaderListeners():void {
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
		}

		private function removeLoaderListeners():void {
			AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			AssetLibrary.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
		}
		
	}

}