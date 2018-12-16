//
//  PickViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()

@end

@implementation PickViewController

@synthesize colour,beak_colour,beak,legs;
//@synthesize pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colour = [[NSArray alloc] initWithObjects:
                         @"COL", @"brwn", @"grn", @"grey",
                         @"blck", @"whit", nil];
    
    self.beak_colour = [[NSArray alloc]
                          initWithObjects:  @"BILL",@"brwn",@"yell", @"grey", @"red", @"blck", nil];
    
    self.beak = [[NSArray alloc] initWithObjects:
                 @"BILL", @"shrt", @"long", @"point", @"curv", @"hook", nil];
   
    self.legs = [[NSArray alloc] initWithObjects:
                 @"LEGS", @"red", @"yell", @"brwn", @"oran", @"blck", nil];
    

  
}



- (void) showPicker:(id)sender {
    // NEW Dec. 2018
//    UIAlertController * menu = [UIAlertController
//                                 alertControllerWithTitle:@"Pick Bird Attributes to find candidates"
//                                 message:@"This device is not configured for sending Email. Please configure the Mail settings in the Settings app."
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//
//
//
//    UIAlertAction* yesButton = [UIAlertAction
//                                actionWithTitle:@"Okay."
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action) {
//                                    //Handle your yes please button action here
//                                }];
//    [menu addAction:yesButton];
//    //[alert addAction:noButton];
//
//    [self presentViewController:menu animated:YES completion:nil];
//
//
    // OLD prior to Dec 2018
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Pick Bird Attributes to find candidates" //[currentData objectAtIndex:0]
                                                      delegate:self
                                             cancelButtonTitle:@"Find"
                                        destructiveButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
    // Add the picker
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,185,0,0)];
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    pickerView.showsSelectionIndicator = YES;    // note this is default to NO
    
    [menu addSubview:pickerView];
    //[menu showFromToolbar:self.toolbarItems[1]];
    [menu showInView:self.view];
    [menu setBounds:CGRectMake(0,0,320, 670)];
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark PickerView DataSource


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
        return [self.colour count];
    else if (component == 1)
        return [legs count];
    else if (component == 2)
        return [beak count];
    else
        return [beak_colour count];

//    NSInteger rows = [self.beak count];
//    return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0)
        return [colour objectAtIndex:row];
    else if (component == 1)
        return [legs objectAtIndex:row];
    else if (component == 2)
        return [beak objectAtIndex:row];
    else
        return [beak_colour objectAtIndex:row];

    
    //return [self.beak objectAtIndex:row];
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    //NSString *bea = [[beak objectAtIndex:row] string];
    //self.pickedLabel.text = bea;
    //float dollars = [dollarText.text floatValue];
    //float result = dollars * rate;
    
    //NSString *resultString = [[NSString alloc] initWithFormat:
    //                          @"%@", colour,
    //                          [colour objectAtIndex:row]];
    //resultLabel.text = resultString;
}
- (IBAction)buttonPick:(id)sender {
    [self showPicker:sender];
}
@end
