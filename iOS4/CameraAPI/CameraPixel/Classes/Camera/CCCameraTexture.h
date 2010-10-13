//
//  CameraTexture.h
//  CameraPixel
//
//  Created by sonson on 10/06/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCameraController.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface CCCameraTexture : CCCameraController {
	GLuint	textureHandle;
}
@property (nonatomic, readonly) GLuint textureHandle;
@end
