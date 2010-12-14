//
//  somnode.m
//  som
//
//  Created by alo on 21/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SOMNode.h"


@implementation SOMNode
-(int) x { return x; }
-(int) y { return y; }
-(NSMutableArray*) weights { return weights; }

-(SOMNode*) init: (int) coordX: (int) coordY: (int) vectorSize {
	int i;
	float value;
	x = coordX; y = coordY;
	weights = [NSMutableArray new];
	for (i = 0; i < vectorSize; i++)
	{
		value = randf();
		[weights addObject: [NSNumber numberWithFloat: value ]];
	}
	return self;
}

-(void) update: (NSArray *) inputVector: (float) learningRate: (float) influence {
	int i;
	float weight, input;
	for (i = 0; i < [weights count]; i++)
	{
		weight = [[weights objectAtIndex: i] floatValue];
		input = [[inputVector objectAtIndex: i] floatValue];
		[weights replaceObjectAtIndex: i withObject: [ NSNumber numberWithFloat:
				 weight + ((input - weight) * learningRate * influence)
		 ]];
	}
}

-(float) difference: (NSMutableArray*) compareVector {
	float diff;
	int i;
	diff = 0;
	for (i = 0; i < [weights count]; i++)
	{
		diff += (pow([[weights objectAtIndex: i] floatValue] - [[compareVector objectAtIndex:i] floatValue], 2));
	}
	
	return diff;

}

-(void) dealloc {
	int i;
	for (i = 0;i < [weights count]; i++)
		[[weights objectAtIndex: i] release];
	[super dealloc];
}

@end
