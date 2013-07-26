//
//  MAGDrawingView.m
//  Canvas
//
//  Created by MillTwo on 7/26/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGDrawingView.h"

@implementation MAGDrawingView

@synthesize liveGestureIndeces = _liveGestureIndeces;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
