package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.IPlayToggleButton;
	import com.halo103.hls.controller.signals.GamePaused;
	import com.halo103.hls.controller.signals.GameStarted;
	import com.halo103.hls.controller.signals.TogglePlayingState;
	import com.halo103.hls.scene.components.Cyborg;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayToggleButtonMediator extends SignalMediator {
		
		[Inject] public var button:IPlayToggleButton;
		
		[Inject] public var playToggleButtonClicked:TogglePlayingState;
		
		[Inject] public var gamePaused:GamePaused;
		[Inject] public var gameStarted:GameStarted;
		
		private function playButtonClicked(event:MouseEvent):void {
			playToggleButtonClicked.dispatch();
		}
		
		private function handleGameStarted():void {
			button.showPauseIcon();
		}
		
		private function handleGamePaused():void {
			button.showPlayIcon();
		}
		
		override public function onRegister():void {
			addToSignal(button.playButtonClicked, playButtonClicked);
			addToSignal(gameStarted, handleGameStarted);
			addToSignal(gamePaused, handleGamePaused);
		}
		
	}

}