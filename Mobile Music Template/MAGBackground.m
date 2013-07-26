//
//  MAGBackground.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/2/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGBackground.h"
#import "MAGCircle.h"
#import "MAGCircleArray.h"
#import "MAGGesture.h"
#import "MAGSample.h"
#import <QuartzCore/QuartzCore.h>

@implementation MAGBackground

@synthesize circles = _circles;

@synthesize allGestures = _allGestures;

@synthesize liveGestureIndeces = _liveGestureIndeces;

@synthesize backgroundImage =_backgroundImage;

-(void)awakeFromNib
{
    // self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    //iterates through the circles, drawing each one
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.backgroundImage == NULL)
    {
        NSLog(@"background image was null");
        for (int counter = 0; counter < self.circles.circleArray.count; counter = counter + 1)
        {
            NSArray *currentColumn = self.circles.circleArray[counter];
            for (int counter2 = 0; counter2 < currentColumn.count; counter2 = counter2 + 1) {
                MAGCircle *aCircle = currentColumn[counter2];
                NSString *currentNoteName = [NSString stringWithFormat:@"Z#"];
                if (aCircle.pitch.intValue%12 == 0) {CGContextSetRGBFillColor(context, 0.8, 0.0, 0.0, 0.1); currentNoteName = @"C";}
                else if (aCircle.pitch.intValue%12 == 1) {CGContextSetRGBFillColor(context, 1.0, 0.25, 0.0, 0.1); currentNoteName = @"C#";}
                else if (aCircle.pitch.intValue%12 == 2) {CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 0.1); currentNoteName = @"D";}
                else if (aCircle.pitch.intValue%12 == 3) {CGContextSetRGBFillColor(context, 1.0, 0.75, 0.0, 0.1); currentNoteName = @"D#";}
                else if (aCircle.pitch.intValue%12 == 4) {CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 0.1); currentNoteName = @"E";}
                else if (aCircle.pitch.intValue%12 == 5) {CGContextSetRGBFillColor(context, 0.5, 1.0, 0.0, 0.1); currentNoteName = @"F";}
                else if (aCircle.pitch.intValue%12 == 6) {CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.1); currentNoteName = @"F#";}
                else if (aCircle.pitch.intValue%12 == 7) {CGContextSetRGBFillColor(context, 0.0, 1.0, 0.5, 0.1); currentNoteName = @"G";}
                else if (aCircle.pitch.intValue%12 == 8) {CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 0.1); currentNoteName = @"G#";}
                else if (aCircle.pitch.intValue%12 == 9) {CGContextSetRGBFillColor(context, 0.0, 0.5, 1.0, 0.1); currentNoteName = @"A";}
                else if (aCircle.pitch.intValue%12 == 10) {CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.1); currentNoteName = @"A#";}
                else if (aCircle.pitch.intValue%12 == 11) {CGContextSetRGBFillColor(context, 0.5, 0.0, 0.9, 0.1); currentNoteName = @"B";}
                else {NSLog(@"%i",aCircle.pitch.intValue%12);}
                
                CGPoint rectOrigin = CGPointMake(aCircle.center.x-aCircle.radius.floatValue,aCircle.center.y-aCircle.radius.floatValue);
                
                CGRect newRect = CGRectMake(rectOrigin.x,rectOrigin.y,aCircle.radius.floatValue*2.0,aCircle.radius.floatValue*2.0);
                
                CGContextAddEllipseInRect(context,newRect);
                
                //CGContextStrokePath(context);
                
                CGContextFillPath(context);
                
                UILabel *noteLabel = [[UILabel alloc] initWithFrame:newRect];
                noteLabel.text = currentNoteName;
                noteLabel.textColor = [[UIColor alloc] initWithWhite:0.5 alpha:1.0];
                [noteLabel drawTextInRect:CGRectMake(aCircle.center.x - 4.0, aCircle.center.y-aCircle.radius.floatValue,aCircle.radius.floatValue*2.0,aCircle.radius.floatValue*2.0)];
            }
        }
    }
        /*
        MAGCircle *aCircle = self.circles[counter];
         UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:aCircle.center radius:aCircle.radius.floatValue startAngle:0.0 endAngle:360 clockwise:TRUE];
        [arc setLineWidth:4.0];
        [[UIColor blackColor] setStroke];
        [arc moveToPoint:CGPointMake(aCircle.center.x+aCircle.radius.floatValue,aCircle.center.y)];
        [arc stroke];
         
        CGMutablePathRef arcPath = CGPathCreateMutable();
        CGPathAddArc(arcPath, NULL, aCircle.center.x, aCircle.center.y, aCircle.radius.floatValue, 0, M_2_PI, TRUE);
        CGContextAddPath(context,arcPath);
        CGContextStrokePath(context);
         */
    else
    {
        NSLog(@"drawing");
        [self.backgroundImage drawInRect:self.bounds];
        MAGGesture *currentGesture;
        MAGSample *sample1;
        MAGSample *sample2;
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1);
        for (int gestureIndexCounter = 0; gestureIndexCounter < self.liveGestureIndeces.count; gestureIndexCounter = gestureIndexCounter + 1)
        {
            /*NSLog(@"gestureIndexCounter: %i",gestureIndexCounter);
            NSLog(@"liveGestureIndeces.count: %i",self.liveGestureIndeces.count);
            NSLog(@"self.allGestures.count: %i", self.allGestures.count);
            NSLog(@"currentGestureIndex: %i",[self.liveGestureIndeces[gestureIndexCounter] intValue]);*/
            int currentGestureIndex  = [self.liveGestureIndeces[gestureIndexCounter] intValue];
            if (currentGestureIndex != -1)
            {
                currentGesture = self.allGestures[[self.liveGestureIndeces[gestureIndexCounter] intValue]];
                sample1 = currentGesture.sampleArray[currentGesture.sampleArray.count - 2];
                sample2 = currentGesture.sampleArray[currentGesture.sampleArray.count - 1];
                CGContextMoveToPoint(context, sample1.location.x, sample1.location.y);
                CGContextAddLineToPoint(context, sample2.location.x, sample2.location.y);
            }
            /*currentSample = currentGesture.sampleArray[0];
            CGContextMoveToPoint(context, currentSample.location.x, currentSample.location.y);
            for (int sampleCounter = 1; sampleCounter < [currentGesture.sampleArray count]; sampleCounter = sampleCounter + 1)
            {
                //NSLog(@"gestureCounter: %i, sampleCounter: %i",gestureCounter,sampleCounter);
                currentSample = currentGesture.sampleArray[sampleCounter];
                CGContextAddLineToPoint(context, currentSample.location.x, currentSample.location.y);
            }
             */
        }
        CGContextStrokePath(context);
    }
    //UIGraphicsBeginImageContext(self.bounds.size);
    //[self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //self.backgroundImage = [[UIImage alloc] initWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    //UIImageWriteToSavedPhotosAlbum(self.backgroundImage, nil, nil, nil);
    //UIGraphicsEndImageContext();
    
    //CGContextDrawImage(context,CGRectMake(0, 0, 768, 1004), self.backgroundImage.CGImage);
    
    /*
    
     */
}

@end
