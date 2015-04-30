/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2015 Claudius Jähn <claudius@uni-paderborn.de>
 *
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

return fn() {
	var n = new MinSG.GeometryNode;
	module('LibMinSGExt/SemanticObject').markAsSemanticObject(n);

	//! \see ObjectTraits/Geometry/DynamicSphereTrait
	Std.Traits.addTrait( n, Std.module('ObjectTraits/Geometry/DynamicSphereTrait'));
	module('../InternalTools').registerNodeWithUniqueId(n,"Sphere");
	
	return n;
};

