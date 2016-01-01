//
//  PopUpPickerViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "PopUpPickerViewController.h"
#import "PopUpPickerView.h"

@implementation PopUpPickerViewController

@synthesize pickerData, pickerView, picker;

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
    
    self.pickerView = [[PopUpPickerView alloc] initWithFrame:CGRectMake(0.0, 174.0, 320.0, 286.0)];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 70.0, 320.0, 216.0)];
    //self.pickerView.picker = self.picker;
    //[self.picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    //self..parentViewController = self;
    [self.pickerView addSubview:self.picker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)change:(id)sender{
    PopUpPickerView *pView = (PopUpPickerView*) pickerView;
    [pView animateDatePicker:YES];
    
}

-(void)addSubviewToWindow:(UIView*) addView{
    [self.view addSubview:addView];
}

@end