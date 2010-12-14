//
//  SOM.m
//  som
//
//  Created by alo on 21/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SOM.h"


@implementation SOM

-(NSMutableArray*) nodes { return nodes; }
-(int) width { return width; }
-(int) height { return height; }

-(SOM*) init: (int) trainDur: (int) vsize: (int) sizex: (int) sizey: (float) lrate {
	
	trainDuration = trainDur;
	vectorSize = vsize;
	width = sizex;
	height = sizey;
	initialLearningRate = lrate;
	learningRate = initialLearningRate;
	trainCount = 0;
	
	mapRadius = (float)max(width, height) / 2.0f;
	
	timeConst = trainDuration / logf(mapRadius);
	
	[self initNodes];
	
	return self;
	
}

-(void) initNodes {
	int i, j;
	NSMutableArray* row;
	nodes = [NSMutableArray new];
	
	for (i = 0; i < width; i++) {
		row = [NSMutableArray new];
		for (j = 0; j < height; j++) {
			[row addObject: [[[SOMNode new] init: i : j : vectorSize] retain]]; 
		}
		[nodes addObject: row];
	}

}

-(SOMNode*) findBMU: (NSMutableArray*) inputVector {
	int i, j;
	float diff, best; 
	SOMNode* thenode;
	
	best = 10.0f;
	
//	thenode = [[nodes objectAtIndex: 0] objectAtIndex: 0];
		
	for (i=0;i<width;i++) {
		for(j=0;j<height;j++) {
			diff = [[[nodes objectAtIndex: i] objectAtIndex: j] difference: inputVector];
			if (diff < best) {
				best = diff;
				thenode = [[nodes objectAtIndex: i] objectAtIndex: j];
			}
		}
	}
			
	return thenode;
		
}

-(SOMNode*) train: (NSMutableArray*) inputVector {
	SOMNode* bmu;
	SOMNode* updateNode;
	SOMNode* thisNode;
	float trad;
	int i, j;
	float infl, dist;
	bmu = [self findBMU: inputVector];
	if (trainCount < trainDuration) {
		trad = mapRadius * expf((float)trainCount/(timeConst*-1.0f));
		for (i=0;i<width;i++) {
			for(j=0;j<height;j++) {
				
				thisNode = [[nodes objectAtIndex: i] objectAtIndex: j];
				
				dist = (float)(pow([bmu x] - [thisNode x], 2) + pow([bmu y] - [thisNode y], 2));
				
				if (dist < (float)pow(trad, 2))
				{
					infl = expf(dist / (powf(trad, 2.0f) * -2.0f));
					updateNode = [[nodes objectAtIndex: i] objectAtIndex: j];
					[updateNode update: inputVector: learningRate: infl];
				}
			}
		}
		
		learningRate = initialLearningRate * exp(trainCount/(trainDuration * -1.0));
		
		trainCount++;
		
	}
	
	return bmu;
}

-(void) dealloc {
	int i, j;
	SOMNode * node;
	NSMutableArray * row;
	
	for (i = 0; i < [nodes count]; i++)
	{
		row = [nodes objectAtIndex: i];
		for (j = 0; j < [row count]; j++)
		{
			node = [[nodes objectAtIndex: i] objectAtIndex: j];
			[node release];
			[node release];
		}
		[row release];
	}
	
	[nodes release];
	
	[super dealloc];
	
}

@end
