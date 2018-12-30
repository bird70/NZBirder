//
//  BirdDetailViewController_CD.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 1/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdDetailViewController_CD.h"
#import "BirdMasterTableViewController_CD.h"
#import "ModelController.h"
#import "Bird_attributes.h"
#import "AudioToolbox/AudioToolbox.h"
#import "MasterViewController.h"
#import "BrowserViewController.h"
#import "Observation.h"
#import "ObservationTableViewController.h"

@interface BirdDetailViewController_CD ()


@end

@implementation BirdDetailViewController_CD
@synthesize bird;
//@synthesize birdtableviewcell;
@synthesize birddescription;
//@synthesize favStatusSwitch;
@synthesize beakLabel;
@synthesize legLabel;
@synthesize sizeLabel;
//@synthesize behaviorLabel;
@synthesize statusLabel;
@synthesize familyLabel;
@synthesize birdname;
@synthesize myCurrentSpot;
@synthesize mySpot;
@synthesize currentspotname;
@synthesize allobs;
@synthesize moID;
@synthesize spot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setupSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeGestureRight.direction = (UISwipeGestureRecognizerDirectionRight );
    [self.view addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeGestureLeft.direction = (UISwipeGestureRecognizerDirectionLeft );
    [self.view addGestureRecognizer:swipeGestureLeft];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)gesture {
    //NSLog(@"Swipe received.");//Lets you know this method was called by gesture recognizer.
    //NSLog(@"Direction is: %i", gesture.direction);//Lets you know the numeric value of the gesture direction for confirmation (1=right).
    //only interested in gesture if gesture state == changed or ended (From Paul Hegarty @ standford U
    
    //NSLog(@"Direction is: %lu", (unsigned long)gesture.direction);
    
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        if (gesture.direction == 1){
        //do something for a right swipe gesture.
        [self.navigationController popViewControllerAnimated:YES];
       // [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
        else
        {
            [self performSegueWithIdentifier:@"showBirdDetails" sender:spot];
        }
            }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setupSwipeGestureRecognizer];
    
    if (self.bird.sound){
            self.hearMeButton.hidden = NO;
            }
    else {
            self.hearMeButton.hidden = YES;
            }
//    UIImage *image = [UIImage imageWithData:[self.bird valueForKey:@"image"]];
//    [[self imageView] setImage: image];
    
    
    //self.birdtableviewcell.accessoryType = UITableViewCellAccessoryCheckmark;
//    self.birdtableviewcell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:13.0f];
//    self.birdtableviewcell.textLabel.text = self.bird.name;
//    self.birdtableviewcell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
//    self.birdtableviewcell.detailTextLabel.text = self.bird.family;
//    
    birdname = self.bird.short_name;
    self.title = self.spot.name ;
    NSLog(@"spot name in viewDidLoad BDVC: %@", self.spot.name);
    self.birddescription.text = self.bird.item_description;
    self.beakLabel.text = self.bird.beak_length;
    //self.bird.
    self.legLabel.text = self.bird.leg_colour;
    self.statusLabel.text = self.bird.threat_status;
    //self.behaviorLabel.text = self.bird.behaviour;
    self.labelScName.text = self.bird.short_name;
    self.billcolourLabel.text = self.bird.beak_colour;
    self.familyLabel.text = self.bird.family;
    self.sizeLabel.text = self.bird.size_and_shape;
    
    
    //NSLog(@"Here comes a favourite or not, %@", bird.favourite);
    
//    if (
//        bird.favourite == [NSNumber numberWithInt:1]
//         
//        )
//            {
//                [self.favStatusSwitch setOn:YES animated:NO];
//                 //NSLog(@" I'm a Favourite: YES");
//            }
//    else if (
//      bird.favourite == [NSNumber numberWithBool:0]
//        )   
//            {
//                [self.favStatusSwitch setOn:NO animated:YES];
//                //NSLog(@"Favourite: NO");
//                }
//    else
//        NSLog(@"Favourite: Unknown");
        
