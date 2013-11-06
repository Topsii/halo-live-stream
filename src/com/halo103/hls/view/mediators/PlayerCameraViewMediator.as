package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.PlayerCameraView;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.halo103.hls.controller.signals.SpectateSlotIdChanged;
	import flash.geom.Vector3D;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerCameraViewMediator extends SignalMediator {
		
		[Inject] public var cameraView:PlayerCameraView;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private function handleGameStateChanged(gameState:GameState):void {
			var slotId:int = cameraView.slotId;
			cameraView.showAlive();
			if (0 <= slotId && slotId < GameState.PLAYER_SLOTS) {
				var player:PlayerState = gameState.getPlayerBySlotId(slotId);
				if (player && player.token) {
					cameraView.perspective = player.token.perspDirection;
					//ersetze durch ein event, das von PlayerTokenMediator gesendet wird und die Position des Augenmarkers wiedergibt
					cameraView.cameraPosition = player.token.position.add(new Vector3D(0, 64, 0));
					if (!player.token.alive) {
						cameraView.showDeath();
					}
				} else {
					cameraView.showNothing();
				}
			}
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}