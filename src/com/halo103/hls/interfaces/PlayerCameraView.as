package com.halo103.hls.interfaces {
	
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface PlayerCameraView extends PlayerDependent {
		
		function set perspective(direction:Vector3D):void;
		
		function set cameraPosition(position:Vector3D):void;
		
		function showDeath():void;
		
		function showAlive():void;
		
		function showNothing():void;
	}
	
}