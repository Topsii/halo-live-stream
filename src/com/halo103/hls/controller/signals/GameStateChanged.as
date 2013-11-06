package com.halo103.hls.controller.signals {
	
	import com.halo103.hls.vos.states.GameState;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameStateChanged extends Signal {
		
		public function GameStateChanged() {
			super(GameState);
		}
		
		public function dispatchValue(gameState:GameState):void {
			dispatch(gameState);
		}
		
	}

}