//
//  ObservationTableViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 10/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Observation.h"
#import "Spot.h"
//@class Spot;
#import "FMDatabase.h"
//#import "Bird_attributes.h"
#import "PickViewController.h"

@interface ObservationTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//- (IBAction)identifyMe:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Spot *spot;
@property (nonatomic, strong) NSMutableSet *myObservations;
@property (nonatomic, strong) NSSet *obs;
@property (nonatomic, strong) NSString *strNrs;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, strong) NSManagedObjectID *spotID;
//@property (nonatomic, strong) Bird_attributes *bird;

@end
