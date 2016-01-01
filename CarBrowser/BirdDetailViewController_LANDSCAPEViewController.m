//
//  BirdDetailViewController_LANDSCAPEViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 22/06/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdDetailViewController_LANDSCAPEViewController.h"
#import "BirdTableViewController.h"
#import "Bird.h"
#import "BirdDetailViewController.h"
BOOL isShowingLandscapeView;

//#import "BirdDescriptionViewController.h"


@interface BirdDetailViewController_LANDSCAPEViewController ()

@end

@implementation BirdDetailViewController_LANDSCAPEViewController
@synthesize bird;
@synthesize birds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///


//@implementation BirdDetailViewController



// Set up the text and title as the view appears
- (void) viewDidAppear: (BOOL) animated
{
    //  self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    // match the title to the text view
    
    self.title = self.bird.name;
    self.presentingViewController.view.autoresizingMask =
    UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)viewWillLayoutSubviews
{
    //self.imageView.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void) logSizes {
    //   NSLog(@"theView.bounds: %@", NSStringFromCGRect(theView.bounds));
    //   NSLog(@"theView.sizeThatFits: %@", NSStringFromCGSize([theView sizeThatFits:CGSizeZero]));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self makeLabel] setText:[[self bird] name]];
    //[[self modelLabel] setText:[[self bird] maoriname]];
    [[self imageView] setImage:[[self bird] image]];

    
}


/*
- (IBAction)triggerBirdDescriptionVC:(UIBarButtonItem *)sender {
    //Action to perform when Description button is pressed:
    [self performSegueWithIdentifier: @"ShowBirdDescription"
                              sender: self];
    
    
}

*/


/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)UIInterfaceOrientationPortrait{
    [self updateViewConstraints];
}

*/





/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowBirdDescription"])
    {
        BirdDescriptionViewController *dvc = [segue destinationViewController];
        [dvc setBird:[self bird]];
        
        
    }
    
}

*/


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bird = nil;
    
}


- (IBAction)backToPortrait:(UIBarButtonItem *)sender {
 //[[self navigationController] popViewControllerAnimated:YES];
 //[self dismissViewControllerAnimated:YES completion:nil];
 //[[self navigationController] popToRootViewControllerAnimated:YES ];
   [self performSegueWithIdentifier:@"backToPortraitBirdDetail" sender:self];

}


- (void)awakeFromNib
{
    isShowingLandscapeView = YES;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"backToPortraitBirdDetail"])
    {
        BirdDetailViewController *dvc = [segue destinationViewController];
        [dvc setBird:[self bird]];
            
    }
    
    
}



- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
        !isShowingLandscapeView
        )
    {
        //[[self navigationController] popToRootViewControllerAnimated:YES ];
        //[self dismissViewControllerAnimated:YES completion:nil];
        [[self navigationController] popViewControllerAnimated:NO];
        //![self performSegueWithIdentifier:@"backToPortraitBirdDetail" sender:self];
          isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
                  isShowingLandscapeView
             )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }
}
@end
