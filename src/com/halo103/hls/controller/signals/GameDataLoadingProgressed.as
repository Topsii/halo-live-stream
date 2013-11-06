package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameDataLoadingProgressed extends Signal {
		
		public function GameDataLoadingProgressed() {
			super(Number, Number);
		}
		
		public function dispatchValues(bytesLoaded:Number, bytesTotal:Number):void {
			dispatch(bytesLoaded, bytesTotal);
		}
		
	}

}