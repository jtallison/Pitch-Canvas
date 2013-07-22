//
//  MAGSample.h
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGSample : NSObject

- (id)initWithLocation:(CGPoint)sampleLocation andTime:(NSDate *)sampleTime andFirstSample:(BOOL)wasFirstSample andLastSample:(BOOL)wasLastSample;

- (float)distanceFromSample:(CGPoint)aPoint;

@property (strong,nonatomic) NSDate *time;

@property CGPoint location;

@property BOOL wasFirstSample;

@property BOOL wasLastSample;

@end
