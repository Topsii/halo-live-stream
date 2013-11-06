package com.halo103.hls.controller.commands {
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import com.halo103.hls.services.Away3DAssetsService;
	import away3d.loaders.parsers.AWD2Parser;
	import com.halo103.hls.services.GameReplayService;
	import com.halo103.hls.scene.components.Cyborg;
	import flash.net.URLRequest;
	import away3d.loaders.parsers.OBJParser;
	import com.halo103.hls.interfaces.IGameDataService;
	import away3d.loaders.parsers.ImageParser;
	import away3d.loaders.parsers.MD2Parser;
	import org.robotlegs.mvcs.SignalCommand;
	/**
	 * ...
	 * @author Topsi
	 */
	public class LoadGameDataCommand extends SignalCommand {
		
		[Inject] public var gameDataService:IGameDataService;
		
		[Inject] public var retrCmd:String;
		
		override public function execute():void {
			
			if (retrCmd == "undefined") {
				//retrCmd = "getGameByID 14";
				//retrCmd = "getGameByServer 82.198.215.36:2309";
				//retrCmd = "getGameByServer 95.211.120.168:2312";
				retrCmd = "getGameByID 22";
				//retrCmd = "getGameByServer 127.0.0.1:2309";
				//retrCmd = "getGameByID 1";
			}
			
			gameDataService.getGameData("data2.txt");
			
			//gameDataService.getGameData(retrCmd);
			
		}
		
	}

}