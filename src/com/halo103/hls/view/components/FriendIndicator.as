package com.halo103.hls.view.components {
	
	import away3d.containers.View3D;
	import com.halo103.hls.interfaces.PlayerNameDisplay;
	import com.halo103.hls.interfaces.PlayerPositionDisplay;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class FriendIndicator extends Sprite implements PlayerPositionDisplay, PlayerNameDisplay {
		
		private var _slotId:int;
		
		private var _view3D:View3D;
		
		private var _playerName:TextField;
		private var _arrowPointer:Sprite;
		
		public function FriendIndicator(playerId:int, view3D:View3D) {
			
			_slotId = playerId;
			_view3D = view3D;
			
			_playerName = new TextField();
			var tf:TextFormat = new TextFormat("Arial", 11)
			tf.align = TextFormatAlign.CENTER;
			_playerName.defaultTextFormat = tf;
			_playerName.border = false;
			_playerName.selectable = false;
			_playerName.textColor = 0xAAAAAA;
			addChild(_playerName);
			
			_arrowPointer = new Sprite();
			addChild(_arrowPointer);
		}
		
		public function set playerName(name:String):void {
			_playerName.text = name;
		}
		
		public function set position(player3DPosition:Vector3D):void {
			if (player3DPosition != null) {
				
				var player2DPosition:Vector3D = _view3D.project(player3DPosition);
				
				//if the player is in front of the camera and not behind the camera
				if (player2DPosition.z > 0) {
					
					_arrowPointer.x = player2DPosition.x;
					_arrowPointer.y = player2DPosition.y;
					_arrowPointer.graphics.clear()
					_arrowPointer.graphics.beginFill(0x00AF00);
					_arrowPointer.graphics.moveTo(0, 0);
					_arrowPointer.graphics.lineTo(15,-14);
					_arrowPointer.graphics.lineTo(-15, -14);
					_arrowPointer.graphics.endFill();
					
					_playerName.x = player2DPosition.x - (_playerName.width/2);
					_playerName.y = player2DPosition.y - 35;
					this.visible = true;
					
					//_view3D.render();
				} else {
				this.visible = false;
				}
			} else {
				this.visible = false;
			}
		}
		
		public function get slotId():int {
			return _slotId;
		}
		
		public function set slotId(value:int):void {
			_slotId = value;
		}
		
	}

}