package com.halo103.hls.controller.signals {
	
	import com.halo103.hls.interfaces.PlayerToken;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerTokenAnimated extends Signal {
		
		public function PlayerTokenAnimated() {
			super(PlayerToken);
		}
		
		public function dispatchValue(playerToken:PlayerToken, slotId:int):void {
			dispatch(playerToken, slotId);
		}
		
	}

}