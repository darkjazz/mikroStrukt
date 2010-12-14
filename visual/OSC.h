//
//  FxOSC.h
//  Fx
//
//  Created by alo on 21/01/2009.
//  Copy_i__t 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "lo/lo.h"
#import "Draw.h"
#import "Patch.h"
#import "SOMNode.h"

id refToOscer;

int alpha_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int clear_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int zoom_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int patch_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);
		
int vector_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data);

int init_handler(const char *path, const char *types, lo_arg **argv, int argc,
				   void *data, void *user_data);

void error(int num, const char *m, const char *path);

int quit_handler(const char *path, const char *types, lo_arg **argv, int argc, 
	void *data, void *user_data);

@interface OSC : NSObject {
	const char * scIP;
	const char * scPort;
	lo_address addr;
	lo_server_thread thread;
	Draw* dw;
	NSMutableArray * weights;
}

- (id) initWithAddress: (const char*) ip: (const char*) port: (Draw*) draw;
- (void) sendMessage: (SOMNode*) bmu;
- (void) startListener;
- (void) stopListener;
- (float) getAlpha;
- (float) getZoom;
- (float) getClear;
- (int) getDone;
- (void) setPatch;

- (bool) getNewVector;
- (bool) initializeSom;
- (void) resetInitialized;
- (int) trainDuration;
- (int) width; 
- (int) height; 
- (float) learningRate;

- (void) initWeights;
- (NSMutableArray*) getWeights;
- (NSString*) currentPatch;

- (void) dealloc;


@end
