//
//  BirdMasterTableViewController_CD.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 23/06/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "Spot.h"

@interface BirdMasterTableViewController_CD : UITableViewController <NSFetchedResultsControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic)  NSArray *p_colour;
@property (strong, nonatomic)  NSArray *p_legs;
@property (strong, nonatomic) NSArray *p_beak;
@property (strong, nonatomic) NSArray *p_beak_colour;
@property (strong, nonatomic) NSString *BEAK_SELECTED;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *gardenFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *coastFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *bushFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *allFetchedResultsController;

@property (nonatomic, retain) NSFetchedResultsController *pickFetchedResultsController;
@property (nonatomic, retain) NSPredicate *pickerPredicate;
@property (nonatomic, retain) NSCompoundPredicate *comppredicate;

@property (nonatomic, retain) UISegmentedControl *segmentControl;
@property (nonatomic, retain) Spot *spot;

@property (nonatomic) NSInteger *selectedScrollIndex;

- (IBAction)buttonPick:(id)sender;

- (IBAction)segmentControl:(id)sender;


@end

