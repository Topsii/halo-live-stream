package com.halo103.hls.controller.signals {
	
	import com.halo103.hls.vos.GameInfo;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameInfoParsed extends Signal {
		
		public function GameInfoParsed() {
			super(GameInfo)
		}
		
		public function dispatchValue(gameInfo:GameInfo):void {
			dispatch(gameInfo);
		}
		
	}

}