//
//  BirdCountsViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 25/05/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdCountsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISlider *sl_numOfBirdsHeard;
@property (weak, nonatomic) IBOutlet UISlider *sl_numOfBirdsSeen;
@property (weak, nonatomic) IBOutlet UILabel *lbl_numOfBirdsHeard;
@property (weak, nonatomic) IBOutlet UILabel *lbl_numOfBirdsSeen;

@end
