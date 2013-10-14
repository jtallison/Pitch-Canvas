//
//  MAGInfoViewController.m
//  PitchCanvas
//
//  Created by Jesse Allison on 10/13/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGInfoViewController.h"

@interface MAGInfoViewController ()
- (IBAction)linkToMAGSite:(UIButton *)sender;
- (IBAction)backToSetup:(UIButton *)sender;

@end

@implementation MAGInfoViewController

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

- (IBAction)linkToMAGSite:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cct.lsu.edu/focus-areas/cultural-computing/mag/mag-apps"]];
}

- (IBAction)backToSetup:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
