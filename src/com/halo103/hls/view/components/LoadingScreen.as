package com.halo103.hls.view.components {
	import com.halo103.hls.interfaces.IAssetLoadProgressView;
	import com.halo103.hls.interfaces.IGameDataLoadProgressView;
	import com.halo103.hls.interfaces.IGameDataParseProgressView;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author Topsi
	 */
	public class LoadingScreen extends Sprite implements IGameDataLoadProgressView, IGameDataParseProgressView, IAssetLoadProgressView {
		
		
		private const progBarWidth:Number = 400;
		private const progBarHeight:Number = 40;
		private const verticalPadding:Number = 300;
		
		private var addedToStage:NativeSignal;
		private var removedFromStage:NativeSignal;
		private var stageResized:NativeSignal;
		
		private var _loadGDataProgBar:Shape;
		private var _loadGDataDescr:TextField;
		private var loadGprogress:Number;
		
		private var _parseGDataProgBar:Shape;
		private var _parseGDataDescr:TextField;
		private var parseGprogress:Number;
		
		private var _load3dFilProgBar:Shape;
		private var _load3dFilDescr:TextField;
		private var load3dGprogress:Number;
		
		
		public function LoadingScreen() {
			super();
			
			loadGprogress = 0;
			parseGprogress = 0;
			load3dGprogress = 0;
			
			_loadGDataProgBar = new Shape();
			_loadGDataDescr = new TextField();
			
			_parseGDataProgBar = new Shape();
			_parseGDataDescr = new TextField();
			
			_load3dFilProgBar = new Shape();
			_load3dFilDescr = new TextField();
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			removedFromStage = new NativeSignal(this, Event.REMOVED_FROM_STAGE, Event);
			
			addedToStage.addOnce(onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			
			setUpProgressSet(1, _loadGDataProgBar, _loadGDataDescr);
			setLoadGameDataProgress(0);
			addChild(_loadGDataProgBar);
			addChild(_loadGDataDescr);
			
			setUpProgressSet(2, _parseGDataProgBar, _parseGDataDescr);
			setParseGameDataProgress(0);
			addChild(_parseGDataProgBar);
			addChild(_parseGDataDescr);
			
			setUpProgressSet(3, _load3dFilProgBar, _load3dFilDescr);
			setLoad3dFilesProgress(0);
			setLoadedAssets(0);
			addChild(_load3dFilProgBar);
			addChild(_load3dFilDescr);
			
			stageResized = new NativeSignal(stage, Event.RESIZE, Event);
			stageResized.add(onStageResize);
			removedFromStage = new NativeSignal(this, Event.REMOVED_FROM_STAGE, Event);
			removedFromStage.addOnce(onRemovedFromStage);
		}
		
		private function onStageResize(event:Event):void {
			setUpProgressSet(1, _loadGDataProgBar, _loadGDataDescr);
			setUpProgressSet(2, _parseGDataProgBar, _parseGDataDescr);
			setUpProgressSet(3, _load3dFilProgBar, _load3dFilDescr);
			_loadGDataProgBar.width = loadGprogress * progBarWidth;
			_parseGDataProgBar.width = parseGprogress * progBarWidth;
			_load3dFilProgBar.width = load3dGprogress * progBarWidth;
		}
		
		private function onRemovedFromStage(event:Event):void {
			stageResized.remove(onStageResize);
			stageResized = null;
		}
		
		public function setLoadGameDataProgress(progress:Number):void {
			loadGprogress = progress;
			_loadGDataProgBar.width = loadGprogress * progBarWidth;
			_loadGDataDescr.text = "Game data loaded: " + Math.round(progress * 100) + "%";
		}
		
		public function setParseGameDataProgress(progress:Number):void {
			parseGprogress = progress;
			_parseGDataProgBar.width = parseGprogress * progBarWidth;
			_parseGDataDescr.text = "Game data parsed: " + Math.round(progress * 100) + "%";
		}
		
		public function setLoad3dFilesProgress(progress:Number):void {
			load3dGprogress = progress;
			_load3dFilProgBar.width = load3dGprogress * progBarWidth;
		}
		
		public function setLoadedAssets(loadedAssets:uint):void {
			_load3dFilDescr.text = "3d assets loaded: " + loadedAssets;
		}
		
		private function setUpProgressSet(position:Number, progBar:Shape, description:TextField):void {
			progBar.graphics.clear();
			progBar.graphics.beginFill(0xFFFFFF);
			progBar.graphics.drawRect(0,0,progBarWidth,progBarHeight);
			progBar.graphics.endFill();
			progBar.x = (stage.stageWidth / 2) - (progBarWidth / 2);
			progBar.y = ((position - 0.5) * (stage.stageHeight - verticalPadding) / 3) - (progBarHeight / 2) + (verticalPadding / 2);
			
			description.textColor = 0xFFFFFF;
			description.height = 20;
			description.width = 150;
			description.x = progBar.x;
			description.y = progBar.y + progBarHeight;
			description.selectable = false;
		}
	}

}