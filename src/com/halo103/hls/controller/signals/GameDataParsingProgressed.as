package com.halo103.hls.controller.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameDataParsingProgressed extends Signal {
		
		public function GameDataParsingProgressed() {
			super(int, int);
		}
		
		public function dispatchValues(centisecondsParsed:int, centisecondsTotal:int):void {
			dispatch(centisecondsParsed, centisecondsTotal);
		}
		
	}

}