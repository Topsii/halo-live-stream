package com.halo103.hls.view.components {
	import com.halo103.hls.interfaces.CameraView3D;
	import com.halo103.hls.interfaces.PlayerCameraView;
	import com.halo103.hls.scene.components.GameMap3D;
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import org.osflash.signals.natives.NativeSignal;
	
	import flash.utils.getTimer;
	
	public class PlayerCameraView3D extends View3D implements PlayerCameraView, CameraView3D {
		
		private var addedToStage:NativeSignal;
		private var removedFromStage:NativeSignal;
		
		private var stageMouseDown:NativeSignal;
		private var stageMouseUp:NativeSignal;
		private var stageMouseMoved:NativeSignal;
		private var stageMouseWheel:NativeSignal;
		private var stageKeyUp:NativeSignal;
		private var stageKeyDown:NativeSignal;
		private var frameEntered:NativeSignal;
		
		private var friendIndicators:Vector.<FriendIndicator>;
		
		//away3d camera variables
		private var _hoverController:HoverController;
		private var _slotId:int;
		
		private var _perspDirection:Vector3D;
		
		private var dragging:Boolean;
		
		private var sensitivity:Number;
		private var prevMouseX:Number;
		private var prevMouseY:Number;
		private var time:uint;
		private var a:Boolean;
		private var w:Boolean;
		private var d:Boolean;
		private var s:Boolean;
		private var f:Boolean;
		private var r:Boolean;
		
		public function PlayerCameraView3D(slotId:int = -1) {
			super();
			dragging = false;
			_slotId = slotId;
			sensitivity = 0.2;
			time = getTimer();
			a = false;
			w = false;
			d = false;
			s = false;
			f = false;
			r = false;
			
			friendIndicators = new Vector.<FriendIndicator>();
			for (var i:int = 0; i < 16; i++) {
				friendIndicators.push(new FriendIndicator(i, this));
			}
			
			camera = new Camera3D();
			
			backgroundColor = 0x0F0F0F;
			camera.lens.far = 20000;
			camera.lens.near = 1;
			_hoverController = new HoverController(new Camera3D(), null, 45, 30, 1000);
			_hoverController.tiltAngle = 70;
			_hoverController.panAngle = 180;
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void {
			
			frameEntered = new NativeSignal(this, Event.ENTER_FRAME, Event);
			frameEntered.add(onEnterFrame);
			stageMouseDown = new NativeSignal(stage, MouseEvent.MOUSE_DOWN, MouseEvent);
			stageMouseDown.add(onStageMouseDown);
			stageMouseUp = new NativeSignal(stage, MouseEvent.MOUSE_UP, MouseEvent);
			stageMouseUp.add(onStageMouseUp);
			stageMouseMoved = new NativeSignal(stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			stageMouseMoved.add(onStageMouseMove);
			stageMouseWheel = new NativeSignal(stage, MouseEvent.MOUSE_WHEEL, MouseEvent);
			stageMouseWheel.add(onStageMouseWheel);
			stageKeyUp = new NativeSignal(stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			stageKeyUp.add(onKeyUp);
			stageKeyDown = new NativeSignal(stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			stageKeyDown.add(onKeyDown);
			
			for (var i:int = 0; i < 16; i++) {
				addChild(friendIndicators[i]);
			}
			
			removedFromStage = new NativeSignal(this, Event.REMOVED_FROM_STAGE, Event);
			removedFromStage.addOnce(onRemovedFromStage);
			
		}
		
		private function onRemovedFromStage(event:Event):void {
			stageMouseDown.remove(onStageMouseDown);
			stageMouseMoved.remove(onStageMouseMove);
			stageMouseWheel.remove(onStageMouseWheel);
			stageKeyUp.remove(onKeyUp);
			stageKeyDown.remove(onKeyDown);
			frameEntered.remove(onEnterFrame);
			
			for (var i:int = 0; i < 16; i++) {
				removeChild(friendIndicators[i]);
			}
			
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.addOnce(onAddedToStage);
		}
		
		private function onStageMouseDown(ev:MouseEvent):void {
			if (this.hitTestPoint(ev.stageX, ev.stageY)) {
				dragging = true;
				prevMouseX = ev.stageX;
				prevMouseY = ev.stageY;
			}
		}
		
		private function onStageMouseUp(ev:MouseEvent):void {
			dragging = false;
		}
		
		private function onStageMouseMove(ev:MouseEvent):void {
			if (dragging) {
				var changeX:Number = ev.stageX - prevMouseX;
				var changeY:Number = ev.stageY - prevMouseY;
				if (_slotId != -1) {
					hoverController.panAngle += (changeX);
					hoverController.tiltAngle += (changeY);
				} else {
					//trace("CH: " + changeX + " " + changeY);
					var rotX:Number = camera.rotationX + (changeY / 4);
					var rotY:Number = camera.rotationY + (changeX / 4);
					//trace("ROT: " + rotX + " " + rotY);
					if (-90 < rotX && rotX < 90) {
						camera.rotateTo(rotX, rotY, 0);
					} else {	
						camera.rotateTo(camera.rotationX, rotY, 0);
					}
				}
			}
			prevMouseX = ev.stageX;
			prevMouseY = ev.stageY;
		}
		
		private function onStageMouseWheel(ev:MouseEvent):void {
			if (_slotId != -1) {
				hoverController.distance -= ev.delta * 5;
				
				if (hoverController.distance < 100) {
					hoverController.distance = 100;
				} else if (hoverController.distance > 2000) {
					hoverController.distance = 2000;
				}
			} else {
				var newSens:Number = sensitivity + sensitivity * (-ev.delta) * 0.1;
				if (newSens > 0) {
					sensitivity = newSens;
				}
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					w = true;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					s = true;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					a = true;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					d = true;
					break;
				case Keyboard.SPACE:
				case Keyboard.R:
					r = true;
					break;
				case Keyboard.CONTROL:
				case Keyboard.F:
					f = true;
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					w = false;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					s = false;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					a = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					d = false;
					break;
				case Keyboard.SPACE:
				case Keyboard.R:
					r = false;
					break;
				case Keyboard.CONTROL:
				case Keyboard.F:
					f = false;
					break;
				case Keyboard.C:
					break;
			}
		}
		
		private function onEnterFrame(event:Event):void {
			//vor und zurück bewegen, ohne die höhe zu ändern
			var newTime:uint = getTimer();
			if (_slotId == -1) {
				if (a) camera.moveLeft(sensitivity * (newTime - time));
				if (w) camera.moveForward(sensitivity * (newTime - time));
				if (d) camera.moveRight(sensitivity * (newTime - time));
				if (s) camera.moveBackward(sensitivity * (newTime - time));
				if (r) camera.moveTo(camera.x, camera.y + sensitivity * (newTime - time), camera.z);
				if (f) camera.moveTo(camera.x, camera.y - sensitivity * (newTime - time), camera.z);
			} else {				
				if (_perspDirection) {
					camera.lookAt(camera.position.add(_perspDirection));
				}
			}
			time = newTime;
			render();
		}
		
		public function showDeath():void {
			if (stage) {
				graphics.clear();
				graphics.beginFill(0x000000, .67)
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
			}
		}
		
		public function showAlive():void {
			graphics.clear();
		}
		
		public function showNothing():void {
			if (stage) {
				graphics.clear();
				graphics.beginFill(0x000000)
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
			}
		}
		
		public function set perspective(direction:Vector3D):void {
			_perspDirection = direction;
		}
		
		public function set cameraPosition(position:Vector3D):void {
			camera.position = position;
		}
		
		public function get hoverController():HoverController {
			return _hoverController;
		}
		
		public function get slotId():int {
			return _slotId;
		}
	}
}