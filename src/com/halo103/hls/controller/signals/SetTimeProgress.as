package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SetTimeProgress extends Signal {
		
		public function SetTimeProgress() {
			super(Number);
		}
		
		public function dispatchValue(timeProgress:Number):void {
			dispatch(timeProgress);
		}
		
	}

}