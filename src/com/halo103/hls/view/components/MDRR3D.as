package com.halo103.hls.view.components {
	
	import away3d.debug.AwayStats;
	import com.halo103.hls.controller.MDRR3DContext;
	import com.halo103.hls.interfaces.CameraView3D;
	import com.halo103.hls.interfaces.SpectateSelectionView;
	import com.halo103.hls.view.components.ControlBar;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author Topsi
	 */
	public class MDRR3D extends Sprite implements SpectateSelectionView {
		
		private var addedToStage:NativeSignal;
		private var removedFromStage:NativeSignal;
		
		private var stageResized:NativeSignal;
		private var keyDown:NativeSignal;
		private var keyUp:NativeSignal;
		
		private var loadingScreen:LoadingScreen;
		private var spectatorView:PlayerCameraView3D;
		private var awayStats:AwayStats;
		private var controlBar:ControlBar;
		private var chat:PlayerChat;
		private var scoreboard:Scoreboard;
		
		private var showMap:Boolean;
		
		public function MDRR3D() {
			super();
			showMap = false;
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			onStageResize();
			
			stageResized = new NativeSignal(stage, Event.RESIZE, Event);
			stageResized.add(onStageResize);
			
			removedFromStage = new NativeSignal(this, Event.REMOVED_FROM_STAGE, Event);
			removedFromStage.addOnce(onRemovedFromStage);
		}
		
		private function onStageResize(event:Event=null):void {
			if (showMap) {
				if ((stage.stageHeight - controlBar.height) > 0) {
					if (!contains(spectatorView)) {
						addChildAt(spectatorView, 0);
					}
					spectatorView.height = (stage.stageHeight - controlBar.height);
					spectatorView.width = stage.stageWidth;
				} else {
					if (contains(spectatorView)) {
						removeChild(spectatorView);
					}
					controlBar.height = stage.stageHeight;
				}
				awayStats.x = stage.stageWidth - awayStats.width;
			} else {
				if ((stage.stageHeight - controlBar.height) > 0) {
					
				} else {
					controlBar.height = stage.stageHeight;	
				}
			}
		}
		
		private function onRemovedFromStage(event:Event):void {
			stageResized.remove(onStageResize);
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
		}
		
		public function initView():void {
			loadingScreen = new LoadingScreen;
			addChild(loadingScreen);
			
			controlBar = new ControlBar();
			addChild(controlBar);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.F1) {
				scoreboard.visible = true;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.F1) {
				scoreboard.visible = false;
			}
		}
		
		public function showContent():void {
			showMap = true;
			
			removeChild(loadingScreen);
			loadingScreen = null;
			
			spectatorView = new PlayerCameraView3D();
			addChildAt(spectatorView, 0);
			
			chat = new PlayerChat();
			addChildAt(chat,1);
			
			scoreboard = new Scoreboard();
			scoreboard.visible = false;
			addChild(scoreboard);
			keyUp = new NativeSignal(stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			keyUp.add(onKeyUp);
			keyDown = new NativeSignal(stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			keyDown.add(onKeyDown);
			
			controlBar.enableContentControls();
			spectatorView.height -= controlBar.height;
			
			awayStats = new AwayStats(spectatorView);
			addChild(awayStats);
			
			onStageResize();
		}
		
		public function set spectateSlotId(spectateSlotId:int):void {
			removeChild(spectatorView);
			awayStats.unregisterView(spectatorView);
			spectatorView.dispose();
			spectatorView = new PlayerCameraView3D(spectateSlotId);
			awayStats.registerView(spectatorView);
			addChildAt(spectatorView, 0);
			
			removeChild(chat);
			chat = new PlayerChat(spectateSlotId);
			addChildAt(chat,1);
		}
		
	}

}