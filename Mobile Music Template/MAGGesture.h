//
//  MAGGesture.h
//  Mobile Music Template
//
//  Created by MillTwo on 7/5/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGSample.h"

@interface MAGGesture : NSObject

@property (strong, nonatomic) NSMutableArray *sampleArray;

@property BOOL hasEnded;

@property float duration;

@property (weak,nonatomic) NSArray *pitchMap;

- (id) initWithFirstSample:(MAGSample *)firstSample andPitchMap:(NSArray *)aPitchMap;

- (NSArray *)addSample:(MAGSample *)newSample;

@end
