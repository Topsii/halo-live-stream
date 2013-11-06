package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.IScoreboard;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class ScoreboardMediator extends SignalMediator {
		
		[Inject] public var scoreboard:IScoreboard;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private function handleGameStateChanged(gameState:GameState):void {
			scoreboard.showPlayers(gameState.scoreboard);
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}