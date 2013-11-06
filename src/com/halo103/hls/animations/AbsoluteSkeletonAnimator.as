package com.halo103.hls.animations {
	
	import away3d.animators.data.Skeleton;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class AbsoluteSkeletonAnimator extends SkeletonAnimator {
		
		public function AbsoluteSkeletonAnimator(skeletonAnimationSet:SkeletonAnimationSet, skeleton:Skeleton, forceCPU:Boolean=false) {
			super(skeletonAnimationSet, skeleton, forceCPU);
			
		}
		
		public function set absoluteTime(value:Number):void {
			updateDeltaTime(value - _absoluteTime);
			
		}
		
	}

}