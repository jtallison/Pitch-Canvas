//
//  MAGMainViewController.m
//  Mobile Music Template
//
//  Created by MillTwo on 7/19/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGMainViewController.h"
#import "MAGViewController.h"

@interface MAGMainViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *keySwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *shiftSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSwitch;

- (IBAction)loadCanvas;

@end

@implementation MAGMainViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadCanvas"])
    {
        [segue.destinationViewController setBaseKey:([self.keySwitch selectedSegmentIndex] + 69.0)];
        [segue.destinationViewController setCircleSize:([self.sizeSwitch selectedSegmentIndex]*50.0 + 50.0)];
        [segue.destinationViewController setShift:([self.shiftSwitch selectedSegmentIndex])];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [self setKeySwitch:nil];
    [self setShiftSwitch:nil];
    [self setSizeSwitch:nil];
    [super viewDidUnload];
}
@end
