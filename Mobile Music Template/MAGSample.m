//
//  MAGSample.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGSample.h"

@implementation MAGSample

@synthesize location = _location;
@synthesize time = _time;
@synthesize wasFirstSample = _wasFirstSample;
@synthesize wasLastSample = _wasLastSample;

- (id)initWithLocation:(CGPoint)sampleLocation andTime:(NSDate *)sampleTime andFirstSample:(BOOL)wasFirstSample andLastSample:(BOOL)wasLastSample
{
    self = [super init];
    
    if(self)
    {
        _location = CGPointMake(sampleLocation.x,sampleLocation.y);
        _time = sampleTime.copy;
        _wasFirstSample = wasFirstSample;
        _wasLastSample = wasLastSample;
    }
    return self;
}

- (float)distanceFromSample:(CGPoint)aPoint
{
    return sqrt( pow(self.location.x-aPoint.x,2) + pow(self.location.y-aPoint.y,2) );
}

@end
