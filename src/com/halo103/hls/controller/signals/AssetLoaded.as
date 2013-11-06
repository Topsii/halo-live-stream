package com.halo103.hls.controller.signals {
	
	import away3d.events.AssetEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class AssetLoaded extends Signal {
		
		public function AssetLoaded() {
			super(AssetEvent);
		}
		
		public function dispatchValue(event:AssetEvent):void {
			dispatch(event);
		}
		
	}

}