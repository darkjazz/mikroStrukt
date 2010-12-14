//
//  FxView.m
//  Fx
//
//  Created by alo on 02/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "View.h"

@implementation View

+ (NSOpenGLPixelFormat*) basicPixelFormat
{
    NSOpenGLPixelFormatAttribute attributes [] = {
        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,	// double buffered
        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute)16, // 16 bit depth buffer
        (NSOpenGLPixelFormatAttribute)nil
    };
    return [[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];
}

- (void) prepareOpenGL {
	glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
	glClearDepth(1.0f);
	glDepthFunc(GL_LEQUAL);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

    glActiveTexture(GL_TEXTURE0);
    glEnable( GL_TEXTURE_2D );

}

- (void) reshape
{
    float aspect;
    NSSize bound = [self frame].size;
    aspect = bound.width / bound.height;
    // change the size of the viewport to the new width and height
    // this controls the affine transformation of x and y from normalized device 
    // coordinates to window coordinates (from the OpenGl 1.1 reference book, 2nd ed)
    glViewport(0, 0, bound.width, bound.height);
    glMatrixMode(GL_PROJECTION);
    // you must reload the identity before this or you'll lose your picture
    glLoadIdentity();
    gluPerspective(45.0f, (GLfloat)aspect, 0.1f,100.0f);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (void) trainSom {
		
	if ([oscer initializeSom])
	{
		som = [[SOM new] init: [oscer trainDuration] : VECTOR_SIZE : [oscer width] : [oscer height] : [oscer learningRate] ];
		[oscer resetInitialized];
		initialized = true;
	}
	
	if (initialized)
	{
		if ([oscer getNewVector])
		{
			bmu = [som train:[oscer getWeights]];
			if (bmu) { [oscer sendMessage: bmu]; }			
		}
	}

}

- (void) drawFrame {

	glLoadIdentity();
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	if (initialized)
		[self drawCells];
	[[NSOpenGLContext currentContext] flushBuffer];
	
}


- (void) drawCells {
	int i, j;
	NSMutableArray * row;
	SOMNode * node;
	
	zoom = [oscer getZoom];
	glTranslatef(0.0f, 0.0f, zoom);
	
	glAlpha = [oscer getAlpha];
	[draw setGlobalAlpha: glAlpha];
		
	[oscer setPatch];
						
	for (i = 0; i < [[som nodes] count]; i++)
	{
		row = [[som nodes] objectAtIndex: i];
		for (j = 0; j < [row count]; j++)
		{
			node = [row objectAtIndex: j];
			[draw drawNode:[node weights] : i : j : [som width] : [bmu x] : [bmu y] ];			
		}
	}
	
	bg = [oscer getClear];
	glClearColor(bg, bg, bg, 1.0f);
	done = [oscer getDone];
	phase += 1;

}

- (id) initWithFrame: (NSRect) frameRect {

	NSOpenGLView* opengl;
	
	NSOpenGLPixelFormat * pf = [View basicPixelFormat];

	[super initWithContentRect:frameRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
 
	NSRect view_bounds = NSMakeRect(0,0,frameRect.size.width, frameRect.size.height);
	
	opengl = [NSOpenGLView alloc];
	
	[self setContentView: [[opengl initWithFrame:view_bounds pixelFormat:pf] autorelease]];

	[[opengl openGLContext] makeCurrentContext];

	draw = [[Draw new] init];

	initialized = false;	
		
	done = 0;
	bg = 0.0f;
	zoom = -32.0f;
	glAlpha = 1.0f;
	oscer = [[[OSC new] initWithAddress: SC_ADDRESS : SC_PORT: draw] retain];	
	[oscer startListener];
	
	[self prepareOpenGL];
	
	[self reshape];
	
    return self;
}

- (void) awakeFromNib { }

- (int) done { return done; }

- (void) dealloc {
	[oscer stopListener];
	[oscer release];
	[som release];
	[draw release];
	[super dealloc];
}

@end
