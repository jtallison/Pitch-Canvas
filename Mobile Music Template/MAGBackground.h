//
//  MAGBackground.h
//  Mobile Music Template
//
//  Created by MillTwo on 7/2/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGCircleArray.h"

@interface MAGBackground : UIView

@property MAGCircleArray *circles;

@property (weak, nonatomic) NSMutableArray *allGestures;

@property (weak, nonatomic) NSArray *liveGestureIndeces;

@property (strong, nonatomic) UIImage *backgroundImage;

@end
