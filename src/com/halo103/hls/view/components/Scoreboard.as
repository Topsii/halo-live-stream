package com.halo103.hls.view.components {
	import com.halo103.hls.interfaces.IScoreboard;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.ScoreState;
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
	public class Scoreboard extends Sprite implements IScoreboard {
		
		private var addedToStage:NativeSignal;
		private var removedFromStage:NativeSignal;
		
		private var stageResized:NativeSignal;
		
		private var table:TextField;

		private var nameCol:TextField;
		private var killsCol:TextField;
		private var assistsCol:TextField;
		private var deathsCol:TextField;
		
		public function Scoreboard() {
			table = new TextField();
			nameCol = new TextField();
			killsCol = new TextField();
			assistsCol = new TextField();
			deathsCol = new TextField();
			
			var tf:TextFormat = new TextFormat("Arial", 20)
			tf.align = TextFormatAlign.LEFT;
			
			nameCol.defaultTextFormat = tf;
			killsCol.defaultTextFormat = tf;
			assistsCol.defaultTextFormat = tf;
			deathsCol.defaultTextFormat = tf;
			
			nameCol.selectable = false;
			killsCol.selectable = false;
			assistsCol.selectable = false;
			deathsCol.selectable = false;
			
			nameCol.text = "Name\n";
			killsCol.text = "Kills\n";
			assistsCol.text = "Assists\n";
			deathsCol.text = "Deaths\n";
			
			addChild(table);
			addChild(nameCol);
			addChild(killsCol);
			addChild(assistsCol);
			addChild(deathsCol);
			
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
			graphics.clear();
			table.width = stage.stageWidth - 60;
			table.height = stage.stageHeight - 80;
			table.x = (stage.stageWidth/2)-(table.width/2);
			table.y = (stage.stageHeight/2)-(table.height/2) - 12;
			graphics.beginFill(0xcccccc, .35);
			graphics.drawRect(table.x, table.y, table.width, table.height);
			graphics.endFill();
			setColMeasures(nameCol, 1);
			nameCol.width *= 2;
			setColMeasures(killsCol, 5);
			setColMeasures(assistsCol, 6);
			setColMeasures(deathsCol, 7);
		}
		
		private function onRemovedFromStage(event:Event):void {
			stageResized.remove(onStageResize);
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
		}
		
		public function showPlayers(players:Vector.<PlayerState>):void {
			nameCol.text = "Name\n";
			killsCol.text = "Kills\n";
			assistsCol.text = "Assists\n";
			deathsCol.text = "Deaths\n";
			var score:ScoreState;
			for (var i:int = 0; i < players.length; i++) {
				score = players[i].score
				nameCol.appendText(players[i].name + "\n");
				killsCol.appendText(score.kills + "\n");
				assistsCol.appendText(score.assists + "\n");
				deathsCol.appendText(score.deaths + "\n");
			}
		}
		
		private function setColMeasures(col:TextField, position:int):void {
			col.x = table.x + (((table.width - 40) / 8) * position) + 20;
			col.y = table.y + 20;
			col.width = (table.width - 40) / 8;
			col.height = table.height - 40;
		}
	}

}