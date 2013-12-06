/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2011-2012 Benjamin Eikel <benjamin@eikel.org>
 * Copyright (C) 2011-2013 Claudius Jähn <claudius@uni-paderborn.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
/****
 **	[PADrend] LibGUIExt/GUI_Utils.escript
 **
 **  GUI helper functions
 **/

//! Creates global gui manager GLOBALS.gui.
GUI.init := fn(Util.UI.Window window, Util.UI.EventContext eventContext) {
	if(!GLOBALS.isSet($gui)){
		GLOBALS.gui := new GUI.GUI_Manager(eventContext);
		gui.setWindow(window);
		gui.initDefaultFonts();  // see FontHandling.escript
		gui._destructionMonitor := void; // (optional for debugging) Util.DestructionMonitor
		gui.onMouseMove := new MultiProcedure(); // \todo (Cl) replace by @(init) alternative below when Type._supportsInit() is implemented.
		gui.onMouseButton := new MultiProcedure(); // \todo (Cl) replace by @(init) alternative below when Type._supportsInit() is implemented.
	}
	if(!GLOBALS.gui.isSet($windows)){
		GLOBALS.gui.windows := new Map();
	}
};


/*! GUI.ChainedEventHandler ---|> MultiProcedure

	A GUI.ChainedEventHandler is similar to an ordinary MultiProcedure with
	different behavior depending on the result of the registered functions:
		$BREAK (or true)		skip other functions; return true (event consumed)
		$BREAK_AND_REMOVE		remove this function; skip other functions; return true (event consumed)
		$CONTINUE (or void)		continue with other functions; if this was the last one, return false. (event not consumed)
		$CONTINUE_AND_REMOVE	remove this function;  continue with other functions; 
								if this was the last one, return false (event consumed).
		
	\see MultiProcedure
*/
GUI.ChainedEventHandler := new Type(MultiProcedure);
{
	var T = GUI.ChainedEventHandler;
	T._printableName @(override) ::= $ChainedEventHandler;
	T.BREAK ::= $BREAK;
	T.BREAK_AND_REMOVE ::= $BREAK_AND_REMOVE;
	T.CONTINUE ::= $CONTINUE;
	T.CONTINUE_AND_REMOVE ::= $CONTINUE_AND_REMOVE;

	//! Calls all the registered functions and returns true iff the event has been consumed (one function returned true or $BREAK...)
	T._call @(override) ::= fn(obj,params...){
		for(var i=0;i<functions.count();){
			var result = (obj->functions[i])(params...);
			if(result){
				if(result == CONTINUE){
					++i;
				}else if(result == BREAK  || result === true){
					return true; // event handled
				}else if(result == BREAK_AND_REMOVE){
					functions.removeIndex(i);
					return true; // event handled
				}else if(result == CONTINUE_AND_REMOVE || result == REMOVE){
					functions.removeIndex(i);
				}else {
					Runtime.warn("Invalid return value '"+result+"'. Expected $BREAK, $BREAK_AND_REMOVE, $CONTINUE, or $CONTINUE_AND_REMOVE");
					++i;
				}
			}else{
				++i;
			}
		}
		return false;
	};
}

// ------------------------------------------------------------------------------
// GUI Manager extensions

//GUI.GUI_Manager.onMouseMove @(init,const) :=  MultiProcedure; // \todo (Cl) not working correctly until now...

// ------------------------------------------------------------------------------
// constants
// ------------------------------------------------------------------------------

GUI.H_DELIMITER := $DELIMITER;
GUI.NEXT_ROW := $NEXT_ROW;
GUI.NEXT_COLUMN := $NEXT_COLUMN;


GUI.BLACK := new Util.Color4ub(0,0,0,255);
GUI.WHITE := new Util.Color4ub(255,255,255,255);
GUI.RED := new Util.Color4ub(255,0,0,255);
GUI.DARK_GREEN := new Util.Color4ub(0,128,0,255);
GUI.GREEN := new Util.Color4ub(0,255,0,255);
GUI.BLUE := new Util.Color4ub(0,0,255,255);
GUI.NO_COLOR := new Util.Color4ub(0, 0, 0, 0);

// default layouters
GUI.LAYOUT_FLOW := (new GUI.FlowLayouter()).setMargin(2).setPadding(2);
GUI.LAYOUT_TIGHT_FLOW := (new GUI.FlowLayouter()).setMargin(0).setPadding(0);
GUI.LAYOUT_BREAKABLE_TIGHT_FLOW := (new GUI.FlowLayouter()).setMargin(0).setPadding(0).enableAutoBreak();

// default SIZEs
GUI.SIZE_MAXIMIZE := [GUI.WIDTH_REL|GUI.HEIGHT_REL , 1.0,1.0 ];
GUI.SIZE_MINIMIZE := [GUI.WIDTH_CHILDREN_ABS|GUI.HEIGHT_CHILDREN_ABS , 0,0 ];

// default values for GUI.POSITION
GUI.POSITION_CENTER_XY :=	[
								GUI.POS_X_ABS | GUI.REFERENCE_X_CENTER | GUI.ALIGN_X_CENTER |
								GUI.POS_Y_ABS | GUI.REFERENCE_Y_CENTER | GUI.ALIGN_Y_CENTER,
								0, 0
							];

// Text (or description) used for buttons opening the options menu in dropdowns and comboboxes.
// May be overridden and used for other menu buttons.
GUI.OPTIONS_MENU_MARKER := ">";

// ------------------------------------------------------------------------------------
