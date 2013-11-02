//
//  DetailViewController.m
//  BirdBrowser
//
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "DetailViewController.h"
#import "ModelController.h"
#import "MapViewAnnotation.h"
#import "ModelController.h"
#import "NSCoder+FavSpots.h"
#import "CHCSVParser.h"
#import <MessageUI/MessageUI.h>
#import "BirdMasterTableViewController_CD.h"


static NSString * const kSpotKey = @"kSpotKey";
static NSString * const kRegionKey = @"kRegionKey";
static NSString * const kNameKey = @"kNameKey";

CHCSVWriter * csvWriter;
MFMailComposeViewController * controller;

@interface DetailViewController ()
@property (nonatomic, readwrite, assign, getter = isRestoring) BOOL restoring;
@end

@implementation DetailViewController
@synthesize birdnotes, birdObservationCell;
@synthesize labelProtocol, labelAllObservations, labelDuration;


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];

  [coder RN_encodeSpot:self.spot forKey:kSpotKey];
  [coder RN_encodeMKCoordinateRegion:self.mapView.region forKey:kRegionKey];
    [coder encodeObject:self.birdObservationCell.textLabel.text forKey:kNameKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  
  _spot = [coder RN_decodeSpotForKey:kSpotKey];
  
  if ([coder containsValueForKey:kRegionKey]) {
    _mapView.region = [coder RN_decodeMKCoordinateRegionForKey:kRegionKey];
  }
    self.birdObservationCell.textLabel.text = [coder decodeObjectForKey:kNameKey];
 
  _restoring = YES;
}

- (void)viewDidLoad
{
  
    
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

    self.labelDuration.text = self.spot.duration;
    self.labelProtocol.text = self.spot.protocol;
    self.labelAllObservations.text = self.spot.allObs;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
    
  UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNoteTap:)];
    [self.noteTextView addGestureRecognizer:g];
 
    
    UITapGestureRecognizer *tap_cell = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(doNothing)];
    
    [self.view addGestureRecognizer:tap_cell];
    
    UIGestureRecognizer *g2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellTap:)];
    [self.birdObservationCell addGestureRecognizer:g2];
    
}


- (void)handleNoteTap:(UIGestureRecognizer *)g {
  [self performSegueWithIdentifier:@"editNote" sender:self];
}

- (void)handleCellTap:(UIGestureRecognizer *)g2 {
    [self performSegueWithIdentifier:@"showObservationsForSpot" sender:self];
}

- (void)dismissKeyboard
{
    [self.noteTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [labelProtocol resignFirstResponder];
    [labelAllObservations resignFirstResponder];
    [labelDuration resignFirstResponder];
    
    return YES;
}

- (void)doNothing
{
    //[self.noteTextView resignFirstResponder];
}

- (void)setSpot:(Spot *)newSpot
{
  if (_spot != newSpot) {
    _spot = newSpot;
    [self configureView];
  }
}

- (void)configureView {
  Spot *spot = self.spot;
    
    NSString *bird = self.birdname;
    self.title = bird;
    
    NSLog(@"Notes so far: %@", spot.notes);
    
    if (! self.isRestoring || self.birdObservationCell.textLabel.text.length == 0) {
        self.birdObservationCell.textLabel.text = spot.name;
        ;
  }

  if (! self.isRestoring ||
      self.mapView.region.span.latitudeDelta == 0 ||
      self.mapView.region.span.longitudeDelta == 0) {
    CLLocationCoordinate2D center =
    CLLocationCoordinate2DMake(spot.latitude, spot.longitude);
    self.mapView.region =
    MKCoordinateRegionMakeWithDistance(center, 500, 500);
  }
  
  //self.locationLabel.text =
  // [NSString stringWithFormat:@"(%@)",
  //  spot.name];
    
  //self.coordinateLabel.text =
  //  [NSString stringWithFormat:@"%.3f, %.3f",
  //   spot.latitude, spot.longitude];
    //birdnotes = (@"Observation notes: %@, %@", spot.notes, self.birdname);
    //NSLog(@"die birdnotes sind: %@", birdnotes);
    
    self.noteTextView.text = spot.notes;
    //self.noteTextView.text = self.birdnotes;
    self.birdObservationCell.textLabel.text = spot.name;
    self.birdObservationCell.detailTextLabel.text =  [NSString stringWithFormat:@"%.3f, %.3f", spot.latitude, spot.longitude];
  //self.labelProtocol =
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotation:
   [[MapViewAnnotation alloc] initWithSpot:spot]];
  
  //  self.labelSeen.text = @"%@",self.sliderSeen.value;
  //  self.labelHeard.text = @"%@",self.sliderHeard.value;
    
  self.restoring = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self configureView];
    {
        
    
    }
        
}

