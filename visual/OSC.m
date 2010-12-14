//
//  FxOSC.m
//  Fx
//
//  Created by alo on 21/01/2009.
//  Copy_i__t 2009
//

#import "OSC.h"

int done = 0;

float alpha = 1.0f;
float zoom = -40.0f;
float clear = 0.0f;

int cmd = 0;
float value = 0.0f;

float vector[6];
bool newvector = false;

bool initialized = false;

int trainDur = 1000;
int sizex = 40;
int sizey = 40;
float learningrate = 0.1f;

int patch[] = {0,0,0,0,0};

@implementation OSC

- (id) initWithAddress: (const char*) ip: (const char*) port: (Draw*) draw;
{
	self = [super init];
	scIP = ip;
	scPort = port;
	addr = lo_address_new(scIP, scPort);
	dw = draw;
	done = 0;
	[self initWeights];
	return self;
}

- (void) initWeights {
	int i;
	weights = [NSMutableArray new];
	for (i=0;i<6;i++)
	{
		[weights addObject: [NSNumber numberWithFloat: 0.0f]];
	}
}

- (float) getAlpha { return alpha; }
- (float) getZoom { return zoom; }
- (float) getClear { return clear; }
- (int) getDone { return done; }

- (bool) getNewVector { return newvector; }

- (bool) initializeSom {  return initialized; }
- (void) resetInitialized { initialized = false; }

- (int) trainDuration { return trainDur; }
- (int) width { return sizex; }
- (int) height { return sizey; }
- (float) learningRate { return learningrate; }

- (NSString*) currentPatch { 
	NSMutableString * string;
	int i;
	string = [NSMutableString stringWithCapacity: 5];
	for (i=0;i<5;i++)
	{
		[string appendString: [NSString stringWithFormat:@"%d", patch[i]]];
	}
	return (NSString*)string; 
}

- (NSMutableArray*) getWeights
{
	int i;
	for (i=0;i<6;i++)
		[weights replaceObjectAtIndex: i withObject: [NSNumber numberWithFloat: vector[i]]];
	newvector = false;
	return weights;
}


- (void) sendMessage: (SOMNode*) bmu
{
	int x, y;
	float w1, w2, w3, w4, w5, w6;
	x = [bmu x];
	y = [bmu y];
	w1 = [[[bmu weights] objectAtIndex: 0] floatValue ];
	w2 = [[[bmu weights] objectAtIndex: 1] floatValue ];
	w3 = [[[bmu weights] objectAtIndex: 2] floatValue ]; 
	w4 = [[[bmu weights] objectAtIndex: 3] floatValue ]; 
	w5 = [[[bmu weights] objectAtIndex: 4] floatValue ]; 
	w6 = [[[bmu weights] objectAtIndex: 5] floatValue ];
	lo_send(addr, "/som/bmu", "iiffffff", x, y, w1, w2, w3, w4, w5, w6);
}

- (void) startListener
{
	thread = lo_server_thread_new("7770", error);
	lo_server_thread_add_method(thread, "/som/fade", "f", alpha_handler, NULL);
	lo_server_thread_add_method(thread, "/som/zoom", "f", zoom_handler, NULL);
	lo_server_thread_add_method(thread, "/som/clear", "f", clear_handler, NULL);
	lo_server_thread_add_method(thread, "/som/patch", "iiiii", patch_handler, NULL);
	lo_server_thread_add_method(thread, "/som/vector", "ffffff", vector_handler, NULL);
	lo_server_thread_add_method(thread, "/som/init", "iiif", init_handler, NULL);

	lo_server_thread_add_method(thread, "/som/quit", "i", quit_handler, NULL);
	
	lo_server_thread_start(thread);
	
}

- (void) stopListener
{
	lo_server_thread_free(thread);
}

- (void) setPatch
{

}

- (void) dealloc {
	int i;
	for (i=0;i<[weights count];i++)
	{
		[[weights objectAtIndex: i] release];
	}
	
	[super dealloc];
}

@end


int alpha_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	alpha = argv[0]->f;
	return 0;
}

int zoom_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	zoom = argv[0]->f;
	return 0;
}

int clear_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	clear = argv[0]->f;
	return 0;
}

int patch_handler(const char *path, const char *types, lo_arg **argv, int argc,
				  void *data, void *user_data)
{
	int i;
	for (i=0;i<5;i++)
		patch[i] = argv[i]->i;
	return 0;
}


int vector_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	int i;
	
	for (i=0;i<6;i++)
		vector[i] = argv[i]->f;
	
	newvector = true;
	
	return 0;
}

int init_handler(const char *path, const char *types, lo_arg **argv, int argc,
				   void *data, void *user_data)
{
	
	trainDur = argv[0]->i;
	sizex = argv[1]->i;
	sizey = argv[2]->i;
	learningrate = argv[3]->f;
	
	initialized = true;
	
	return 0;
}



int quit_handler(const char *path, const char *types, lo_arg **argv, int argc, 
	void *data, void *user_data)
{
	done = 1;
	return 0;
}

void error (int num, const char *msg, const char *path)
{
	printf("liblo server %d error in path %s: %s\n", num, path, msg);
	fflush(stdout);
}

