//
//  PatchDictionary.h
//  som
//
//  Created by alo on 24/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PatchDictionary : NSObject {
	NSMutableDictionary * patches;
}

- (PatchDictionary*) init;

- (NSMutableDictionary*) patches;

- (NSString*) toBinaryString : (int) number: (int) size;

- (void) dealloc;

@end
