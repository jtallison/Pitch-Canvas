//
//  MAGSampleHandler.h
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGSample.h"
#import "MAGCircleArray.h"

@interface MAGSampleHandler : NSObject

- (id)initEmptyArrayWithCircles:(MAGCircleArray *)someCircles;

//- (int)handleFirstSample:(MAGSample *)firstSample withAudioChannel:(int)channelNumber;

- (NSArray *)handleFirstSample:(MAGSample *)firstSample;

- (NSArray *)handleSample:(MAGSample *)newSample inGesture:(int) gestureIndex;

@property (strong, nonatomic) NSMutableArray *gestureArray;

@property (weak, nonatomic) MAGCircleArray *circles;

@end
