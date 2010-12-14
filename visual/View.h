//
//  FxView.h
//  Fx
//
//  Created by alo on 02/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import  <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>
#include "SOM.h"
#include "Draw.h"
#import "OSC.h"
#include "PatchDictionary.h"
#include <GLUT/glut.h>

#define BITS_PER_PIXEL          32.0
#define DEPTH_SIZE              32.0
#define WORLD_SIZE				40
#define TRAIN_DUR				3000
#define VECTOR_SIZE				6
#define LEARNING_RATE			0.1
#define SC_ADDRESS				"127.0.0.1" //"192.168.1.4"
#define SC_PORT					"57120"

@interface View : NSWindow {

	bool first;
	NSTimer *time;
	SOM *som;
	SOMNode *bmu;
	Draw *draw;
	bool run;
	OSC * oscer;
	float bg, zoom, glAlpha;
	int done;
	int phase;
	bool initialized;
	PatchDictionary * pdict;
}

+ (NSOpenGLPixelFormat*) basicPixelFormat;

- (int) done;

- (void) drawCells;
- (void) drawFrame;
- (void) trainSom;

- (void) prepareOpenGL;

- (id) initWithFrame: (NSRect) frameRect;
- (void) awakeFromNib;

- (void) dealloc;

@end
