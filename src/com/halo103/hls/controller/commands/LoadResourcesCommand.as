package com.halo103.hls.controller.commands {
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import com.halo103.hls.services.Away3DAssetsService;
	import away3d.loaders.parsers.AWD2Parser;
	import com.halo103.hls.services.GameReplayService;
	import com.halo103.hls.scene.components.Cyborg;
	import com.halo103.hls.vos.GameInfo;
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
	public class LoadResourcesCommand extends SignalCommand {
		
		[Inject] public var away3dAssetsService:Away3DAssetsService;
		
		[Inject] public var gameInfo:GameInfo;
		
		override public function execute():void {
			
			var mapname:String = "ratrace";
			var assets:Vector.<String> = new <String>[
				"assets/" + gameInfo.mapName + ".awd",
				"assets/" + gameInfo.mapName + "_Lightmap.awd",
				"assets/cyborg/cyborg.md5mesh",
				"assets/cyborg/anims/stand look.md5anim",
				"assets/cyborg/anims/rifle/stand rifle aim-move.md5anim",
				"assets/cyborg/anims/rifle/stand rifle aim-still.md5anim",
				"assets/cyborg/anims/rifle/stand rifle idle.md5anim",
				"assets/cyborg/anims/rifle/stand rifle move-back.md5anim",
				"assets/cyborg/anims/rifle/stand rifle move-front.md5anim",
				"assets/cyborg/anims/rifle/stand rifle move-left.md5anim",
				"assets/cyborg/anims/rifle/stand rifle move-right.md5anim",
				"assets/cyborg/anims/rifle/stand rifle turn-left.md5anim",
				"assets/cyborg/anims/rifle/stand rifle turn-right.md5anim",
				//"assets/cyborg/anims/unarmed/stand unarmed move-front.md5anim",
				"assets/cyborg/cyborg.png",
				"assets/cyborg/cyborgred.png",
				"assets/cyborg/cyborgblue.png",
				"assets/cyborg/cyborgNormalMap.jpg",
			];
			var names:Vector.<String> = new <String>[
				null,
				null,
				Cyborg.MESH,
				Cyborg.STAND_LOOK,
				Cyborg.STAND_RIFLE_AIM_MOVE,
				Cyborg.STAND_RIFLE_AIM_STILL,
				Cyborg.STAND_RIFLE_IDLE,
				Cyborg.STAND_RIFLE_MOVE_BACK,
				Cyborg.STAND_RIFLE_MOVE_FRONT,
				Cyborg.STAND_RIFLE_MOVE_LEFT,
				Cyborg.STAND_RIFLE_MOVE_RIGHT,
				Cyborg.STAND_RIFLE_TURN_LEFT,
				Cyborg.STAND_RIFLE_TURN_RIGHT,
				//"assets/cyborg/anims/stand unarmed move-front.md5anim",
				"cyborg-",
				"cyborgred-",
				"cyborgblue-",
				"cyborg normal-",
			];
			var parsers:Vector.<Class> = new <Class>[
				Max3DSParser,
				AWD2Parser,
				OBJParser,
				ImageParser,
				MD5MeshParser,
				MD5AnimParser,
			];
			away3dAssetsService.getAway3DAssets(assets, parsers, names);
		}
		
	}

}