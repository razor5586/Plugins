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
 


var resourceFolder = __DIR__+"/../resources";

gui.loadIconFile( resourceFolder+"/Icons/PADrendDefault.json");

GUI.OPTIONS_MENU_MARKER @(override) := {
	GUI.TYPE : GUI.TYPE_ICON,
	GUI.ICON : '#DownSmall',
	GUI.ICON_COLOR : new Util.Color4ub(0x30,0x30,0x30,0xff)
};

// init fonts
gui.registerFonts({
	GUI.FONT_ID_DEFAULT : 		resourceFolder+"/Fonts/DejaVu_Sans_Codensed_12.fnt",
//		GUI.FONT_ID_DEFAULT : 		resourceFolder+"/Fonts/DejaVu_Sans_Codensed_12.png",
//		GUI.FONT_ID_DEFAULT : 		GUI.BitmapFont.createFont(resourceFolder+"/Fonts/BAUHS93.ttf",12, " !\"#$%&'()*+,-./0123456789:;<=>?@ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),
//		GUI.FONT_ID_DEFAULT : 		GUI.BitmapFont.createFont(resourceFolder+"/Fonts/BAUHS93.ttf",20, " !\"#$%&'()*+,-./0123456789:;<=>?@ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),
//		GUI.FONT_ID_DEFAULT : 		GUI.BitmapFont.createFont("Arial.ttf",20, " !\"#$%&'()*+,-./0123456789:;<=>?@ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),
	GUI.FONT_ID_HEADING : 		resourceFolder+"/Fonts/DejaVu_Sans_14.fnt",
	GUI.FONT_ID_LARGE : 		resourceFolder+"/Fonts/DejaVu_Sans_Codensed_18.fnt",
	GUI.FONT_ID_TOOLTIP : 		resourceFolder+"/Fonts/DejaVu_Sans_10.fnt",
	GUI.FONT_ID_WINDOW_TITLE : 	resourceFolder+"/Fonts/DejaVu_Sans_12.fnt",
	GUI.FONT_ID_XLARGE : 		resourceFolder+"/Fonts/DejaVu_Sans_32_outline_aa.fnt",
	GUI.FONT_ID_HUGE : 			resourceFolder+"/Fonts/DejaVu_Sans_64_outline_aa.fnt",
});



var color_accent1 = new Util.Color4ub(0,58,128,255);
var color_accent2 = new Util.Color4ub(255,221,0,255);

var NS = new Namespace;

NS.TOOLBAR_ICON_COLOR := new Util.Color4f(0.0,0,0,0.9);
NS.TOOLBAR_BG_SHAPE := new GUI.ShapeProperty(GUI.PROPERTY_COMPONENT_BACKGROUND_SHAPE,
											gui._createRectShape(new Util.Color4f(0.3,0.3,0.3,0.5),new Util.Color4ub(0,0,0,0),true));
NS.TOOLBAR_BUTTON_PROPERTIES := [new GUI.ColorProperty(GUI.PROPERTY_ICON_COLOR, NS.TOOLBAR_ICON_COLOR)];
NS.TOOLBAR_BUTTON_HOVER_PROPERTIES := [ [new GUI.ShapeProperty(GUI.PROPERTY_BUTTON_SHAPE,
											gui._createRectShape(color_accent1,new Util.Color4ub(0,0,0,0),true)),1,false] ];

NS.TOOLBAR_ACTIVE_BUTTON_PROPERTIES := [	new GUI.ColorProperty(GUI.PROPERTY_ICON_COLOR, GUI.BLACK),
											new GUI.ShapeProperty(GUI.PROPERTY_BUTTON_SHAPE,
											gui._createRectShape(color_accent2,new Util.Color4ub(0,0,0,0),true))];
//									PROPERTY_BUTTON_ENABLED_COLOR
//									TOOLBAR_ACTIVE_BUTTON_PROPERTIES
											
NS.resourceFolder := resourceFolder;
											
NS.CURSOR_DEFAULT := Util.loadBitmap(resourceFolder+"/MouseCursors/3dSceneCursor.png");

gui.registerMouseCursor(GUI.PROPERTY_MOUSECURSOR_DEFAULT, NS.CURSOR_DEFAULT, 0, 0);
gui.registerMouseCursor(GUI.PROPERTY_MOUSECURSOR_TEXTFIELD, Util.loadBitmap(resourceFolder+"/MouseCursors/TextfieldCursor.png"), 8, 8);
gui.registerMouseCursor(GUI.PROPERTY_MOUSECURSOR_RESIZEDIAGONAL, Util.loadBitmap(resourceFolder+"/MouseCursors/resizeCursor.png"), 9, 9);


// menu
gui.setDefaultColor(GUI.PROPERTY_MENU_TEXT_COLOR,new Util.Color4ub(255,255,255,255));
gui.setDefaultShape(GUI.PROPERTY_MENU_SHAPE,
						gui._createShadowedRectShape( new Util.Color4ub(20,20,20,200),new Util.Color4ub(150,150,150,200),true) );
gui.setDefaultShape(GUI.PROPERTY_TEXTFIELD_SHAPE,
						gui._createRectShape( new Util.Color4ub(230,230,230,240),new Util.Color4ub(128,128,128,128),true ));

return NS;