//    //override output for Audio: always play on Speaker first
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
   // IMAGE ACCESS redefined
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:[[self bird] image]
                                        ofType:@"jpg"]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *imageSave=[[UIImage alloc]initWithData:data];
     [[self imageView] setImage: imageSave];
    
    // IMAGE ACCESS redefined END

    
    NSURL *sndurl = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:[[self bird ]sound]
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:sndurl
                   error:&error];
    if (error)
    {
//        NSLog(@"Error in audioPlayer: %@",
//              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    
    //==============================
    // Find CurrentObject
    //==============================
    //Find  ID of the currentSpot
    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CurrentSpot" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //
    //    // Set predicate and sort orderings...
    //    NSPredicate *predicate =  nil; //[NSPredicate predicateWithFormat:
    //                              //@"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
    //    [request setPredicate:predicate];
    //
    //    NSSortDescriptor *sortDescriptor = nil; //[[NSSortDescriptor alloc]
    //                                        //initWithKey:@"name" ascending:YES];
    //    [request setSortDescriptors:@[sortDescriptor]];
    //
    //NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    //
    if (array == nil)
    {
        // Deal with error...
        NSLog(@"Can't retrieve currentSpot ID");
    }
    else
    {
        myCurrentSpot = array[0];
        //NSString *newStr = myCurrentSpot.name;
        currentspotname = myCurrentSpot.name;
        
      //  NSLog(@"currentspot first request id: %@", currentspotname);
    }

    
    

    // USE THE NAME of CURRENTSPOT to FIND the SPoT which it is so that we can send it to ObservationTableViewController through Segue
    NSEntityDescription *entityDescription2 = [NSEntityDescription
                                               entityForName:@"Spot" inManagedObjectContext:moc];
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entityDescription2];

    // Set predicate and sort orderings...
   // NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(name LIKE[c] '%@')", currentspotname];
 //   [request2 setPredicate:predicate];
    //
    //    NSSortDescriptor *sortDescriptor = nil; //[[NSSortDescriptor alloc]
    //                                        //initWithKey:@"name" ascending:YES];
    //    [request setSortDescriptors:@[sortDescriptor]];
    //
    //    //NSError *error;
    NSArray *array2 = [moc executeFetchRequest:request2 error:&error];
    //
    if (array2 == nil)
    {
        // Deal with error...
       // NSLog(@"Can't retrieve Spot for CurrentSpot");
    }
    else
    {
        mySpot = array2[0];
        //find ObjectID for the Spot with currentSpotname
        moID = [mySpot objectID];
       // NSLog(@"ObjectUD for mySpot: %@", moID);
        //txs 12/15 NSString *newStr2 = mySpot.name;
        
        //NSLog(@"spot name/id: %@", newStr2);
        Spot *tempSpot ;
        tempSpot = [moc objectRegisteredForID:moID];
       //txs 12/15  NSString *newStr3 = tempSpot.name;
        
        //NSLog(@"tempSpot name/id: %@", newStr3);
        
    }
    
   //NSLog(@"currentspot ( before segue )id: %@", currentspotname);
    
    //find existing observations, put in an NSSet so that we can add this new observation to it
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    
  
    
}

// Set up the text and title as the view appears
- (void) viewDidAppear: (BOOL) animated
{
     //self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    self.navigationController.navigationBar.hidden = NO;
    // match the title to the text view
    
    self.title = self.bird.othername;
    
    //Bird_attributes *bird = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    //self.presentingViewController.view.autoresizingMask =
    //UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)viewWillDisappear:(BOOL)animated {
   
//    if ([self.favStatusSwitch isOn] == TRUE)
//    {
//        [bird setFavourite:[NSNumber numberWithBool:1]];
//        //NSLog (@"Fav Status is on");
//    }
//    else if ([self.favStatusSwitch isOn] == NO)
//    {
//        [bird setFavourite:[NSNumber numberWithBool:0]];
//        //NSLog (@"Fav Status is off");
//    }
//    else
//        NSLog(@"Fav Stauts is unknown");
    
//    [[ModelController sharedController] saveContext];
    self.navigationController.navigationBar.hidden = NO;
    
}





- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bird = nil;
    audioPlayer = nil;
    allobs = nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"countBird"]) {
        //[[segue destinationViewController] setSpot:self.spot];
//        NSLog(@"preparing for Segue countBird in BirdDetailViewController for birdname: %@", self.spot.name);
//        //
        //[[segue destinationViewController] setBird: self.bird];
//        NSLog(@"countBird Segue");
//          NSLog(@"preparing for Segue countBird in BirdDetailViewController for birdname: %@", birdname);
       ObservationTableViewController *mvc = [segue destinationViewController];
        
        
        [mvc setSpot: spot];
        [mvc setSpotID: moID];
//        
        //============================================
        //someBird has been observed, create object:
        //===========================================
        NSManagedObjectContext *context = [[ModelController sharedController] managedObjectContext];
        Observation *newManagedObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Observation" inManagedObjectContext:context];
        //Set Observations attributes
        int valueHeard = (int)(self.sliderHeard.value);
        //int valueSeen = (int)(self.sliderSeen.value);
        
        
        [newManagedObject1 setValue:self.birdname forKey:@"bird_observed"];
        [newManagedObject1 setValue:[NSNumber numberWithInt:valueHeard] forKey:@"number_heard"];
        //[newManagedObject1 setValue:[NSNumber numberWithInt:valueSeen] forKey:@"number_seen"];
        [newManagedObject1 setValue:self.spot forKey:@"observation_atSpot"];
      
        //[self.allobs addObject:newManagedObject1];
        
        //add the bird to the spot where it has been seen
        [self.spot addObservationsObject:newManagedObject1];
        //[mySpot setValue:self.allobs forKey:@"observations"];
        NSError *error;
        if (![context save:&error]) {
       //     NSLog(@"Whoops, couldn't save new bird: %@", [error localizedDescription]);
        }
        //[context save:NULL];
        //Spot *newSpot = [newManagedObject1 objectRegisteredForID:moID]
        
        //txs 12/15 NSString *ObservationName = [newManagedObject1 valueForKeyPath:@"Observation_atSpot.name"];
        //NSLog(@"ObservationNSpotpotname is: %@", ObservationName);
        
        //txs 12/15 NSString *mySpotName = [mySpot valueForKeyPath:@"name"];
        //NSLog(@"mySpot name is: %@", mySpotName);
        //txs 12/15 NSString *myCurrSpotName = [myCurrentSpot valueForKeyPath:@"name"];
        
        //[context existingObjectWithID:moID];
        
        //NSManagedObjectID *myCurrSpotID = [[myCurrentSpot valueForKeyPath:@"name"] objectID];
        //NSLog(@"BDVC: myCurrentSpotname  for myCurrSpotID %@ is: %@",myCurrSpotID, myCurrSpotName);
        
        newManagedObject1 = nil;
        
          
        //NSLog(@"passing to countBird from BirdDetailViewController %@", birdname);
    }
    else
    {
        BrowserViewController *mvc = [segue destinationViewController];
        [mvc setExternalLink:self.bird.link];
        
    }
}



- (IBAction)sliderHeard:(UISlider *)sender {
        self.labelHeard.text = [NSString stringWithFormat:@"%.f", self.sliderHeard.value];
}

- (IBAction)countMe:(id)sender {
        
   
    
   [self performSegueWithIdentifier:@"countBird" sender:sender];
    
}

- (IBAction)hearMe:(id)sender {
    [audioPlayer play];
   // NSLog(@"Playing Audio" );
}

-(void)playAudio
{
    [audioPlayer play];
   // NSLog(@"Playing Audio" );
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Observation" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bird_observed" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"ObsMaster"];
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

//- (NSFetchedResultsController *) iscurrentSpotFetchedResultsController
//{
//    if (_iscurrentSpotFetchedResultsController != nil) {
//        return _iscurrentSpotFetchedResultsController;
//    }
//    
//    NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    // Edit the entity name as appropriate.
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentSpot" inManagedObjectContext:moc];
//    [fetchRequest setEntity:entity];
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:5];
//    
//    // Edit the sort key as appropriate.
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_last_changed" ascending:NO];
//    NSArray *sortDescriptors = @[sortDescriptor];
//    
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:nil]; //@"isCurrent = 1"];
//    [fetchRequest setPredicate:predicate];
//    
//    
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
//    aFetchedResultsController.delegate = self;
//    //self.fetchedResultsController = aFetchedResultsController;
//    
//	NSError *error = nil;
//	if (![aFetchedResultsController performFetch:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//	}
//    
//    return aFetchedResultsController;
//}



@end

