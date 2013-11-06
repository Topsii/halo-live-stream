package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.GameChange;
	import com.halo103.hls.vos.states.GameState;

	public interface GameStateChange extends GameChange {
		
		function apply(gameState:GameState):void;
		
	}

}