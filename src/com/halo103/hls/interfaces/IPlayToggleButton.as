package com.halo103.hls.interfaces {
	
	import org.osflash.signals.ISignal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface IPlayToggleButton {
		
		function get playButtonClicked():ISignal;
		
		function showPlayIcon():void;
		
		function showPauseIcon():void;
		
	}
	
}