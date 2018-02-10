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
#include <cmath>
#include <iostream>
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



//Adapted From: https://github.com/marcoss/opencv-face-detection-swift/

+(UIImage *) detectFaces: (UIImage *) image {
    // Convert UIImage to CV Mat
    cv::Mat colorMat;
    UIImageToMat(image, colorMat);
    
    Mat smallImage;
    cv::resize(colorMat, smallImage, cv::Size(image.size.width,image.size.height), 0.3f, 0.3f, INTER_AREA);
    
    Mat blurredImage;
    cv::GaussianBlur(smallImage, blurredImage, Size_<double>(5.0, 5.0), 0);

    // Convert to grayscale
    cv::Mat grayMat;
    cv::cvtColor(blurredImage, grayMat, CV_BGR2GRAY);
    
    // Load classifier from file
    cv::CascadeClassifier classifier;
    const NSString* cascadePath = [[NSBundle mainBundle]
                                   pathForResource:@"haarcascade_frontalface_default"
                                   ofType:@"xml"];
    classifier.load([cascadePath UTF8String]);
    
    // Initialize vars for classifier
    std::vector<cv::Rect> detections;
    
    const double scalingFactor = 1.1;
    const int minNeighbors = 2;
    const int flags = 0;
    const cv::Size minimumSize(80, 80);
    
    // Classify function
    classifier.detectMultiScale(
                                grayMat,
                                detections,
                                scalingFactor,
                                minNeighbors,
                                flags,
                                minimumSize
                                );
    
    // If no detections found, return nil
    if (detections.size() <= 0) {
        return nil;
    }
    
    // Range loop through detections
    for (auto &face : detections) {
        const cv::Point tl(face.x,face.y);
        const cv::Point br = tl + cv::Point(face.width, face.height);
        const cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(colorMat, tl, br, magenta, 4, 8, 0);
    }
    
    Mat outImage;
    cv::resize(colorMat, outImage, cv::Size(image.size.width,image.size.height), 0, 0, INTER_LINEAR);
    
    return MatToUIImage(outImage);
}

+(UIImage *) detectShapes: (UIImage *) image {
    
    Mat inputImage;
    UIImageToMat(image, inputImage);
    Mat gray;
    cvtColor(inputImage, gray, CV_BGR2GRAY);
    Mat smallImage;
    cv::resize(gray, smallImage, cv::Size(image.size.width,image.size.height), 0.5f, 0.5f, INTER_AREA);
    Mat blurredImage;
    cv::GaussianBlur(smallImage, blurredImage, Size_<double>(5.0, 5.0), 0);
    Mat thresholdImage;
    cv::threshold(blurredImage, thresholdImage, 60, 255, THRESH_BINARY_INV);
    
    std::vector<std::vector<cv::Point> > contours;
    cv::findContours(thresholdImage, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    std::vector<cv::Point> approx;
    Mat output;
    
    int fontface = cv::FONT_HERSHEY_SIMPLEX;
    double scale = 0.4;
    int thickness = 1;
    int baseline = 0;
    
    for (int i = 0; i < contours.size(); i++)
    {
        cv::approxPolyDP(cv::Mat(contours[i]), approx, cv::arcLength(cv::Mat(contours[i]), true)*0.02, true);
        if (std::fabs(cv::contourArea(contours[i])) < 100 || !cv::isContourConvex(approx))
            continue;
        
        if (approx.size() == 3)
        {
            // Triangles
            String shape = "triangle";
        }
        else if (approx.size() >= 4 && approx.size() <= 6)
        {
            // Number of vertices of polygonal curve
            int vtc = approx.size();
            // Get the cosines of all corners
            std::vector<double> cos;
            for (int j = 2; j < vtc+1; j++){
                
                double dx1 = approx[j%vtc].x - approx[j-1].x;
                double dy1 = approx[j%vtc].y - approx[j-1].y;
                double dx2 = approx[j-2].x - approx[j-1].x;
                double dy2 = approx[j-2].y - approx[j-1].y;
                double result =(dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
                cos.push_back(result);
            }
            // Sort ascending the cosine values
            std::sort(cos.begin(), cos.end());
            // Get the lowest and the highest cosine
            double mincos = cos.front();
            double maxcos = cos.back();
            // Use the degrees obtained above and the number of vertices
            // to determine the shape of the contour
            if (vtc == 4 && mincos >= -0.1 && maxcos <= 0.3)
                //rect
                String shape = "rect";
            else if (vtc == 5 && mincos >= -0.34 && maxcos <= -0.27)
                //penta
                String shape = "penta";
            else if (vtc == 6 && mincos >= -0.55 && maxcos <= -0.45)
                //hexa
                String shape = "hexa";
        }
        else
        {
            // Detect and label circles
            double area = cv::contourArea(contours[i]);
            cv::Rect r = cv::boundingRect(contours[i]);
            int radius = r.width / 2;
            
            if (std::abs(1 - ((double)r.width / r.height)) <= 0.2 &&
                std::abs(1 - (area / (CV_PI * std::pow(radius, 2)))) <= 0.2)
                //circle
                String shape = "circle";
        }
    }
    Mat outImage;
    cv::resize(output, outImage, cv::Size(image.size.width,image.size.height), 0, 0, INTER_LINEAR);
    return MatToUIImage(outImage);
}


+(UIImage *) detectCircles: (UIImage *)image{
    Mat inputImage;
    UIImageToMat(image, inputImage);
    Mat gray;
    cvtColor(inputImage, gray, CV_BGR2GRAY);
    //Mat blurredImage;
    //cv::GaussianBlur(gray, blurredImage, Size_<double>(5.0, 5.0), 0);
    //Mat thresholdImage;
    //cv::threshold(blurredImage, thresholdImage, 60, 255, THRESH_BINARY_INV);
    std::vector<Vec3f> circles;
    HoughCircles(gray, circles, HOUGH_GRADIENT, 1,
                 gray.rows/16,  // change this value to detect circles with different distances to each other
                 100, 30, 5, 100 // change the last two parameters
    // (min_radius & max_radius) to detect larger circles
    );
    for( size_t i = 0; i < circles.size(); i++ )
    {
        Vec3i c = circles[i];
        cv::Point center = cv::Point(c[0], c[1]);
        // circle center
        cv::circle( inputImage, center, 1, Scalar(0,100,100), 3, LINE_AA);
        // circle outline
        int radius = c[2];
        cv::circle( inputImage, center, radius, Scalar(255,0,255), 3, LINE_AA);
    }

    return MatToUIImage(inputImage);
}


@end