- (void)viewWillDisappear:(BOOL)animated
{
  self.spot.name = 
    self.birdObservationCell.textLabel.text;
    self.spot.duration = self.labelDuration.text;
    self.spot.allObs = self.labelAllObservations.text;
    self.spot.protocol = self.labelProtocol.text;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  //[[segue destinationViewController] setSpot:self.spot];
    if ([[segue identifier] isEqualToString:@"editNote"]) {
    [[segue destinationViewController] setSpot:self.spot];
  }
  else if ([[segue identifier] isEqualToString:@"showObservationsForSpot"]) {
        [[segue destinationViewController] setSpot:self.spot];
      }
  else if ([[segue identifier] isEqualToString:@"addBird"]) {
      [[segue destinationViewController] setSpot:self.spot];
      //[[segue destinationViewController] setNumber_heard:self.sliderHeard.value];
      //[[segue destinationViewController] setNumber_seen:self.sliderSeen.value];
  }
       NSLog(self.spot.name);
    
}
- (IBAction)addBird:(id)senderv{
//    Spot *spot = self.spot;
    NSString *mySpot = self.spot.name;
    NSLog(@"in addBirdSegue spotname: %@",mySpot);
//    BirdMasterTableViewController_CD *masterVC = [segue destinationViewController];
//    masterVC.spot = spot;
    [self performSegueWithIdentifier:@"addBird" sender:self];
    
}

//- (IBAction)dismissKeyboardfromLabel:(id)sender {
//    [labelProtocol resignFirstResponder];
//}

- (IBAction)mailMe:(id)sender {
    
//    Spot *spot = self.spot;
    NSString *mySpot = self.spot.name;
    //NSString *myLat = [NSString stringWithFormat:]spot.latitude;
    
    NSLog(@"ObjectID for %@, %@",self.spot.name, self.spot.objectID);
    //NSLog(@"ObjectID moID %@", spotID);
    
    //NSString *spotName = @"Johannesburg";//self.spot.name;
    NSLog(@"spotName in DetailVController: %@",self.spot.name);
    //NSLog(@"spotName in ObservationTVController: %@",mySpot);
    
    //	if (![spotName length] > 0) {
    //		spotName = @"Unnamed spot";
    //	}
	
    // spotName   =
    
//	// Display all the obs, so fetch then using the spot's context.
//	// Put the fetched obs into a mutable array.
//	NSManagedObjectContext *context = spot.managedObjectContext;
//	
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Observation"
//											  inManagedObjectContext:context];
//	[fetchRequest setEntity:entity];
//	
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bird_observed"
//																   ascending:YES];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//	[fetchRequest setSortDescriptors:sortDescriptors];
//	
//    //  NSManagedObjectID  *obsSpotID = [spot valueForKey:@"objectID"];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observation_atSpot.name= %@", self.spot.name];
//    [fetchRequest setPredicate:predicate];
//    ////
//    
//    NSError *error;
//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//	if (fetchedObjects == nil) {
//		// Handle the error.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
//	
//	NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
//	
//    for (NSString *columnname in mutableArray) {
//        
//        //id value = [resultRow objectForKey:columnname];
//        //[csvWriter writeField:columnname];
//        //[
//        // csvWriter writeField:value];
//        NSLog(@" is : ...");//,columnname);//, value);
//        
//    
    //self.tagsArray = mutableArray;
	

    
//    }
    
    
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"NZBirder.sqlite"];
    NSLog(docsPath);
