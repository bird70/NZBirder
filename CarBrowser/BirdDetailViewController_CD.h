//
//  BirdDetailViewController_CD.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 1/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FMDatabase.h"
#import "CurrentSpot.h"
#import "Spot.h"

@class Bird_attributes;

@interface BirdDetailViewController_CD : UIViewController <NSFetchedResultsControllerDelegate,AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *iscurrentSpotFetchedResultsController;

@property (weak, nonatomic) Bird_attributes *bird;
@property (weak, nonatomic) NSArray *birds;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UITableViewCell *birdtableviewcell;

@property (weak, nonatomic) IBOutlet UITextView *birddescription;
//@property (weak, nonatomic) IBOutlet UISwitch *favStatusSwitch;
@property (weak, nonatomic) IBOutlet UILabel *beakLabel;
@property (weak, nonatomic) IBOutlet UILabel *legLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *billcolourLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyLabel;
@property (strong, nonatomic) NSString *birdname;
@property (strong, nonatomic) CurrentSpot *myCurrentSpot;
@property (strong, nonatomic) Spot *mySpot;
@property (strong, nonatomic) Spot  *spot;
@property (strong, nonatomic) NSSet *allobs;
@property (strong, nonatomic) NSString *currentspotname;
@property (strong, nonatomic) NSManagedObjectID *moID;
@property (weak, nonatomic) IBOutlet UILabel *labelScName;
//@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;
@property (weak, nonatomic) IBOutlet UIButton *hearMeButton;
//@property (weak, nonatomic) IBOutlet UILabel *legColourLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelHeard;
//@property (weak, nonatomic) IBOutlet UILabel *labelSeen;
@property (weak, nonatomic) IBOutlet UISlider *sliderHeard;
//@property (weak, nonatomic) IBOutlet UISlider *sliderSeen;

- (IBAction)sliderHeard:(id)sender;

//- (IBAction)sliderSeen:(id)sender;

- (IBAction)countMe:(id)sender;
- (IBAction)hearMe:(id)sender;

@end

