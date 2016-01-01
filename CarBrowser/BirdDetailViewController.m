//
//  BirdDetailViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdDetailViewController.h"
#import "BirdDetailViewController_LANDSCAPEViewController.h"
#import "BirdDescriptionViewController.h"
#import "BirdTableViewController.h"
#import "Bird.h"
//#import "AudioToolbox/AudioServices.h"
#import "AudioToolbox/AudioToolbox.h"

BOOL isShowingLandscapeView;

@interface BirdDetailViewController ()


@end

@implementation BirdDetailViewController

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


// Set up the text and title as the view appears
- (void) viewDidAppear: (BOOL) animated
{
  //  self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    // match the title to the text view
   
    self.title = self.bird.name;
    self.imageView.layer.cornerRadius = 15;
    self.imageView.layer.masksToBounds = YES;
   
    //self.presentingViewController.view.autoresizingMask =
    //UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }

- (void)viewWillLayoutSubviews
{

    self.imageView.layer.cornerRadius = 15;
    self.imageView.layer.masksToBounds = YES;
    
}

- (void) logSizes {
   NSLog(@"imageView.bounds: %@", NSStringFromCGRect(self.imageView.bounds));
   NSLog(@"imageView.sizeThatFits: %@", NSStringFromCGSize([self.imageView sizeThatFits:CGSizeZero]));
}
/*
-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    
    
    [[self modelLabel] setText:[[self bird] maoriname]];
    [[self imageView] setImage:[[self bird] image]];
    [[self soundLabel] setText:[[self bird] sound]];
    [[self familyLabel] setText:[[self bird] family]];
    
    //override output for Audio: always play on Speaker first
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
         
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:[[self bird ]sound]
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    
    
}



- (IBAction)triggerBirdDescriptionVC:(UIBarButtonItem *)sender {
    //Action to perform when Description button is pressed:
    [self performSegueWithIdentifier: @"ShowBirdDescription"
                              sender: self];
    
     
}


-(void)playAudio
{
    [audioPlayer play];
    NSLog(@"Playing Audio" );
}


/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)UIInterfaceOrientationPortrait{
    [self updateViewConstraints];
}
*/


/*

-(void)stopAudio
{
    [audioPlayer stop];
}

*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowBirdDescription"])
    {
        BirdDescriptionViewController *dvc = [segue destinationViewController];
                [dvc setBird:[self bird]];
        
        
    }
    else if ([[segue identifier] isEqualToString:@"DisplayAlternateView"]) {
        BirdDetailViewController_LANDSCAPEViewController *dvc = [segue destinationViewController];
        [dvc setBird:[self bird]];
        

    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bird = nil;
    audioPlayer = nil;
    
    //volumeControl = nil;
}


- (IBAction)backToList:(UIBarButtonItem *)sender {
    //[[self navigationController] popViewControllerAnimated:NO];
    [[self navigationController] popToRootViewControllerAnimated:YES ];
    //[[self performSegueWithIdentifier:backToBirdList    sender]];
}


- (void)awakeFromNib
{
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView
        )
    {
        [self performSegueWithIdentifier:@"DisplayAlternateView" sender:self];
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView
             )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }
}
@end