//    
//    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
//    [db open];
//    
    
    
    //create CSVWriter object with a file
    NSString *fullPath = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.csv", @"CSVfile"]];
    NSLog(@"DocumentPath: %@", fullPath);
    CHCSVWriter *csvWriter =[[CHCSVWriter alloc] initForWritingToCSVFile:fullPath ];;
   
    //   -----------  ALTERNATIVE
    
    
    //CHCSVWriter *cvsExport = [[CHCSVWriter alloc] initWithCSVFile:[fileURL absoluteString] atomic:NO];
    
    NSManagedObjectContext *context = self.spot.managedObjectContext;
	
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
           
    //NSString *empty = @"empty";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
     NSString *datumString = [dateFormat stringFromDate:self.spot.date_last_changed];
    
    
    NSString *veryempty = @"  ";
    for (Observation *obs in mutableArray) {
        [csvWriter writeField:obs.bird_observed];
        [csvWriter writeField:veryempty];
        [csvWriter writeField:veryempty];
        NSNumber *sum = [NSNumber numberWithFloat:([obs.number_heard floatValue] + [obs.number_seen floatValue])];
        [csvWriter writeField:[sum stringValue]];
        // [csvWriter writeField:obs.number_seen];
      
        [csvWriter writeField:veryempty];
        [csvWriter writeField:self.spot.name];
        
        [csvWriter writeField:[NSString stringWithFormat:@"%.3f", self.spot.latitude]];
        [csvWriter writeField:[NSString stringWithFormat:@"%.3f", self.spot.longitude]];
        //[csvWriter writeField:self.spot.date_last_changed];
        [csvWriter writeField:datumString];
        
        [csvWriter writeField:self.spot.startTime];
        [csvWriter writeField:veryempty];
        [csvWriter writeField:@"NZ"];
        [csvWriter writeField:self.spot.protocol];
        [csvWriter writeField:@"1"];
        [csvWriter writeField:self.spot.duration];
        [csvWriter writeField:self.labelAllObservations.text];
        [csvWriter writeField:veryempty];
        [csvWriter writeField:veryempty];
        
        [csvWriter writeField:self.spot.notes];
        
        [csvWriter finishLine];
    }
    [csvWriter closeStream];
    
    
    
    // -----------
    
    //NSString * ident = spot.name;
    //FMResultSet *resultBirdNumber = [db executeQuery:@"SELECT Z_PK FROM ZSpot WHERE  ZNAME= %@;", ident];

    
//    //deal with the bird
//    FMResultSet *resultBird = [db executeQuery:@"SELECT ZBIRD_OBSERVED, ZNUMBER_HEARD, ZNUMBER_SEEN FROM ZObservation ;"]; //WHERE ZOBSERVATION_ATSPOT = 1 ;"];
//    while ([resultBird next]) {
//        
//            NSDictionary *resultRow = [resultBird resultDictionary];
//        NSLog(@"RowCnt is %lu",(unsigned long)resultRow.count);
//        
//        NSArray *orderedKeys = [[resultRow allKeys] sortedArrayUsingSelector:@selector(compare:)];
//            // iterate over the array and write out each result row to CSV file
//            for (NSString *columnname in orderedKeys) {
//                
//                    id value = [resultRow objectForKey:columnname];
//                    //[csvWriter writeField:columnname];
//                    [csvWriter writeField:value];
//                NSLog(@" %@ is :%@",columnname, value);
//                
//             
//        
//            }
//        [csvWriter writeField:self.spot.name];
//        [csvWriter writeField:[NSString stringWithFormat:@"%.3f", self.spot.latitude]];
//        [csvWriter writeField:[NSString stringWithFormat:@"%.3f", self.spot.longitude]];
//        
//        NSLog(@"%@", mySpot);
//        NSLog([NSString stringWithFormat:@"%.3f, %.3f", self.spot.latitude, self.spot.longitude]);
//        
//        [csvWriter finishLine];
//    resultBird = nil;
//    resultRow = nil;
//    orderedKeys = nil;
//        [db close];
//        
//    }
//    
//    //deal with all other fields
//    FMResultSet *results = [db executeQuery:@"SELECT * FROM ZObservation WHERE ZOBSERVATION_ATSPOT = 1 ;"];
//    while ([results next]) {
//            NSDictionary *resultRow = [results resultDictionary];
//            NSArray *orderedKeys = [[resultRow allKeys] sortedArrayUsingSelector:@selector(compare:)];
//            // iterate over the array and write out each result row to CSV file
//            for (NSString *columnname in orderedKeys) {
//                id value = [resultRow objectForKey:columnname];
//              //  if ([columnname isEqual: @"ZBird_observed"]) {
//                    NSLog( @"Value for %@: %@", columnname, value);
//                    
//                    //write values out to CSV file
//                    [csvWriter writeField:value];
//                
//                   // [csvWriter writeField:[NSString stringWithFormat:@"%.3f, %.3f", spot.latitude, spot.latitude]];
//                   // 
//                    
//            //    }
////                else {
////                    [csvWriter writeField:value];
////                }
//                
//                
//                //[csvWriter writeField:[spot latitude]]
//                
//            }
//        
//        
//           // [csvWriter writeField:@"\n"];
//        
//    }
    
    NSData *csvData = [NSData dataWithContentsOfFile:fullPath];
    MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@""]];
    [controller setSubject:@"eBird CSV Observations Export"];
