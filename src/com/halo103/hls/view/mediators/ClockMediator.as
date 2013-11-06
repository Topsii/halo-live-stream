package com.halo103.hls.view.mediators {
	import com.halo103.hls.interfaces.IClock;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class ClockMediator extends SignalMediator {
		
		[Inject] public var clock:IClock;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private function handleGameStateChanged(gameState:GameState):void {
			clock.showTime(gameState.time);
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}