//
//  PopUpPickerView.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "PopUpPickerView.h"
#import "PopUpPickerViewController.h"

#import "PopUpPickerView.h"
#import "PopUpPickerViewController.h"

@implementation PopUpPickerView

@synthesize  picker, pickerData, parentViewController;

- (void)animateDatePicker:(BOOL)show {
    
    pickerData = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    CGRect screenRect = self.frame;
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  pickerSize.width, pickerSize.height);
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.origin.y + screenRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    self.picker.frame = pickerRect;
    //self.backgroundColor = UIColorMakeRGBA( 255, 125, 64, 0.7f - (int)show * 0.7f );
    
    if ( show ) {
        self.picker.frame = startRect;
        PopUpPickerViewController *controller = (PopUpPickerViewController*) self.parentViewController;
        [controller addSubviewToWindow:self];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    //self.backgroundColor = UIColorMakeRGBA( 255, 125, 64, 0.0f + (int)show * 0.7f );
    
    if ( show ) {
        self.picker.frame = pickerRect;
        
    } else {
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        self.picker.frame = startRect;
    }
    
    [UIView commitAnimations];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}


@end
