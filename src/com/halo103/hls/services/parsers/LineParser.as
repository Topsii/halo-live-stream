package com.halo103.hls.services.parsers {
	import com.halo103.hls.interfaces.IGameDataParser;
	import com.halo103.hls.vos.AddablePlayerChange;
	import com.halo103.hls.vos.changes.ChatMessage;
	import com.halo103.hls.vos.changes.Death;
	import com.halo103.hls.vos.changes.Join;
	import com.halo103.hls.vos.changes.Kill;
	import com.halo103.hls.vos.changes.Leave;
	import com.halo103.hls.vos.changes.Move;
	import com.halo103.hls.vos.changes.Reset;
	import com.halo103.hls.vos.changes.Spawn;
	import com.halo103.hls.vos.changes.TeamChange;
	import com.halo103.hls.controller.signals.GameDataParsed;
	import com.halo103.hls.controller.signals.GameDataParsingProgressed;
	import com.halo103.hls.services.GameReplayService;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class LineParser implements IGameDataParser {

		[Inject] public var model:GameReplayService;
		[Inject] public var parsingCompleted:GameDataParsed;
		[Inject] public var parsingProgressed:GameDataParsingProgressed;
		
		private var prevCoords:Array;
		private var rowCount:int = 0;
		
		public function LineParser() {
			prevCoords = new Array();
		}
		
		/**
		 * Asynchronous method
		 * @param	rawLogfile
		 */
		public function parse(rowStr:String):void {
			
			var rowParts:Array = rowStr.split(",");
			
			//trace(rowParts[0] + rowParts[1] + rowParts[2] + rowParts[3] + 
			//		rowParts[4] + rowParts[5] + rowParts[6] + rowParts[7]);
			if (rowCount == 1) {
				trace(rowStr);
			}
			
			if (rowParts[1] == "k") {
				
				var assistPlayerOffset:int = 4;
				var assistPlayerIds:Vector.<int> = new Vector.<int>;
				while (rowParts[assistPlayerOffset]) {
					assistPlayerIds.push(rowParts[assistPlayerOffset]);
					assistPlayerOffset++;
				}
				if (rowParts[2] == 255) {
					rowParts[2] = Kill.UNKNOWN_KILLER;
				}
				var kill:Kill = new Kill(rowParts[0] * 10, rowParts[2], rowParts[3], assistPlayerIds);
				model.addGameInformation(kill);
				
				var death:Death = new Death(rowParts[0] * 10);
				var addableDeath:AddablePlayerChange = new AddablePlayerChange(death, rowParts[3]);
				model.addGameInformation(addableDeath);
				
			} else if (rowParts[1] == "j") {
				var join:Join = new Join(rowParts[0] * 10, rowParts[2], rowParts[3], rowParts[4]);
				model.addGameInformation(join);
				
			} else if (rowParts[1] == "l") {
				var leave:Leave = new Leave(rowParts[0] * 10, rowParts[2]);
				model.addGameInformation(leave);
				
			} else if (rowParts[1] == "r") {
				var reset:Reset = new Reset(rowParts[0] * 10);
				model.addGameInformation(reset);
				
			} else if (rowParts[1] == "c") {
				var chatMsg:ChatMessage = new ChatMessage(rowParts[0] * 10, rowParts[4], rowParts[2], rowParts[3]);
				model.addGameInformation(chatMsg);
				
			} else if (rowParts[1] == "s") {
				
				for (var i:int = 0; i < 10; i++) {
					if (rowParts[i + 2 + 1] != "") {
						prevCoords[i] = Number(rowParts[i + 2 + 1]);
					}
				}
				
				prevCoords[3] = (prevCoords[3] * ( -90)) - 90;
				var time2:int = rowParts[0] * 10;
				if (prevCoords[4] > 0) {
					prevCoords[3] = prevCoords[3] + (180 - prevCoords[3]) * 2;
				}
				if (prevCoords[3] < 0)
					prevCoords[3] += 360;
				var spawn:Spawn = new Spawn(time2, new Vector3D(prevCoords[0], prevCoords[2], prevCoords[1]),prevCoords[3], new Vector3D(prevCoords[6]/100, prevCoords[8]/100, prevCoords[7]/100));
				var addableSpawn:AddablePlayerChange = new AddablePlayerChange(spawn, rowParts[2]);
				model.addGameInformation(addableSpawn);
				
			} else if (rowParts[1] == "t") {
				var teamChange:TeamChange = new TeamChange(rowParts[0] * 10, rowParts[2], rowParts[3]);
				model.addGameInformation(teamChange);
				
			} else {
				const dataOffset:int = 10;	//how many data parts does one player block contain
				const initialOffset:int = 1; //(timestamp)
				var playerCounter:int = 0;
				var offsetCounter:int = initialOffset;
				
				if ((rowParts.length - initialOffset) % dataOffset == 0 && rowParts.length != 1) {
					
					//as long as there are players that were tracked
					while (rowParts[offsetCounter]) {
						
						var activePlayer:int = rowParts[offsetCounter];
						
						//inactivity for the players that were skipped while reading the next tracked player				
						while (playerCounter < activePlayer) {
							//executeInactivity(playerCounter);
							playerCounter += 1;
						}
						
						for (var k:int = 0; k < dataOffset; k++) {
							if (rowParts[k + offsetCounter + 1] != "") {
								prevCoords[k] = Number(rowParts[k + offsetCounter + 1]);
							}
						}
						
						prevCoords[3] = (prevCoords[3] * ( -90)) - 90;
						var time:int = rowParts[0] * 10;
						if (prevCoords[4] > 0) {
							prevCoords[3] = prevCoords[3] + (180 - prevCoords[3]) * 2;
						}
						if (prevCoords[3] < 0)
							prevCoords[3] += 360;
						var move:Move = new Move(time, new Vector3D(prevCoords[0], prevCoords[2], prevCoords[1]),prevCoords[3], new Vector3D(prevCoords[6]/100, prevCoords[8]/100, prevCoords[7]/100));
						var addMe:AddablePlayerChange = new AddablePlayerChange(move, rowParts[offsetCounter]);
						model.addGameInformation(addMe);
						
						offsetCounter += dataOffset;
						playerCounter += 1;
					}
					
					//inactivity for all players with a memory id higher than the last read active player
					while (playerCounter < 16) {
						
						playerCounter += 1;
					}
				}
			}
			rowCount++;
		}
		
	}

}