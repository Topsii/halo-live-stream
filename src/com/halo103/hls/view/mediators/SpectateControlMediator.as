package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.interfaces.ISpectateControl;
	import com.halo103.hls.controller.signals.SpectateSlotIdChanged;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SpectateControlMediator extends SignalMediator {
		
		[Inject] public var spectatorControl:ISpectateControl;
		
		[Inject] public var spectateSlotIdChanged:SpectateSlotIdChanged;
		
		private function spectateSlotIdSetByUser(spectateSlotId:int):void {
			spectateSlotIdChanged.dispatchValue(spectateSlotId);
		}
		
		override public function onRegister():void {
			addToSignal(spectatorControl.spectatorIdChanged, spectateSlotIdSetByUser);
		}
		
	}

}