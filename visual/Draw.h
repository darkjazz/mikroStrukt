//
//  FxDraw.h
//  Fx
//
//  Created by alo on 17/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import  <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>
#include <OpenGL/glext.h>
#include "util.h"
#include "Patch.h"
#import "SOMNode.h"


@interface Draw : NSObject {
	NSMutableDictionary * patches;
	int indexi, indexj, slices, stacks;
	float left, bottom, width, height, red, green, blue, alpha, size;
	float state, gAlpha, lineWidth;
	NSMutableArray* currentNode;
	Patch* cp;
	
	GLfloat points[20][20][3];
}


-(float) state;
-(void) setState: (float) value;

-(int) indexi;
-(void) setIndexi: (int) value;

-(int) indexj;
-(void) setIndexj: (int) value;

-(NSMutableDictionary*) patches;

-(void) setGlobalAlpha: (float) value;

-(void) setPoint: (int) i: (int) j: (GLfloat) x: (GLfloat) y: (GLfloat) z;

-(void) dealloc;


- (Draw*) init;
- (void) drawNode: (NSMutableArray*) node: (int) i: (int) j : (int) worldSize : (int) bmu_x : (int) bmu_y;
- (void) drawDiffX: (SOMNode*) node: (SOMNode*) compareNode: (int) i: (int) j : (int) worldSize;
- (void) drawDiffY: (SOMNode*) node: (SOMNode*) compareNode: (int) i: (int) j : (int) worldSize;
- (void) strokeRect;
- (void) strokeRect3f: (float) front;
- (void) drawRect;
- (void) fillRect;
- (void) fillRect3f: (float) front;
- (void) drawAxialRect: (float) colN: (float) colE: (float) colS: (float) colW;
- (void) wireSphere;
- (void) solidSphere;
- (void) drawLine: (float) startx: (float) starty: (float) endx: (float) endy: (float) startz: (float) startx;
- (void) drawCircle: (float) cx: (float) cy: (float) cz: (float) r: (int) num_segments: (bool) fill;
- (void) drawSurface;
- (void) drawPoint: (float) x: (float) y: (float) z: (float) sz;
- (void) fillTriangle: (float) ax: (float) ay: (float) az: (float) bx: (float) by: (float) bz: (float) cx: (float) cy: (float) cz;


@end
