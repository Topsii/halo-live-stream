package com.paultondeur.away3d.robotlegs.core {
	import away3d.containers.Scene3D;

	/**
	 * @author Paul Tondeur
	 */
	public interface IContext3D {
		function get scene3D() : Scene3D;

		function set scene3D(value : Scene3D) : void

		function get threeDeeMap() : IMediator3DMap;

		function set threeDeeMap(value : IMediator3DMap) : void
	}
}
