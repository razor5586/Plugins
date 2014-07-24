/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2014 Claudius Jähn <claudius@uni-paderborn.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
 
 
var plugin = new Plugin({
		Plugin.NAME : 'PADrend/Picking',
		Plugin.DESCRIPTION : "PADrend picking support.",
		Plugin.VERSION : 1.0,
		Plugin.AUTHORS : "Claudius",
		Plugin.OWNER : "All",
		Plugin.REQUIRES : ['PADrend'],
		Plugin.EXTENSION_POINTS : [	]
});

plugin.init @(override) := fn(){
	return true;
};

static getRayCaster = fn(){
	static caster;
	@(once)	caster = new (Std.require('LibMinSGExt/RendRayCaster'));
	return caster;
};

static queryCameras = fn(screenCoordinate){
	@(once) static EventLoop = Util.requirePlugin('PADrend/EventLoop');
	var cameras = [];
	foreach( EventLoop.getCamerasUsedForLastFrame() as var camera){
		if(camera.getViewport().contains(screenCoordinate))
			cameras.pushFront(camera);// top most first
	}
	return cameras;
};

/*! Pick a node from the screen using the currently active cameras.
	@p screenCoordinate	Geometry.Vec2 or [x,y]
	@p rootNode			iff void, the active scene is used
	@p renderingLayers	iff void, the active renderingLayers are used	
	@return The node at the given @p screenCoordinates or void*/
plugin.pickNode := fn( screenCoordinate, [MinSG.Node,void] rootNode=void, [Number,void] renderingLayers){
	screenCoordinate = new Geometry.Vec2(screenCoordinate);
	if(!rootNode)
		rootNode = PADrend.getCurrentScene();

	@(once) static EventLoop = Util.requirePlugin('PADrend/EventLoop');
	
	var rayCaster = getRayCaster();
	rayCaster.renderingLayers( renderingLayers ? renderingLayers : EventLoop.getRenderingLayers() );
	
	frameContext.pushCamera();
	var node;
	foreach( queryCameras(screenCoordinate) as var camera){
		frameContext.setCamera(camera);
		node = rayCaster.queryNodeFromScreen(frameContext,rootNode,screenCoordinate,true);
		if(node)
			break;
	}
	frameContext.popCamera();
	return node;
};

/*! Detect the intersection from a ray into the screen with the scene using the currently active cameras.
	@p screenCoordinate	Geometry.Vec2 or [x,y]
	@p rootNode			iff void, the active scene is used
	@p renderingLayers	iff void, the active renderingLayers are used	
	@return Vec3 world coordinate or void*/
plugin.queryIntersection := fn( screenCoordinate, [MinSG.Node,void] rootNode=void, [Number,void] renderingLayers){
	screenCoordinate = new Geometry.Vec2(screenCoordinate);
	if(!rootNode)
		rootNode = PADrend.getCurrentScene();

	var rayCaster = getRayCaster();
	rayCaster.renderingLayers( renderingLayers ? renderingLayers : Util.requirePlugin('PADrend/EventLoop').getRenderingLayers() );
	
	frameContext.pushCamera();
	var intersection;
	foreach( queryCameras(screenCoordinate) as var camera){
		frameContext.setCamera(camera);
		intersection = rayCaster.queryIntersectionFromScreen(frameContext,rootNode,screenCoordinate);
		if(intersection)
			break;
	}
	frameContext.popCamera();

	return intersection;
};

plugin.getPickingRay := fn( screenCoordinate ){
	screenCoordinate = new Geometry.Vec2(screenCoordinate);
	
	frameContext.pushCamera();
	var ray;
	foreach( queryCameras(screenCoordinate) as var camera){
		frameContext.setCamera(camera);
		ray = frameContext.calcWorldRayOnScreenPos(screenCoordinate);
		frameContext.popCamera();
		break;
	}else{ // fallback: use the "official" activeCamera, even if the screenCoordinate is beyond its viewport.
		frameContext.popCamera();
		ray = frameContext.calcWorldRayOnScreenPos(screenCoordinate);
	}
	return ray;
};

return plugin;

// ------------------------------------------------------------------------------
