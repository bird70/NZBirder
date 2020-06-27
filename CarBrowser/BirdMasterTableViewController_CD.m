//
//  BirdMasterTableViewController_CD.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 23/06/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdMasterTableViewController_CD.h"
#import "BirdDetailViewController_CD.h"
#import "ModelController.h"
#import "AudioToolbox/AudioToolbox.h"
#import "BirdTableViewCell.h"
//#import "Spot.h"
#import "Bird_attributes.h"


@interface BirdMasterTableViewController_CD ()
{
    NSArray * IndexTitles;
}
@end


@implementation BirdMasterTableViewController_CD
@synthesize segmentControl;
@synthesize spot;
@synthesize p_colour;
@synthesize p_beak_colour, p_beak;
@synthesize p_legs;
@synthesize selectedScrollIndex;
@synthesize BEAK_SELECTED;
@synthesize pickerPredicate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //self.fetchedResultsController = self.fetchedResultsController;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

    self.title = spot.name;
        
    self.p_flightless = [[NSArray alloc] initWithObjects:
                         @"FLY", @"yes", @"no", nil];
    
    //self.p_big_or_small = [[NSArray alloc] initWithObjects:     @"S/M", "L/XL", nil];
    
    //self.p_land_or_water = [[NSArray alloc] initWithObjects:
     //                       @"land", @"water", nil];
    
    self.p_colour = [[NSArray alloc] initWithObjects:
                   @"COL", @"brown", @"green", @"grey",
                   @"blue", @"red", @"yellow",  @"black", @"white", nil];
    
    self.p_beak_colour = [[NSArray alloc]
                        initWithObjects:  @"BILL", @"brow",@"yell", @"grey", @"red", @"oran",@"black", nil];
    
    self.p_beak = [[NSArray alloc] initWithObjects:
                 @"BILL",@"short", @"medium", @"long", @"pointed", @"curved", @"duck", @"hook", nil];
    
//    self.p_legs = [[NSArray alloc] initWithObjects:
//                 @"LEGS", @"red", @"yell", @"brow", @"oran", @"black", nil];
//    
    self.p_legs = [[NSArray alloc] initWithObjects:
                 @"SIZE", @"sparrow", @"blackbird", @"pigeon", @"duck", @"goose", @"swan",@"albatross", @"ostrich", nil];
    
 
    IndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];

    
}





- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedScrollIndex = &row;
    
    // We want to use a search for the combined attributes selected using the PickerView
    
    NSUInteger selectedRow1 = [pickerView selectedRowInComponent:0];
    NSUInteger selectedRow2 = [pickerView selectedRowInComponent:1];
    NSUInteger selectedRow3 = [pickerView selectedRowInComponent:2];
    NSUInteger selectedRow4 = [pickerView selectedRowInComponent:3];
   
    NSString * pick1comp = [[pickerView delegate] pickerView:pickerView titleForRow:selectedRow1 forComponent:0];
    NSString * pick2comp = [[pickerView delegate] pickerView:pickerView titleForRow:selectedRow2 forComponent:1];
    NSString * pick3comp = [[pickerView delegate] pickerView:pickerView titleForRow:selectedRow3 forComponent:2];
    NSString * pick4comp = [[pickerView delegate] pickerView:pickerView titleForRow:selectedRow4 forComponent:3];
        
        NSPredicate *predicateTemplate4 = [NSPredicate
                                        predicateWithFormat:@"behaviour CONTAINS[c] %@", pick1comp];
        
        NSPredicate *predicateTemplate = [NSPredicate
                                          predicateWithFormat:@"colour CONTAINS [c] %@", pick2comp];
        NSPredicate *predicateTemplate2 = [NSPredicate
                                          predicateWithFormat:@"size_and_shape CONTAINS [c] %@", pick3comp];
//    NSPredicate *predicateTemplate2 = [NSPredicate
//                                       predicateWithFormat:@"leg_colour CONTAINS [c] %@", pick2comp];
    NSPredicate *predicateTemplate3 = [NSPredicate
                                          predicateWithFormat:@"beak_length CONTAINS [c] %@", pick4comp];


        
    NSCompoundPredicate *comppredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateTemplate4,predicateTemplate,predicateTemplate2,predicateTemplate3]];//,predicateTemplate4]];
                                              //,predicateTemplate2,predicateTemplate3,predicateTemplate4]];
                                         
        pickerPredicate = comppredicate;
        NSLog(@"%@",pickerPredicate);
    
    
    [self buttonPick:pickerPredicate];  
    

    
}



