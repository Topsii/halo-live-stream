package com.halo103.hls.controller.signals {
	
	import away3d.events.LoaderEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class AssetResourceLoaded extends Signal {
		
		public function AssetResourceLoaded() {
			super(String, int, int);
		}
		
		public function dispatchValues(resourceUrl:String, resourcesLoaded:int, resourcesTotal:int):void {
			dispatch(resourceUrl, resourcesLoaded, resourcesTotal);
		}
		
	}

}