package com.halo103.hls.view.mediators {
	import away3d.containers.Scene3D;
	import com.halo103.hls.interfaces.CameraView3D;
	import com.halo103.hls.interfaces.IPlayToggleButton;
	import com.halo103.hls.scene.components.GameMap3D;
	import flash.utils.getTimer;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.mvcs.SignalMediator;
	/**
	 * ...
	 * @author Topsi
	 */
	public class CameraViewMediator extends SignalMediator {
		
		[Inject] public var cameraView:CameraView3D;
		
		[Inject] public var scene3D2:Scene3D;
		
		override public function onRegister():void {
			cameraView.scene = scene3D2;
		}
		
		
	}

}