//
//  FxDraw.m
//  Fx
//
//  Created by alo on 17/01/2009.
//  Copyright 2009 alo. All rights reserved.
//

#import "Draw.h"


@implementation Draw

-(float) state { return state; }
-(void) setState: (float) value { state = value; }

-(int) indexi { return indexi; }
-(void) setIndexi: (int) value { indexi = value; }

-(int) indexj { return indexj; }
-(void) setIndexj: (int) value { indexj = value; }

-(NSMutableDictionary*) patches { return patches; }

-(void) setGlobalAlpha: (float) value { gAlpha = value; }

-(void) setParam: (NSString*) key: (char*) param: (float) value
{
	
}

-(void) setPoint: (int) i: (int) j: (GLfloat) x: (GLfloat) y: (GLfloat) z 
{ 
	points[i][j][0] = x; 
	points[i][j][1] = y; 
	points[i][j][2] = z;
}

-(Draw*) init {
	NSArray* names;
	NSString* name;
	int i;
	self = [super init];
	names = [NSArray arrayWithObjects: @"kanji", @"ringz", @"wobble", @"grid", @"horizons", @"blinds", 
			 @"axial", @"radial", @"elastic", @"mesh", nil ];
	patches = [NSMutableDictionary new];
	
	for (i = 0; i < [names count]; i++)
	{
		name = [names objectAtIndex:i];
		[patches setObject: [[Patch new] init] forKey: name];
	}
	
	return self;
}


- (void) drawNode: (NSMutableArray *) node: (int) i: (int) j : (int) worldSize : (int) bmu_x : (int) bmu_y {
	
	float depth;
	float sizex, sizey;
	
	currentNode = node;
	indexi = i;
	indexj = j;

	lineWidth = 1.0f;
	
//	if (i == bmu_x && j == bmu_y)
//	{
//		lineWidth = 3.0f;
//	}
//	else
//	{
//		lineWidth = 1.0f;	
//	}
	sizex = 1.333f;
	sizey = 1.0f;

	red = clipf([[node objectAtIndex:0] floatValue], 0.0f, 1.0f);
	green = clipf([[node objectAtIndex:1] floatValue], 0.0f, 1.0f);
	blue = clipf([[node objectAtIndex:2] floatValue], 0.0f, 1.0f);
	alpha = clipf(1.0f - [[node objectAtIndex:3] floatValue], 0.0f, 1.0f);
		
	left =  i * sizex - (sizex * worldSize / 2);
	bottom = j * sizey - (sizey * worldSize / 2);
	width = sizex;
	height = 0.25f;
	
	depth = 0.0f; //([[node objectAtIndex:0] floatValue] + [[node objectAtIndex:1] floatValue] + [[node objectAtIndex:2] floatValue]) / 3 * 5.0f;

	[self drawLine: left : bottom : left + width : bottom : 1.0f : 1.0f ];

//	[self fillRect3f: depth];
	[self strokeRect3f: depth];
	
	red = green = blue = [[node objectAtIndex:5] floatValue];
	depth = 0.0f; // [[node objectAtIndex:5] floatValue] * 3.0f;
	
	left = i * sizex - (sizex * worldSize / 2);
	bottom = j * sizey - (sizey * worldSize / 2) + 0.5f;
	width = sizex;
	height = 0.25f;

	[self drawLine: left : bottom : left + width : bottom : 1.0f : 1.0f ];
	
//	[self fillRect3f: depth];
	[self strokeRect3f: depth];
			
}

- (void) drawDiffX: (SOMNode*) node: (SOMNode*) compareNode: (int) i: (int) j : (int) worldSize {
	float diff, sizex, sizey;
	
	sizex = 1.333f;
	sizey = 1.0f;	
	
	diff = [node difference: [compareNode weights]];
	
	lineWidth = 1.0f;
	red = diff;
	green = diff;
	blue = diff + 0.1f;
	alpha = 0.2f + diff;
	
	left = i*sizex-(sizex*worldSize/2)+sizex;
	bottom = j*sizey-(sizey*worldSize/2);
	width = sizex;
	height = sizey;
	
	[self drawLine: left : bottom : left : bottom+sizey : 1.0f : 1.0f ];
	
}

