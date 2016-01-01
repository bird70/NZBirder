//
//  BirdDescriptionViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 13/05/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdDescriptionViewController.h"
#import "Bird.h"
#import "BirdDetailViewController.h"


@interface BirdDescriptionViewController ()
//

@end

@implementation BirdDescriptionViewController
@synthesize bird;
@synthesize birdDescriptionLabel2;
//@synthesize bdescWebView;
@synthesize birdLink;

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
    //[[self birdDescriptionThumbnail] setImage:[[self bird] image]];
    [[self birdDescriptionLabel2] setText:[[self bird] description]];
    [[self birdOtherName]setText:[[self bird]maoriname]];
    [[self birdLink] setText:[[self bird] link]];    
    
}

// Set up the text and title as the view appears
- (void) viewDidAppear: (BOOL) animated
{
    //self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    
    // match the title to the text view
    self.title = self.bird.name;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)backToDetail:(UIBarButtonItem *)sender {
    //Action to perform when Description button is pressed:
    [self performSegueWithIdentifier: @"BackToBirdDetail"
                              sender: self];
}
 */

- (IBAction)backToDetail:(UIBarButtonItem *)sender {
    //Action to perform when Description button is pressed:
    // BirdDescriptionViewController *dvc = [segue destinationViewController];
    //UIViewController *pvc = self.parentViewController;
    [[self navigationController] popViewControllerAnimated:NO];
    //[[self navigationController] popToViewController:self.parentViewController animated:YES ];
   // [self performSegueWithIdentifier: @"BackToBirdDetail"
    //                          sender: self];
}
@end
