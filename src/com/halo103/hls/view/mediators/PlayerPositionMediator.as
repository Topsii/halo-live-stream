package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.controller.signals.PlayerTokenAnimated;
	import com.halo103.hls.interfaces.PlayerPositionDisplay;
	import com.halo103.hls.interfaces.PlayerToken;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerPositionMediator extends SignalMediator {
		
		[Inject] public var positionDisplay:PlayerPositionDisplay;
		
		[Inject] public var tokenAnimated:PlayerTokenAnimated;
		
		private function handleTokenAnimated(playerToken:PlayerToken, slotId:int):void {
			if (positionDisplay.slotId == slotId) {
				if (playerToken != null) {
					positionDisplay.position = playerToken.headPosition;
				} else {
					positionDisplay.position = null;
				}
			}
		}
		
		override public function onRegister():void {
			addToSignal(tokenAnimated, handleTokenAnimated);
		}
		
	}

}