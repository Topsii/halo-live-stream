package com.halo103.hls.scene.components {
	import away3d.animators.nodes.SkeletonDirectionalNode;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.ColorTransformMethod;
	import com.halo103.hls.animations.Skeleton180AimingNode;
	import com.halo103.hls.vos.states.GameState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	import flash.events.FullScreenEvent;
	//import avmplus.describeTypeJSON;
	import away3d.animators.data.Skeleton;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	//import away3d.animators.states.AnimationClipState;
	//import away3d.core.base.CompactSubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.IAsset;
	import away3d.library.assets.AssetType;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.OBJParser; 
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FresnelSpecularMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.textures.BitmapTexture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameMap3D extends ObjectContainer3D {
		private var modelTexture:BitmapTexture;
		private const DemoColor:Array = [0xffffff, 0x99AAff, 0x0F0F0F];//[2]:0x222233
		
		//away3d light objects
		private var sunLight:DirectionalLight;
		private var skyLight:PointLight;
		private var lightPicker:StaticLightPicker;
		
		//away3d scene objects
		//private var hero:ObjectContainer3D;
		private var players:Vector.<ObjectContainer3D>;
		private var map:Vector.<Mesh>;
		
		//away3d animation variables
		private var skeleton:Skeleton;
		private var animationSet:SkeletonAnimationSet;
		private var animator:SkeletonAnimator;
		private var animation:SkeletonClipNode;
		private var crossfadeTransition:CrossfadeTransition;
		
		//animation constants
		private const XFADE_TIME:Number = 0.5;
		
		
		//private const ANIMATION_SET_NAME = "Run";
		//private const ANIMATION_SET_NAME:String = "null.5"; //oder "null"
		
		//private const SKELETON_NAME:String = "bip01 pelvis";
		//private const SKELETON_NAME:String = "cyborgskeleton";
		
		//private const CYBORG_MESH_NAME:String = "cyborg";
		//private const CYBORG_MESH_NAME:String = "cyborgmesh";
		
		
		
		//private var MESH_URL:String = "../assets/ratrace.AWD";
		//private var TEXTURE_URL:String = "../assets/onkba_N.jpg";
		//private const ANIM_BREATHE:String = ANIMATION_SET_NAME;
		private const MESH_URL:String = "ratrace3.AWD";
		private const TEXTURE_URL:String = "onkba_N.jpg";
		private const MESH_OBJ_URL:String = "ratrace.obj";
		private const MESH_OBJ_EXP_URL:String = "ratraceExported.obj";
		private var assetsThatAreloaded:int;
		private var assetsToLoad:int;
		private const SEPERATOR:String = "%";
		
		public function GameMap3D() {
			
		}
		
		public function init():void {
			initLights();
			setupScene();
		}
		
		private function initLights():void {
			//create a light for shadows that mimics the sun's position in the skybox
			sunLight = new DirectionalLight(-1, -0.4, 1);
			sunLight.color = DemoColor[0];
			sunLight.castsShadows = true;
			sunLight.ambient = 1;
			sunLight.diffuse = 1;
			sunLight.specular = 1;
			//addChild(sunLight);
			
			//create a light for ambient effect that mimics the sky
			skyLight = new PointLight();
			skyLight.y = 500;
			skyLight.color = DemoColor[1];
			skyLight.diffuse = 1;
			skyLight.specular = 0.5;
			skyLight.radius = 2000;
			skyLight.fallOff = 2500;
			//addChild(skyLight);
			
			lightPicker = new StaticLightPicker([sunLight, skyLight]);
			
		}
		
		private function setupScene():void {
			animationSet = SkeletonAnimationSet(AssetLibrary.getAsset(Cyborg.MESH + AssetType.ANIMATION_SET));
			prepareAnimations();
			
	//		var ali:AssetLibraryIterator = AssetLibrary.createIterator();
	//		var a:IAsset;
	//		while ((a = ali.next()) != null) {
				/*if (a.assetType == AssetType.TEXTURE) {
					var texture:IAsset = AssetLibrary.getAsset(a.name);
					var materialName:String = a.name.substring(5, a.name.length - 4);
					while (materialName.indexOf(" ") != -1) {
						materialName = materialName.replace(" ", "_");
					}
					var i:int = 0;
					var meshAsset:IAsset;
					while ((meshAsset = AssetLibrary.getAsset(i + SEPERATOR + materialName)) != null) {
						
						var mesh:Mesh = Mesh(meshAsset);
						
						// prepare the model's texture material
						/*modelTexture = BitmapTexture(texture);
						var autoMap:Mapper = new Mapper(modelTexture.bitmapData);
						var specularMethod:FresnelSpecularMethod = new FresnelSpecularMethod();
						specularMethod.normalReflectance = .4;
						
						var material:TextureMaterial = new TextureMaterial(modelTexture);
						material.normalMap = new BitmapTexture(autoMap.bitdata[1]);
						material.specularMap = new BitmapTexture(autoMap.bitdata[2]);
						material.specularMethod = specularMethod;
						//material.lightPicker = lightPicker;
						material.gloss = 40;
						material.specular = 0.5;
						material.ambientColor = 0xAAAAFF;
						material.ambient = 0.25;
						material.addMethod(new RimLightMethod(DemoColor[1], .4, 3, RimLightMethod.ADD));
						mesh.material = material;*//*
						
						scene.addChild(mesh);
						trace("applied " + meshAsset.name);
						i++;
					}
					
					
				}*/
				
			//trace("-------------------------------------------------------------");
			var ali:AssetLibraryIterator = AssetLibrary.createIterator(AssetType.MESH);
			var a:IAsset;
			//var mapGeom:Geometry = new Geo
			//var mapMesh:Mesh = new Mesh(
			while ((a = ali.next()) != null) {
				trace("MESH: " + a.name);
				var mesh:Mesh = Mesh(a);
				if (a.name.indexOf("ratrace") != -1) {
					//trace(a.name);
					//a.name = "cyborgmesh"
				}
				if (a.name.indexOf("Lightmap") == -1 && a.name.indexOf("%") != -1) {
					//aaaasassaaaaaayaaaasaystrace(a.name);
					var meshName:Array = a.name.split("%");
					var materialName:String = meshName[1];
					//trace("ASSETNAME: " + a.name);
					//trace("MESHNAME: " + meshName);
					//trace("MATERIALNAME: " + materialName);
					
					//mesh.material = new TextureMaterial(BitmapTexture());
					addChild(mesh);
				} else {
					if (a.name == "ratrace") {
						var lightmap:Mesh = Mesh(AssetLibrary.getAsset(a.name + "_Lightmap"));
						var geom:Geometry = mesh.geometry;
						var lightGeom:Geometry = mesh.geometry;
/*						for each (var subGeom:SubGeometry in geom.subGeometries) {
							for each (var lightSubGeom:SubGeometry in lightGeom.subGeometries) {
								subGeom.updateSecondaryUVData(lightSubGeom.UVData);
							}
						}*/
						addChild(mesh);
					}
				}
			}
			ali = AssetLibrary.createIterator(AssetType.GEOMETRY);
			while ((a = ali.next()) != null) {
				//trace(a.name);
				if (a.name.indexOf("Lightmap") != -1) {
					/*var geom:Geometry = Geometry(IAsset);
					//geom.u
					for each (var subGeom:SubGeometry in geom.subGeometries) {
						subGeom.UVData
					}*/
					//trace(a.name);
					/*var meshName:Array = a.name.split("%");
					var materialName:String = meshName[1];
					trace(materialName);
					var texture:IAsset = AssetLibrary.getAsset("maps/");
					var mesh:Mesh = Mesh(a);
					scene.addChild(mesh);*/
				} else {
					
				}
			}
			ali = AssetLibrary.createIterator(AssetType.TEXTURE);
			while ((a = ali.next()) != null) {
				//trace("texture: " + a.name);
			}
			var skeleton:Skeleton;
			ali = AssetLibrary.createIterator(AssetType.SKELETON);
			while ((a = ali.next()) != null) {
				//trace("SKELETON " + a.name);
			}
			ali = AssetLibrary.createIterator(AssetType.SKELETON_POSE);
			while ((a = ali.next()) != null) {
				//trace(a.name);
			}
			ali = AssetLibrary.createIterator(AssetType.ANIMATION_NODE);
			while ((a = ali.next()) != null) {
				var skeletonClipNode:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(a.name));
				//trace(a.assetPathEquals(InitAppCommand.CYBORG_STAND_RIFLE_MOVE_BACK, a.assetNamespace));
				
				//a.assetPathEquals(
				//forward.assetPathEquals
				//trace(a.name);
			}
			//trace((AssetLibrary.getAsset("null.1") as IAsset).assetType)
			var meshss:Mesh = Mesh(AssetLibrary.getAsset(Cyborg.MESH + AssetType.MESH));
			var bmt:BitmapTexture = BitmapTexture(AssetLibrary.getAsset(Cyborg.CYBORG_WHITE_DIFFUSE_MAP));
			var materialll:TextureMaterial = new TextureMaterial(bmt);
			var redBT:BitmapTexture = new BitmapTexture(new BitmapData(1, 1, true, 0x88FF0000));
			//materialll = new TextureMaterial(redBT);
			//materialll.ambientTexture = redBT;
			//materialll.ambient = 0.9;
			//materialll.diffuseLightSources
			var bam:BasicAmbientMethod = new BasicAmbientMethod();
			//bam.ambient = 1;
			bam.ambientColor = 0xFF0000;
			//materialll.ambientMethod = bam;
			//materialll.alphaBlending = true;
			//materialll.alphaThreshold = 21;
			materialll.normalMap = BitmapTexture(AssetLibrary.getAsset(Cyborg.CYBORG_NORMAL_MAP));
			var ct:ColorTransform = new ColorTransform(0xFF0000);
			var ctMethod:ColorTransformMethod = new ColorTransformMethod();
			//materialll.colorTransform = ct;
			ctMethod.colorTransform = ct;
			//materialll.addMethod(ctMethod);
			//materialll.shadowMethod = null;
			//materialll.ambientColor = 0xFF0000;
			
			
			players = new Vector.<ObjectContainer3D>();
			for (var i:int = 0; i < GameState.PLAYER_SLOTS; i++) {
				//players[i] = new Mesh(Mesh(AssetLibrary.getAsset(CYBORG_MESH_NAME)).geometry);
				//players[i].material = new TextureMaterial(BitmapTexture(AssetLibrary.getAsset(InitAppCommand.PLAYER_TEXTURE)));
				//players[i] = new Mesh(new SphereGeometry(), new ColorMaterial(0xFF0000));
				//players[i].visible = false;
				
				players[i] = new Cyborg(i, animationSet, Mesh(meshss.clone()), materialll);
				scene.addChild(players[i]);
			}
			
			
			//var animation:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(ANIMATION_SET_NAME));
			//hero = Mesh(AssetLibrary.getAsset("cyborg"));
			//var hero:Mesh = Mesh(AssetLibrary.getAsset(CYBORG_MESH_NAME));
			//var hero:Cyborg = new Cyborg(-1);
			
			//hero.material = new TextureMaterial(BitmapTexture(AssetLibrary.getAsset(InitAppCommand.CYBORG_TEXTURE)));
			//hero.material = new ColorMaterial(0xFFFFFF);
			
			
			
			//var moveAnimation:SkeletonDirectionalNode = new SkeletonDirectionalNode();
			/*var back:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(InitAppCommand.CYBORG_STAND_RIFLE_MOVE_BACK));
			var forward:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(InitAppCommand.CYBORG_STAND_RIFLE_MOVE_FRONT));
			var left:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(InitAppCommand.CYBORG_STAND_RIFLE_MOVE_LEFT));
			var right:SkeletonClipNode = SkeletonClipNode(AssetLibrary.getAsset(InitAppCommand.CYBORG_STAND_RIFLE_MOVE_RIGHT));*/
			
			
			/*moveAnimation.backward = back;
			moveAnimation.forward = forward
			moveAnimation.left = left;
			moveAnimation.right = right;
			moveAnimation.name = "Move";*/
			
			//trace(breatheState);
			
			/*animationSet.addAnimation(back);
			animationSet.addAnimation(forward);
			animationSet.addAnimation(left);
			animationSet.addAnimation(right);
			animationSet.addAnimation(moveAnimation); //oder addAnimation(animation)*/
			
			//animationSet.addState(anim
			//animationSet.addState("",  new AnimationClipState(
			//animationSet.addState(ANIM_BREATHE, breatheState);
			
			//couple our animation set with our skeleton and wrap in an animator object and apply to our mesh object
			//animator = new SkeletonAnimator(animationSet, skeleton);
			//var moveAnimationState:SkeletonDirectionalState = moveAnimation.getAnimationState(animator);
			//moveAnimationState.direction = 45;
			//animator.playbackSpeed = 0.15;
			//animator.autoUpdate = false;
			//hero.animator = animator;
			
			//var animator2:SkeletonAnimator = new SkeletonAnimator(animationSet, skeleton);
			//players[0].animator = animator2;
			//animator2.play(standRifleMoveFrontStateName, crossfadeTransition);
			
			//SubMesh(hero.subMeshes[0]).subGeometry = SkinnedSubGeometry(SubMesh(hero.subMeshes[0]).subGeometry);
			
			//create our crossfade transition object
			crossfadeTransition = new CrossfadeTransition(XFADE_TIME);
			
			//hero.subMeshes : 0
			//addChild(hero);
			//animator.play("Move", crossfadeTransition);
			//animator.play("null.4", crossfadeTransition);
			
			//setze bei turn animation die rotation von hero immer wieder auf 0 und beobachte verhalten
			//animator.play("null.2");
			
			
			
			/*var asset:IAsset = AssetLibrary.getAsset("ratrace_geom");
			trace(asset.assetFullPath);
			trace(asset.assetNamespace);
			trace(asset.assetType);
			trace(asset.name);
			
			var geom:Geometry = Geometry(asset);*//*
			
			
			
			// request all the things we loaded into the AssetLibrary
			modelTexture = BitmapTexture(AssetLibrary.getAsset(TEXTURE_URL));
			var it:AssetLibraryIterator = AssetLibrary.createIterator();
			var a:IAsset;
			while ((a = it.next()) != null) {
				trace(a.name);
				
			}
			hero = Mesh(AssetLibrary.getAsset("ratrace"));
			
			hero = new Mesh(geom, new DefaultMaterialBase());
			//hero = new Mesh(geom);
			trace(hero);
			//trace(hero.subMeshes.length);
			var geo:Geometry =  Geometry(AssetLibrary.getAsset("geometry"));
			//trace(geo.subGeometries.length);
			// put our hero center stage and assign our material object
			//hero.scale(8);
			
			//hero.material = new ColorMaterial( 0xff0000 );
			
			//hero.material = 
			
			// prepare the model's texture material
			var autoMap:Mapper = new Mapper(modelTexture.bitmapData);
			var specularMethod:FresnelSpecularMethod = new FresnelSpecularMethod();
			specularMethod.normalReflectance = .4;
			
			/*var material:TextureMaterial = new TextureMaterial(modelTexture);
			material.normalMap = new BitmapTexture(autoMap.bitdata[1]);
			trace(autoMap.bitdata[2]);
			material.specularMap = new BitmapTexture(autoMap.bitdata[2]);
			material.specularMethod = specularMethod;
			material.lightPicker = lightPicker;
			material.gloss = 40;
			material.specular = 0.5;
			material.ambientColor = 0xAAAAFF;
			//material.ambient = 0.25;
			material.addMethod(new RimLightMethod(DemoColor[1], .4, 3, RimLightMethod.ADD));
			
			hero.material = material;*//*
			scene.addChild(hero);
			for (var k:int = 1; k < 42; k++) {
				trace(i);
				hero = Mesh(AssetLibrary.getAsset("xy" + k));
				scene.addChild(hero);
				
				var material:TextureMaterial = TextureMaterial(hero.material);
				hero.material.normalMap = new BitmapTexture(autoMap.bitdata[1]);
				trace(autoMap.bitdata[2]);
				material.specularMap = new BitmapTexture(autoMap.bitdata[2]);
				material.specularMethod = specularMethod;
				material.lightPicker = lightPicker;
				material.gloss = 40;
				material.specular = 0.5;
				material.ambientColor = 0xAAAAFF;
				//material.ambient = 0.25;
				material.addMethod(new RimLightMethod(DemoColor[1], .4, 3, RimLightMethod.ADD));
			}*/
		}
		
		public function updateScene(player:int, x:Number, y:Number, z:Number, xPersp:Number, yPersp:Number, zPersp:Number):void {
			
			//trace("x: " + x + "\ny: " + y + "\nz: " + z + "\n");
			//trace("x: " + xPersp + "\ny: " + yPersp + "\nz: " + zPersp + "\n");
			players[player].visible = true;
			players[player].x = x;
			players[player].y = z;
			players[player].z = y;
			//players[player].rotationX = xPersp;
			players[player].rotationY = yPersp;
			//players[player].rotationZ = zPersp;
			//if (hero) {
				//trace(Math.round(hero.x*100) + ", " + Math.round(hero.y*100) + ", " + Math.round(hero.z*100))
			//}
		}
		
		/**
		 * Adds all required animations to the animationSet.
		 */
		private function prepareAnimations():void {
			var a:IAsset = AssetLibrary.getAsset(Cyborg.STAND_LOOK + AssetType.ANIMATION_NODE);
			var lookNode:SkeletonClipNode = SkeletonClipNode(a);
			lookNode.name = Cyborg.STAND_LOOK;
			animationSet.addAnimation(lookNode);
			
			a = AssetLibrary.getAsset(Cyborg.STAND_RIFLE_AIM_MOVE + AssetType.ANIMATION_NODE);
			var aimMoveNode:SkeletonClipNode = SkeletonClipNode(a);
			aimMoveNode.name = Cyborg.STAND_RIFLE_AIM_MOVE;
			animationSet.addAnimation(aimMoveNode);
			
			a = AssetLibrary.getAsset(Cyborg.STAND_RIFLE_AIM_STILL + AssetType.ANIMATION_NODE);
			var aimStillNode:SkeletonClipNode = SkeletonClipNode(a);
			aimStillNode.name = Cyborg.STAND_RIFLE_AIM_STILL;
			animationSet.addAnimation(aimStillNode);
			
			prepareAnimation(Cyborg.STAND_RIFLE_IDLE, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_MOVE_BACK, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_MOVE_FRONT, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_MOVE_LEFT, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_MOVE_RIGHT, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_TURN_LEFT, aimMoveNode);
			prepareAnimation(Cyborg.STAND_RIFLE_TURN_RIGHT, aimMoveNode);
		}
		
		/**
		 * Adds the animation with the specified name together with the specified
		 * overlay animation as a Skeleton180AimingNode to the animation set.
		 * 
		 * @param	animName
		 * @param	overlayNode
		 */
		private function prepareAnimation(animName:String, overlayNode:SkeletonClipNode):void {
			if (!animationSet.hasAnimation(animName)) {
				var a:IAsset = AssetLibrary.getAsset(animName + AssetType.ANIMATION_NODE);
				var animNode:SkeletonClipNode = SkeletonClipNode(a);
				animNode.name = animName;
				animationSet.addAnimation(animNode);
				var skel180Node:Skeleton180AimingNode = new Skeleton180AimingNode();
				skel180Node.baseAnimationNode = animNode;
				skel180Node.jmoAnimationNode = overlayNode;
				skel180Node.name = animName + overlayNode.name;
				animationSet.addAnimation(skel180Node);
			}
		}
	}

}