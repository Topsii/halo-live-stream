package com.halo103.hls.animations {
	
	import away3d.animators.*;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.states.*;
	import away3d.animators.nodes.AnimationNodeBase;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Skeleton180AimingNode extends AnimationNodeBase {
		
		public var baseAnimationNode:AnimationNodeBase;
		
		public var jmoAnimationNode:SkeletonClipNode;
		
		public function Skeleton180AimingNode() {
			_stateClass = Skeleton180AimingState;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAnimationState(animator:IAnimator):Skeleton180AimingState
		{
			return animator.getAnimationState(this) as Skeleton180AimingState;
		}
		
	}

}