//
//  MAGCircle.h
//  Mobile Music Template
//
//  Created by MillTwo on 6/28/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGCircle : NSObject

@property (readonly) CGPoint center;

@property (readonly) NSNumber *radius;

@property (readonly) NSNumber *pitch;

- (id)initWithCenterX:(float)x1 CenterY:(float)y1 Radius:(float)r Pitch:(float)p;

- (id)initWithCenter:(CGPoint)center Radius:(float)r Pitch:(float)p;

- (BOOL)isInCircle:(CGPoint)aPoint;

- (float)distanceFromCircleCenter:(CGPoint)aPoint;

@end
