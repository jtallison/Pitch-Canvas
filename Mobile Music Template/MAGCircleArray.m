//
//  MAGCircleArray.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/4/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGCircleArray.h"
#import "MAGCircle.h"

@implementation MAGCircleArray

@synthesize circleArray = _circleArray;

@synthesize pitchMap = _pitchMap;

- (id)initWithRadius:(float)circleRadius andPitch:(float)startingPitch andShift:(int)shift andMultipleKeys:(BOOL)multipleKeys
{
    NSLog(@"initializing a MAGCircleArray");
    self = [super init];
    
    //string used to check the user preferences
    NSString *keyString = [NSString stringWithFormat:@"pitchMapWithRadius%fandStartingPitch%fandShift:%i",circleRadius,startingPitch,shift];
    
    //initializing self.circleArray
    //will be a two-dimensional matrix of circles
    //the point (0,0) refers to the top-left pixel on the screen
    
    BOOL centerAboveScreen = TRUE; //boolean describing whether or not the current column of circles begins with the first circle's center above the end of the screen
    float altitude = sqrt(3.0)/2.0*circleRadius;
    NSArray *aboveScreenPitches = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:21.0],
                                   [NSNumber numberWithFloat:17.0],
                                   [NSNumber numberWithFloat:14.0],
                                   [NSNumber numberWithFloat:11.0],
                                   [NSNumber numberWithFloat:7.0],
                                   [NSNumber numberWithFloat:4.0],
                                   [NSNumber numberWithFloat:0.0],nil];
    
    NSArray *notAboveScreenPitches = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:23.0],
                                      [NSNumber numberWithFloat:19.0],
                                      [NSNumber numberWithFloat:16.0],
                                      [NSNumber numberWithFloat:12.0],
                                      [NSNumber numberWithFloat:9.0],
                                      [NSNumber numberWithFloat:5.0],
                                      [NSNumber numberWithFloat:2.0],nil];
    
    NSMutableArray *futureCircles = [[NSMutableArray alloc] init];
    CGPoint currentCenter = CGPointMake(0.0, circleRadius/2.0);
    
    int pitchCounter = shift;
    float pitchBase = startingPitch;
    NSNumber *currentPitch = [NSNumber numberWithFloat:0.0];
    while (currentCenter.x < 768+circleRadius*2.0)
    {
        //create a new array for this column of circles
        NSMutableArray *columnCircles = [[NSMutableArray alloc] init];
        
        while (currentCenter.y < 1024+circleRadius*2.0) {
            //find the pitch of the current circle
            if (centerAboveScreen)
            {
                currentPitch = [NSNumber numberWithFloat:pitchBase + [aboveScreenPitches[pitchCounter] floatValue]];
            }
            else
            {
                currentPitch = [NSNumber numberWithFloat:pitchBase + [notAboveScreenPitches[pitchCounter] floatValue]];
            }
            pitchCounter = pitchCounter + 1;
            if (pitchCounter==aboveScreenPitches.count) {pitchCounter = pitchCounter - aboveScreenPitches.count; pitchBase = pitchBase - 24;}
            [columnCircles addObject:[[MAGCircle alloc] initWithCenter:currentCenter Radius:circleRadius Pitch:currentPitch.floatValue]];
            
            //increment currentCenter.y
            currentCenter.y = currentCenter.y + 2.0*circleRadius;
        }
        
        //add the new array to futureCircles
        [futureCircles addObject:columnCircles];
                
        //increment currentCenter.x
        currentCenter.x = currentCenter.x + 2.0*altitude;
        if (centerAboveScreen)
        {
            centerAboveScreen = FALSE;
            currentCenter.y = -circleRadius/2.0;
            pitchCounter = shift;
            pitchBase = startingPitch;
        }
        else
        {
            centerAboveScreen = TRUE;
            currentCenter.y = circleRadius/2.0;
            pitchCounter = shift;
            //enable mulitple scales
            /*
            if ( ((int )(currentCenter.x/(2.0*altitude)))%(4) == 0)
            {
                startingPitch = startingPitch + 7.0;
            }
            else
            {
                startingPitch = startingPitch - 5.0;
            }
            */
            pitchBase = startingPitch;
        }
    }
    _circleArray = [[NSArray alloc] initWithArray:futureCircles];
    NSLog(@"initialized self.circleArray");
    //NSLog(@"self.circleArray.count: %i",self.circleArray.count);
    //NSLog(@"self.circleArray[0].count: %i",[[self.circleArray objectAtIndex:0] count]);
    //NSLog(@"self.circleArray[1].count: %i",[[self.circleArray objectAtIndex:1] count]);
    //NSLog(@"currentPitch: %f, circleRadius: %f",[[[[futureCircles objectAtIndex:0] objectAtIndex:0] pitch] floatValue],[[[[futureCircles lastObject] lastObject] radius] floatValue]);

    /*
     
     NSArray *oldArray = [prefs objectForKey:@"savedArray"];
     self.savedLabel.text = [oldArray objectAtIndex:0];
     //NSLog([prefs objectForKey:@"savedString"]);
     
     self.userName = self.textField.text;
     
     NSString *nameString = self.userName;
     if ([nameString length] == 0) {
     nameString = @"World";
     }
     NSString *greeting = [[NSString alloc] initWithFormat: @"Hello, %@!", nameString];
     self.label.text = greeting;
     [prefs setObject:[[NSArray alloc] initWithObjects:nameString, nil] forKey:@"savedArray"];
     //NSLog(@"Done");
     */
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //moved to beginning of method
    //NSString *keyString = [NSString stringWithFormat:@"pitchMapWithRadius%fandStartingPitch%f",circleRadius,startingPitch];
    NSArray *thePitchMap = [prefs arrayForKey:keyString];
    if (thePitchMap != NULL)
    {
        NSLog(@"thePitchMap != NULL");
    }
    else
    {
        NSLog(@"thePitchMap == NULL");
        NSMutableArray *futurePitchMap = [[NSMutableArray alloc] init];
        futurePitchMap = [[NSMutableArray alloc] init];
        NSMutableArray *slidePitchReference = [[NSMutableArray alloc] init];
        //c1 = (0,-r/2)
        //c2 = (0,3r/2)
        //c3 = (2*altitude,r/2)
        CGPoint center1 = CGPointMake(0.0, -circleRadius/2.0);
        CGPoint center2 = CGPointMake(0.0,3*circleRadius/2.0);
        CGPoint center3 = CGPointMake(2.0*altitude, circleRadius/2.0);
        double d1 = 0.0;
        double d2 = 0.0;
        double d3 = 0.0;
        float p1Coefficient = 0.0;
        float p2Coefficient = 0.0;
        float p3Coefficient = 0.0;
        for (int xCounter = 0; xCounter <= (int)altitude; xCounter = xCounter + 1)
        {
            //add an array for each pixel in the circle radius
            [slidePitchReference addObject:[[NSMutableArray alloc] init]];
            for (int yCounter = 0; yCounter <= (int) circleRadius; yCounter = yCounter + 1)
            {
                //for each (x,y):
                //calculate its distance from the center of each circle
                d1 = sqrt( pow( center1.x - xCounter, 2)+pow( center1.y - yCounter, 2));
                d2 = sqrt( pow( center2.x - xCounter, 2)+pow( center2.y - yCounter, 2));
                d3 = sqrt( pow( center3.x - xCounter, 2)+pow( center3.y - yCounter, 2));
                
                //if the distance from a circle is less than the radius, that point gets that circle's pitch
                if (d1 < circleRadius) {
                    [slidePitchReference.lastObject addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],nil]];
                }
                else if (d2 < circleRadius) {
                    [slidePitchReference.lastObject addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.0],nil]];
                }
                else if (d3 < circleRadius) {
                    [slidePitchReference.lastObject addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],nil]];
                }
                else
                {
                    //find the contribution of the first circle
                    if (d2 < d3) //use the closer circle
                    {
                        p1Coefficient = [self giveFreqCoefficientForCircleCenter:center1 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center2];
                    }
                    else
                    {
                        p1Coefficient = [self giveFreqCoefficientForCircleCenter:center1 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center3];
                    }
                    
                    //find the contribution of the second circle
                    if (d1 < d3) //use the closer circle
                    {
                        p2Coefficient = [self giveFreqCoefficientForCircleCenter:center2 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center1];
                    }
                    else
                    {
                        p2Coefficient = [self giveFreqCoefficientForCircleCenter:center2 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center3];
                    }
                    
                    //find the contribution of the third circle
                    if (d1 < d2) //use the closer circle
                    {
                        p3Coefficient = [self giveFreqCoefficientForCircleCenter:center3 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center1];
                    }
                    else
                    {
                        p3Coefficient = [self giveFreqCoefficientForCircleCenter:center3 Radius:circleRadius atPoint:CGPointMake(xCounter, yCounter) closestToCircle:center2];
                    }
                    
                    [slidePitchReference.lastObject addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:p1Coefficient],[NSNumber numberWithFloat:p2Coefficient],[NSNumber numberWithFloat:p3Coefficient],nil]];
                }
            }
        }
        NSLog(@"slide pitch reference calculated");
        
        
        //iterate through the pixels, giving each pixel an empty pitch in the array
        for (int rowCounter = 0; rowCounter < 769; rowCounter = rowCounter + 1 ) {
            NSMutableArray *tempColumnPitches = [[NSMutableArray alloc] init];
            for (int columnCounter = 0; columnCounter < 1025; columnCounter = columnCounter + 1) {
                [tempColumnPitches addObject:[NSNumber numberWithFloat:0.0]];
            }
            [futurePitchMap addObject:tempColumnPitches];
        }
        NSLog(@"created empty futurePitchMap");
        
        BOOL isTriangle = FALSE;
        BOOL isFlipped = FALSE;
        NSMutableArray *relevantCircles = [[NSMutableArray alloc] init];
        //NSArray *currentCircleIndex = [[NSArray alloc] init];
        //NSArray *currentCircleColumn = [[NSArray alloc] init];
        
        MAGCircle *c1 = [[MAGCircle alloc] init];
        MAGCircle *c2 = [[MAGCircle alloc] init];
        MAGCircle *c3 = [[MAGCircle alloc] init];
        int tempHorizontalIndex = 0;
        int tempVerticalIndex = 0;
        float tempPitch = 0.0;
        NSArray *slidePitchForCurrentPixel = [[NSArray alloc] init];
        
        //NSLog(@"cell index:\tisTriangle:\tisFlipped:\trelevantCircles:");
        for (int horizontalCellIndex = 0; horizontalCellIndex < 768/altitude; horizontalCellIndex = horizontalCellIndex + 1)
        {
            NSLog(@"currently initializing cells in column: %i",((int) altitude)*horizontalCellIndex);
            for (int verticalCellIndex = 0; verticalCellIndex < 1024/(circleRadius); verticalCellIndex = verticalCellIndex + 1)
            {
                //determine isFlipped
                if (horizontalCellIndex % 2 == 0){isFlipped = FALSE;}
                else if (horizontalCellIndex % 2 == 1){isFlipped = TRUE;}
                else {NSLog(@"error: horizontalCellIndex mod 2 != 0 or 1");}
                
                //determine isTriangle
                if ((horizontalCellIndex%4 == 0) || (horizontalCellIndex%4 == 3))
                {
                    if (verticalCellIndex % 2 == 0){isTriangle = FALSE;}
                    else if (verticalCellIndex % 2 == 1){isTriangle = TRUE;}
                    else {NSLog(@"error: verticalCellIndex mod 2 != 0 or 1");}
                }
                else
                {
                    if ((verticalCellIndex+1) % 2 == 0) {isTriangle = FALSE;}
                    else if ((verticalCellIndex+1) % 2 == 1) {isTriangle = TRUE;}
                    else {NSLog(@"error: (verticalCellIndex+1) mod 2 != 0 or 1");}
                };
                
                if (isTriangle)
                {
                    if (horizontalCellIndex%4 == 0)
                    {
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex-1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex+1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex+1 and:verticalCellIndex]];
                    }
                    else if (horizontalCellIndex%4 == 1)
                    {
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex-1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex+1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex-1 and:verticalCellIndex]];
                    }
                    else if (horizontalCellIndex%4 == 2)
                    {
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex-1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex+1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex+1 and:verticalCellIndex]];
                    }
                    else if (horizontalCellIndex%4 == 3)
                    {
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex-1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex+1]];
                        [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex-1 and:verticalCellIndex]];
                    }
                }
                else
                {
                    [relevantCircles addObject:[self giveCircleForCellAt:horizontalCellIndex and:verticalCellIndex]];
                }
                
                /*
                 NSMutableString *printStr = [[NSMutableString alloc] init];
                 [printStr appendString:@"("];
                 [printStr appendFormat:@"%i",horizontalCellIndex];
                 [printStr appendString:@","];
                 [printStr appendFormat:@"%i",verticalCellIndex];
                 [printStr appendString:@")\t\t"];
                 
                 if (isTriangle){[printStr appendString:@"True\t\t"];}
                 else {[printStr appendString:@"False\t\t"];}
                 if (isFlipped){[printStr appendString:@"True\t\t"];}
                 else {[printStr appendString:@"False\t\t"];}
                 
                 [printStr appendString:@"{"];
                 for (int circleCounter = 0; circleCounter < relevantCircles.count; circleCounter = circleCounter + 1)
                 {
                 NSArray *theRelevantCircle = relevantCircles[circleCounter];
                 [printStr appendString:@"["];
                 [printStr appendFormat:@"%i",[theRelevantCircle[0] intValue]];
                 [printStr appendString:@","];
                 [printStr appendFormat:@"%i",[theRelevantCircle[1] intValue]];
                 [printStr appendString:@"]"];
                 }
                 [printStr appendString:@"}"];
                 NSLog(printStr);
                 */
                
                //NSLog(@"c1x: %f, c1y: %f, c1.radius: %f, c1.pitch: %f",c1.center.x,c1.center.y,c1.radius.floatValue,c1.pitch.floatValue);
                
                for (int horizontalPixelIndex = 0; horizontalPixelIndex < altitude; horizontalPixelIndex = horizontalPixelIndex + 1)
                {
                    for (int verticalPixelIndex = 0; verticalPixelIndex < circleRadius; verticalPixelIndex = verticalPixelIndex + 1)
                    {
                        tempHorizontalIndex = horizontalCellIndex*((int) altitude)+horizontalPixelIndex;
                        tempVerticalIndex = verticalCellIndex*circleRadius+verticalPixelIndex;
                        if ((tempHorizontalIndex<769) && (tempVerticalIndex<1025))
                        {
                            c1 = [[self.circleArray objectAtIndex:[[[relevantCircles objectAtIndex:0] objectAtIndex:0] intValue]] objectAtIndex:[[[relevantCircles objectAtIndex:0] objectAtIndex:1] intValue]];
                            if (isTriangle)
                            {
                                if (isFlipped)
                                {
                                    slidePitchForCurrentPixel = [[slidePitchReference objectAtIndex:(((int) altitude)-horizontalPixelIndex)] objectAtIndex:verticalPixelIndex];
                                }
                                else
                                {
                                    slidePitchForCurrentPixel = [[slidePitchReference objectAtIndex:horizontalPixelIndex] objectAtIndex:verticalPixelIndex];
                                }
                                c2 = [[self.circleArray objectAtIndex:[[[relevantCircles objectAtIndex:1] objectAtIndex:0] intValue]] objectAtIndex:[[[relevantCircles objectAtIndex:1] objectAtIndex:1] intValue]];
                                c3 = [[self.circleArray objectAtIndex:[[[relevantCircles objectAtIndex:2] objectAtIndex:0] intValue]] objectAtIndex:[[[relevantCircles objectAtIndex:2] objectAtIndex:1] intValue]];
                                p1Coefficient = [[slidePitchForCurrentPixel objectAtIndex:0] floatValue];
                                p2Coefficient = [[slidePitchForCurrentPixel objectAtIndex:1] floatValue];
                                p3Coefficient = [[slidePitchForCurrentPixel objectAtIndex:2] floatValue];
                                tempPitch = (c1.pitch.floatValue*p1Coefficient + c2.pitch.floatValue*p2Coefficient + c3.pitch.floatValue*p3Coefficient)/(p1Coefficient+p2Coefficient+p3Coefficient);
                            }
                            else
                            {
                                tempPitch = c1.pitch.floatValue;
                            }
                            [[futurePitchMap objectAtIndex:tempHorizontalIndex] replaceObjectAtIndex:tempVerticalIndex withObject:[NSNumber numberWithFloat:tempPitch]];
                        }
                    }
                }
                
                //empty the array
                [relevantCircles removeAllObjects];
            }
        }
        NSLog(@"saving the pitchMap");
        thePitchMap = futurePitchMap;
        [prefs setObject:thePitchMap forKey:keyString];
        [prefs synchronize];
    }
    
    _pitchMap = [[NSArray alloc] initWithArray:thePitchMap];
    
    return self;
}

