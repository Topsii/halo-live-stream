package com.halo103.hls.interfaces {
	
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.ScoreState;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface IScoreboard {
		
		function showPlayers(players:Vector.<PlayerState>):void;
		
	}
	
}