package com.halo103.hls.interfaces {
	
	import org.osflash.signals.ISignal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface ITimeProgressControl {
		
		function get timeProgressChanged():ISignal;
		
		function showTimeProgress(time:Number):void;
		
	}
	
}