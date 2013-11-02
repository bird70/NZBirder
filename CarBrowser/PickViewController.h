//
//  PickViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 6/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic)  NSArray *colour;
@property (strong, nonatomic)  NSArray *legs;
@property (strong, nonatomic) NSArray *beak;
@property (strong, nonatomic) NSArray *beak_colour;
- (IBAction)buttonPick:(id)sender;

//@property (weak, nonatomic) IBOutlet UILabel *pickedLabel;
//@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@end
