package com.halo103.hls.interfaces {
	
	import com.halo103.hls.vos.states.PlayerTokenState;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface PlayerToken extends PlayerDependent {
		
		function get headPosition():Vector3D;
		
		function set state(tokenState:PlayerTokenState):void;
		
		/**
		 * Sets the color of the PlayerToken.
		 * @param color value equal to one of the color constants in PlayerState.
		 */
		function set color(color:int):void;
	}
	
}