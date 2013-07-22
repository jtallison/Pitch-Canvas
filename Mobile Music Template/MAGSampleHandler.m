//
//  MAGSampleHandler.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGSampleHandler.h"
#import "MAGSample.h"
#import "MAGGesture.h"

//import the file with the giveFreqForPoint method.
//should be same file that stores the array of circles
#import "MAGBackground.h"

@implementation MAGSampleHandler

@synthesize circles = _circles;

@synthesize gestureArray = _gestureArray;

- (id)initEmptyArrayWithCircles:(MAGCircleArray *)someCircles
{
    self = [super init];
    self.gestureArray = [[NSMutableArray alloc] init];
    self.circles = someCircles;
    return self;
}

//- (int)handleFirstSample:(MAGSample *)firstSample withAudioChannel:(int)channelNumber
- (NSArray *)handleFirstSample:(MAGSample *)firstSample
{
    //ensure that the sample it recieved was a first sample
    if(firstSample.wasFirstSample)
    {
        //create a new gesture, and add it to the end of self.gesture array
        [self.gestureArray addObject:[[MAGGesture alloc] initWithFirstSample:firstSample andPitchMap:self.circles.pitchMap]];
        //record the current gesture index
        int currentGestureIndex = self.gestureArray.count-1;
        
        //grab the audio information for the first sample
        NSArray *pitchMapRow = self.circles.pitchMap[(int) firstSample.location.x];
        float currentPitch = [pitchMapRow[(int) firstSample.location.y] floatValue];
        
        //tell view controller what index the new gesture is, and provide audio information
        return [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:currentPitch],[NSNumber numberWithFloat:0.01],[NSNumber numberWithInt:currentGestureIndex], nil];
    }
    else
    {
        NSLog(@"error: sample that was not first sample passed to handleSample:firstSample");
    }
    return [[NSArray alloc] init];
}


- (NSArray *)handleSample:(MAGSample *)newSample inGesture:(int) gestureIndex
{
    if(newSample.wasFirstSample)
    {
        NSLog(@"error: firstSample passed to handleSample:fromGestureThatStartedAt:");
    }
    
    //else:
    //add newSample to the relevant gesture
    //return audio information array for that gesture
    return [self.gestureArray[gestureIndex] addSample:newSample];
}

@end
