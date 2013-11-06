package com.halo103.hls.interfaces {
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface PlayerDependent {
		
		/**
		 * Returns the slotId used by the player on whom this class is depending on.
		 */
		function get slotId():int;
		
	}
	
}