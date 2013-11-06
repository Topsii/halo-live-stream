package com.halo103.hls.vos {
	import com.halo103.hls.services.intervals.GameInterval;
	
	/**
	 * All objects containing information about how a Game changed as for example the
	 * deaht of a player at a specific time are considered game changes.
	 * 
	 * This interface exists specifically for the purpose of adding such game
	 * changes to the GameReplayService. Parsers need to create objects that
	 * are implementing this interface to add them to the GameReplayService.
	 * 
	 * There is a difference to the GameStateChange interface, because GameChanges can 
	 * be GameStateChanges as well as PlayerStateChanges, while GameStateChanges cannot
	 * be PlayerStateChanges. PlayerStateChanges only change certain fields of a 
	 * PlayerState exclusively.
	 * 
	 * @author Topsi
	 */
	public interface GameChange {
		
		/**
		 * When executed this piece of information about the game will add itself to a GameInterval object.
		 */
		function addToInterval(gameInterval:GameInterval):void;
		
		function get time():int;
		
		function set time(time:int):void;
		
	}
	
}