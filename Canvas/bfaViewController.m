//
//  bfaViewController.m
//  Canvas
//
//  Created by MillTwo on 6/24/13.
//  Copyright (c) 2013 emdm. All rights reserved.
//

#import "bfaViewController.h"

@interface bfaViewController ()

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation bfaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // _________________ LOAD Pd Patch ____________________
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"mag_template.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touched = [[event allTouches] anyObject];
    CGPoint location = [touched locationInView:touched.view];
    [self changeGreeting:location.x WithYCoord:location.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touched = [[event allTouches] anyObject];
    CGPoint location = [touched locationInView:touched.view];
    [self changeGreeting:location.x WithYCoord:location.y];
}
- (void)changeGreeting:(float)x WithYCoord:(float)y{
    NSString *coordString = [[NSString alloc] initWithFormat: @"X:%f,Y:%f", x,y];
    self.label.text = coordString;
}

@end
