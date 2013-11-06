package com.halo103.hls.controller.commands {
	import away3d.containers.Scene3D;
	import com.halo103.hls.scene.components.GameMap3D;
	import org.robotlegs.mvcs.SignalCommand;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class SetupSceneCommand extends SignalCommand {
		
		[Inject] public var scene:Scene3D;
		
		[Inject] public var gameMap:GameMap3D;
		
		override public function execute():void {
			scene.addChild(gameMap);
			gameMap.init();
		}
		
	}

}