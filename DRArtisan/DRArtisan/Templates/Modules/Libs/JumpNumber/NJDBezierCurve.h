//
//  NJDBezierCurve.h
//  DataStream
//
//  Created by Jason on 4/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  二维坐标点结构
 */
typedef struct{
    float x;
    float y;
} Point2D;

@interface NJDBezierCurve : NSObject

Point2D PointOnCubicBezier(Point2D* cp, float t);

@end