//    NSString * spotname = self.spot.name;
//    NSString * myObservationMessage = @"My Bird Observations at %@",spotname;
    [controller setMessageBody:@"My Bird Observations. \nKey to eBird Fields: Common Name/	 Genus/	 Species/	 Number/     Species Comments/     Location Name/	 Latitude/	 Longitude/	 Date/	 Start Time/     State,Province/ Country Code/     Protocol/   Number of Observers/     Duration/     All observations reported?/Effort Distance Miles/     Effort area acres/	 Submission Comments" isHTML:NO];
    //[controller set]
    [controller addAttachmentData:csvData  mimeType:@"text/csv" fileName:@"CSVfile.csv"];
    [self presentViewController:controller animated:YES completion:nil];
    
    
    

}


//-(NSString *)getdate{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"MM-dd-yyyy"];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
//    //NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//    //[timeFormat setDateFormat:@"HH:mm:ss"];
//    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//    //[dateFormatter setDateFormat:@"EEEE"];
//    
//    NSDate *now = [[NSDate alloc] init];
//    NSString *dateString = [dateFormat stringFromDate:now];
//    NSString *theDate = [dateFormat stringFromDate:now];
//    //NSString *theTime = [timeFormat stringFromDate:now];
//    
//    //NSString *week = [dateFormatter stringFromDate:now];
//    NSLog(@"\n"
//          "dateString: |%@| \n"
//          //"dateFormatter: |%@| \n"
//          "Now: |%@| \n"
//          //"Week: |%@| \n"
//          
//          , dateString,theDate);
//    
//    return dateString;
//    }

//#pragma mark -
//#pragma mark Compose Mail/SMS
//
//// Displays an email composition interface inside the application. Populates all the Mail fields.
//-(void)displayMailComposerSheet
//{
//	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	picker.mailComposeDelegate = self;
//	
//	[picker setSubject:@"Hello from California!"];
//	
//	
//	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
//	
//	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];
//	[picker setBccRecipients:bccRecipients];
//	
//	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//	NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
//	
//	// Fill out the email body text
//	NSString *emailBody = @"It is raining in sunny California!";
//	[picker setMessageBody:emailBody isHTML:NO];
//	
//	[self presentModalViewController:picker animated:YES];
//	[picker release];
//}



#pragma mark -
#pragma mark Compose Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	//feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
		NSLog( @"Result: Mail sending canceled");
			break;
		case MFMailComposeResultSaved:
		NSLog( @"Result: Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog( @"Result: Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog (@"Result: Mail sending failed");
			break;
		default:
			NSLog ( @"Result: Mail not sent" );
			break;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)buttonUpload:(id)sender {
    //NSURL *myURL = [NSURL URLWithString:@"http://ebird.org/ebird/import/upload.form?file=CSVfile.csv&fileType=sabini"];
    //[[UIApplication sharedApplication] openURL:myURL];
    self.flUploadEngine = [[FileUploadEngine alloc] initWithHostName:@"http://ebird.org/ebird/import/upload.form" customHeaderFields:nil];
}
@end
