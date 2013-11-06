package com.paultondeur.away3d.robotlegs.mvcs {
	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;
	import away3d.primitives.SphereGeometry;
	import com.paultondeur.away3d.robotlegs.mvcs.view.View3DMediator;
	import org.robotlegs.mvcs.SignalContext;

	import com.paultondeur.away3d.robotlegs.base.Mediator3DMap;
	import com.paultondeur.away3d.robotlegs.core.IContext3D;
	import com.paultondeur.away3d.robotlegs.core.IMediator3DMap;

	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Paul Tondeur
	 */
	public class SignalContext3D extends SignalContext implements IContext3D {
		private var _scene3D : Scene3D;
		private var _threeDeeMap : IMediator3DMap;
		
		public function SignalContext3D(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true) {
			super(contextView, autoStartup);
		}

		public function get scene3D() : Scene3D {
			return _scene3D || (_scene3D = new Scene3D());
		}

		public function set scene3D(value : Scene3D) : void {
			_scene3D = value;
		}

		public function get threeDeeMap() : IMediator3DMap {
			return _threeDeeMap ||= new Mediator3DMap(scene3D, createChildInjector(), reflector);
		}

		public function set threeDeeMap(value : IMediator3DMap) : void {
			_threeDeeMap = value;
		}

		override protected function mapInjections() : void {
			super.mapInjections();
			injector.mapValue(Scene3D, scene3D);
			injector.mapValue(IMediator3DMap, threeDeeMap);
		}

		override public function startup() : void {
			mediatorMap.mapView(Scene3D, View3DMediator);
			//contextView.addChild(scene3D);

			super.startup();
		}
	}
}
