//
//  BirdTableViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bird.h"
#import <CoreData/CoreData.h>



@interface BirdTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSArray *birds;
@property (strong,nonatomic) NSMutableArray *filteredBirdsArray;

//@property (strong,nonatomic) NSArray *searchResults;

@property IBOutlet UISearchBar *birdSearchBar;
//- (IBAction)gotoSearch:(UIBarButtonItem *)sender;

@end
