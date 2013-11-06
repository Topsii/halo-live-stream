package com.halo103.hls.view.components {
	
	import com.halo103.hls.interfaces.IClock;
	import com.halo103.hls.interfaces.ILiveButton;
	import com.halo103.hls.interfaces.IPlayToggleButton;
	import com.halo103.hls.interfaces.ISpectateControl;
	import com.halo103.hls.interfaces.ITimeProgressControl;
	import com.halo103.hls.controller.signals.SetTimeProgress;
	import com.halo103.hls.controller.signals.SpectateSlotIdChanged;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class ControlBar extends Sprite implements IPlayToggleButton, ITimeProgressControl, IClock, ISpectateControl, ILiveButton {
		
		private const cBarHt:Number = 20;
		private const border:Number = 3;
		private const btnWh:Number = 28;
		
		private var _playButtonMouseClick:NativeSignal;
		private var _timeProgressChanged:SetTimeProgress;
		private var _spectateSlotIdChanged:SpectateSlotIdChanged;
		
		private var _liveButtonClick:NativeSignal;
		private var _fullScreenButtonMouseClick:NativeSignal;
		private var _timeLineMouseDown:NativeSignal;
		private var _stageMouseUp:NativeSignal;
		private var _stageMouseMove:NativeSignal;
		private var _stageKeyUp:NativeSignal;
		
		private var timeLineDragging:Boolean;
		
		//needs to be saved for a call of the resize method
		private var _timeProgress:Number;
		
		//view components
		private var playButton:Sprite;
		private var timeText:TextField;
		private var timeLine:Sprite;
		private var liveButton:Sprite;
		private var fullScreenButton:Sprite;
		
		public function ControlBar() {
			super();
			
			_timeProgress = 0;
			
			/**
			 * Create the signals in the constructor, because listeners may be
			 * added before the control bar is added to stage. Also create the
			 * sprites here since they are needed to create the native signals 
			 */
			playButton = new Sprite();
			liveButton = new Sprite();
			timeText = new TextField();
			timeLine = new Sprite();
			fullScreenButton = new Sprite();
			_timeProgressChanged = new SetTimeProgress();
			_spectateSlotIdChanged = new SpectateSlotIdChanged();
			_playButtonMouseClick = new NativeSignal(playButton, MouseEvent.CLICK, MouseEvent);
			_liveButtonClick = new NativeSignal(liveButton, MouseEvent.CLICK, MouseEvent);
			_fullScreenButtonMouseClick = new NativeSignal(fullScreenButton, MouseEvent.CLICK, MouseEvent);
			_fullScreenButtonMouseClick.add(onFullScreenButtonClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			_timeLineMouseDown = new NativeSignal(timeLine, MouseEvent.MOUSE_DOWN, MouseEvent);
			_timeLineMouseDown.add(onTimeLineMouseDown);
			_stageMouseMove = new NativeSignal(stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			_stageMouseMove.add(onStageMouseMove);
			_stageMouseUp = new NativeSignal(stage, MouseEvent.MOUSE_UP, MouseEvent);
			_stageMouseUp.add(onStageMouseUp);
			_stageKeyUp = new NativeSignal(stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			_stageKeyUp.add(onKeyUp);
			y = stage.stageHeight - (cBarHt + border);
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, cBarHt + border);
			graphics.endFill();
			
			fullScreenButton.x = stage.stageWidth -btnWh;
			fullScreenButton.y = border;
			fullScreenButton.graphics.beginFill(0x666666);
			fullScreenButton.graphics.drawRect(0, 0, btnWh, cBarHt);
			fullScreenButton.graphics.endFill();
			fullScreenButton.graphics.lineStyle(2.5, 0x000000);
			fullScreenButton.graphics.drawRect(7, 6, 15, 9);
			fullScreenButton.useHandCursor = true;
			fullScreenButton.buttonMode = true;
			fullScreenButton.mouseChildren = false;
			addChild(fullScreenButton);
			
			liveButton.x = stage.stageWidth -(btnWh*2) - border;
			liveButton.y = border;
			liveButton.useHandCursor = true;
			liveButton.buttonMode = true;
			liveButton.mouseChildren = false;
			liveButton.graphics.beginFill(0x666666);
			liveButton.graphics.drawRect(0, 0, btnWh, cBarHt);
			liveButton.graphics.endFill();
			var liveText:TextField = new TextField();
			var liveTf:TextFormat = new TextFormat("Arial", 11)
			liveTf.align = TextFormatAlign.CENTER;
			liveText.defaultTextFormat = liveTf
			liveText.text = "LIVE";
			liveText.width = btnWh;
			liveText.height = cBarHt;
			liveText.border = false;
			liveText.selectable = false;
			liveButton.addChild(liveText);
			
			playButton.y = border;
			showPauseIcon();
			playButton.useHandCursor = true;
			playButton.buttonMode = true;
			playButton.mouseChildren = false;
			
			var timeTf:TextFormat = new TextFormat("Arial", 13)
			timeTf.align = TextFormatAlign.RIGHT;
			timeText.defaultTextFormat = timeTf;
			timeText.x = playButton.x + playButton.width + border;
			timeText.y = border;
			timeText.background = true;
			timeText.backgroundColor = 0x666666;
			timeText.text = "00:00";
			timeText.width = 40;
			timeText.height = cBarHt;
			timeText.border = false;
			timeText.selectable = false;
			
			timeLine.y = border;
			timeLine.x = timeText.x + timeText.width + border;
			
			timeLine.graphics.beginFill(0x666666);
			timeLine.graphics.drawRect(0, 0, liveButton.x - border - timeLine.x, cBarHt);
			timeLine.graphics.endFill();
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		private function onKeyUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.NUMBER_1:
				case Keyboard.NUMBER_2:
				case Keyboard.NUMBER_3:
				case Keyboard.NUMBER_4:
				case Keyboard.NUMBER_5:
				case Keyboard.NUMBER_6:
				case Keyboard.NUMBER_7:
				case Keyboard.NUMBER_8:
				case Keyboard.NUMBER_9:
					_spectateSlotIdChanged.dispatchValue(event.keyCode - 49);
					break;
				case Keyboard.NUMBER_0:
					_spectateSlotIdChanged.dispatchValue(9);
					break;
				case Keyboard.U:
					_spectateSlotIdChanged.dispatchValue(10);
					break;
				case Keyboard.I:
					_spectateSlotIdChanged.dispatchValue(11);
					break;
				case Keyboard.O:
					_spectateSlotIdChanged.dispatchValue(12);
					break;
				case Keyboard.J:
					_spectateSlotIdChanged.dispatchValue(13);
					break;
				case Keyboard.K:
					_spectateSlotIdChanged.dispatchValue(14);
					break;
				case Keyboard.L:
					_spectateSlotIdChanged.dispatchValue(15);
					break;
				case Keyboard.P:
					_spectateSlotIdChanged.dispatchValue(-1);
					break;
			}
		}
		
		public function enableContentControls():void {
			addChild(playButton);
			addChild(timeLine);
			addChild(liveButton);
			addChild(timeText);
		}
		
		public function get timeProgressChanged():ISignal {
			return _timeProgressChanged;
		}
		
		public function get spectatorIdChanged():ISignal {
			return _spectateSlotIdChanged;
		}
		
		public function showTimeProgress(timeProgress:Number):void {
			_timeProgress = timeProgress;
			drawTimeLine(timeProgress);
		}
		
		public function showTime(time:int):void {
			var d:Date = new Date(Number(time));
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("mm:ss");
			timeText.text = dtf.format(d);
		}
		
		public function showPlayIcon():void {
			playButton.graphics.clear();
			playButton.graphics.beginFill(0x666666);
			playButton.graphics.drawRect(0, 0, btnWh, cBarHt);
			playButton.graphics.endFill();
			playButton.graphics.beginFill(0x000000);
			playButton.graphics.moveTo(8, 5);
			playButton.graphics.lineTo(20, 10);
			playButton.graphics.lineTo(8, 15);
			playButton.graphics.lineTo(8, 5);
			playButton.graphics.endFill();
		}
		
		public function showPauseIcon():void {
			playButton.graphics.clear();
			playButton.graphics.beginFill(0x666666);
			playButton.graphics.drawRect(0, 0, btnWh, cBarHt);
			playButton.graphics.endFill();
			playButton.graphics.lineStyle(3, 0x000000);
			playButton.graphics.moveTo(9, 5);
			playButton.graphics.lineTo(9, 15);
			playButton.graphics.moveTo(15, 5);
			playButton.graphics.lineTo(15, 15);
		}
		
		public function get playButtonClicked():ISignal {
			return _playButtonMouseClick;
		}
		
		public function get liveButtonClicked():ISignal {
			return _liveButtonClick;
		}
		
		private function drawTimeLine(timeProgress:Number):void {
			timeLine.graphics.clear();
			
			timeLine.graphics.beginFill(0x666666);
			timeLine.graphics.drawRect(0, 0, liveButton.x - border - timeLine.x, cBarHt);
			timeLine.graphics.endFill();
			
			timeLine.graphics.beginFill(0x800000);
			timeLine.graphics.drawRect(0, 0, timeProgress * (liveButton.x - border - timeLine.x), cBarHt);
			timeLine.graphics.endFill();
		}
		
		private function setTime(time:int):void {
			_timeProgressChanged.dispatchValue(time);
		}
		
		private function onTimeLineMouseDown(event:MouseEvent):void {
			timeLineDragging = true;
			var timeLineProgress:Number = (event.stageX - ((timeLine.localToGlobal(new Point(0, 0))).x)) / timeLine.width;
			if (timeLineProgress <= 0) {
				_timeProgressChanged.dispatchValue(0);
			} else if (timeLineProgress >= 1) {
				_timeProgressChanged.dispatchValue(1);
			} else {
				_timeProgressChanged.dispatchValue(timeLineProgress);
			}
		}
		
		private function onStageMouseUp(event:MouseEvent):void {
			timeLineDragging = false;
		}
		
		private function onStageMouseMove(event:MouseEvent):void {
			if (timeLineDragging) {
				var timeLineProgress:Number = (event.stageX - ((timeLine.localToGlobal(new Point(0, 0))).x)) / timeLine.width;
				if (timeLineProgress <= 0) {
					_timeProgressChanged.dispatchValue(0);
				} else if (timeLineProgress >= 1) {
					_timeProgressChanged.dispatchValue(1);
				} else {
					_timeProgressChanged.dispatchValue(timeLineProgress);
				}
			}
		}
		
		private function onFullScreenButtonClick(event:MouseEvent):void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;	
			} else {
				stage.displayState = StageDisplayState.NORMAL; 
			}
			dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, true));
		}
		
		private function onStageResize(event:Event):void {
			y = stage.stageHeight - (cBarHt + border);
			
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, cBarHt + border);
			graphics.endFill();
			
			fullScreenButton.x = stage.stageWidth -btnWh;
			
			liveButton.x = stage.stageWidth -(btnWh * 2) - border;
			
			timeText.x = playButton.x + playButton.width + border;
			
			timeLine.x = timeText.x + timeText.width + border;
			drawTimeLine(_timeProgress);
		}
		
	}

}