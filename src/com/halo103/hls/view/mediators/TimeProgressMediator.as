package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.ITimeProgressControl;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.halo103.hls.controller.signals.ReplayDurationChanged;
	import com.halo103.hls.controller.signals.SetTimeProgress;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class TimeProgressMediator extends SignalMediator {
		
		[Inject] public var timeProgressControl:ITimeProgressControl;
		
		[Inject] public var setTimeProgress:SetTimeProgress;
		
		[Inject] public var durationChanged:ReplayDurationChanged;
		[Inject] public var gameStateChanged:GameStateChanged;
		
		private var _duration:Number;
		private var _time:Number;
		
		private function timeProgressSetByUser(timeProgress:Number):void {
			setTimeProgress.dispatchValue(timeProgress);
		}
		
		private function handleGameStateChanged(gameState:GameState):void {
			_time = gameState.time;
			timeProgressControl.showTimeProgress(_time / _duration);
		}
		
		private function handleDurationChanged(duration:int):void {
			_duration = duration;
			timeProgressControl.showTimeProgress(_time / _duration);
		}
		
		override public function onRegister():void {
			_duration = 0;
			_time = 0;
			addToSignal(timeProgressControl.timeProgressChanged, timeProgressSetByUser);
			addToSignal(durationChanged, handleDurationChanged);
			addToSignal(gameStateChanged, handleGameStateChanged);
		}
		
	}

}