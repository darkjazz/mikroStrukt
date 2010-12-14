//
//  SOM.h
//  som
//
//  Created by alo on 21/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <math.h>
#include "util.h"
#include "SOMNode.h"


@interface SOM : NSObject {
	int trainDuration, vectorSize, width, height, trainCount;
	float timeConst, initialLearningRate, learningRate, mapRadius;
	NSMutableArray* nodes;
}

-(NSMutableArray*) nodes;
-(int) width;
-(int) height;

-(SOM*) init: (int) trainDur: (int) vsize: (int) sizex: (int) sizey: (float) lrate; 
-(void) initNodes;
-(SOMNode*) findBMU: (NSMutableArray*) inputVector;
-(SOMNode*) train: (NSMutableArray*) inputVector;
-(void) dealloc;

@end
