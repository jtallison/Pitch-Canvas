//
//  MAGCircle.m
//  Mobile Music Template
//
//  Created by MillTwo on 6/28/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGCircle.h"

@implementation MAGCircle

@synthesize center =_center;
@synthesize radius = _radius;
@synthesize pitch = _pitch;

- (id)initWithCenterX:(float)x1 CenterY:(float)y1 Radius:(float)r Pitch:(float)p
{
    self = [super init];
    
    if(self)
    {
        _center = CGPointMake(x1,y1);
        _radius = [NSNumber numberWithFloat:r];
        _pitch = [NSNumber numberWithFloat:p];
    }
    return self;
}

- (id)initWithCenter:(CGPoint)center Radius:(float)r Pitch:(float)p
{
    self = [super init];
    
    if(self)
    {
        _center = center;
        _radius = [NSNumber numberWithFloat:r];
        _pitch = [NSNumber numberWithFloat:p];
    }
    return self;
}

- (BOOL)isInCircle:(CGPoint)aPoint
{
    //checks to see if a point is within the circle (self)
    if([self distanceFromCircleCenter:aPoint] < [self.radius floatValue])
    {
        return TRUE;
    }
    return FALSE;
}

- (float)distanceFromCircleCenter:(CGPoint)aPoint
{
    return sqrt( pow(self.center.x-aPoint.x,2) + pow(self.center.y-aPoint.y,2) );
}

@end
