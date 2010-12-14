//
//  Patch.h
//  Fx
//
//  Created by tehis on 28/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Patch : NSObject {
	NSString* name;
	int hits;
	NSMutableDictionary * nodes;
}

-(Patch*) init: (NSString*) argName;
-(NSString*) name;
-(int) hits;
-(NSMutableDictionary*) nodes;

-(void) incrementHits;
-(void) incrementHitsForKey: (id)aKey;

-(void) dealloc;

@end
