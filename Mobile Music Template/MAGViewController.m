//
//  MAGViewController.m
//  Mobile Music Template
//
//  Created by Jesse Allison on 10/17/12.
//  Copyright (c) 2012 MAG. All rights reserved.
//

#import "MAGViewController.h"
#import "MAGCircle.h"
#import "MAGCircleArray.h"
#import "MAGBackground.h"
#import "CoreGraphics/CoreGraphics.h"
#import "MAGSample.h"
#import "MAGSampleHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface MAGViewController ()

- (void)newSample:(CGPoint)newLocation;

- (void)initializeAttributes;

//void triangle_tilde_setup();

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet MAGBackground *theBackground;

@property (strong, nonatomic) MAGSampleHandler *sampleHandler;

@property (weak, nonatomic) UIImage *backgroundImage;

@property (strong, nonatomic) MAGCircleArray *circles;

@property (strong,nonatomic) NSMutableArray *liveGestureIndeces;

@property CFMutableArrayRef liveTouches;

@property BOOL isChannel1Open;

@property BOOL isChannel2Open;

@property BOOL isChannel3Open;

@property BOOL isChannel4Open;

@property BOOL isChannel5Open;

@property BOOL isChannel6Open;

@property BOOL isChannel7Open;

@property BOOL isChannel8Open;

@end


@implementation MAGViewController

@synthesize baseKey =_baseKey;
@synthesize shift = _shift;
@synthesize circleSize = _circleSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // _________________ LOAD Pd Patch ____________________
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    //triangle_tilde_setup();
    patch = [PdBase openFile:@"mag_template.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    NSLog(@"loading view");
    self.isChannel1Open = TRUE;
    self.isChannel2Open = TRUE;
    self.isChannel3Open = TRUE;
    self.isChannel4Open = TRUE;
    self.isChannel5Open = TRUE;
    self.isChannel6Open = TRUE;
    self.isChannel7Open = TRUE;
    self.isChannel8Open = TRUE;
    
    [self initializeAttributes];
    NSLog(@"exiting viewDidLoad");
}

