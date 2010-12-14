//
//  somnode.h
//  som
//
//  Created by alo on 21/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "util.h"

@interface SOMNode : NSObject {
	int x, y;
	NSMutableArray* weights;
}

-(int) x;
-(int) y;
-(NSMutableArray*) weights;

-(SOMNode*) init: (int) coordX: (int) coordY: (int) vectorSize;
-(void) update: (NSArray *) inputVector: (float) learningRate: (float) influence;
-(float) difference: (NSMutableArray*) compareVector;
-(void) dealloc;

@end