- (void) drawDiffY: (SOMNode*) node: (SOMNode*) compareNode: (int) i: (int) j : (int) worldSize {
	float diff, sizex, sizey;
	
	sizex = 1.333f;
	sizey = 1.0f;	
	
	diff = [node difference: [compareNode weights]];
	
	lineWidth = 1.0f;
	red = diff;
	green = diff;
	blue = diff + 0.1f;
	alpha = 0.2f + diff;

	left = i*sizex-(sizex*worldSize/2);
	bottom = j*sizey-(sizey*worldSize/2)+sizey;
	width = sizex;
	height = sizey;
	
	[self drawLine: left : bottom : left+sizex : bottom : 1.0f : 1.0f ];
	
}



// basic drawing functions

- (void) drawRect {
	glColor4f(red, green, blue, alpha);
	glBegin(GL_POLYGON);
	
	glVertex3f (left, bottom, 0.0f);
	glVertex3f (left + width, bottom, 0.0f);
	glVertex3f (left + width, bottom + height, 0.0f);
	glVertex3f (left, bottom + height, 0.0f);
	
	glEnd();
	
}

- (void) drawAxialRect: (float) colN: (float) colE: (float) colS: (float) colW {
	glBegin(GL_POLYGON);
	
	glColor4f(colS, colS, colS, alpha);
	glVertex3f (left, bottom, 0.0f);
	glColor4f(colE, colE, colE, alpha);
	glVertex3f (left + width, bottom, 0.0f);
	glColor4f(colN, colN, colN, alpha);
	glVertex3f (left + width, bottom + height, 0.0f);
	glColor4f(colW, colW, colW, alpha);
	glVertex3f (left, bottom + height, 0.0f);
	
	glEnd();
	
}

- (void) fillTriangle: (float) ax: (float) ay: (float) az: (float) bx: (float) by: (float) bz: (float) cx: (float) cy: (float) cz {

	glColor4f(red, green, blue, alpha);
	glEnable(GL_POLYGON_SMOOTH);
	glBegin(GL_POLYGON);

	glVertex3f(ax, ay, az);
	glVertex3f(bx, by, bz);
	
	glVertex3f(bx, by, bz);
	glVertex3f(cx, cy, cz);
	
	glVertex3f(cx, cy, cz);
	glVertex3f(ax, ay, az);
	
	glEnd();
	glDisable(GL_POLYGON_SMOOTH);
	
}

- (void) fillRect {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POLYGON_SMOOTH);
	glBegin(GL_POLYGON);
	
	glVertex2f (left, bottom);
	glVertex2f (left + width, bottom);
	
	glVertex2f (left + width, bottom);
	glVertex2f (left + width, bottom + height);
	
	glVertex2f (left + width, bottom + height);
	glVertex2f (left, bottom + height);
	
	glVertex2f (left, bottom + height);
	glVertex2f (left, bottom);	
	
	glEnd();
	glDisable(GL_POLYGON_SMOOTH);
	
}

- (void) strokeRect {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	glVertex2f (left, bottom);
	glVertex2f (left + width, bottom);
	
	glVertex2f (left + width, bottom);
	glVertex2f (left + width, bottom + height);
	
	glVertex2f (left + width, bottom + height);
	glVertex2f (left, bottom + height);
	
	glVertex2f (left, bottom + height);
	glVertex2f (left, bottom);	
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);
}

- (void) fillRect3f: (float) front {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POLYGON_SMOOTH);
	glBegin(GL_POLYGON);
	
	glVertex3f (left, bottom, front);
	glVertex3f (left + width, bottom, front);
	
	glVertex3f (left + width, bottom, front);
	glVertex3f (left + width, bottom + height, front);
	
	glVertex3f (left + width, bottom + height, front);
	glVertex3f (left, bottom + height, front);
	
	glVertex3f (left, bottom + height, front);
	glVertex3f (left, bottom, front);	
	
	glEnd();
	glDisable(GL_POLYGON_SMOOTH);
	
}


