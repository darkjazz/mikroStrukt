//
//  Patch.m
//  Fx
//
//  Created by tehis on 28/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Patch.h"


@implementation Patch

-(NSString*) name { return name; }
-(int) hits { return hits; }
-(NSMutableDictionary*) nodes { return nodes; }

-(Patch*) init: (NSString*) argName {
	name = argName;
	hits = 0;
	nodes = [NSMutableDictionary new];
	return self;
}

-(void) incrementHits { hits += 1; }

-(void) incrementHitsForKey: (id)aKey {
	[self incrementHits];
	if ([nodes objectForKey:aKey])
	{
		[nodes setObject: [NSNumber numberWithInt: [[nodes objectForKey: aKey] intValue] + 1] forKey: aKey];
	}
	else
	{
		[nodes setObject: [NSNumber numberWithInt: 1] forKey: aKey];
	}
}

-(void) dealloc
{
	for (id key in nodes)
	{
		[[nodes objectForKey:key] release];
	}
	
	[nodes release];
	
	[super dealloc];
}

@end
