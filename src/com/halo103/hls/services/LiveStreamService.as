package com.halo103.hls.services {
	import com.halo103.hls.interfaces.IGameDataParser;
	import com.halo103.hls.interfaces.IGameDataService;
	import com.halo103.hls.controller.signals.GameDataLoaded;
	import com.halo103.hls.controller.signals.GameDataLoadingProgressed;
	import com.halo103.hls.controller.signals.GameDataParsed;
	import com.halo103.hls.controller.signals.GameDataParsingProgressed;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import org.osflash.signals.natives.NativeSignal;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class LiveStreamService implements IGameDataService {
		
		[Inject] public var parser:IGameDataParser;
		
		//inform the rest of the application by dispatching these signals
		[Inject] public var loadingCompleted:GameDataLoaded;
		[Inject] public var loadingProgressed:GameDataLoadingProgressed;
		[Inject] public var parsingCompleted:GameDataParsed;
		[Inject] public var parsingProgressed:GameDataParsingProgressed;
		
		private static const IP:String = "213.165.86.250";
		private static const PORT:int = 33333;
		private static const POLICY_PORT:int = 33334;
		
		//listen to these signals to get information from the loader
		private var socketClosed:NativeSignal;
		private var socketConnected:NativeSignal;
		private var socketIOError:NativeSignal;
		private var socketSecurityError:NativeSignal;
		private var socketDataProgressed:NativeSignal;
		
		private var socket:Socket;
		
		private var rows:Array;
		
		private var retrCmd:String;
		
		private var storedLines:int;
		private var storedLinesLoaded:int;
		
		private var lines:Array;
		private var currentLine:String;
		
		public function LiveStreamService() {
			//Security.loadPolicyFile("xmlsocket://178.254.8.51:33334");
			Security.loadPolicyFile("xmlsocket://" + IP + ":" + POLICY_PORT);
			
			socket = new Socket();
			
			socketClosed = new NativeSignal(socket, Event.CLOSE, Event);
			socketConnected = new NativeSignal(socket, Event.CONNECT, Event);
			socketIOError = new NativeSignal(socket, IOErrorEvent.IO_ERROR, IOErrorEvent);
			socketSecurityError = new NativeSignal(socket, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
			socketDataProgressed = new NativeSignal(socket, ProgressEvent.SOCKET_DATA, ProgressEvent);
		}
		
		public function getGameData(retrieveCommand:String):void {
			currentLine = "";
			retrCmd = retrieveCommand;
			socketClosed.addOnce(handleSocketClosed);
			socketConnected.addOnce(handleSocketConnected);
			socketIOError.addOnce(handleSocketIOError);
			socketSecurityError.addOnce(handleSocketSecurityError);
			socketDataProgressed.add(handleSocketData); 7
			
			storedLinesLoaded = 0;
			
			//socket.connect("178.254.8.51", 33333);
			socket.connect(IP, PORT);
		}
		
		private function handleSocketData(event:ProgressEvent):void {
			currentLine += socket.readUTFBytes(socket.bytesAvailable);
			
			if (currentLine.indexOf("\r\n") != -1) {
				rows = currentLine.split("\r\n");
			} else {
				rows = currentLine.split("\n");
			}
			if (rows.length != 0) {
				currentLine = rows.pop();
				var i:int = 0;
			}
			processRows();
			
		}
		
		private function processRows():void {
			var rowsPerRun:int = 100;
			var rowStr:String;
			
			while ( rows.length > 0 && rowsPerRun-- ) {
				if ( (rowStr = rows.shift() as String) != null) {
					if (rowStr == "loginIsGranted") {
						socket.writeUTFBytes(retrCmd + "\n");
						socket.flush();
					} else if (rowStr.indexOf("storedLines ") != -1) {
						storedLines = int(rowStr.substr(11, rowStr.length));
					} else if (rowStr == "gameIsStopped") {
						socket.close();
					} else if (rowStr == "gameIsNowLive") {
						loadingCompleted.dispatch();
					} else if (rowStr == "areYouThereAnymore") {
						socket.writeUTFBytes("yes\n");
						socket.flush();
					} else {
						parser.parse(rowStr);
						storedLinesLoaded++;
						if (storedLinesLoaded >= storedLines) {
							loadingCompleted.dispatch();
							parsingCompleted.dispatch();
						} else {
							loadingProgressed.dispatchValues(storedLinesLoaded, storedLines);
							parsingProgressed.dispatchValues(storedLinesLoaded, storedLines);
						}
					}
				}
			}
			
			if (rows.length > 0) {
				setTimeout(processRows, 20);
			}
		}
		
		private function handleSocketIOError(event:IOErrorEvent):void {
			trace(event.text);
		}
		
		private function handleSocketSecurityError(event:SecurityErrorEvent):void {
			trace(event.text);
		}
		
		private function handleSocketConnected(event:Event):void {
			socket.writeUTFBytes("login\n")
			socket.flush();
		}
		
		private function handleSocketClosed(event:Event):void {
			socketDataProgressed.remove(handleSocketData);
		}
		
	}

}