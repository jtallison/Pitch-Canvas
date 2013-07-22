//
//  MAGRootViewController.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/19/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGRootViewController.h"

@interface MAGRootViewController ()

- (IBAction)loadCanvas;

@end

@implementation MAGRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadCanvas
{
     [self performSegueWithIdentifier:@"loadCanvas" sender:self];
}
@end
