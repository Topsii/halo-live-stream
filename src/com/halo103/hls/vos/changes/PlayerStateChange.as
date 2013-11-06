package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.states.PlayerState;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface PlayerStateChange {
		
		function apply(player:PlayerState, curTime:int, prevTime:int):void;
		
		function get time():int;
		
		function set time(time:int):void;
		
	}
	
}