/*
- (void)viewDidUnload
{
    // uncomment for pre-iOS 6 deployment
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// _________________ UI Interactions with Pd Patch ____________________

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    //nothing currently happening here
}

- (void)initializeAttributes
{
    self.circles = [[MAGCircleArray alloc] initWithRadius:self.circleSize andPitch:self.baseKey andShift:self.shift];
    //NSLog(@"self.circles loaded");
    self.sampleHandler = [[MAGSampleHandler alloc] initEmptyArrayWithCircles:self.circles];
    //NSLog(@"self.sampleHandler loaded");
    self.theBackground.circles = self.circles;
    self.theBackground.allGestures = self.sampleHandler.gestureArray;
    [self.theBackground setNeedsDisplay];
    self.liveTouches = CFArrayCreateMutable(NULL, 8, &kCFTypeArrayCallBacks);
    self.liveGestureIndeces = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1], nil];
    self.theBackground.liveGestureIndeces = self.liveGestureIndeces;
    NSLog(@"initialization complete");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for each new gesture:
        //for each of the audio channels:
            //if it is open, create a new gesture and close the channel. store the gesture index.
            //stop checking for an audio channel for this gesture
    
    if ([touches count] > 0)
    {
        for (UITouch *touch in touches)
        {
            if (touch.phase == UITouchPhaseBegan)
            {
                if (self.isChannel1Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 0, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq1"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain1"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev1"];
                    self.isChannel1Open = FALSE;
                    //NSLog(@"added gesture to channel 1.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel2Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 1, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq2"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain2"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev2"];
                    //NSLog(@"freq2: %f, gain2: %f",[pitchAndGainAndIndex[0] floatValue],[pitchAndGainAndIndex[1] floatValue]);
                    self.isChannel2Open = FALSE;
                    //NSLog(@"adding a gesture in channel 2.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel3Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 2, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq3"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain3"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev3"];
                    self.isChannel3Open = FALSE;
                    //NSLog(@"adding a gesture in channel 3.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel4Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 3, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq4"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain4"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev4"];
                    self.isChannel4Open = FALSE;
                    //NSLog(@"adding a gesture in channel 4.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel5Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 4, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq5"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain5"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev5"];
                    self.isChannel5Open = FALSE;
                    //NSLog(@"adding a gesture in channel 5.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel6Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 5, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq6"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain6"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev6"];
                    self.isChannel6Open = FALSE;
                    //NSLog(@"adding a gesture in channel 6.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel7Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 6, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:6 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq7"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain7"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev7"];
                    self.isChannel7Open = FALSE;
                    //NSLog(@"adding a gesture in channel 7.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else if (self.isChannel8Open)
                {
                    CFArraySetValueAtIndex(self.liveTouches, 7, (__bridge const void *)(touch));
                    
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:TRUE
                                                                 andLastSample:FALSE];
                    NSArray *audioAndIndex = [self.sampleHandler handleFirstSample:newSample];
                    int newGestureIndex = [[audioAndIndex lastObject] intValue];
                    [self.liveGestureIndeces replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:newGestureIndex]];
                    
                    [PdBase sendFloat:[audioAndIndex[0] floatValue] toReceiver:@"freq8"];
                    [PdBase sendFloat:[audioAndIndex[1] floatValue] toReceiver:@"gain8"];
                    [PdBase sendFloat:[audioAndIndex[2] floatValue] toReceiver:@"rev8"];
                    self.isChannel8Open = FALSE;
                    //NSLog(@"adding a gesture in channel 8.  gesture index: %i",newGestureIndex);
                    //NSLog(@"liveGestureIndeces: = [%i,%i,%i,%i,%i,%i,%i,%i]",[self.liveGestureIndeces[0] intValue],[self.liveGestureIndeces[1] intValue],[self.liveGestureIndeces[2] intValue],[self.liveGestureIndeces[3] intValue],[self.liveGestureIndeces[4] intValue],[self.liveGestureIndeces[5] intValue],[self.liveGestureIndeces[6] intValue],[self.liveGestureIndeces[7] intValue]);
                }
                else
                {
                    NSLog(@"all channels full, could not add gesture");
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for each gesture that has an audio channel:
        //add a new sample to the gesture
    
    if ([touches count] > 0)
    {
        for (UITouch *touch in touches)
        {
            if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 0)])
            {
                //NSLog(@"moving touch is in channel 1");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[0] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq1"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain1"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev1"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 1)])
            {
                //NSLog(@"moving touch is in channel 2");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[1] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq2"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain2"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev2"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 2)])
            {
                //NSLog(@"moving touch is in channel 3");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[2] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq3"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain3"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev3"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 3)])
            {
                //NSLog(@"moving touch is in channel 4");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[3] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq4"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain4"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev4"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 4)])
            {
                //NSLog(@"moving touch is in channel 5");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[4] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq5"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain5"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev5"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 5)])
            {
                //NSLog(@"moving touch is in channel 6");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[5] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq6"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain6"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev6"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 6)])
            {
                //NSLog(@"moving touch is in channel 7");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[6] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq7"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain7"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev7"];
                    }
                }
            }
            else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 7)])
            {
                //NSLog(@"moving touch is in channel 8");
                CGPoint location = [touch locationInView:touch.view];
                //if it's on the relevant portion of the screen:
                if ((location.x>0)&&(location.y>0))
                {
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:location
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:FALSE];
                    //find the pitch and the gain while sending the sample to self.sampleHandler (which will add the sample to the relevant gesture)
                    NSArray *audioArray = [self.sampleHandler handleSample:newSample
                                                                   inGesture:[self.liveGestureIndeces[7] intValue]];
                    if (audioArray.count > 0)
                    {
                        [PdBase sendFloat:[audioArray[0] floatValue] toReceiver:@"freq8"];
                        [PdBase sendFloat:[audioArray[1] floatValue] toReceiver:@"gain8"];
                        [PdBase sendFloat:[audioArray[2] floatValue] toReceiver:@"rev8"];
                    }
                }
            }
        }
    }
    /*
    UIGraphicsBeginImageContext(self.theBackground.bounds.size);
    [self.theBackground.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.theBackground.backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.theBackground setNeedsDisplay];
     */
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for each touch that has an audio channel:
        //if the current touch has ended, add the last sample, set the channel's gain to zero, and announce that the channel is open.
    
    if ([touches count] > 0)
    {
        for (UITouch *touch in touches)
        {
            if (touch.phase == UITouchPhaseEnded)
            {
                if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 0)])
                {
                    //NSLog(@"closing touch is in channel 1");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[0] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain1"];
                    self.isChannel1Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 1)])
                {
                    //NSLog(@"closing touch is in channel 2");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[1] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain2"];
                    self.isChannel2Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 2)])
                {
                    //NSLog(@"closing touch is in channel 3");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[2] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain3"];
                    self.isChannel3Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 3)])
                {
                    //NSLog(@"closing touch is in channel 4");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[3] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain4"];
                    self.isChannel4Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 4)])
                {
                    //NSLog(@"closing touch is in channel 5");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[4] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain5"];
                    self.isChannel5Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 5)])
                {
                    //NSLog(@"closing touch is in channel 6");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[5] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain6"];
                    self.isChannel6Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 6)])
                {
                    //NSLog(@"closing touch is in channel 7");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[6] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain7"];
                    self.isChannel7Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 7)])
                {
                    //NSLog(@"closing touch is in channel 8");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[7] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain8"];
                    self.isChannel8Open = TRUE;
                }
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for each touch that has an audio channel:
    //if the current touch has ended, add the last sample, set the channel's gain to zero, and announce that the channel is open.
    
    if ([touches count] > 0)
    {
        for (UITouch *touch in touches)
        {
            if (touch.phase == UITouchPhaseCancelled)
            {
                if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 0)])
                {
                    //NSLog(@"closing touch is in channel 1");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[0] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain1"];
                    self.isChannel1Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 1)])
                {
                    //NSLog(@"closing touch is in channel 2");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[1] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain2"];
                    self.isChannel2Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 2)])
                {
                    //NSLog(@"closing touch is in channel 3");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[2] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain3"];
                    self.isChannel3Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 3)])
                {
                    //NSLog(@"closing touch is in channel 4");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[3] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain4"];
                    self.isChannel4Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 4)])
                {
                    //NSLog(@"closing touch is in channel 5");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[4] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain5"];
                    self.isChannel5Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 5)])
                {
                    //NSLog(@"closing touch is in channel 6");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[5] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain6"];
                    self.isChannel6Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 6)])
                {
                    //NSLog(@"closing touch is in channel 7");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[6] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain7"];
                    self.isChannel7Open = TRUE;
                }
                else if ([touch isEqual:CFArrayGetValueAtIndex(self.liveTouches, 7)])
                {
                    //NSLog(@"closing touch is in channel 8");
                    MAGSample *newSample = [[MAGSample alloc] initWithLocation:[touch locationInView:touch.view]
                                                                       andTime:[[NSDate alloc] init]
                                                                andFirstSample:FALSE
                                                                 andLastSample:TRUE];
                    [self.sampleHandler handleSample:newSample inGesture:[self.liveGestureIndeces[7] intValue]];
                    [PdBase sendFloat:0.0 toReceiver:@"gain8"];
                    self.isChannel8Open = TRUE;
                }
            }
        }
    }
}

- (void)viewDidUnload {
    //[self setImageView:nil];
    [self setTheBackground:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

@end
