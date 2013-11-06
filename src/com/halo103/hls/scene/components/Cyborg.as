package com.halo103.hls.scene.components {
	
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.nodes.SkeletonDifferenceNode;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.states.SkeletonDifferenceState;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.animators.transitions.CrossfadeTransitionNode;
	import away3d.animators.transitions.CrossfadeTransitionState;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	import com.halo103.hls.animations.AbsoluteSkeletonAnimator;
	import com.halo103.hls.animations.Skeleton180AimingNode;
	import com.halo103.hls.animations.Skeleton180AimingState;
	import com.halo103.hls.interfaces.PlayerToken;
	import com.halo103.hls.vos.AnimInfo;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.PlayerTokenState;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Cyborg extends ObjectContainer3D implements PlayerToken {
		
		//private static const TEXTURE = "texture";
		//private static const MD5ANIM = "";
		
		public static const CYBORG_WHITE_DIFFUSE_MAP:String = "cyborg-texture";
		public static const CYBORG_NORMAL_MAP:String = "cyborg normal-texture";
		public static const CYBORG_RED_DIFFUSE_MAP:String = "cyborgred-texture";
		public static const CYBORG_BLUE_DIFFUSE_MAP:String = "cyborgblue-texture";
		public static const MESH:String = "cyborg mesh";
		
		public static const STAND_LOOK:String = "stand look anim";
		public static const STAND_RIFLE_AIM_MOVE:String = "stand rifle aim-move anim";
		public static const STAND_RIFLE_AIM_STILL:String = "stand rifle aim-still anim";
		public static const STAND_RIFLE_MOVE_BACK:String = "stand rifle move-back anim";
		public static const STAND_RIFLE_MOVE_FRONT:String = "stand rifle move-front anim";
		public static const STAND_RIFLE_MOVE_LEFT:String = "stand rifle move-left anim";
		public static const STAND_RIFLE_MOVE_RIGHT:String = "stand rifle move-right anim";
		public static const STAND_RIFLE_IDLE:String = "stand rifle idle anim";
		public static const STAND_RIFLE_TURN_LEFT:String = "stand rifle turn-left anim";
		public static const STAND_RIFLE_TURN_RIGHT:String = "stand rifle turn-right anim";
		
		private var _slotId:int;
		
		private var cyborgMesh:Mesh;
		
		//animation variables
		private var skeleton:Skeleton;
		private var animationSet:SkeletonAnimationSet;
		private var animator:AbsoluteSkeletonAnimator;
		private var crossfadeTransition:CrossfadeTransition;
		private var cyborgAnimationNode:Skeleton180AimingNode;
		
		//cached vars
		private var colorCache:int;
		
		public function Cyborg(slotId:int, animSet:SkeletonAnimationSet, mesh:Mesh, material:MaterialBase) {
			_slotId = slotId;
			cyborgMesh = mesh;
			var bmt:BitmapTexture = BitmapTexture(AssetLibrary.getAsset(Cyborg.CYBORG_WHITE_DIFFUSE_MAP));
			var materialll:TextureMaterial = new TextureMaterial(bmt);
			materialll.normalMap = BitmapTexture(AssetLibrary.getAsset(Cyborg.CYBORG_NORMAL_MAP));
			cyborgMesh.material = materialll;
			addChild(cyborgMesh);
			cyborgMesh.visible = false;
			
			colorCache = -1;
			
			animationSet = animSet;
			
			skeleton = Skeleton(AssetLibrary.getAsset(MESH + AssetType.SKELETON));
			crossfadeTransition = new CrossfadeTransition(PlayerTokenState.MOVE_ANIM_FADE_DUR/1000);
			
			animator = new AbsoluteSkeletonAnimator(animationSet, skeleton);
			cyborgMesh.animator = animator;
			animator.updatePosition = false;
			animator.autoUpdate = true;
			animator.playbackSpeed = 0;
			
			cyborgMesh.y += ((cyborgMesh.maxY - cyborgMesh.minY)/2);
			
		}
		
		public function set state(tokenState:PlayerTokenState):void {
			if (tokenState == null || !tokenState.alive) {
				if (_slotId == 0) {
					//trace("FALSE");
				}
				cyborgMesh.visible = false;
			} else {
				//trace("d   " + tokenState.perspDirection);
				var rotation:Number = tokenState.rotation;
				var rotationRad:Number = rotation * Math.PI / 180;
				//trace(rotation);
				var rotVec:Vector3D = new Vector3D(Math.sin(rotationRad), 0, Math.cos(rotationRad));
				var relativeDirection:Vector3D = tokenState.perspDirection.add(rotVec);
				
				var absoluteLookRotation:Number = (tokenState.perspDirection.x * ( -90)) - 90;
				if (tokenState.perspDirection.z > 0) {
					absoluteLookRotation = absoluteLookRotation + (180 - absoluteLookRotation) * 2;
				}
				if (absoluteLookRotation < 0)
					absoluteLookRotation += 360;
					
				//to get from 30 to 340 it is more direct to subtract 50 than adding 310
				//in those cases the absolute difference is greater than 180
				var relativeLookRotation:Number = absoluteLookRotation - rotation;
				if (Math.abs(relativeLookRotation) > 180) {
					//the diff between 30 and 340 would be 310. Since 310 is positive, 
					//we subtract 360 and find out that we need to subtract 50
					if (relativeLookRotation < 0) {
						relativeLookRotation += 360; 
					} else {
						relativeLookRotation -= 360;
					}
				}
				if (relativeLookRotation < -90 || relativeLookRotation > 90) {
					//trace("Bad value: " + relativeLookRotation);
				}
				
				var relativeDir:Vector3D = new Vector3D(Math.sin(relativeLookRotation * (Math.PI / 180)), tokenState.perspDirection.y, Math.cos(relativeLookRotation * (Math.PI / 180)));
				
				if (relativeDir.z < 0) {
					//trace("Bad value: " + relativeDir.z);
				}
				
				var lookState:Skeleton180AimingState;
				for (var i:int = 0; i < tokenState.prevMoveInfoLength; i++) {
					var moveInfo:AnimInfo = tokenState.getPrevMoveInfo(i);
					switch (moveInfo.animationType) {
						case AnimInfo.MOVE_FRONT:
							animator.play(STAND_RIFLE_MOVE_FRONT + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.MOVE_BACK:
							animator.play(STAND_RIFLE_MOVE_BACK + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.MOVE_LEFT:
							animator.play(STAND_RIFLE_MOVE_LEFT + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.MOVE_RIGHT:
							animator.play(STAND_RIFLE_MOVE_RIGHT + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.MOVE_IDLE:
							animator.play(STAND_RIFLE_IDLE + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.TURN_LEFT:
							animator.play(STAND_RIFLE_TURN_LEFT + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
						case AnimInfo.TURN_RIGHT:
							animator.play(STAND_RIFLE_TURN_RIGHT + STAND_RIFLE_AIM_MOVE, crossfadeTransition)
							break;
					}
					if (i == 0) animator.absoluteTime = 0;
					
					if (animator.activeAnimation is Skeleton180AimingNode) {
						lookState = Skeleton180AimingState(animator.getAnimationState(animator.activeAnimation));
					} else {
						lookState = Skeleton180AimingState(animator.getAnimationState(Skeleton180AimingNode(CrossfadeTransitionNode(animator.activeAnimation).inputB)));
					}
					lookState.perspective = relativeDir;
					animator.absoluteTime += moveInfo.time;
					//trace(moveInfo);
				}
				//trace("------------");
				cyborgMesh.x = tokenState.position.x;
				cyborgMesh.y = tokenState.position.y + ((cyborgMesh.maxY - cyborgMesh.minY) / 2) + 4;
				cyborgMesh.z = tokenState.position.z;
				cyborgMesh.rotationY = tokenState.rotation;
				cyborgMesh.visible = true;
			}
		}
		
		public function get headPosition():Vector3D {
			if (cyborgMesh.visible) {
				return cyborgMesh.position.add(new Vector3D(0, 65.11/2, 0));
			}
			return null;
		}
		
		public function set color(color:int):void {
			if (colorCache != color) {
				if (color == PlayerState.RED_TEAM) {
					TextureMaterial(cyborgMesh.material).texture = BitmapTexture(AssetLibrary.getAsset(CYBORG_RED_DIFFUSE_MAP));
				} else if (color == PlayerState.BLUE_TEAM) {
					TextureMaterial(cyborgMesh.material).texture = BitmapTexture(AssetLibrary.getAsset(CYBORG_BLUE_DIFFUSE_MAP));
				} else {
					//todo: change to individual preferred color in non-teamplay gametype instead of making all players white.
					TextureMaterial(cyborgMesh.material).texture = BitmapTexture(AssetLibrary.getAsset(CYBORG_WHITE_DIFFUSE_MAP));
				}
				colorCache = color;
			}
			return;
		}
		
		public function get slotId():int {
			return _slotId;
		}
		
	}

}