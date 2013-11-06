package com.halo103.hls.view.mediators {
	
	import com.halo103.hls.controller.signals.SpectateSlotIdChanged;
	import com.halo103.hls.interfaces.SpectateSelectionView;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SpectateSelectionViewMediator extends SignalMediator {
		
		[Inject] public var spectatorView:SpectateSelectionView;
		
		[Inject] public var spectatorIdChanged:SpectateSlotIdChanged;
		
		private function handleSpectateSlotIdChanged(spectateSlotId:int):void {
			spectatorView.spectateSlotId = spectateSlotId;
		}
		
		override public function onRegister():void {
			addToSignal(spectatorIdChanged, handleSpectateSlotIdChanged);
		}
	
	}

}