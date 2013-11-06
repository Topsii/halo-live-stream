package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.halo103.hls.interfaces.PlayerNameDisplay;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerNameMediator extends SignalMediator {
		
		[Inject] public var nameDisplay:PlayerNameDisplay;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private function handleGameStateChanged(gameState:GameState):void {
			var player:PlayerState = gameState.getPlayerBySlotId(nameDisplay.slotId);
			if (player) {
				nameDisplay.playerName = player.name;
			} else {
				nameDisplay.playerName = "";
			}
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
	}

}