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


/*! The AnimatedBaseTrait is a helper trait for specific animation traits.
	It handles the registration with a linked animator node.
	The following members are added to the given Node:
			
	- node.animationInit 	MultiProcedure(time)
	- node.animationPlay 	MultiProcedure(time,lastTime)
	- node.animationStop	MultiProcedure(time)
	
	\note add the ObjectTraits/NodeLinkTrait to the given node.
	\note adds the ObjectTraits/AnimatorBaseTrait to a node linked with the "animator" role.
*/
static AnimationHandler = new Type;
AnimationHandler.subject := void;
AnimationHandler.currentMode := void;
AnimationHandler.lastTime := void;
AnimationHandler._constructor ::= fn(_subject){
	this.subject = _subject;
};
AnimationHandler._call ::= fn(caller,mode,time=0){
	switch(mode){
	case 'play':
		if(this.currentMode!=mode){
			this.subject.animationInit(time);
			this.currentMode = mode;
			this.lastTime = time;
		}
		this.subject.animationPlay(time,this.lastTime);
		this.lastTime = time;
		break;
	case 'stop':
		if(this.currentMode!=mode){
			this.subject.animationStop(time,this.lastTime);
			this.currentMode = mode;
			this.lastTime = time;
		}
	case 'pause':
		break;
	default:
		Runtime.warn("Unknown mode: "+mode);
	}
};

static trait = new MinSG.PersistentNodeTrait('ObjectTraits/AnimatedBaseTrait');

trait.onInit += fn(MinSG.Node node){

	@(once) static NodeLinkTrait = Std.require('ObjectTraits/NodeLinkTrait');
	@(once) static AnimatorBaseTrait = Std.require('ObjectTraits/AnimatorBaseTrait');

	if(!Traits.queryTrait(node,NodeLinkTrait))
		Traits.addTrait(node,NodeLinkTrait);
	
	var handler = new AnimationHandler(node);


	var connectTo = [node,handler] => fn(node,handler, [MinSG.Node,void] animatorNode){
		outln(" Connecting ",node," to ",animatorNode);
		if(node.isSet($__myAnimatorNode) && node.__myAnimatorNode){
			node.__myAnimatorNode.animationCallbacks.accessFunctions().removeValue(handler); //! \see ObjectTraits/AnimatorBaseTrait
			handler( "stop" );
		}

		node.__myAnimatorNode := animatorNode;

		if(animatorNode){
			if(!Traits.queryTrait(animatorNode,AnimatorBaseTrait))
				Traits.addTrait(animatorNode,AnimatorBaseTrait);
				
			animatorNode.animationCallbacks += handler;	//! \see ObjectTraits/AnimatorBaseTrait
		}
	};

	//! \see ObjectTraits/NodeLinkTrait
	node.onNodesLinked += [connectTo] => fn(connectTo, role,Array nodes,Array parameters){
		if(role=="animator"){
			connectTo(nodes[0]);
			if(nodes.count()!=1){
				Runtime.warn("AnimationBaseTrait: only one AnimatorNode allowed.");
			}
		}
	};
	
	//! \see ObjectTraits/NodeLinkTrait
	node.onNodesUnlinked += [connectTo] => fn(connectTo, role,Array nodes,Array parameters){
		if(role=="animator")
			connectTo( void );
	};
	
	var exisitingLinks = node.getNodeLinks("animator");
	if(!exisitingLinks.empty()){
		connectTo(exisitingLinks[0][0][0]);
		if(exisitingLinks.count()!=1||exisitingLinks[0][0].count()!=1){
			Runtime.warn("AnimationBaseTrait: only one AnimatorNode allowed.");
			print_r(exisitingLinks);
		}
	}
		
		
	node.animationPlay := new MultiProcedure;
	node.animationInit := new MultiProcedure;
	node.animationStop := new MultiProcedure;
};

trait.allowRemoval();
trait.onRemove += fn(node){
	node.animationStop(0);
	node.animationStop.clear();
	node.animationPlay.clear();
	node.animationInit.clear();
};


return trait;
