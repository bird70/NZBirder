//
//  ObservationTableViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 10/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "ObservationTableViewController.h"
#import "ModelController.h"
#import "PickViewController.h"

@interface ObservationTableViewController ()

@end

@implementation ObservationTableViewController

@synthesize spot;// = _spot;
@synthesize myObservations;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize strNrs;
@synthesize tagsArray;
@synthesize spotID;
//@synthesize bird;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

//    // Retrieve all Observations
//    self.myObservations = [[NSMutableSet alloc] init];
//    NSError *error;
//    if (![self.fetchedResultsController performFetch:&error]) {
//	    NSLog(@"Error in observations retrieval %@, %@", error, [error userInfo]);
//	    abort();
//	}
//    // Each observation attached to the details is included in the array
//    NSSet *obs = self.myObservations;
//    for (Observation *observ in obs) {
//        [myObservations addObject:observ];
//    }
//    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.spot.name;
//    NSLog(@"ObjectID for %@, %@",spot.name, spot.objectID);
//    NSLog(@"ObjectID moID %@", spotID);
    
    //txs 12/15 NSString *spotName = self.spot.name;
//    NSLog(@"spotName in ObservationTVController: %@",spotName);
    
//	if (![spotName length] > 0) {
//		spotName = @"Unnamed spot";
//	}
	
   // spotName   =
    
    
            if (spot == NULL){

                //Previous version (Dec 2018)
                //                UIAlertView *alert = [[UIAlertView alloc]
//                                      initWithTitle:@"You need to create or select an observation spot on the map first (long tap on map or tap on existing spot)" message:nil delegate:nil
//                                      cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                
                //[alert show];
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"You need to create or select an observation spot on the map first (long tap on map or tap on existing spot)"
                                             message:@" - Use 'Map' tab or 'Spots' tab  on Main Screen- "
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Okay. Got it."
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                            }];
                [alert addAction:yesButton];
                //[alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                return;
                
            }

	// Display all the obs, so fetch then using the spot's context.
	// Put the fetched obs into a mutable array.
	NSManagedObjectContext *context = spot.managedObjectContext;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Observation"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bird_observed"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
  //  NSManagedObjectID  *obsSpotID = [spot valueForKey:@"objectID"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observation_atSpot.name= %@", self.spot.name];
   [fetchRequest setPredicate:predicate];
////   
    
    NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
	self.tagsArray = mutableArray;
	

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of tags in the array, adding one if editing (for the Add Tag row).
	NSUInteger count = [tagsArray count];
	if (self.editing) {
		count++;
	}
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
	NSUInteger row = indexPath.row;
	
    
	static NSString *ObsCellIdentifier = @"ObservationCell";
	
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ObsCellIdentifier];
	
	
    
    Observation *myObs = [tagsArray objectAtIndex:row];
	
	// If the tag at this row in the tags array is related to the event, display a checkmark, otherwise remove any checkmark that might have been present.
    cell.textLabel.text = myObs.bird_observed;
    NSString *heard =  [myObs.number_heard stringValue];
     NSNumber *sum = [NSNumber numberWithFloat:([heard floatValue] )];
    
    cell.detailTextLabel.text = [sum stringValue];
 	
    return cell;
}





// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Observation *obs = (Observation *)[self.fetchedResultsController objectAtIndexPath:indexPath];
//    UITableViewCell * cell = [self.tableView  cellForRowAtIndexPath:indexPath];
//    [cell setSelected:NO animated:YES];
//    if ([myObservations containsObject:obs]) {
//        [myObservations removeObject:obs];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        [myObservations addObject:obs];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        //self.spot.isCurrent =  (intWithNumber 1);
//        
//    }
}


#pragma mark - Fetched results controller


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spot" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observation_atSpot = 1"];
//    [fetchRequest setPredicate:predicate];
//    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"bird_observed"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _fetchedResultsController;
}


@end
