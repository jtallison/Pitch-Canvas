//
//  MAGGesture.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/5/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGGesture.h"

@implementation MAGGesture

@synthesize sampleArray = _sampleArray;

@synthesize hasEnded = _hasEnded;

@synthesize duration = _duration;

@synthesize pitchMap = _pitchMap;

//@synthesize audio_channel = _audio_channel;

//-(id)initWithFirstSample:(MAGSample *)firstSample andPitchMap:(NSArray *)aPitchMap andAudioChannel:(int)channelNumber
- (id) initWithFirstSample:(MAGSample *)firstSample andPitchMap:(NSArray *)aPitchMap
{
    self = [super init];
    _sampleArray = [[NSMutableArray alloc] init];
    _hasEnded = FALSE;
    [self.sampleArray addObject:firstSample];
    _pitchMap = aPitchMap;
    //_audio_channel = channelNumber;
    return self;
}

-(NSArray *)addSample:(MAGSample *)newSample
{
    if (!self.hasEnded)
    {
        if (newSample.wasFirstSample)
        {
            NSLog(@"error: first sample in gesture passed to [gesture addSample]");
        }
        if(newSample.wasLastSample)
        {
            self.hasEnded = TRUE;
            MAGSample *firstSample = self.sampleArray[0];
            self.duration = [newSample.time timeIntervalSinceDate:firstSample.time];
            //NSLog(@"length of gesture: %i samples",self.sampleArray.count);
            //NSLog(@"duration of gesture: %f seconds",self.duration);
            //return an array with zero for the gain
            return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithFloat:0.0], nil];
        }
        //get the current time, calculate the change in time from the
        //last sample
        MAGSample *formerSample = self.sampleArray.lastObject;
        NSTimeInterval dt = [newSample.time timeIntervalSinceDate:formerSample.time];
        
        //calculate the change in position from the last sample
        double dp = sqrt(pow(newSample.location.x-formerSample.location.x,2)+pow(newSample.location.y-formerSample.location.y,2));
        
        //calculate the speed, map it to the gain
        float gain = dp/dt;
        gain = gain/1000.0;
        if(gain > 0.125){gain = 0.125;}
        
        //update formerTime and formerLocation
        [self.sampleArray addObject:newSample];
        
        //return the pitch and gain(speed) information.
        //will be sent to Pd
        NSArray *pitchMapRow = self.pitchMap[(int) newSample.location.x];
        return [[NSArray alloc] initWithObjects:pitchMapRow[(int) newSample.location.y],[NSNumber numberWithFloat:gain],[NSNumber numberWithFloat:newSample.location.x/768.0],nil];
    }
    //NSLog(@"error: sample passed to a gesture that has ended");
    return [[NSArray alloc] init];
}

@end
