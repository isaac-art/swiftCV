//
//  OpenCVWrapper.m
//  swiftCV
//
//  Created by Isaac Clarke on 07/02/2018.
//

#import <opencv2/core.hpp>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc.hpp>
#import "OpenCVWrapper.h"

using namespace cv;

@implementation OpenCVWrapper

+(NSString *) openCVVersionString
{
    return [NSString stringWithFormat:@"OpenCV Version %s", CV_VERSION];
}

+(UIImage *) makeItGrayScale:(UIImage *)image
{
    Mat inputImage;
    UIImageToMat(image, inputImage);
    if (inputImage.channels() == 1) return image;
    Mat gray;
    cvtColor(inputImage, gray, CV_BGR2GRAY);
    return MatToUIImage(gray);
    
}

+(UIImage *) fillShape:(UIImage *)image
{
    Mat inputImage;
    UIImageToMat(image, inputImage);
   
    Mat gray;
    cvtColor(inputImage, gray, CV_BGR2GRAY);
    
    Mat smallImage;
    cv::resize(gray, smallImage, cv::Size(image.size.width,image.size.height), 0.3f, 0.3f, INTER_AREA);
    
    Mat blurredImage;
    cv::GaussianBlur(smallImage, blurredImage, Size_<double>(5.0, 5.0), 0);
    
    Mat thresholdImage;
    cv::threshold(blurredImage, thresholdImage, 60, 255, THRESH_BINARY_INV);
    
    std::vector<std::vector<cv::Point> > contours;
    std::vector<Vec4i> hierarchy;

    cv::findContours(thresholdImage, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
    
    Mat drawing = Mat::zeros( thresholdImage.size(), CV_8UC3 );
    for( int i = 0; i< contours.size(); i++ )
    {
        Scalar color( rand()&255, rand()&255, rand()&255 );
        drawContours( drawing, contours, i, color, 2, 8, hierarchy, 0, cv::Point() );
    }
    
    Mat outImage;
    cv::resize(drawing, outImage, cv::Size(image.size.width,image.size.height), 0, 0, INTER_LINEAR);
    
    return MatToUIImage(outImage);
}

+(UIImage *) makeThreshold:(UIImage *)image
{
    Mat inputImage;
    UIImageToMat(image, inputImage);
    Mat gray;
    cvtColor(inputImage, gray, CV_BGR2GRAY);
    Mat thresholdImage;
    cv::threshold(gray, thresholdImage, 60, 255, THRESH_BINARY_INV);
    return MatToUIImage(thresholdImage);
}



@end








