//
//  EAGLView.m
//  CameraPixel
//
//  Created by sonson on 10/06/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CCEAGLView.h"

#import "CCES1Renderer.h"

@implementation CCEAGLView

@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initGL {
	// Get the layer
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = TRUE;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	if (!renderer) {
		renderer = [[CCES1Renderer alloc] init];
		if (!renderer) {
			[self release];
			return nil;
		}
	}
	animating = FALSE;
	animationFrameInterval = 1;
	displayLink = nil;
	return self;
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super initWithCoder:coder]) {
		[self initGL];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect {
	if (self = [super initWithFrame:rect]) {
		self = [self initGL];
	}
	return self;
}

- (void)drawView:(id)sender {
    [renderer render];
}

- (void)layoutSubviews {
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval {
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval {
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation {
    if (!animating) {
		displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
		[displayLink setFrameInterval:animationFrameInterval];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		
        animating = TRUE;
    }
}

- (void)stopAnimation {
    if (animating) {
		[displayLink invalidate];
		displayLink = nil;
		
        animating = FALSE;
    }
}

- (void)dealloc {
    [renderer release];
    [super dealloc];
}

@end
