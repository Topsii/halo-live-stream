package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SpectateSlotIdChanged extends Signal  {
		
		public function SpectateSlotIdChanged() {
			super(int);
		}
		
		public function dispatchValue(spectateSlotId:int):void {
			dispatch(spectateSlotId);
		}
		
	}

}