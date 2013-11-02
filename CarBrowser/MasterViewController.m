//
//  MasterViewController.m
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "MasterViewController.h"
#import "BirdTableViewCell.h"
#import "DetailViewController.h"
#import "ModelController.h"
#import "CurrentSpot.h"
//#import "FMDatabase.h"

//FMDatabase *db  ;
//FMResultSet *results ;

@interface MasterViewController ()
- (void)configureCell:(BirdTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController
//nur ein Test

@synthesize birdname;
@synthesize cell;
@synthesize mySpots;
@synthesize obs;

#pragma mark - Table View
-(void) viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

    birdname = self.birdname;
     // NSLog(@"got into MasterViewController %@", birdname);
    
    // Retrieve all Spots
    self.mySpots = [[NSMutableSet alloc] init];
    NSError *error;
//    if (![self.iscurrentSpotFetchedResultsController performFetch:&error]) {
//	    NSLog(@"Error in spots retrieval %@, %@", error, [error userInfo]);
//	    abort();
//	}
    if (![self.fetchedResultsController performFetch:&error]) {
	//    NSLog(@"Error in spots retrieval %@, %@", error, [error userInfo]);
	    abort();
	}
    // Each spot attached to the details is included in the array
    NSSet *spt = self.mySpots;
    for (Spot *obspot in spt) {
        [mySpots addObject:obspot];
        
    }
//    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"NZBirder.sqlite"];
//    //NSLog(dbPath);
    
//    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
//    [db open];
//    FMStatement *deleteCurrentSpot = [db executeQuery:@"DELETE * FROM ZCURRENTSPOT WHERE Z_PK>1;"];
//    NSLog(@"Trying to delete all currentSpots");
//    
    //NSString * ident = spot.name;
    //FMResultSet *resultBirdNumber = [db executeQuery:@"DELETE * FROM ZCURRENTSPOT WHERE Z_PK =1;"];
//    [db close];
    [self.tableView reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

- (BirdTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];// forIndexPath:indexPath];
  //[self configureCell:cell atIndexPath:indexPath];
    [self configureCell:cell withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
 
 //    cell.accessoryType = UITableViewCellAccessoryNone;
//    /Spot *obs = (Spot *)[self.fetchedResultsController objectAtIndexPath:indexPath];
//    if ([mySpots containsObject:obs]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    
    //cell.textLabel.text = obs.bird_observed;
    //strNrs = ([NSString stringWithFormat:@"heard: %@, seen: %@", obs.number_heard, obs.number_seen]);
    
    //NSLog([NSString stringWithFormat:@"heard: %@, seen: %@", obs.number_heard, obs.number_seen]);
    //cell.detailTextLabel.text =  strNrs;
    
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    NSError *error = nil;
    if (![context save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    self.obs = (Spot *)[self.fetchedResultsController objectAtIndexPath:indexPath];
//    NSString *lat = [NSString stringWithFormat:@"%.3f", obs.latitude];
//    NSString *long = [NSString stringWithFormat:@"%.3f", obs.longitude];
//    
    
     //[self prepareForSegue:@"addBird" withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    //[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    
    
    UITableViewCell * localcell = [self.tableView  cellForRowAtIndexPath:indexPath];
    [localcell setSelected:NO animated:YES];
    if ([mySpots containsObject:obs]) {
        [mySpots removeObject:obs];
        localcell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [mySpots addObject:obs];
        localcell.accessoryType = UITableViewCellAccessoryNone;
        //self.spot.isCurrent =  (intWithNumber 1);
        //[obs setValue:[NSNumber numberWithInt:1] forKey:@"isCurrent"];
        
    }
    //[context nil]
    
    
    
    NSManagedObjectContext *context2 = [[ModelController sharedController] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CurrentSpot" inManagedObjectContext:context2];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate = nil;
    [request setPredicate:predicate];
    
    [request setSortDescriptors:nil];
    
    NSError *error;
   
    //Retrieve the Current Spot
    //make the tapped spot the new current spot
    NSArray *mo = [context2 executeFetchRequest:request error:&error];
    if (mo == nil)
    {
        // Deal with error...
     //   NSLog(@"can't retrieve the only CurrentSpot entry");
    }
    else{
        [mo[0] setValue:obs.name forKey:@"name"];
    }
    
    [context2 save:NULL];
    
    
   //while ([resultBird next]) {
        
}

    
    
//}

#pragma mark - Fetched results controller

//- (IBAction)dismissMe:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
//}

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
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (name CONTAINS [cd] %@)",  @"TestSpotPalm"];
    [fetchRequest setPredicate:predicate];
    
    
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
  
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  
  return _fetchedResultsController;
}

- (NSFetchedResultsController *) iscurrentSpotFetchedResultsController
{
    if (_iscurrentSpotFetchedResultsController != nil) {
        return _iscurrentSpotFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentSpot" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_last_changed" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:nil]; //@"isCurrent = 1"];
    [fetchRequest setPredicate:predicate];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    //self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return aFetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
          [self configureCell:cell withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
     // [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
      break;
      
          
          
          
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

- (void)configureCell:(BirdTableViewCell *)mycell withObject:(Spot *)spot
{
    mycell.textLabel.text = spot.name;
    
    mycell.detailTextLabel.text = [NSString stringWithFormat:@"%@,  all obs:%@, %@, Duration: %@",spot.protocol,spot.allObs,spot.startTime,spot.duration];
    //[NSString stringWithFormat:@"%.3f, %.3f", spot.latitude, spot.longitude];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[[segue destinationViewController] setSpot:self.spot];
    
    if ([[segue identifier] isEqualToString:@"addBird"]) {
        
 //       [[segue destinationViewController] setSpot:obs];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Spot *spot = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [[segue destinationViewController] setSpot:spot];
        
    }
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx
                                            inView:(UIView *)view {
  if (idx && view) {
    Spot *spot = [self.fetchedResultsController objectAtIndexPath:idx];
    return [[[spot objectID] URIRepresentation] absoluteString];
  }
  else {
    return nil;
  }
}

- (NSIndexPath *)
indexPathForElementWithModelIdentifier:(NSString *)identifier
                                inView:(UIView *)view {
  if (identifier && view) {
    NSUInteger numberOfRows =
    [self tableView:self.tableView numberOfRowsInSection:0];
    for (NSUInteger index = 0; index < numberOfRows; ++index) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index
                                                   inSection:0];
      Spot *spot = [self.fetchedResultsController
                    objectAtIndexPath:indexPath];
      if ([spot.objectID.URIRepresentation.absoluteString
           isEqualToString:identifier]) {
        return indexPath;
      }
    }
  }
  return nil;
}



@end
