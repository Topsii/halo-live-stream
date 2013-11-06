package com.halo103.hls.view.components {
	
	import com.halo103.hls.interfaces.MessagesPlayerDisplay;
	import com.halo103.hls.vos.Message;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerChat extends Sprite implements MessagesPlayerDisplay {
		
		private var addedToStage:NativeSignal;
		private var removedFromStage:NativeSignal;
		
		private var stageResized:NativeSignal;
		
		private var textBox:TextField;
		
		private var _slotId:int;
		
		public function PlayerChat(slotId:int = -1) {
			_slotId = slotId;
			textBox = new TextField();
			textBox.selectable = false;
			textBox.textColor = 0xFFFFFF;
			textBox.x = 5;
			addChild(textBox);
			
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
		
		private function onStageResize(event:Event = null):void {
			textBox.width = stage.stageWidth;
			textBox.y = stage.stageHeight * 0.6;
			var tf:TextFormat = new TextFormat("Arial Narrow", Math.ceil(stage.stageHeight * 0.02));
			tf.align = TextFormatAlign.LEFT;
			textBox.defaultTextFormat = tf;
		}
		
		private function onRemovedFromStage(event:Event):void {
			stageResized.remove(onStageResize);
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
		}
		
		public function displayMessages(messages:Vector.<Message>):void {
			textBox.text = "";
			for each (var msg:Message in messages) {
				if (msg.recipient == _slotId || msg.recipient == Message.TO_ALL) {
					textBox.appendText(msg.text + "\n");
				}
			}
		}
		
		public function get slotId():int {
			return _slotId;
		}
		
	}

}