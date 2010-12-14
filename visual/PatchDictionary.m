//
//  PatchDictionary.m
//  som
//
//  Created by alo on 24/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PatchDictionary.h"


@implementation PatchDictionary

- (NSMutableDictionary*) patches { return patches; }

-(PatchDictionary*) init {
	int i;
	NSString* key;

	patches = [NSMutableDictionary new];
	
	for (i = 0; i < 32; i++)
	{
		key = [self toBinaryString: i : 5];
		[patches setObject: [NSMutableDictionary new] forKey: key];
	}
	
	return self;
}

- (NSString*) toBinaryString : (int) number: (int) size {
	int i, val;
	NSMutableString* binary;
	
	binary = [NSMutableString stringWithCapacity: size];
	
	for (i = size - 1; i >= 0; i--)
	{
		val = (number >> i & 1);
		[binary appendString: [NSString stringWithFormat:@"%d", val]];
		
	}
	
	return (NSString*)binary;
}

- (void) dealloc {
	
	for (id key in patches)
	{
		[[patches objectForKey:key] release];
	}
	
	[super dealloc];
	
}

@end