- (NSArray *)giveCircleForCellAt:(int)horizontalCellIndex and:(int)verticalCellIndex
{
    NSMutableArray *circleCoordinates = [[NSMutableArray alloc] init];
    if (verticalCellIndex < 0) {verticalCellIndex = 0;}
    if (horizontalCellIndex % 4 == 0) {
        [circleCoordinates addObject:[NSNumber numberWithInt:horizontalCellIndex/2]];
        [circleCoordinates addObject:[NSNumber numberWithInt:verticalCellIndex/2]];
    }
    else if (horizontalCellIndex % 4 == 1)
    {
        [circleCoordinates addObject:[NSNumber numberWithInt:(horizontalCellIndex+1)/2]];
        [circleCoordinates addObject:[NSNumber numberWithInt:(verticalCellIndex+1)/2]];
    }
    else if (horizontalCellIndex % 4 == 2)
    {
        [circleCoordinates addObject:[NSNumber numberWithInt:horizontalCellIndex/2]];
        [circleCoordinates addObject:[NSNumber numberWithInt:(verticalCellIndex+1)/2]];
    }
    else if (horizontalCellIndex % 4 == 3)
    {
        [circleCoordinates addObject:[NSNumber numberWithInt:(horizontalCellIndex+1)/2]];
        [circleCoordinates addObject:[NSNumber numberWithInt:verticalCellIndex/2]];
    }
        return circleCoordinates;
}

