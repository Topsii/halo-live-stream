package com.halo103.hls.animations {
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.IAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.states.AnimationStateBase;
	import away3d.animators.states.ISkeletonAnimationState;
	import away3d.animators.states.SkeletonClipState;
	import away3d.core.math.Quaternion;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Skeleton180AimingState extends AnimationStateBase implements ISkeletonAnimationState {
		
		private static var _tempQuat : Quaternion = new Quaternion();
		private var _skeletonPoseDirty : Boolean = true;
		private var _skeletonAnimationNode:Skeleton180AimingNode;
		private var _skeletonPose : SkeletonPose = new SkeletonPose();
		private var _jmoAnimationNode:SkeletonClipNode;
		private var _jmoAnimationState:SkeletonClipState;
		private var _baseAnimationState:ISkeletonAnimationState;
		private var _direction:Vector3D;
		
		function Skeleton180AimingState(animator:IAnimator, skeletonAnimationNode:Skeleton180AimingNode) {
			super(animator, skeletonAnimationNode);
			_direction = new Vector3D(0,0,1);
			_skeletonAnimationNode = skeletonAnimationNode;
			_jmoAnimationNode = _skeletonAnimationNode.jmoAnimationNode;
			_jmoAnimationNode.stitchFinalFrame = true;
			_jmoAnimationState = animator.getAnimationState(_skeletonAnimationNode.jmoAnimationNode) as SkeletonClipState;
			_baseAnimationState = animator.getAnimationState(_skeletonAnimationNode.baseAnimationNode) as ISkeletonAnimationState;
		}
		
		public function set perspective(value:Vector3D):void {
			if (value.equals(_direction))
				return;
			
			_direction = value;
			
			_skeletonPoseDirty = true;
			_positionDeltaDirty = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function phase(value:Number):void {
			
			_skeletonPoseDirty = true;
			
			_positionDeltaDirty = true;
			
			_jmoAnimationState.phase(value);
			_baseAnimationState.phase(value);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateTime(time:int):void
		{
			_skeletonPoseDirty = true;
			
			_jmoAnimationState.update(time);
			_baseAnimationState.update(time);
			
			super.updateTime(time);
		}
		
		/**
		 * Returns the current skeleton pose of the animation in the clip based on the internal playhead position.
		 */
		public function getSkeletonPose(skeleton:Skeleton):SkeletonPose {
			if (_skeletonPoseDirty)
				updateSkeletonPose(skeleton);
			
			return _skeletonPose;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updatePositionDelta():void {
			
		}
		
		/**
		 * Updates the output skeleton pose of the node based on the direction axis and the input node
		 * 
		 * @param skeleton The skeleton used by the animator requesting the ouput pose. 
		 */
		private function updateSkeletonPose(skeleton:Skeleton):void
		{
			_skeletonPoseDirty = false;
			
			var endPose : JointPose;
			var endPoses : Vector.<JointPose> = _skeletonPose.jointPoses;
			var basePoses : Vector.<JointPose> = _baseAnimationState.getSkeletonPose(skeleton).jointPoses;
			var botLeftPoses:Vector.<JointPose>;
			var botRightPoses:Vector.<JointPose>;
			var topLeftPoses:Vector.<JointPose>;
			var topRightPoses:Vector.<JointPose>;
			var jmoBasePoses : Vector.<JointPose> = _jmoAnimationNode.frames[4].jointPoses;
			var jmoPoses : Vector.<JointPose> = _jmoAnimationState.getSkeletonPose(skeleton).jointPoses;
			var base : JointPose, jmoBase : JointPose, jmo : JointPose;
			var jmoDiff : JointPose;
			var basePos : Vector3D, jmoBasePos : Vector3D, jmoPos : Vector3D;
			var jmoDiffPos : Vector3D = new Vector3D();
			var jmoBaseOrient : Quaternion = new Quaternion();
			var jmoOrient : Quaternion = new Quaternion();
			var orientDiff : Quaternion;
			var tr : Vector3D;
			var numJoints : uint = skeleton.numJoints;
			
			//0 would be the bottom Pose; 1 would be the top Pose
			var verticalRatio:Number;
			
			//0 would be the right Pose; 1 would be the left Pose
			var horizontalRatio:Number;
			
			var j:int = 0;
			if (_direction.x < 0) {
				j += 1;
				horizontalRatio = 1 - _direction.z;
			} else {
				horizontalRatio = _direction.z;
			}
			if (_direction.y < 0) {
				verticalRatio = 1 + _direction.y;
			} else {
				j += 3;
				verticalRatio = _direction.y;
			}
			
			//handling invalid values
			if (_direction.z < 0) {
				if (_direction.x < 0) {
					horizontalRatio = 1;
				} else {
					horizontalRatio = 0;
				}
			}
			
			botRightPoses = _jmoAnimationNode.frames[j].jointPoses;
			botLeftPoses = _jmoAnimationNode.frames[j+1].jointPoses;
			topRightPoses = _jmoAnimationNode.frames[j+3].jointPoses;
			topLeftPoses = _jmoAnimationNode.frames[j+4].jointPoses;
			
			// :s
			if (endPoses.length != numJoints) endPoses.length = numJoints;
			
			for (var i : uint = 0; i < numJoints; ++i) {

				
				endPose = endPoses[i] ||= new JointPose();
				base = basePoses[i];
				jmoBase = jmoBasePoses[i];
				var leftPose:JointPose = differencePose(botLeftPoses[i], topLeftPoses[i], verticalRatio);
				var rightPose:JointPose = differencePose(botRightPoses[i], topRightPoses[i], verticalRatio);
				jmo = differencePose(rightPose, leftPose, horizontalRatio);
				
				jmoOrient.copyFrom(jmo.orientation);
				jmoBaseOrient.copyFrom(jmoBase.orientation);
				basePos = base.translation;
				jmoBasePos = jmoBase.translation;
				jmoPos = jmo.translation;
				
				orientDiff = new Quaternion();
				
				//lazy condition:
				if (jmoBaseOrient.x > 0) {
					jmoBaseOrient = conjugate(jmoBaseOrient);
				}
				
				//lazy condition:
				if (jmoOrient.x > 0) {
					jmoOrient = conjugate(jmoOrient);
				}
				
				orientDiff.multiply(inverse(jmoBaseOrient), jmoOrient);
				orientDiff.normalize();
				
				_tempQuat.multiply(orientDiff, base.orientation);
				_tempQuat.normalize();
				endPose.orientation.lerp(base.orientation, _tempQuat, 1);
				
				jmoDiffPos.x = jmoPos.x - jmoBasePos.x;
				jmoDiffPos.y = jmoPos.y - jmoBasePos.y;
				jmoDiffPos.z = jmoPos.z - jmoBasePos.z;
				
				tr = endPose.translation;
				tr.x = basePos.x + 1*jmoDiffPos.x;
				tr.y = basePos.y + 1*jmoDiffPos.y;
				tr.z = basePos.z + 1*jmoDiffPos.z;
			}
		}
		
		private function differencePose(inputPoseA:JointPose, inputPoseB:JointPose, ratio:Number):JointPose {
			var endPose:JointPose = new JointPose();
			var p1 : Vector3D, p2 : Vector3D;
			var tr : Vector3D;
			
			p1 = inputPoseA.translation; p2 = inputPoseB.translation;
			
			endPose.orientation.lerp(inputPoseA.orientation, inputPoseB.orientation, ratio);
			
			tr = endPose.translation;
			tr.x = p1.x + ratio*(p2.x - p1.x);
			tr.y = p1.y + ratio*(p2.y - p1.y);
			tr.z = p1.z + ratio * (p2.z - p1.z);
			
			return endPose;
		}
		
		public static function inverse(q:Quaternion):Quaternion {
			q.w = q.w / ((q.w * q.w) + (q.x * q.x) + (q.y * q.y) + (q.z * q.z));
			q.x = -q.x / ((q.w * q.w) + (q.x * q.x) + (q.y * q.y) + (q.z * q.z));
			q.y = -q.y / ((q.w * q.w) + (q.x * q.x) + (q.y * q.y) + (q.z * q.z));
			q.z = -q.z / ((q.w * q.w) + (q.x * q.x) + (q.y * q.y) + (q.z * q.z));
			return q;
		}
		
		public static function conjugate(q:Quaternion):Quaternion {
			return new Quaternion(-q.x, -q.y, -q.z, -q.w);
		}
	}

}