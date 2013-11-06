package com.halo103.hls.controller {
	import com.halo103.hls.interfaces.CameraView3D;
	import com.halo103.hls.interfaces.IAssetLoadProgressView;
	import com.halo103.hls.interfaces.IClock;
	import com.halo103.hls.interfaces.ILiveButton;
	import com.halo103.hls.interfaces.IScoreboard;
	import com.halo103.hls.interfaces.ISpectateControl;
	import com.halo103.hls.interfaces.MessagesPlayerDisplay;
	import com.halo103.hls.interfaces.PlayerCameraView;
	import com.halo103.hls.interfaces.PlayerToken;
	import com.halo103.hls.interfaces.IGameDataLoadProgressView;
	import com.halo103.hls.interfaces.IGameDataParseProgressView;
	import com.halo103.hls.interfaces.IGameDataService;
	import com.halo103.hls.interfaces.IGameDataParser;
	import com.halo103.hls.interfaces.IPlayToggleButton;
	import com.halo103.hls.interfaces.ITimeProgressControl;
	import com.halo103.hls.interfaces.PlayerNameDisplay;
	import com.halo103.hls.interfaces.PlayerPositionDisplay;
	import com.halo103.hls.controller.commands.*;
	import com.halo103.hls.controller.signals.*;
	import com.halo103.hls.interfaces.SpectateSelectionView;
	import com.halo103.hls.scene.mediators.PlayerTokenMediator;
	import com.halo103.hls.services.*;
	import com.halo103.hls.services.parsers.*;
	import com.halo103.hls.view.components.*;
	import com.halo103.hls.scene.components.GameMap3D;
	import com.halo103.hls.scene.components.Cyborg;
	import com.halo103.hls.view.mediators.*;
	import com.paultondeur.away3d.robotlegs.mvcs.Context3D;
	import com.paultondeur.away3d.robotlegs.mvcs.SignalContext3D;
	import org.osflash.signals.Signal;
	import org.robotlegs.base.ContextEvent;
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.utilities.variance.base.IVariantMediatorMap;
	import org.robotlegs.utilities.variance.base.RLVariantMediatorMap;
	/**
	 * ...
	 * @author Topsi
	 */
	public class MDRR3DContext extends SignalContext3D {
		
		private var variantMap:IVariantMediatorMap;
		
		public function MDRR3DContext(contextView:DisplayObjectContainer, autoStartup : Boolean = true) {
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			variantMap = new RLVariantMediatorMap(contextView, createChildInjector(), reflector);
			
			//mediatorMap.mapView(MessageView, MessageViewMediator);
			
			injector.mapSingleton(GameMap3D);
			
			injector.mapSingletonOf(IGameDataService, LogLoaderService);
			//injector.mapSingletonOf(IGameDataService, LiveStreamService);
			injector.mapSingleton(Away3DAssetsService);
			injector.mapSingletonOf(IGameDataParser, LogParser);
			//injector.mapSingletonOf(IGameDataParser, LineParser);
			
			
			//inject signals dispatched by the GameDataService
			injector.mapSingleton(GameDataParsed);
			injector.mapSingleton(GameDataParsingProgressed);
			injector.mapSingleton(GameDataLoaded);
			injector.mapSingleton(GameDataLoadingProgressed);
			
			//inject signals dispatched by the Away3dAssetsService
			signalCommandMap.mapSignalClass(AllAssetResourcesLoaded, SetupSceneCommand);
			injector.mapSingleton(AssetResourceLoaded);
			injector.mapSingleton(AssetLoaded);
			
			//inject signals dispatched by the GameReplayService
			injector.mapSingleton(GameStateChanged);
			injector.mapSingleton(GamePaused);
			injector.mapSingleton(GameStarted);
			injector.mapSingleton(ReplayDurationChanged);
			
			injector.mapSingleton(SpectateSlotIdChanged);
			injector.mapSingleton(PlayerTokenAnimated);
			
			injector.mapSingleton(GameReplayService);
			
			var startup:StartedUp = new StartedUp();
			signalCommandMap.mapSignal(startup, LoadGameDataCommand);
			
			signalCommandMap.mapSignalClass(TogglePlayingState, TogglePlayingStateCommand);
			signalCommandMap.mapSignalClass(SetTimeProgress, SetTimeProgressCommand);
			signalCommandMap.mapSignalClass(GoLive, GoLiveCommand);
			signalCommandMap.mapSignalClass(GameInfoParsed, LoadResourcesCommand); //todo: seperate loading resources like the cyborg mesh/anim from loading the map mesh
			
			variantMap.mapMediator(CameraView3D, CameraViewMediator);
			variantMap.mapMediator(PlayerCameraView, PlayerCameraViewMediator);
			variantMap.mapMediator(SpectateSelectionView, SpectateSelectionViewMediator);
			variantMap.mapMediator(MessagesPlayerDisplay, MessagesPlayerDisplayMediator);
			variantMap.mapMediator(IPlayToggleButton, PlayToggleButtonMediator);
			variantMap.mapMediator(IScoreboard, ScoreboardMediator);
			variantMap.mapMediator(PlayerPositionDisplay, PlayerPositionMediator);
			variantMap.mapMediator(PlayerNameDisplay, PlayerNameMediator);
			variantMap.mapMediator(ITimeProgressControl, TimeProgressMediator);
			variantMap.mapMediator(ISpectateControl, SpectateControlMediator);
			variantMap.mapMediator(ILiveButton, LiveButtonMediator);
			variantMap.mapMediator(IClock, ClockMediator);
			variantMap.mapMediator(IGameDataLoadProgressView, GameDataLoadMediator);
			variantMap.mapMediator(IGameDataParseProgressView, GameDataParseMediator);
			variantMap.mapMediator(IAssetLoadProgressView, AssetLoadMediator);
			
			threeDeeMap.mapObject3D(Cyborg, PlayerTokenMediator, PlayerToken);
			
			mediatorMap.mapView(MDRR3D, LoadCompleteMediator);
			
			contextView.addChild(new MDRR3D());
			
			startup.dispatchValue(String(contextView.root.loaderInfo.parameters.retrCmd));
			
		}
	}

}