//
//  ES1Renderer.h
//  CameraPixel
//
//  Created by sonson on 10/06/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CCESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class CCCameraTexture;

@interface CCES1Renderer : NSObject <CCESRenderer> {
    EAGLContext *context;

    GLint backingWidth;
    GLint backingHeight;

    GLuint defaultFramebuffer, colorRenderbuffer;
	
	CCCameraTexture *cameraTexture;
}

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
