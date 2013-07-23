//
//  MAGDrawingImage.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/20/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGDrawingImage.h"

@implementation MAGDrawingImage

@synthesize allGestures = _allGestures;

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
    NSLog(@"we're in drawRect!");
    if (self.allGestures == nil)
    {
        NSLog(@"allGestures is nil");
    }
    // Drawing code
}


@end
