package com.paultondeur.away3d.robotlegs.base {
	
	import com.paultondeur.away3d.robotlegs.core.IMediator3D;
	import org.osflash.signals.ISignal;
	import org.robotlegs.core.ISignalMap;
	import org.robotlegs.mvcs.SignalMap;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SignalMediator3D extends Mediator3D {
		
		protected var _signalMap:ISignalMap;
		
		public function SignalMediator3D() {
			super();
		}
	
		override public function preRemove():void {
			signalMap.removeAll();
			super.preRemove();
		}
		
		protected function get signalMap():ISignalMap {
			return _signalMap ||= new SignalMap();
		}
	
		protected function addToSignal(signal:ISignal, handler:Function):void {
			signalMap.addToSignal(signal, handler);
		} 
		
		protected function addOnceToSignal(signal:ISignal, handler:Function):void {
			signalMap.addOnceToSignal(signal, handler);
		}
	}

}