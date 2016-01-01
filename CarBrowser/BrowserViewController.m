//
//  BrowserViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 14/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController

@synthesize browserView;
@synthesize externalLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setupSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeGestureRight.direction = (UISwipeGestureRecognizerDirectionRight );
    [self.view addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeGestureLeft.direction = (UISwipeGestureRecognizerDirectionLeft );
    [self.view addGestureRecognizer:swipeGestureLeft];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)gesture {
     //NSLog(@"Direction is: %i", gesture.direction);
    
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        if (gesture.direction == 1){
            //do something for a left swipe gesture.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
        //    NSLog(@"Other swipe direction");
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSwipeGestureRecognizer];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
	// Do any additional setup after loading the view.
    self.labelURL.text = externalLink;
    
    [browserView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:externalLink]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
