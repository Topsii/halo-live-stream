package com.halo103.hls.services.parsers {
	import com.halo103.hls.controller.signals.GameInfoParsed;
	import com.halo103.hls.interfaces.IGameDataParser;
	import com.halo103.hls.vos.AddablePlayerChange;
	import com.halo103.hls.vos.changes.*;
	import com.halo103.hls.vos.GameInfo;
	import com.halo103.hls.vos.GameType;
	import com.halo103.hls.vos.states.*;
	import com.halo103.hls.controller.signals.GameDataParsed;
	import com.halo103.hls.controller.signals.GameDataParsingProgressed;
	import com.halo103.hls.services.GameReplayService;
	import flash.geom.Vector3D;
	import org.robotlegs.mvcs.Actor;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Topsi
	 */
	public class LogParser implements IGameDataParser {
		
		[Inject] public var model:GameReplayService;
		[Inject] public var parsingCompleted:GameDataParsed;
		[Inject] public var parsingProgressed:GameDataParsingProgressed;
		[Inject] public var gameInfoParsed:GameInfoParsed;
		
		private var rows:Array;
		private var rowsNo:uint;
		private var rowCount:int;
		
		private var gameLength:uint; //time in milliseconds
		
		private var gameInfo:GameInfo;
		
		private var prevCoords:Array;
		
		/**
		 * Asynchronous method
		 * @param	rawLogfile
		 */
		public function parse(rawLogfile:String):void {
			
			prevCoords = new Array();
			
			rows = rawLogfile.split("\n");
			rowsNo = rows.length;
			rowCount = 0;
			var rowParts:Array = rows[rows.length - 2].split(",");
			
			var mapName:String =  rows.shift() as String;
			var gameTypeName:String =  rows.shift() as String;
			var gameMode:int =  int(rows.shift() as String);
			var teamPlayString:String = rows.shift() as String;
			var teamPlay:Boolean;
			if (teamPlayString == "0") {
				teamPlay = false;
			} else if (teamPlayString == "1") {
				teamPlay = true;
			} else {
				throw new Error("could not read if it is a teamgame or not");
			}
			
			gameInfo = new GameInfo(mapName, new GameType(gameTypeName, gameMode, teamPlay));
			gameInfoParsed.dispatchValue(gameInfo);
			
			gameLength = rowParts[0] * 10;
			
			processRows();
		}
		
		private function processRows():void {
			
			var rowsPerRun:int = 100;
			var rowStr:String;
			
			while ( rows.length > 0 && rowsPerRun-- ) {
				
				if( (rowStr = rows.shift() as String) != null){
					
					var rowParts:Array = rowStr.split(",");
					
					//trace(rowParts[0] + rowParts[1] + rowParts[2] + rowParts[3] + 
					//		rowParts[4] + rowParts[5] + rowParts[6] + rowParts[7]);
					
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
						var join:Join;
						if (gameInfo.gameType.teamPlay) {
							join = new Join(rowParts[0] * 10, rowParts[2], rowParts[3], rowParts[4]);
						} else {
							join = new Join(rowParts[0] * 10, rowParts[2], rowParts[3], int(rowParts[5])+2);
						}
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
						
						rowParts[6] = (rowParts[6] * ( -90)) - 90;
						var time2:int = rowParts[0] * 10;
						if (rowParts[7] > 0) {
							rowParts[6] = rowParts[6] + (180 - rowParts[6]) * 2;
						}
						if (rowParts[6] < 0)
							rowParts[6] += 360;
						
						var spawn:Spawn = new Spawn(time2, new Vector3D(rowParts[3], rowParts[4], rowParts[5]), rowParts[6], new Vector3D(rowParts[9]/100, rowParts[11]/100, rowParts[10]/100));
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
						
						//as long as there are players that were tracked
						while (rowParts[offsetCounter]) {
							
							var activePlayer:int = rowParts[offsetCounter];
							
							//inactivity for the players that were skipped while reading the next tracked player				
							while (playerCounter < activePlayer) {
								//executeInactivity(playerCounter);
								playerCounter += 1;
							}
							
							for (var i:int = 0; i < dataOffset; i++) {
								if (rowParts[i + offsetCounter + 1] != "") {
									prevCoords[i] = Number(rowParts[i + offsetCounter + 1]);
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
						
						// inactivity for all players with a memory id higher than the last read active player
						while(playerCounter < 16) {
							
							playerCounter += 1;
						}
					}
					rowCount++;
				}
			}
			
			var fractionProcessed:Number = rows.length / rowsNo;
			if (rows.length > 0) {
				parsingProgressed.dispatchValues(rowParts[0] * 10, gameLength);
				setTimeout(processRows, 20);
			} else {
				parsingCompleted.dispatch();
			}
		}
		
	}

}