- (float) giveFreqCoefficientForCircleCenter:(CGPoint)c1 Radius:(float)circleRadius atPoint:(CGPoint)point closestToCircle:(CGPoint)c2
{
    float slope = (point.y-c1.y)/(point.x-c1.x);
    float yIntercept = point.y - slope*point.x;
    
    float a = pow(slope,2.0) + 1.0;
    float b = 2.0*((yIntercept - c2.y)*slope - c2.x);
    float c = pow(c2.x,2.0) + pow(yIntercept - c2.y,2.0) - pow(circleRadius,2.0);
    
    float plusX = (-b + sqrt( pow(b,2.0) - 4.0*a*c))/(2.0*a);
    float minusX = (-b - sqrt( pow(b,2.0) - 4.0*a*c))/(2.0*a);
    float plusY = slope*plusX + yIntercept;
    float minusY = slope*minusX + yIntercept;
    
    float dCircleToPoint = [self distanceBetweenPointsP1:c1 andP2:point]-circleRadius;
    float dC1EdgeToC2Edge = 0.0;
    
    if ([self distanceBetweenPointsP1:CGPointMake(plusX, plusY) andP2:point] < [self distanceBetweenPointsP1:CGPointMake(minusX, minusY) andP2:point])
    {
        //use plusX and plusY
         dC1EdgeToC2Edge = [self distanceBetweenPointsP1:c1 andP2:CGPointMake(plusX, plusY)] - circleRadius;
    }
    else
    {
        //use minusX and minusY
        dC1EdgeToC2Edge = [self distanceBetweenPointsP1:c1 andP2:CGPointMake(minusX, minusY)] - circleRadius;
    }
    
    return (1.0 - dCircleToPoint/dC1EdgeToC2Edge);
}

- (float)distanceBetweenPointsP1:(CGPoint)p1 andP2:(CGPoint)p2
{
    return sqrt(pow(p1.x-p2.x,2.0) + pow(p1.y-p2.y,2.0));
}

@end