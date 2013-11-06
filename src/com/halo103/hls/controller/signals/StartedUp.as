package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class StartedUp extends Signal {
		
		public function StartedUp() {
			super(String)
		}
		
		public function dispatchValue(retrCmd:String):void {
			dispatch(retrCmd);
		}
		
	}

}