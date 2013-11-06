package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class ReplayDurationChanged extends Signal {
		
		public function ReplayDurationChanged() {
			super(int);
		}
		
		public function dispatchValue(duration:int):void {
			dispatch(duration);
		}
		
	}

}