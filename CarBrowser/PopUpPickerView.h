//
//  PopUpPickerView.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpPickerViewController.h"

@class PopUpPickerViewController;

@interface PopUpPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    PopUpPickerViewController *parentViewController;
    NSArray *pickerData;
}

-(void)animateDatePicker:(BOOL)show;

@property(nonatomic, retain) UIPickerView *picker;
@property(nonatomic, retain) NSArray *pickerData;
@property(nonatomic, retain) PopUpPickerViewController *parentViewController;

@end