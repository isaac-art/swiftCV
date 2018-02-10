//
//  OpenCVWrapper.h
//  swiftCV
//
//  Created by Isaac Clarke on 07/02/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+(NSString *) openCVVersionString;

+(UIImage *) makeItGrayScale:(UIImage *)image;

+(UIImage *) fillShape:(UIImage *)image;

+(UIImage *) makeThreshold:(UIImage *)image;

@end