- (void)viewWillLayoutSubviews
{
    [super viewWillAppear:YES];
    
    
    self.fetchedResultsController = self.fetchedResultsController;
    //[self.navigationController  setNavigationBarHidden:NO animated:NO];
    
    
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birdTableCell"];
    [self configureCell:cell withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}


// INSERTED 27/06/20 ==>

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return IndexTitles;
//}
////
////- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
////    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
////}
//
////- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
////    if ([[self->IndexTitles objectAtIndex:section] count] > 0) {
////        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
////    }
////    return nil;
////}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}
//

// INSERTED 27/06/20 <==


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showBirdDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Bird_attributes *bird = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [[segue destinationViewController] setSpot:spot];
    
            //BirdDetailViewController_CD *bdVC = [segue destinationViewController];
            //bdVC.spot = sender;
            NSLog(@"Spotname for segue from Birdmaster to Birddetail : %@", spot.name);
        
        [[segue destinationViewController] setBird:bird];
    }
}
#pragma mark - Fetched results controller
/*
NSSet *projectTodoEntities = [mySelectedProject valueForKey:@"todos"];
NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"myKey" ascending:YES];
NSArray *sortedToDos = [projectTodoEntities sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];

*/

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"habitat  == [c] %@ OR habitat == [c] %@ OR habitat == [c] %@", @"garden", @"coast", @"bush"];
    //[fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil] ; //]@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Master Fetched Results controller - Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)gardenFetchedResultsController
{
    if (_gardenFetchedResultsController != nil) {
        return _gardenFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.habitat contains[cd] %@", @"bush"];
    //[fetchRequest setPredicate:predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitat CONTAINS [cd] 'garden'"];
    [fetchRequest setPredicate:predicate];

//    NSPredicate *predicateTemplate_beak = [NSPredicate
//                                      predicateWithFormat:@"beak like[c] $BEAK_SELECTED"];
    //NSCompoundPredicate *predicate = [[NSCompoundPredicate andPredicateWithSubpredicates:
    //                                   @[predicateTemplate_beak,predicateTemplate_beak]];//, lessThanPredicate]];
//    [fetchRequest setPredicate:predicateTemplate_beak];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];//@"garden"];
    aFetchedResultsController.delegate = self;
    self.gardenFetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.gardenFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _gardenFetchedResultsController;
}

- (NSFetchedResultsController *)bushFetchedResultsController
{
    if (_bushFetchedResultsController != nil) {
        return _bushFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.habitat contains[cd] %@", @"bush"];
    //[fetchRequest setPredicate:predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitat CONTAINS [cd] 'bush'"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];//@"bush"];
    aFetchedResultsController.delegate = self;
    self.bushFetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.bushFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _bushFetchedResultsController;
}

- (NSFetchedResultsController *)coastFetchedResultsController
{
    if (_coastFetchedResultsController != nil) {
        return _coastFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5];
    
    // Edit the sort key as appropriate
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.habitat contains[cd] %@", @"bush"];
    //[fetchRequest setPredicate:predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitat CONTAINS [cd]  'coast'"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];//@"coast"];
    aFetchedResultsController.delegate = self;
    self.coastFetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.coastFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _coastFetchedResultsController;
}

- (NSFetchedResultsController *)allFetchedResultsController
{
    if (_allFetchedResultsController != nil) {
        return _allFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.habitat contains[cd] %@", @"bush"];
    //[fetchRequest setPredicate:predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:nil]; //@"all = 1"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.allFetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.allFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _allFetchedResultsController;
}


- (NSFetchedResultsController *)pickFetchedResultsController
{
    if (_pickFetchedResultsController != nil) {
        return _pickFetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird_attributes" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
//    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.habitat contains[cd] %@", @"bush"];
//    //[fetchRequest setPredicate:predicate];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitat CONTAINS [cd] 'garden'"];
//    [fetchRequest setPredicate:predicate];
    
      //  NSPredicate *predicateTemplate_beak = [NSPredicate
      //                                    predicateWithFormat:@"beak like[c] $BEAK_SELECTED"];
    //NSCompoundPredicate *predicate = [[NSCompoundPredicate andPredicateWithSubpredicates:
    //                                   @[predicateTemplate_beak,predicateTemplate_beak]];//, lessThanPredicate]];
    
    [fetchRequest setPredicate:pickerPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.pickFetchedResultsController = aFetchedResultsController;
    
	
    
    NSError *error = nil;
	if (![self.pickFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return _pickFetchedResultsController;
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject]; //atIndexPath:indexPath];
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

// configure what's shown using the Cell Template
- (void)configureCell:(BirdTableViewCell *)cell withObject:(Bird_attributes *)bird
{
    //NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithData:[bird valueForKey:@"thumbnail"]];
    [[cell imageView] setImage:image];
    [[cell nameLabel] setText:[bird name]];
    [[cell othernameLabel] setText:[bird othername]];
    
}



- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx
                                            inView:(UIView *)view {
    if (idx && view) {
        Bird_attributes *bird = [self.fetchedResultsController objectAtIndexPath:idx];
        return [[[bird objectID] URIRepresentation] absoluteString];
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
            Bird_attributes *bird = [self.fetchedResultsController
                          objectAtIndexPath:indexPath];
            if ([bird.objectID.URIRepresentation.absoluteString
                 isEqualToString:identifier]) {
                return indexPath;
            }
        }
    }
    return nil;
}
- (IBAction)segmentControl:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex) {
 
        case 0:
            self.fetchedResultsController = self.allFetchedResultsController;
            NSLog(@"case 1 - all");
            break;
            
        case 1:
            self.fetchedResultsController = self.gardenFetchedResultsController;
             NSLog(@"case 1 - garden");
            break;
        case 2:
            self.fetchedResultsController = self.coastFetchedResultsController;
             NSLog(@"case 2 - coast");
            break;
        case 3:
            self.fetchedResultsController = self.bushFetchedResultsController;
             NSLog(@"case 3 - bush");
            break;
//        case 4:
//            self.fetchedResultsController = self.pickFetchedResultsController;
//            NSLog(@"case 4 - pick");
//            [self showPicker:sender];
//            break;
default:
            break;
            
    }
    NSError *error = nil;
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    if (![context save:&error]) {
        NSLog(@"Core data error when fetching all results %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"reloading");
    [self.tableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    // DO WE STILL NEED THIS?
//    self.allFetchedResultsController = nil;
//    self.bushFetchedResultsController = nil;
//    self.gardenFetchedResultsController = nil;
//    self.fetchedResultsController = nil;
//    self.coastFetchedResultsController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    // DO WE STILL NEED THIS?
    //self.navigationController.navigationBar.hidden = NO;
    
}

//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
//    for (UIView *_currentView in actionSheet.subviews) {
//        if ([_currentView isKindOfClass:[UIButton class]]) {
//            [((UIButton *)_currentView) setFont:[UIFont boldSystemFontOfSize:11.f]];
//        }
//    }
//}

- (void) showPicker:(id)sender {
   // this is called when pressing the magnifying glass
    NSLog(@"Going off to find bird");
    
    NSError *error = nil;
    //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    self.fetchedResultsController = self.pickFetchedResultsController;
    
    
    
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"reloading");
    [self.tableView reloadData];
    
    //self.fetchedResultsController = nil;
    self.pickFetchedResultsController = nil;
    
    // DO WE STILL NEED THIS?
//    // UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Pick Bird Attributes"
//        //                                              delegate:self
//          //                                   cancelButtonTitle:@"Find"
//                                        //destructiveButtonTitle:@"Cancel"
//                                          //   otherButtonTitles:nil];
//    // Add the picker
//    //UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,185,0,0)];
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
//    
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
//    
//    pickerView.showsSelectionIndicator = YES;    // note this is default to NO
//    [self.view addSubview:pickerView];
//   // [menu addSubview:pickerView];
//   // [menu showInView:self.view];
//    [pickerView setBounds:CGRectMake(0,0,320, 320)];
    
}
#pragma mark -
#pragma mark PickerView DataSource


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
        return [self.p_flightless count];
    else if (component == 1)
        return [self.p_colour count];
    else if (component == 2)
        return [self.p_legs count];
    else
        //(component == 3)
        return [self.p_beak count];
//    else
//        return [self.p_beak_colour count];
//    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0)
        return [self.p_flightless objectAtIndex:row];
    else if (component == 1)
        return [self.p_colour objectAtIndex:row];
    else if (component == 2)
        return [self.p_legs objectAtIndex:row];
    else
        //if (component == 3)
        return [self.p_beak objectAtIndex:row];
//    else
//        return [self.p_beak_colour objectAtIndex:row];
//    
}


- (IBAction)buttonPick:(id)sender {
   // [self showPicker:sender];
    NSLog(@"Going off to find bird");
    
    NSError *error = nil;
    
    
    //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    self.fetchedResultsController = self.pickFetchedResultsController;
    
    
    
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"reloading");
    [self.tableView reloadData];
    
    //self.fetchedResultsController = nil;
    self.pickFetchedResultsController = nil;
     NSLog(@"Spotname in buttonPick_BMVC: %@", self.spot.name);
}
@end
