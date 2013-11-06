package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.ILiveButton;
	import com.halo103.hls.controller.signals.GoLive;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class LiveButtonMediator extends SignalMediator {
		
		[Inject] public var liveButton:ILiveButton;
		
		[Inject] public var goLive:GoLive;
		
		private function playButtonClicked(event:MouseEvent):void {
			goLive.dispatch();
		}
		
		override public function onRegister():void {
			addToSignal(liveButton.liveButtonClicked, playButtonClicked);
		}
		
	}

}