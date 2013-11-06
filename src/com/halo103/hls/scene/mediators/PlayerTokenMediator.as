package com.halo103.hls.scene.mediators {
	
	import com.halo103.hls.controller.signals.PlayerTokenAnimated;
	import com.halo103.hls.interfaces.PlayerToken;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.paultondeur.away3d.robotlegs.base.SignalMediator3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerTokenMediator extends SignalMediator3D {
		
		[Inject] public var playerToken:PlayerToken;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		[Inject] public var tokenAnimated:PlayerTokenAnimated;
		
		private function handleGameStateChanged(gameState:GameState):void {
			var player:PlayerState = gameState.getPlayerBySlotId(playerToken.slotId);
			if (player) {
				playerToken.color = player.color;
				playerToken.state = player.token;
				tokenAnimated.dispatchValue(playerToken, playerToken.slotId);
			} else {
				playerToken.state = null;
				tokenAnimated.dispatchValue(null, playerToken.slotId);
			}
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}