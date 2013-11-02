//
//  MasterViewController.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "BirdTableViewCell.h"
#import "FMDatabase.h"
#import "Spot.h"

//#import "Bird_attributes.h"


@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//- (IBAction)dismissMe:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *iscurrentSpotFetchedResultsController;
//@property (strong, nonatomic) Bird_attributes *bird;
@property (strong, nonatomic) NSString *birdname;
@property (strong, nonatomic) BirdTableViewCell *cell;
@property (nonatomic, strong) NSMutableSet *mySpots;
@property (strong, nonatomic) Spot *obs;

@end