- (void) strokeRect3f: (float) front {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	glVertex3f (left, bottom, front);
	glVertex3f (left + width, bottom, front);
	
	glVertex3f (left + width, bottom, front);
	glVertex3f (left + width, bottom + height, front);
	
	glVertex3f (left + width, bottom + height, front);
	glVertex3f (left, bottom + height, front);
	
	glVertex3f (left, bottom + height, front);
	glVertex3f (left, bottom, front);	
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);	
}

- (void) drawLine: (float) startx: (float) starty: (float) endx: (float) endy: (float) startz: (float) endz {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	glVertex3f(startx, starty, startz);
	glVertex3f(endx, endy, endz);
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);
}

- (void) drawPoint: (float) x: (float) y: (float) z: (float) sz {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POINT_SMOOTH);
	glPointSize(sz);
	glBegin(GL_POINTS);
	glVertex3f(x, y, z);
	glEnd();
	glDisable(GL_POINT_SMOOTH);
}

- (void) wireSphere {
	glPushMatrix();
	glTranslatef(left, bottom, 0.0f);
	glColor4f(red, green, blue, alpha);
	glutWireSphere(width, slices, stacks);
	glPopMatrix();
	
}

- (void) solidSphere {
	glPushMatrix();
	glTranslatef(left, bottom, 0.0f);
	glColor4f(red, green, blue, alpha);
	glutSolidSphere(width, slices, stacks);
	glPopMatrix();
}

- (void) drawCircle: (float) cx: (float) cy: (float) cz: (float) r: (int) num_segments: (bool) fill { 
	int i;
	float theta, tangetial_factor, radial_factor, x, y;
	theta = 2 * pi / num_segments;
	tangetial_factor = tanf(theta);
	radial_factor = cosf(theta);
	x = r;
	y = 0;
	
	if (fill) {
		glBegin(GL_POLYGON);	
	}
	{
		glEnable(GL_LINE_SMOOTH);
		glLineWidth(lineWidth);
		glBegin(GL_LINE_LOOP);
	}
	glColor4f(red, green, blue, alpha);
	for(i = 0; i < num_segments; i++) 
	{ 
		glVertex3f(x + cx, y + cy, cz);
        
		float tx = -y; 
		float ty = x; 
		x += tx * tangetial_factor; 
		y += ty * tangetial_factor; 
		x *= radial_factor; 
		y *= radial_factor; 
	} 
	glEnd(); 
}

- (void) drawSurface
{
	glMap2f(GL_MAP2_VERTEX_3, 0, 1, 3, 4, 0, 1, 60, 4, &points[0][0][0]);
	glMapGrid2f(10, 0.0f, 1.0f, 10, 0.0f, 1.0f);
	glEvalMesh2(GL_FILL, 0, 30, 0, 30);

	GLfloat ambient[] = {0.2, 0.2, 0.2, 0.5};
	GLfloat position[] = {1.0, 1.0, -2.0, 0.5};
	GLfloat mat_diffuse[] = {0.6, 0.6, 0.6, 0.5};
	GLfloat mat_specular[] = {1.0, 1.0, 1.0, 0.5};
	GLfloat mat_shininess[] = {30.0};
		
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
	glLightfv(GL_LIGHT0, GL_POSITION, position);
	
	glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);
	glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
	glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
}

-(void) dealloc {
	int i;
	NSArray* names;
	NSString* name;
	
	names = [NSArray arrayWithObjects: @"kanji", @"ringz", @"wobble", @"grid", @"horizons", @"blinds", 
			 @"axial", @"axial", @"radial", @"elastic", @"mesh", nil ];
	
	for (i = 0; i < [names count]; i++)
	{
		name = [names objectAtIndex: i];
		[[patches objectForKey: name] release];
	}
	
	[super dealloc];
}

@end
