//
//  MAGCircleArray.h
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGCircleArray : NSObject

- (id)initWithRadius:(float)circleRadius andPitch:(float)startingPitch andShift:(int)shift;

- (NSArray *)giveCircleForCellAt:(int)horizontalCellIndex and:(int)verticalCellIndex;

- (float) giveFreqCoefficientForCircleCenter:(CGPoint)c1 Radius:(float)circleRadius atPoint:(CGPoint)point closestToCircle:(CGPoint)c2;

@property (strong,nonatomic) NSArray *circleArray;

- (float)distanceBetweenPointsP1:(CGPoint)p1 andP2:(CGPoint)p2;

@property (strong,nonatomic) NSArray *pitchMap;

@end
