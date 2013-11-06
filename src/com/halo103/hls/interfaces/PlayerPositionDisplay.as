package com.halo103.hls.interfaces {
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface PlayerPositionDisplay extends PlayerDependent{
		
		function set position(player3DPosition:Vector3D):void;
		
	}
	
}