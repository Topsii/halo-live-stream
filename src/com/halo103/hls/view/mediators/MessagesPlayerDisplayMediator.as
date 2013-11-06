package com.halo103.hls.view.mediators {
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.halo103.hls.interfaces.MessagesPlayerDisplay;
	import com.halo103.hls.vos.states.GameState;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class MessagesPlayerDisplayMediator extends SignalMediator {
		
		[Inject] public var messagesDisplay:MessagesPlayerDisplay;
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private function handleGameStateChanged(gameState:GameState):void {
			messagesDisplay.displayMessages(gameState.messages);
		}
		
		override public function onRegister():void {
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}