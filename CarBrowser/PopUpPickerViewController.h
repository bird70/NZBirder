//
//  PopUpPickerViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PopUpPickerView.h"

@interface PopUpPickerViewController : UIViewController{


NSArray *pickerData;
UIPickerView *pickerView;
UIPickerView *picker;
}

-(IBAction)change:(id)sender;
-(void)addSubviewToWindow:(UIView*) addView;

@property(nonatomic, retain) UIPickerView *pickerView;
@property(nonatomic, retain) NSArray *pickerData;
@property(nonatomic, retain) UIPickerView *picker;

@end
