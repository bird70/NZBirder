//
//  ModelController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 21/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//  later additions for version 1.3, 2.3
//
//  This is used both during deployment and runtime
//  If it finds that a local data store doesn't exist, a new one is created
//  To populate a sqlite DB with the contents of the script below a number of lines (114-194) must be commented and others uncommented 

#import "ModelController.h"
#import "Spot.h"
#import "CurrentSpot.h"

@interface ModelController ()
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (weak, nonatomic) NSString *spotname;
@end

@implementation ModelController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedController {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }

    // new after deprection warning ios9:
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BirdBrowser" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    BOOL firstRun=NO;
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSURL *documentsDirectory = [paths objectAtIndex:0];

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite"];
//    NSURL *storeURL_shm = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite-shm"];
//    NSURL *storeURL_wal = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite-wal"];
    //NSURL *storeURL_12 = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder12.sqlite"];
    //NSURL *preloadURL = [[self applicationDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite"];
//???this worked pre iOS and has stopped functioning starting with v8.0:    NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NZBirder" ofType:@"sqlite"]];
    //NSURL* preloadURL = [[NSBundle mainBundle] URLForResource:@"NZBirder_12" withExtension:@"sqlite"];
    NSString* preloadURLString = [[NSBundle mainBundle] pathForResource:@"Kakapo" ofType:@"mp3"];
    NSLog(@"preloadURLString"),preloadURLString;
    NSString *modelURLString = [[NSBundle mainBundle] pathForResource:@"BirdBrowser" ofType:@"momd"];
    NSLog(@"modelURLString"),modelURLString;
  //  NSURL *preloadURLPath = [NSURL fileURLWithPath:preloadURLString];
    NSURL* preloadURLPATH = [NSURL fileURLWithPath:modelURLString];
    
//     NSURL *preloadURL_wal = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NZBirder" ofType:@"sqlite-shm"]];
//     NSURL *preloadURL_shm = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NZBirder" ofType:@"sqlite-wal"]];
    //NSURL *storeURL = [documentsDirectory URLByAppendingPat	hComponent:@"NZBirder.sqlite"];
    
//    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"NZBirder.sqlite"];

    //UNCOMMENT ALTERNATIVELY:
    
//    //THIS TO DELETE from the Application Documents directory before ReCreating the SQLLITE DB                                //1st option
//    // must delete NZBirder.sqlite DB from the APPLICATION BUNDLE root FIRST! then put it back in after     //1st option
//    //to delete a stale SQLLite DB after schema changes                         //1st option
//    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite"];
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];        //1st option
//    //if using "new style" SQLLite store need to remove 3 files including _wal and _shm files
//    //[[NSFileManager defaultManager] removeItemAtURL:storeURL_shm error:nil];        //1st option
//    //[[NSFileManager defaultManager] removeItemAtURL:storeURL_wal error:nil];        //1st option
//    //[[NSFileManager defaultManager] removeItemAtURL:preloadURL error:nil];        //1st option
//    
//    //[[NSFileManager defaultManager] removeItemAtURL:storeURL_12 error:nil];        //1st option
//    
//    NSLog(@"Deleting DB");                                                      //1st option
//     firstRun = YES;                                                          //1st option
    
    //OR THIS
    // For App Deployment (2nd option) this needs to be uncommented.
    // In order to re-generate the SQLLITE DB this needs to be commented! (3rd option)
    // firstRun = NO;                                                           //2nd option (leave in); 3rd option comment

    //Easily check whether this is first run of app                         //2nd option (leave in); 3rd option comment
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
    //if (![[NSFileManager defaultManager] fileExistsAtPath:[preloadURL path]]) {
        //NSString *preloadURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NZBirder_orig.sqlite"];
        //NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NZBirder" ofType:@"sqlite"]];
    // 11/15    NSError* err = nil;
        
//        //3rd option uncomment following:
//        firstRun = YES;
//       // 3rd option comment the following expression (in curly brackets) to force it into "firstRun"
//       
//        NSLog(@"Copying DB");
//        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
//       //if (![[NSFileManager defaultManager] copyItemAtPath:<#(NSString *)#> toPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>:preloadURL toURL:storeURL error:&err]) {
//             firstRun = YES;
//             NSLog(@"Oops, couldn't copy preloaded data");
//        }                                                              //2nd option (leave in); 3rd option comment
    }                                                                   //2nd option (leave in);
    
    // comment this completely out with the 2nd option
    //AND THEN PRETEND IT's OUR FIRST RUN so as to create the SQLLite DB        //2nd option
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]){ // isDirectory:NULL]) {
		firstRun = YES;
        NSLog(@"this is my first run");
	}                                                                           //2nd option
    
   // comment this completely out with the 2nd option
    //v2 needs new options to switch back from write-ahead-logging mode in SQLLITe which is now the default in order to have only the sqlite DB file:
    NSDictionary *options = @{NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}, NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    NSError *error = nil;                                                       //2nd option
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];      //2nd option
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }                                                                                                               // end of 2nd option
    
    
    /*
	 If this is the first run, populate a new store with events whose timestamps are spaced every 7 days throughout 2013.
	 */
	if (firstRun) {
		NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
		
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setYear:2013];
		
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSInteger day;
		
         day = 1;
			[dateComponents setDay:day];
			NSDate *date = [calendar dateFromComponents:dateComponents];
            
            NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:date];
            

        NSError *error;
        //[context save:&error];
		//[context save:NULL];
       
        //Create 2 observation spots, make the second one the default location after install
        
        //Insert some Spot as an example
        NSManagedObject *newManagedSpotObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
        [newManagedSpotObject1 setValue:@"TestSpotPalm" forKey:@"name"];
        
        //_spotname = [NSString stringWithFormat:@"%@",@"Kettering at 01 Sep, 2013 21:04"];
        //NSLog (@"self.spotname is: %@", self.spotname);
        
        //Spot *spot = [Spot insertNewDefaultSpot:_spotname inManagedObjectContext:context];//Insert some other Spot as an example
//        NSManagedObject *newManagedSpotObject2  = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
//        [newManagedSpotObject2 setValue:@"DefaultSpot" forKey:@"name"];
        
//        [context save:&error];
        //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //    df.dateStyle = NSDateFormatterShortStyle;
        //    df.timeStyle = NSDateFormatterShortStyle;
        //    [NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
//        NSDate *now = [[NSDate alloc] init];
//        //NSDateComponents *dateComps =[now components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
//        //NSDate *beginningOfDay = [now dateFromComponents:dateComps];
//        // NSDate *date = [NSDate dateWithTimeIntervalSince1970:result];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"HH:mm:ss"];
//        NSString *localizedString = [formatter stringFromDate:now];
//        //v2: changed default protocol to stationary
//        //spot.date_last_changed = now;
//        //spot.name = @"DefaultSpot";
//        spot.latitude = 38.89104461669922;
//        spot.longitude = -76.81642150878906;
//        spot.notes = @" weather, # of observers in party:";
//        spot.protocol = @"Stationary";
//        //NSNumber *myNumber = [NSNumber numberWithInt:1];
//        //spot.isCurrent = myNumber;
//        spot.allObs = @"Y";
//        spot.startTime = localizedString;

//       //CurrentSpot *currentspot =
        NSManagedObject *newManagedSpotObject3 = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentSpot" inManagedObjectContext:context];
        [newManagedSpotObject3 setValue:@"DefaultSpot" forKey:@"name"];
        
        [context save:&error];
//        //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        //    df.dateStyle = NSDateFormatterShortStyle;
//        //    df.timeStyle = NSDateFormatterShortStyle;
//        //    [NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
////        NSDate *now = [[NSDate alloc] init];
////        //NSDateComponents *dateComps =[now components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
////        //NSDate *beginningOfDay = [now dateFromComponents:dateComps];
////        // NSDate *date = [NSDate dateWithTimeIntervalSince1970:result];
////        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////        [formatter setDateFormat:@"HH:mm:ss"];
////        NSString *localizedString = [formatter stringFromDate:now];
////        //v2: changed default protocol to stationary
//        //currentspot.date_last_changed = now;
//        currentspot.name = @"DefaultSpot";
//        currentspot.latitude = 38.89104461669922;
//        currentspot.longitude = -76.81642150878906;
////        currentspot = @" weather, # of observers in party:";
////        spot.protocol = @"Stationary";
////        NSNumber *myNumber = [NSNumber numberWithInt:1];
////        spot.isCurrent = myNumber;
////        spot.allObs = @"Y";
////        spot.startTime = localizedString;

        
        
        //NSManagedObject *newManagedSpotObject2  = [Spot insertNewDefaultSpot:self.spotname inManagedObjectContext:context];//Insert some other Spot as an example
        
//        NSManagedObject *newManagedSpotObject2 = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
//
//        [newManagedSpotObject2 setValue:@"Kettering at 01 Sep, 2013 21:04" forKey:@"name"];
//        
//        [newManagedSpotObject2 setValue:@"38.8910" forKey:@"latitude"];
//        [newManagedSpotObject2 setValue:@"-76.8164" forKey:@"longitude"];
//        [newManagedSpotObject2 setValue:@"6" forKey:@"ent"];
//        [newManagedSpotObject2 setValue:@"7" forKey:@"opt"];
//        [newManagedSpotObject2 setValue:@"Y" forKey:@"allobs"];
//        [newManagedSpotObject2 setValue:@"Y" forKey:@"iscurrent"];
//        [newManagedSpotObject2 setValue:@"none" forKey:@"notes"];
        
        [context save:&error];
		
        
        //someBird
        NSManagedObject *newManagedObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        NSLog(@"Morepork");
        
        
        //Set Bird_attributes: Morepork
        [newManagedObject1 setValue:@"Morepork" forKey:@"name"];
        [newManagedObject1 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject1 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject1 setValue:@"nocturnal,can fly silently" forKey:@"behaviour"];
        [newManagedObject1 setValue:@"1" forKey:@"category"];
        [newManagedObject1 setValue:@"brown" forKey:@"colour"];
        [newManagedObject1 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject1 setValue:@"Strigidae" forKey:@"family"];
        [newManagedObject1 setValue:@"bush" forKey:@"habitat"];
        
        
//        NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                             pathForResource:@"MoreporkMaunga"
//                                             ofType:@"jpg"]];
//        
//        NSData *data1 = [[NSData alloc] initWithContentsOfURL:url1];
//        UIImage *imageSave1=[[UIImage alloc]initWithData:data1];
//        NSData *imageData1 = UIImagePNGRepresentation(imageSave1);
//        
//        [newManagedObject1 setValue:imageData1 forKey:@"image"];
//        
        [newManagedObject1 setValue:@"MoreporkMaunga" forKey:@"image"];
        
        NSURL *url1t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"MoreporkMaunga_TN"
                                              ofType:@"jpg"]];
        
        NSData *data1t = [[NSData alloc] initWithContentsOfURL:url1t];
        UIImage *imageSave1t=[[UIImage alloc]initWithData:data1t];
        NSData *imageData1t = UIImagePNGRepresentation(imageSave1t);
        
        [newManagedObject1 setValue:imageData1t forKey:@"thumbnail"];
        
        
        
        [newManagedObject1 setValue:@"The morepork is NZ’s only surviving native owl. Often heard in the forest at dusk and throughout the night, the morepork is known for its haunting, melancholic call. It was introduced to New Zealand between 1906 and 1910 to try to control smaller introduced birds.\n\nMorepork are commonly found in forests throughout mainland New Zealand and on offshore islands. They are less common within the drier open regions of Canterbury and Otago. They are classified as not threatened.\n\nPhysical description\n\nMorepork are speckled brown with yellow eyes set in a dark facial mask. They have a short tail.\nThe females are bigger than the males.\nHead to tail they measure around 29cm and the average weight is about 175g.\nThey have acute hearing and are sensitive to light.\nThey can turn their head through 280 degrees.\n\nNocturnal birds of prey\n\nMorepork are nocturnal, hunting at night for large invertebrates including beetles, weta, moths and spiders. They will also take small birds, rats and mice. They fly silently as they have soft fringes on the edge of the wing feathers. They catch prey using large sharp talons or beak. By day they roost in the cavities of trees or in thick vegetation. If they are visible during the day they can get mobbed by other birds and are forced to move.\n\nNesting and breeding\nMorepork nest in tree cavities, in clumps of epiphytes or among rocks and roots.\nThe female can lay up to three eggs, but generally two, usually between September and November.\nThe female alone incubates the eggs for about 20 to 32 days during which time the male brings in food for her.\nOnce the chicks hatch, the female stays mainly on the nest until the owlets are fully feathered.\nThey fledge around 37-42 days.\nDepending on food supply often only one chick survives and the other may be eaten.\n\nMaori tradition\nIn Maori tradition the morepork was seen as a watchful guardian. It belonged to the spirit world as it is a bird of the night. Although the more-pork or ruru call was thought to be a good sign, the high pitched, piercing, ‘yelp’ call was thought to be an ominous forewarning of bad news or events." forKey:@"item_description"];
        [newManagedObject1 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject1 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/morepork-ruru/" forKey:@"link"];
        [newManagedObject1 setValue:@"Ruru" forKey:@"othername"];
        [newManagedObject1 setValue:@"Southern Boobook" forKey:@"short_name"];
        [newManagedObject1 setValue:@"Pigeon" forKey:@"size_and_shape"];
        [newManagedObject1 setValue:@"morepork" forKey:@"sound"];
        [newManagedObject1 setValue:@"non threatened" forKey:@"threat_status"];
        [newManagedObject1 setValue:false forKey:@"extra"];
        [newManagedObject1 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
		[context save:NULL];
        newManagedObject1 = nil;
//        data1 = nil;
//        imageSave1 = nil;
//        imageData1 = nil;
//        url1 = nil;
        
        //context = nil;
        
        
//        ///++++
        NSManagedObject *newManagedObject2 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        //NSLog(@"Fantail");
        
        //Set Bird_attributes: Fantail
        [newManagedObject2 setValue:@"Fantail" forKey:@"name"];
        [newManagedObject2 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject2 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject2 setValue:@"can fly, restless" forKey:@"behaviour"];
        [newManagedObject2 setValue:@"1" forKey:@"category"];
        [newManagedObject2 setValue:@"black,grey" forKey:@"colour"];
        [newManagedObject2 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject2 setValue:@"Monarchidae" forKey:@"family"];
        [newManagedObject2 setValue:@"garden,bush" forKey:@"habitat"];
        
        
//        NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                             pathForResource:@"Grey_Fantail"
//                                             ofType:@"jpg"]];
//        
//        NSData *data2 = [[NSData alloc] initWithContentsOfURL:url2];
//        UIImage *imageSave2=[[UIImage alloc]initWithData:data2];
//        NSData *imageData2 = UIImagePNGRepresentation(imageSave2);
//        
//        [newManagedObject2 setValue:imageData2 forKey:@"image"];
        [newManagedObject2 setValue:@"Fantail" forKey:@"image"];
        
        NSURL *url2t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Grey_Fantail_TN"
                                              ofType:@"jpg"]];
        
        NSData *data2t = [[NSData alloc] initWithContentsOfURL:url2t];
        UIImage *imageSave2t=[[UIImage alloc]initWithData:data2t];
        NSData *imageData2t = UIImagePNGRepresentation(imageSave2t);
        
        [newManagedObject2 setValue:imageData2t forKey:@"thumbnail"];
        
        
        [newManagedObject2 setValue:@"Known for its friendly ‘cheet cheet’ call and energetic flying antics, the aptly named fantail is one of the most common and widely distributed native birds on the New Zealand mainland.\n\nIt is easily recognized by its long tail which opens to a fan. \n\nT It is common in most regions of the country, except in the dry, open country of inland Marlborough and Central Otago, where frosts and snow falls are too harsh for it. It also breeds widely in Australia and some Pacific Islands.\n\nThe fantail is one of the few native bird species in New Zealand that has been able to adapt to an environment greatly altered by humans. Originally a bird of open native forests and scrub, it is now also found in exotic plantation forests, in orchards and in gardens. Fantails stay in pairs all year but high mortality means that they seldom survive more than one season.\nThe success of the species is largely due to the fantail’s prolific and early breeding. Juvenile males can start breeding between 2–9 months old, and females can lay as many as 5 clutches in one season, with between 2–5 eggs per clutch.\n\nFantail populations fluctuate greatly from year to year, especially when winters are prolonged or severe storms hit in spring. However, since they are prolific breeders, they are able to spring back quickly after such events.\nBoth adults incubate eggs for about 14 days and the chicks fledge at about 13 days. Both adults will feed the young, but as soon as the female starts building the next nest the male takes over the role of feeding the previous brood. Young are fed about every 10 minutes – about 100 times per day!\n\nIn Māori mythology the fantail was responsible for the presence of death in the world. Maui, thinking he could eradicate death by successfully passing through the goddess of death, Hine-nui-te-po, tried to enter the goddess’s sleeping body through the pathway of birth. The fantail, warned by Maui to be quiet, began laughing and woke Hine-nuite- po, who was so angry that she promptly killed Maui.\n\nDid you know?\n\nFantails use three methods to catch insects. The first, called hawking, is used where vegetation is open and the birds can see for long distances. Fantails use a perch to spot swarms of insects and then fly at the prey, snapping several insects at a time.\nThe second method that fantails use in denser vegetation is called flushing. The fantail flies around to disturb insects, flushing them out before eating them.\nFeeding associations are the third way fantails find food. Every tramper is familiar with this method, where the fantail follows another bird or animal to capture insects disturbed by their movements. Fantails frequently follow feeding silvereyes, whiteheads, parakeets and saddlebacks, as well as people.\n " forKey:@"item_description"];
        [newManagedObject2 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject2 setValue:@"http://en.wikipedia.org/wiki/Fantail" forKey:@"link"];
        [newManagedObject2 setValue:@"Piwakawaka" forKey:@"othername"];
        [newManagedObject2 setValue:@"New Zealand Fantail" forKey:@"short_name"];
        [newManagedObject2 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject2 setValue:@"fantail" forKey:@"sound"];
        [newManagedObject2 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject2 setValue:false forKey:@"extra"];
        [newManagedObject2 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
		[context save:NULL];
        newManagedObject2 = nil;
//        data2 = nil;
//        imageSave2 = nil;
//        imageData2 = nil;
//        url2 = nil;
        
        //context = nil;
        
        
        NSManagedObject *newManagedObject3 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        NSLog(@"Tui");
        //Set Bird_attributes Tui
        [newManagedObject3 setValue:@"Tui" forKey:@"name"];
        [newManagedObject3 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject3 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject3 setValue:@"can fly, great imitator of other birds" forKey:@"behaviour"];
        [newManagedObject3 setValue:@"1" forKey:@"category"];
        [newManagedObject3 setValue:@"black" forKey:@"colour"];
        [newManagedObject3 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject3 setValue:@"Meliphagidae/ Honeyeaters" forKey:@"family"];
        [newManagedObject3 setValue:@"bush,garden" forKey:@"habitat"];
        
        
//        NSURL *url3 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                             pathForResource:@"Tui_on_flax"
//                                             ofType:@"jpg"]];
//        
//        NSData *data3 = [[NSData alloc] initWithContentsOfURL:url3];
//        UIImage *imageSave3=[[UIImage alloc]initWithData:data3];
//        NSData *imageData3 = UIImagePNGRepresentation(imageSave3);
//       
//        [newManagedObject3 setValue:imageData3 forKey:@"image"];
        [newManagedObject3 setValue:@"Tui_on_flax" forKey:@"image"];
        
        NSURL *url3t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Tui_on_flax_TN"
                                              ofType:@"jpg"]];
        
        NSData *data3t = [[NSData alloc] initWithContentsOfURL:url3t];
        UIImage *imageSave3t=[[UIImage alloc]initWithData:data3t];
        NSData *imageData3t = UIImagePNGRepresentation(imageSave3t);
        
        [newManagedObject3 setValue:imageData3t forKey:@"thumbnail"];
        
        [newManagedObject3 setValue:@"Tūī are common throughout New Zealand in forests, towns and on off-shore islands. They are adaptable and are found not only in native forests, bush reserves and bush remnants but also in suburban areas, particularly in winter if there is a flowering gum about.\n\nCan often be heard singing their beautiful melodies long before they are spotted. \n\nIf you are fortunate to glimpse one you will recognise them by their distinctive white tuft under their throat, which contrasts dramatically with the metallic blue-green sheen to their underlying black colour.\n\nTūī are unique (endemic) to New Zealand and belong to the honeyeater family, which means they feed mainly on nectar from flowers of native plants such as kōwhai, puriri, rewarewa, kahikatea, pohutukawa, rātā and flax. Occasionally they will eat insects too. Tūī are important pollinators of many native trees and will fly large distances, especially during winter for their favourite foods.\nTūī will live where there is a balance of ground cover, shrubs and trees. Tūī are quite aggressive, and will chase other tūī and other species (such as bellbird, silvereye and kereru) away from good food sources.\n\nAn ambassador for successful rejuvenation\n\nA good sign of a successful restoration programme, in areas of New Zealand, is the sound of the tūī warbling in surrounding shrubs. These clever birds are often confusing to the human ear as they mimic sounds such as the calls of the bellbird. They combine bell-like notes with harsh clicks, barks, cackles and wheezes.\n\nBreeding facts\n\nCourting takes place between September and October when they sing high up in the trees in the early morning and late afternoon. Display dives, where the bird will fly up in a sweeping arch and then dive at speed almost vertically, are also associated with breeding. Only females build nests, which are constructed from twigs, fine grasses and moss.\n\nWhere can tūī be found\nThe tūī can be found throughout the three main islands of New Zealand. The Chatham Islands have their own subspecies of tūī that differs from the mainland variety mostly in being larger." forKey:@"item_description"];
        [newManagedObject3 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject3 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/tui/" forKey:@"link"];
        [newManagedObject3 setValue:@"Prosthemadera novaeseelandiae" forKey:@"othername"];
        [newManagedObject3 setValue:@"Tui" forKey:@"short_name"];
        [newManagedObject3 setValue:@"blackbird" forKey:@"size_and_shape"];
        [newManagedObject3 setValue:@"tui2" forKey:@"sound"];
        [newManagedObject3 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject3 setValue:NO forKey:@"extra"];
        [newManagedObject3 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
		[context save:NULL];
        newManagedObject3 = nil;
//        data3 = nil;
//        imageSave3 = nil;
//        imageData3 = nil;
//        url3 = nil;
        
        //context = nil;
        
        
         NSManagedObject *newManagedObject4 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        NSLog(@"Hihi");
        //Set Bird_attributes Stitchbird
        [newManagedObject4 setValue:@"Stitchbird" forKey:@"name"];
        [newManagedObject4 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject4 setValue:@"short,pointed,curved" forKey:@"beak_length"];
        [newManagedObject4 setValue:@"can fly, only bird to mate face to face" forKey:@"behaviour"];
        [newManagedObject4 setValue:@"1" forKey:@"category"];
        [newManagedObject4 setValue:@"brown" forKey:@"colour"];
        [newManagedObject4 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject4 setValue:@"Notiomystis" forKey:@"family"];
        [newManagedObject4 setValue:@"bush" forKey:@"habitat"];
      
//        NSURL *url4 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"Hihi_Stitchbird1"
//                                              ofType:@"jpg"]];
//        
//        NSData *data4 = [[NSData alloc] initWithContentsOfURL:url4];
//        UIImage *imageSave4=[[UIImage alloc]initWithData:data4];
//        NSData *imageData4 = UIImagePNGRepresentation(imageSave4);
//        
//        [newManagedObject4 setValue:imageData4 forKey:@"image"];
        [newManagedObject4 setValue:@"Hihi_Stitchbird1" forKey:@"image"];
        
        NSURL *url4t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Hihi_Stitchbird1_TN"
                                              ofType:@"jpg"]];
        
        NSData *data4t = [[NSData alloc] initWithContentsOfURL:url4t];
        UIImage *imageSave4t=[[UIImage alloc]initWithData:data4t];
        NSData *imageData4t = UIImagePNGRepresentation(imageSave4t);
        
        [newManagedObject4 setValue:imageData4t forKey:@"thumbnail"];
        
        
        [newManagedObject4 setValue:@"The stitchbird/hihi (Notiomystis cincta) is one of New Zealand’s rarest birds.  A medium-sized forest species, hihi compete with tui and bellbirds for nectar, insects and small fruits.\nBut apart from diet, hihi share few qualities with tui and bellbird, which are members of the honeyeater family.  Recent DNA analysis has shown that hihi are in fact the sole representative of another bird family found only in New Zealand whose closest relatives may be the iconic wattlebirds that include kokako, saddleback and the extinct huia.\nHow to recognise hihi\n\nMale and female hihi look quite different.  He flaunts a flashy plumage of black head with white ‘ear’ tufts, bright yellow shoulder bars and breast bands and a white wing bar and has a mottled tan-grey-brown body.\nShe is more subdued with an olive-grey-brown body cover, white wing bars and small white ‘ear’ tufts.  They both have small cat-like whiskers around the beak and large bright eyes.\nHihi can be recognised by their posture of an upward tilted tail and strident call from which the name ‘stitchbird’ derives.  A 19th century ornithologist Sir Walter Buller described the call made by the male hihi as resembling the word ‘stitch’.    Both males and females also have a range of warble-like calls and whistles.\n\nUnique characteristics\nUnlike most other birds, hihi build their nests in tree cavities.  The nest is complex with a stick base topped with a nest cup of finer twigs and lined with fern scales, lichen and spider web.\nHihi have a diverse and unusual mating system. \n\nHihi research\n    An active research programme with Massey and Auckland universities, as well as other institutes, has greatly increased our knowledge of hihi biology.\nHihi have been found to have a fascinating and complex mating system.  Males pair up with a female in their territory while also seeking to mate with other females in the neighbourhood.  To ensure the chicks are his, males need to produce large amounts of sperm to dilute that of other males.  And to avoid wasting this, the male has to assess exactly when a female is ready to breed.  In the days leading up to laying, when a female is weighed down with developing eggs, a number of males may chase her for hours at a time, all attempting to mate with her.\nResearch has also resulted in developing techniques for managing nesting behaviour, for example, managing nest mites, cross fostering and sexing of chicks and habitat suitability.\nManagement of the captive population at the Pukaha Mount Bruce National Wildlife Centre in eastern Wairarapa has also contributed to understanding the role of avian diseases in managing hihi populations.  \n\nWhere to find:  —Little Barrier, Tiritiri Matangi, Kapiti Islands, Kaori Wildlife Sanctuary (Zealandia)." forKey:@"item_description"];
        [newManagedObject4 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject4 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/stitchbird/" forKey:@"link"];
        [newManagedObject4 setValue:@"Tauhou/Hihi" forKey:@"othername"];
        [newManagedObject4 setValue:@"Stitchbird" forKey:@"short_name"];
        [newManagedObject4 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject4 setValue:@"Hihi_Stitchbird" forKey:@"sound"];
        [newManagedObject4 setValue:@"Nationally Vulnerable" forKey:@"threat_status"];
        [newManagedObject4 setValue:NO forKey:@"extra"];
        [newManagedObject4 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];

       //}
		
        [context save:NULL];
        newManagedObject4 = nil;
//        data4 = nil;
//        imageSave4 = nil;
//        imageData4 = nil;
//        url4 = nil;
        
        //context = nil;
        
        
        // +++++++++++MOA +++++++++++++
      
        
        NSManagedObject *newManagedObject5 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        NSLog(@"Moa");
        [newManagedObject5 setValue:@"Moa" forKey:@"name"];
        [newManagedObject5 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject5 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject5 setValue:@"flightless" forKey:@"behaviour"];
        [newManagedObject5 setValue:@"1" forKey:@"category"];
        [newManagedObject5 setValue:@"brown" forKey:@"colour"];
        [newManagedObject5 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject5 setValue:@"Ratites" forKey:@"family"];
        [newManagedObject5 setValue:@"coast,bush" forKey:@"habitat"];
//        NSURL *url5 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"823px-Dinornis1387"
//                                              ofType:@"jpg"]];
//        
//        NSData *data5 = [[NSData alloc] initWithContentsOfURL:url5];
//        UIImage *imageSave5=[[UIImage alloc]initWithData:data5];
//        NSData *imageData5 = UIImagePNGRepresentation(imageSave5);
//        
//        [newManagedObject5 setValue:imageData5 forKey:@"image"];
        [newManagedObject5 setValue:@"823px-Dinornis1387" forKey:@"image"];
        
        NSURL *url5t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"823px-Dinornis1387_TN"
                                              ofType:@"jpg"]];
        
        NSData *data5t = [[NSData alloc] initWithContentsOfURL:url5t];
        UIImage *imageSave5t=[[UIImage alloc]initWithData:data5t];
        NSData *imageData5t = UIImagePNGRepresentation(imageSave5t);
        
        [newManagedObject5 setValue:imageData5t forKey:@"thumbnail"];
        
        
        [newManagedObject5 setValue:@"Richard Owen, who became director of London’s Museum of Natural History, was the first to recognise that a bone fragment he was shown in 1839 came from a large bird. When later sent collections of bird bones, he managed to reconstruct moa skeletons. \n\nIn this photograph, published in 1879, he stands next to the largest of all moa, Dinornis maximus (now D. novaezealandiae), while holding the first bone fragment he had examined 40 years earlier. Richard Owen, Memoirs on the extinct wingless birds of New Zealand. Vol. 2. London: John van Voorst, 1879, plate XCVII" forKey:@"item_description"];
        [newManagedObject5 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject5 setValue:@"http://www.lib.utexas.edu/books/nzbirds/html/txu-oclc-7314815-2-31-p-097.html" forKey:@"link"];
        [newManagedObject5 setValue:@"Dinornis novaezealandiae" forKey:@"othername"];
        [newManagedObject5 setValue:@"Moa" forKey:@"short_name"];
        [newManagedObject5 setValue:@"ostrich" forKey:@"size_and_shape"];
        //[newManagedObject5 setValue:@"Hihi_Stitchbird" forKey:@"sound"];
        [newManagedObject5 setValue:@"extinct" forKey:@"threat_status"];
        [newManagedObject5 setValue:NO forKey:@"extra"];
        [newManagedObject5 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        //}
		
        [context save:NULL];
        newManagedObject5 = nil;
//        data5 = nil;
//        imageSave5 = nil;
//        imageData5 = nil;
//        url5 = nil;
        
        //context = nil;
       
        // +++++++++++SEAGULL red billed +++++++++++++
        /*  6
         */
        
        NSManagedObject *newManagedObject6 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        NSLog(@"Seagull, red" );
       
        [newManagedObject6 setValue:@"Gull, Red billed " forKey:@"name"];
        [newManagedObject6 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject6 setValue:@"long, hooked" forKey:@"beak_length"];
        [newManagedObject6 setValue:@"can fly, loud,gregarious,flocks" forKey:@"behaviour"];
        [newManagedObject6 setValue:@"1" forKey:@"category"];
        [newManagedObject6 setValue:@"white/black" forKey:@"colour"];
        [newManagedObject6 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject6 setValue:@"Waders, Gulls and Terns, Auks" forKey:@"family"];
        [newManagedObject6 setValue:@"coast" forKey:@"habitat"];
//        NSURL *url6 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"RedBilledGull_IMG_6599"
//                                              ofType:@"jpg"]];
//    
//        NSData *data6 = [[NSData alloc] initWithContentsOfURL:url6];
//        UIImage *imageSave6=[[UIImage alloc]initWithData:data6];
//        NSData *imageData6 = UIImagePNGRepresentation(imageSave6);
//        
//        [newManagedObject6 setValue:imageData6 forKey:@"image"];
        [newManagedObject6 setValue:@"RedBilledGull_IMG_6599" forKey:@"image"];
        
       
        NSURL *url6t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"RedBilledGull_IMG_6599_TN"
                                              ofType:@"jpg"]];
        
        NSData *data6t = [[NSData alloc] initWithContentsOfURL:url6t];
        UIImage *imageSave6t=[[UIImage alloc]initWithData:data6t];
        NSData *imageData6t = UIImagePNGRepresentation(imageSave6t);
        
        [newManagedObject6 setValue:imageData6t forKey:@"thumbnail"];
        
        
        [newManagedObject6 setValue:@"The red-billed gull is the commonest gull on the New Zealand coast. Except for a colony at Lake Rotorua, it rarely is found inland. It is commonly seen in coastal towns, garbage dumps and at fish processing facilities. Immature adults are often confused with the closely related black-billed gull. Recently the largest colonies in different parts of New Zealand have exhibited a marked decline in numbers (i.e. Kaikoura, Three Kings and Mokohinau Island). The bird tends to nest at the same locality from one season to the next, and offspring mostly return to their natal colony to breed.\n\nIdentification\n\nSexes are similar, but males are slightly larger with a longer and stouter bill. They are almost completely white but the mantle, back and wing coverts are pale grey. The main flight feathers are black with white tips. The iris is white and the bill, eyelids and feet are scarlet, especially in the breeding season, being more dull during the rest of the year. Immatures are similar to adults, except they have brown patches on the mantle and the primaries are brownish in colour rather than black. The iris, bill and legs of immatures are dark brown. Adult plumage is attained in the second year; birds of this age class can be recognised by the brownish-black tip to the bill, and the primary feathers have a brownish tinge instead of black in older individuals. The subantarctic race is stouter.\n\nVoice:\n\n a wide range of calls are used in different circumstances. The alarm call used during the breeding season is a strident \"kek\" call\n\nSimilar species:\n\n the red-billed gull is often confused with the similar-looking black-billed gull, especially as juveniles and immature birds of both species have an overlapping range of bill and leg colours. The black-billed gull is always a paler, more elegant bird, with a longer, more slender bill, and with less black on the outer wing. In the South Island, the black-billed gull is seen inland more frequently than the red-billed gull.\n\nDistribution and habitat\n\nRed-billed gulls are found in most coastal locations throughout New Zealand. They are also commonly found in towns, scavenging on human refuse and offal from fish and meat processing works. They are seldom found inland. On mainland New Zealand, breeding occurs in dense colonies, mainly restricted to the eastern coasts of the North and South Islands on stacks, cliffs, river mouths and sandy and rocky shores. On outlying islands they breed on the Chatham, Campbell, Snares and Auckland Islands. Here, their nests are concealed and located singly or in small groups.\n\nPopulation\n\nThe red-billed gull is a very abundant species that has recently suffered huge declines at its three main breeding colonies (Three Kings Islands, Mokohinau Islands and Kaikoura Peninsula). At Kaikoura the decline began in 1994, and between 1983 and 2005 the population declined by 51%. In contrast, with mammalian predator control at the Otago Peninsula, the population has seen a 6-10% increase in the 20 years since 1992." forKey:@"item_description"];
        [newManagedObject6 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject6 setValue:@"http://www.teara.govt.nz/en/gulls-terns-and-skuas/page-2" forKey:@"link"];
        [newManagedObject6 setValue:@"Tarapunga/ Larus novaehollandiae" forKey:@"othername"];
        [newManagedObject6 setValue:@"Red-billed Gull" forKey:@"short_name"];
        [newManagedObject6 setValue:@"pigeon" forKey:@"size_and_shape"];
        [newManagedObject6 setValue:@"redbilledgull" forKey:@"sound"];
        [newManagedObject6 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject6 setValue:NO forKey:@"extra"];
        [newManagedObject6 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        //}
		
        [context save:NULL];
        newManagedObject6 = nil;
//        data6 = nil;
//        imageSave6 = nil;
//        imageData6 = nil;
//        url6t = nil;
//        data6t = nil;
//        imageSave6b = nil;
//        imageData6b = nil;
//        url6b = nil;
//        
        //context = nil;
        
        // +++++++++++SEAGULL black winged +++++++++++++
        /*  7
         */
        
        NSManagedObject *newManagedObject7 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        [newManagedObject7 setValue:@"Gull, Black backed " forKey:@"name"];
        [newManagedObject7 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject7 setValue:@"medium,hooked" forKey:@"beak_length"];
        [newManagedObject7 setValue:@"can fly, good glider" forKey:@"behaviour"];
        [newManagedObject7 setValue:@"1" forKey:@"category"];
        [newManagedObject7 setValue:@"white" forKey:@"colour"];
        [newManagedObject7 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject7 setValue:@"Waders, Gulls and Terns, Auks" forKey:@"family"];
        [newManagedObject7 setValue:@"coast" forKey:@"habitat"];
//        NSURL *url7 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"BlackWingGull_IMG_6659"
//                                              ofType:@"jpg"]];
//        
//        NSData *data7 = [[NSData alloc] initWithContentsOfURL:url7];
//        UIImage *imageSave7=[[UIImage alloc]initWithData:data7];
//        NSData *imageData7 = UIImagePNGRepresentation(imageSave7);
//        
//        [newManagedObject7 setValue:imageData7 forKey:@"image"];
        [newManagedObject7 setValue:@"BlackWingGull_IMG_6659" forKey:@"image"];
        
     
        NSURL *url7t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"BlackWingGull_IMG_6659_TN"
                                              ofType:@"jpg"]];
        
        NSData *data7t = [[NSData alloc] initWithContentsOfURL:url7t];
        UIImage *imageSave7t=[[UIImage alloc]initWithData:data7t];
        NSData *imageData7t = UIImagePNGRepresentation(imageSave7t);
        
        [newManagedObject7 setValue:imageData7t forKey:@"thumbnail"];
        
        
        
        [newManagedObject7 setValue:@"The southern black-backed gull (or ‘black-back’) is one of the most abundant and familiar large birds in New Zealand, although many people do not realise that the mottled brown juveniles (mistakenly called “mollyhawks”) are the same species as the immaculate adults. Found on or over all non-forested habitats from coastal waters to high-country farms, this is the only large gull found in New Zealand. They are particularly abundant at landfills, around ports and at fish-processing plants.\n\nKnown widely as ‘kelp gull’ in other countries, the same species is also common in similar latitudes around the southern hemisphere, including southern Australia, South America, southern Africa, and most subantarctic and peri-Antarctic islands, and the Antarctic Peninsula.\n\nIdentification\n\nThe familiar large gull throughout New Zealand. Adults have white head and underparts with black back, yellow bill with red spot near tip of lower mandible, and pale green legs. Juveniles are dark mottled brown with black bill and legs; their plumage lightens with age until they moult into adult plumage at 3 years old.\n\nVoice:\n\n a long series of loud calls ‘ee-ah-ha-ha-ha’ etc, given in territorial and aggressive contexts.\n\nSimilar species: adults unmistakeable apart from possible vagrant Pacific gull from Australia (which has a more massive bill, and a black subterminal tip to tail). Juveniles may be confused with the more robust brown skua, which has broader wings with a pale flash at the base of the primaries." forKey:@"item_description"];
        [newManagedObject7 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject7 setValue:@"http://www.teara.govt.nz/en/gulls-terns-and-skuas/page-1" forKey:@"link"];
        [newManagedObject7 setValue:@"Karoro/ Larus dominicanus" forKey:@"othername"];
        [newManagedObject7 setValue:@"Kelp Gull" forKey:@"short_name"];
        [newManagedObject7 setValue:@"goose" forKey:@"size_and_shape"];
        [newManagedObject7 setValue:@"blackbackedgull" forKey:@"sound"];
        [newManagedObject7 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject7 setValue:NO forKey:@"extra"];
        [newManagedObject7 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        //}
		
        [context save:NULL];
        newManagedObject7 = nil;
//        data7 = nil;
//        imageSave7 = nil;
//        imageData7 = nil;
//        url7 = nil;
        
        //context = nil;
        
        // +++++++++++Oystercatcher +++++++++++++
        /*  7
         */
        
        NSManagedObject *newManagedObject8 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes Stitchbird
        [newManagedObject8 setValue:@"Oystercatcher, variable" forKey:@"name"];
        [newManagedObject8 setValue:@"red/orange" forKey:@"beak_colour"];
        [newManagedObject8 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject8 setValue:@"can fly, very vocal" forKey:@"behaviour"];
        [newManagedObject8 setValue:@"1" forKey:@"category"];
        [newManagedObject8 setValue:@"black" forKey:@"colour"];
        [newManagedObject8 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject8 setValue:@"Haematopodidae" forKey:@"family"];
        [newManagedObject8 setValue:@"coast" forKey:@"habitat"];
//        NSURL *url8 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"Watvogel_IMG_6674"
//                                              ofType:@"jpg"]];
//        
//        NSData *data8 = [[NSData alloc] initWithContentsOfURL:url8];
//        UIImage *imageSave8=[[UIImage alloc]initWithData:data8];
//        NSData *imageData8 = UIImagePNGRepresentation(imageSave8);
//        
//        [newManagedObject8 setValue:imageData8 forKey:@"image"];
        [newManagedObject8 setValue:@"Watvogel_IMG_6674" forKey:@"image"];

        NSURL *url8t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Watvogel_IMG_6674_TN"
                                              ofType:@"jpg"]];
        
        NSData *data8t = [[NSData alloc] initWithContentsOfURL:url8t];
        UIImage *imageSave8t=[[UIImage alloc]initWithData:data8t];
        NSData *imageData8t = UIImagePNGRepresentation(imageSave8t);
        
        [newManagedObject8 setValue:imageData8t forKey:@"thumbnail"];
        
        [newManagedObject8 setValue:@"The variable oystercatcher is a familiar stocky coastal bird with a long, bright orange bill, found around much of New Zealand. They are often seen in pairs probing busily for shellfish along beaches or in estuaries. Previously shot for food, variable oystercatchers probably reached low numbers before being protected in 1922, since when numbers have increased rapidly. They are long-lived, with some birds reaching 30+ years of age.\n\nThe existence of different colour morphs (black, intermediate or ‘smudgy’, and pied) caused early confusion, and they were variously thought to be different species, forms, or hybrids. This confusion was compounded by a cline in morphs, with the proportion of all-black birds increasing from north to south. The colour morphs inter-breed freely and are now all accepted as being a single species.\n\nIdentification\n\nThe variable oystercatcher is a large heavily-built shorebird. Adults have black upperparts, their underparts vary from all black, through a range of ‘smudgy’ intermediate states to white. They have a conspicuous long bright orange bill (longer in females), and stout coral-pink legs. The iris is red and eye-ring orange. Downy chicks have pale-mid grey upper parts with black markings and black bill. First-year birds have a dark tip to the bill, browner dorsal plumage, and grey legs.\n\nVoice:\n\n variable oystercatchers are very vocal; loud piping is used in territorial interactions and when alarmed, and they have a loud flight call similar to other oystercatchers. Chicks are warned of danger with a sharp, loud ‘chip’ or ‘click’.\n\nSimilar species:\n\n the black and smudgy morphs are distinctive. Pied morph birds can be confused with South Island pied oystercatcher. If seen together, adult variable oystercatchers are noticeably larger, but first-year birds may be confused. The demarcation between black and white on the breast is generally sharper on South Island pied, and they have more white showing forward of the wing when folded, and a broader white wingbar in flight. The pied morph is similar to Chatham Island oystercatcher, but their ranges are not thought to overlap.\n\nDistribution\n\nVariable oystercatchers occur around most of the coastline of North, South, and Stewart Islands and their offshore islands. Strongholds are in Northland, Auckland, Coromandel Peninsula, Bay of Plenty, Greater Wellington, Nelson/Marlborough, and probably Fiordland. They occur  at lower average densities on west coasts of the two main Islands, and have not been recorded from any outlying island groups.\n\nHabitat\n\nVariable oystercatchers breed most commonly on sandy beaches, sandspits, and in dunes, but will use a wide variety of coastal habitat types, including shell banks, rocky shorelines, and less often gravel beaches. They forage in all these areas and also on inter-tidal mud-flats in estuaries, and on rock platforms." forKey:@"item_description"];
        [newManagedObject8 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject8 setValue:@"http://www.teara.govt.nz/en/wading-birds/page-2" forKey:@"link"];
        [newManagedObject8 setValue:@"black oystercatcher, tōrea pango" forKey:@"othername"];
        [newManagedObject8 setValue:@"Variable Oystercatcher" forKey:@"short_name"];
        [newManagedObject8 setValue:@"pigeon" forKey:@"size_and_shape"];
        [newManagedObject8 setValue:@"oystercatcher" forKey:@"sound"];
        [newManagedObject8 setValue:@"Recovering" forKey:@"threat_status"];
        [newManagedObject8 setValue:NO forKey:@"extra"];
        [newManagedObject8 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        //}
		
        [context save:NULL];
        newManagedObject8 = nil;
//        data8 = nil;
//        imageSave8 = nil;
//        imageData8 = nil;
//        url8 = nil;
//        
        //context = nil;
        
        
        // +++++++++++SPARRW +++++++++++++
        /*  7
         */
        
        NSManagedObject *newManagedObject9 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        [newManagedObject9 setValue:@"Sparrow" forKey:@"name"];
        [newManagedObject9 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject9 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject9 setValue:@"can fly, gregarious, curious" forKey:@"behaviour"];
        [newManagedObject9 setValue:@"1" forKey:@"category"];
        [newManagedObject9 setValue:@"brown" forKey:@"colour"];
        [newManagedObject9 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject9 setValue:@"Passeridae" forKey:@"family"];
        [newManagedObject9 setValue:@"garden" forKey:@"habitat"];
//        NSURL *url9 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                              pathForResource:@"Sparrow_IMG_6604"
//                                              ofType:@"jpg"]];
//        
//        NSData *data9 = [[NSData alloc] initWithContentsOfURL:url9];
//        UIImage *imageSave9=[[UIImage alloc]initWithData:data9];
//        NSData *imageData9 = UIImagePNGRepresentation(imageSave9);
//        
//        [newManagedObject9 setValue:imageData9 forKey:@"image"];
        [newManagedObject9 setValue:@"Sparrow_IMG_6604" forKey:@"image"];
        
        
        NSURL *url9t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Sparrow_IMG_6604_TN"
                                              ofType:@"jpg"]];
        
        NSData *data9t = [[NSData alloc] initWithContentsOfURL:url9t];
        UIImage *imageSave9t=[[UIImage alloc]initWithData:data9t];
        NSData *imageData9t = UIImagePNGRepresentation(imageSave9t);
        
        [newManagedObject9 setValue:imageData9t forKey:@"thumbnail"];
        
        
        [newManagedObject9 setValue:@"One of the world’s most successful introduced species, the house sparrow is found from sub-Arctic to sub-Tropical regions everywhere, except Western Australia and some small islands. It lives mostly in close association with man. This ubiquity has led to many studies of it as a pest and of its physiology, energetics, behaviour, genetics and evolution. There is even a scientific journal devoted to work on the house sparrow and other Passer species.\n\nHouse sparrows were introduced to New Zealand first in the mid 1860s. They soon became abundant and were said to be combating plagues of agricultural pests. By the 1880s, however, they were regarded as pests. Sparrows have made their own way to offshore islands, breeding on those with human habitation. They have evolved differences in morphology in response to local environments. The best source of information on sparrow biology is the monograph by Summers-Smith, although adjustment for the six-month difference in seasons is necessary.\n\nIdentification\n\nMales are smart chestnut-brown, white-and-grey with a distinctive black “bib”; they are difficult to confuse with any other species. Females and young lack the bib and are greyer, with lighter brown dorsal plumage than the male. Their underparts are plain grey, but their backs and wings are variegated several shades of brown and white. The robust conical bill is black in breeding males, otherwise pale pinkish-brown. The eyes are dark brown and legs dull pink.\n\nVoice: the familiar unmelodious chirp is the male’s song, and the same call is used by both sexes in roosts and other social gatherings. The alarm call is harsher.\n\nSimilar species:\n\n females and juveniles can be confused with dunnock, greenfinch or chaffinch. Dunnocks are smaller, with darker, more sombre plumage, and a slender dark bill. They usually stay close to cover, and are never in large flocks. Chaffinches differ in their distinctive double wing-bar and white outer tail. The young of greenfinches are greenish above their shorter tail. In comparison with finches, sparrow flight generally is more direct, almost laboured, and usually low.\n\nDistribution and habitat\n\nHouse sparrows are found everywhere except for high mountains and bush." forKey:@"item_description"];
        [newManagedObject9 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject9 setValue:@"http://en.wikipedia.org/wiki/Sparrow" forKey:@"link"];
        [newManagedObject9 setValue:@"House sparrow" forKey:@"othername"];
        [newManagedObject9 setValue:@"House Sparrow" forKey:@"short_name"];
        [newManagedObject9 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject9 setValue:@"Sparrow_XC112666-Pasdom_Sohar_27dec2009" forKey:@"sound"];
        [newManagedObject9 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject9 setValue:NO forKey:@"extra"];
        [newManagedObject9 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        //}
		
        [context save:NULL];
        newManagedObject9 = nil;
//        data9 = nil;
//        imageSave9 = nil;
//        imageData9 = nil;
//        url9 = nil;
        
        //context = nil;
        
        
        // +++++++++++GANNET +++++++++++++
        /*  10
         */
        
        NSManagedObject *newManagedObject10 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes 
        [newManagedObject10 setValue:@"Gannet"       forKey:@"name"];
        [newManagedObject10 setValue:@"Takapu (Morus serrator)" forKey:@"othername"];
        [newManagedObject10 setValue:@"Up to 1.8m wingspan. Hunt by diving with up to 100km/h so they can catch fish deeper than most other fishing airborne bird species. An air sac under the skin in their face cushions the impact on the water. \n\nAdults are mostly white, with black flight feathers at the wingtips and lining the trailing edge of the wing. The central tail feathers are also black. The head is yellow, with a pale blue-grey bill edged in black, and blue-rimmed eyes. \n\nTheir breeding habitat is on islands and the coast of New Zealand, Victoria and Tasmania, with 87% of the adult population in New Zealand. These birds are plunge divers and spectacular fishers, plunging into the ocean at high speed. They mainly eat squid and forage fish which school near the surface. It has the same colours and similar appearance to the Northern Gannet. \n\nThey normally nest in large colonies on coastal islands. In New Zealand there are colonies of over 10,000 breeding pairs each at Three Kings Islands, Whakaari / White Island and Gannet Island. There is a large protected colony on the mainland at Cape Kidnappers (6,500 pairs). There are also mainland colonies at Muriwai and Farewell Spit, as well as numerous other island colonies. Gannet pairs may remain together over several seasons. They perform elaborate greeting rituals at the nest, stretching their bills and necks skywards and gently tapping bills together. The adults mainly stay close to colonies, whilst the younger birds disperse." forKey:@"item_description"];
        [newManagedObject10 setValue:@"http://www.teara.govt.nz/en/gannets-and-boobies/page-2" forKey:@"link"];
        [newManagedObject10 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject10 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject10 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject10 setValue:@"1" forKey:@"category"];
        [newManagedObject10 setValue:@"white" forKey:@"colour"];
        [newManagedObject10 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject10 setValue:@"Sulidae" forKey:@"family"];
        [newManagedObject10 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject10 setValue:@"not threatened" forKey:@"threat_status"];
        [newManagedObject10 setValue:@"Australasian Gannet" forKey:@"short_name"];
        [newManagedObject10 setValue:@"albatross" forKey:@"size_and_shape"];
        
//        NSURL *url10 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//              pathForResource:@"Gannet_IMG_6624"
//              ofType:@"jpg"]];
//        NSData *data10 = [[NSData alloc] initWithContentsOfURL:url10];
//        UIImage *imageSave10=[[UIImage alloc]initWithData:data10];
//        NSData *imageData10 = UIImagePNGRepresentation(imageSave10);
//        [newManagedObject10 setValue:imageData10         forKey:@"image"];
//        
        [newManagedObject10 setValue:@"Gannet_IMG_6624"         forKey:@"image"];
        
        
        NSURL *url10t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Gannet_IMG_6624_TN"
                                               ofType:@"jpg"]];
        NSData *data10t = [[NSData alloc] initWithContentsOfURL:url10t];
        UIImage *imageSave10t=[[UIImage alloc]initWithData:data10t];
        NSData *imageData10t = UIImagePNGRepresentation(imageSave10t);
        [newManagedObject10 setValue:imageData10t         forKey:@"thumbnail"];
        
        [newManagedObject10 setValue:@"gannet" forKey:@"sound"];
            
        [newManagedObject10 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject10 setValue:NO forKey:@"extra"];
        [newManagedObject10 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject10 = nil;
//        data10 = nil;
//        imageSave10 = nil;
//        imageData10 = nil;
//        url10 = nil;
        
        //context = nil;
        //++++++++++++++++++++++
        
        // +++++++++++TOMTIT +++++++++++++
        /*  11
         */
        
        NSManagedObject *newManagedObject11 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject11 setValue:@"Tomtit (South Island)"       forKey:@"name"];
        [newManagedObject11 setValue:@"Ngirungiru (Miromiro)" forKey:@"othername"];
        [newManagedObject11 setValue:@"The New Zealand tomtit (Petroica macrocephala) looks similar to a robin. They are a small endemic bird with a large head, a short bill and tail, and live in forest and scrub.\nThe Māori name of the North Island Tomtit is miromiro, while the South Island Tomtit is known as ngirungiru.\nThere are five subspecies of tomtit/miromiro, each restricted to their own specific island or island group: North Island, South Island, the Snares Islands, the Chatham Islands and the Auckland Islands." forKey:@"item_description"];
        [newManagedObject11 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/tomtit-miromiro/" forKey:@"link"];
        [newManagedObject11 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject11 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject11 setValue:@"can fly, largely insectivore/fruit in winter" forKey:@"behaviour"];
        [newManagedObject11 setValue:@"1" forKey:@"category"];
        [newManagedObject11 setValue:@"black" forKey:@"colour"];
        [newManagedObject11 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject11 setValue:@"Petroicidae" forKey:@"family"];
        [newManagedObject11 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject11 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject11 setValue:@"Tomtit" forKey:@"short_name"];
        [newManagedObject11 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url11 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"SI_Tomtit_male2"
//                                               ofType:@"jpg"]];
//        NSData *data11 = [[NSData alloc] initWithContentsOfURL:url11];
//        UIImage *imageSave11=[[UIImage alloc]initWithData:data11];
//        NSData *imageData11 = UIImagePNGRepresentation(imageSave11);
//        [newManagedObject11 setValue:imageData11         forKey:@"image"];
        [newManagedObject11 setValue:@"NorthIsland_Tomtit_steintil"         forKey:@"image"];
        
        NSURL *url11t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"SI_Tomtit_male2_TN"
                                               ofType:@"jpg"]];
        NSData *data11t = [[NSData alloc] initWithContentsOfURL:url11t];
        UIImage *imageSave11t=[[UIImage alloc]initWithData:data11t];
        NSData *imageData11t = UIImagePNGRepresentation(imageSave11t);
        [newManagedObject11 setValue:imageData11t         forKey:@"thumbnail"];
        
        
        [newManagedObject11 setValue:@"north-island-tomtit-song-18ni_DOC" forKey:@"sound"];
        
        [newManagedObject11 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject11 setValue:NO forKey:@"extra"];
        [newManagedObject11 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject11 = nil;
//        data11 = nil;
//        imageSave11 = nil;
//        imageData11 = nil;
//        url11 = nil;
        
        //context = nil;
        //++++++++++++++++++++++
        
        // +++++++++++Starling +++++++++++++
        /*  12
         */
        
        NSManagedObject *newManagedObject12 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];

        //Set Bird_attributes
        [newManagedObject12 setValue:@"Starling"       forKey:@"name"];
        [newManagedObject12 setValue:@"Starling" forKey:@"othername"];
        [newManagedObject12 setValue:@"Introduced to NZ, commonly seen around cities, gardens and the open country. Starlings are small to medium-sized passerine birds in the family Sturnidae. The name \"Sturnidae\" comes from the Latin word for starling, sturnus. Many Asian species, particularly the larger ones, are called mynas, and many African species are known as glossy starlings because of their iridescent plumage.\n\n Starlings are native to the Old World, from Europe, Asia and Africa, to northern Australia and the islands of the tropical Pacific. Several European and Asian species have been introduced to these areas as well as North America, Hawaii and New Zealand, where they generally compete for habitat with native birds and are considered to be invasive species. The starling species familiar to most people in Europe and North America is the common starling, and throughout much of Asia and the Pacific the common myna is indeed common.\n\n         Starlings have strong feet, their flight is strong and direct, and they are very gregarious. Their preferred habitat is fairly open country, and they eat insects and fruit. Several species live around human habitation, and are effectively omnivores. Many species search for prey such as grubs by \"open-bill probing\", that is, forcefully opening the bill after inserting it into a crevice, thus expanding the hole and exposing the prey; this behavior is referred to by the German verb zirkeln (pronounced [ˈtsɪʁkəln]).\n\n         Plumage of many species is typically dark with a metallic sheen. Most species nest in holes, laying blue or white eggs.\
         Starlings have diverse and complex vocalizations, and have been known to embed sounds from their surroundings into their own calls, including car alarms and human speech patterns. The birds can recognize particular individuals by their calls, and are currently the subject of research into the evolution of human language." forKey:@"item_description"];
        [newManagedObject12 setValue:@"http://en.wikipedia.org/wiki/Starling" forKey:@"link"];
        [newManagedObject12 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject12 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject12 setValue:@"can fly, odd and quirky" forKey:@"behaviour"];
        [newManagedObject12 setValue:@"1" forKey:@"category"];
        [newManagedObject12 setValue:@"black" forKey:@"colour"];
        [newManagedObject12 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject12 setValue:@"Sturnidae" forKey:@"family"];
        [newManagedObject12 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject12 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject12 setValue:@"European Starling" forKey:@"short_name"];
        [newManagedObject12 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url12 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Starling_IMG_6964"
//                                               ofType:@"jpg"]];
//        NSData *data12 = [[NSData alloc] initWithContentsOfURL:url12];
//        UIImage *imageSave12=[[UIImage alloc]initWithData:data12];
//        NSData *imageData12 = UIImagePNGRepresentation(imageSave12);
//        [newManagedObject12 setValue:imageData12         forKey:@"image"];
        [newManagedObject12 setValue:@"Starling_IMG_6964"         forKey:@"image"];
        
        NSURL *url12t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Starling_IMG_6964_TN"
                                               ofType:@"jpg"]];
        NSData *data12t = [[NSData alloc] initWithContentsOfURL:url12t];
        UIImage *imageSave12t=[[UIImage alloc]initWithData:data12t];
        NSData *imageData12t = UIImagePNGRepresentation(imageSave12t);
        [newManagedObject12 setValue:imageData12t         forKey:@"thumbnail"];
        
        [newManagedObject12 setValue:@"starling" forKey:@"sound"];
        
        [newManagedObject12 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject12 setValue:NO forKey:@"extra"];
        [newManagedObject12 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject12 = nil;
//        data12 = nil;
//        imageSave12 = nil;
//        imageData12 = nil;
//        url12 = nil;
        
        //context = nil;
        
        //++++++++++++++++++++++
        
        // +++++++++++Goldfinch +++++++++++++
        /*  13
         */
        
        NSManagedObject *newManagedObject13 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject13 setValue:@"Goldfinch"       forKey:@"name"];
        [newManagedObject13 setValue:@"Carduelis carduelis" forKey:@"othername"];
        [newManagedObject13 setValue:@"Goldfinches are small finches with flashes of bright yellow and red, common in open country throughout New Zealand. Introduced from Britain 1862-1883, their tinkling calls contribute to the collective noun “a charm of goldfinches”. They are mainly seed-eaters, and often gather in flocks to feed on thistle seed. Goldfinches frequently stray to outlying island groups, and are resident on the Chatham Islands.\
         \n\nIdentification\n\n         Goldfinches are smaller than a house sparrow, with a bright yellow wingbar visible both in flight and when perched. Wings and tail otherwise black (some white spots near tail tip), contrasting with the buff-brown back. Adults have diagnostic bright red, white and black facial feathering. The red is more extensive in the males, especially above and behind the eye. Juveniles have drab brown on the head. Often in flocks (small or large), goldfinches have a bouncy undulating flight accompanied by frequent liquid, tinkly calling.\n\n         Similar species: \n\nThe slightly larger greenfinch also has yellow at the base of the primaries, forming a diffuse patch on the outer wing. All finches have similar undulating flight, but can be distinguished by their calls (goldfinch has a shrill, clear pee-yu).\n\n         Distribution and habitat\n\n         Throughout the country from sea level up to about 500 m altitude, in farmland, orchards, coastal vegetation, riverbeds, plantations and urban areas – almost anywhere other than dense native forest. Goldfinches are locally common on the Chatham Islands, and occur as vagrants on the Kermadec, Snares, Antipodes, Auckland and Campbell Islands. They occur naturally throughout Europe, North Africa, the Middle East and western Asia, and were introduced to New Zealand, Australia, Argentina and Bermuda.\n\n         Population\n\n         Common and widespread since the 1920s, flocks in the non-breeding season may number several hundred birds.\n\nCommonly kept and bred in captivity around the world because of their distinctive appearance and pleasant song" forKey:@"item_description"];
        [newManagedObject13 setValue:@"http://www.nzbirds.com/birds/goldfinch.html" forKey:@"link"];
        [newManagedObject13 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject13 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject13 setValue:@"can fly, group together in winter" forKey:@"behaviour"];
        [newManagedObject13 setValue:@"1" forKey:@"category"];
        [newManagedObject13 setValue:@"brown/red/yellow" forKey:@"colour"];
        [newManagedObject13 setValue:@"red/brown" forKey:@"leg_colour"];
        [newManagedObject13 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject13 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject13 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject13 setValue:@"European Goldfinch" forKey:@"short_name"];
        [newManagedObject13 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url13 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Goldfinch_IMG_6721"
//                                               ofType:@"jpg"]];
//        NSData *data13 = [[NSData alloc] initWithContentsOfURL:url13];
//        UIImage *imageSave13=[[UIImage alloc]initWithData:data13];
//        NSData *imageData13 = UIImagePNGRepresentation(imageSave13);
//        [newManagedObject13 setValue:imageData13         forKey:@"image"];
        [newManagedObject13 setValue:@"Goldfinch_IMG_6721"         forKey:@"image"];
        
        NSURL *url13t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Goldfinch_IMG_6721_TN"
                                               ofType:@"jpg"]];
        NSData *data13t = [[NSData alloc] initWithContentsOfURL:url13t];
        UIImage *imageSave13t=[[UIImage alloc]initWithData:data13t];
        NSData *imageData13t = UIImagePNGRepresentation(imageSave13t);
        [newManagedObject13 setValue:imageData13t         forKey:@"thumbnail"];
        
        
        [newManagedObject13 setValue:@"goldfinch" forKey:@"sound"];
        
        [newManagedObject13 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject13 setValue:NO forKey:@"extra"];
        [newManagedObject13 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject13 = nil;
//        data13 = nil;
//        imageSave13 = nil;
//        imageData13 = nil;
//        url13 = nil;
        
        // +++++++++++Magpie +++++++++++++
        /*  14
         */
        
        NSManagedObject *newManagedObject14 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject14 setValue:@"Magpie, australian"       forKey:@"name"];
        [newManagedObject14 setValue:@"Cracticus tibicen" forKey:@"othername"];
        [newManagedObject14 setValue:@"he black-and-white Australian magpie is a common and conspicuous inhabitant of open country throughout much of New Zealand. It was introduced from Australia and Tasmania by Acclimatisation Societies between 1864 and 1874, mainly to control insect pests. There are three subspecies; the black-backed, and two white-backed forms, with white-backed birds predominating in most parts of New Zealand.\n\n        Identification\n\n         This familiar large songbird is similar in size to a crow or a New Zealand pigeon. The white-backed form tyrannica is the largest of the sub-species. The male has a white hind-neck, mantle, rump and shoulder patches. The upper two-thirds of the tail and under-tail coverts are also white. The rest of the plumage is black, with a blue iridescence. The female is similar, but the mantle is grey, and the black parts of the plumage are less iridescent. Both sexes have a blue-grey bill with a dark tip, and red eyes. The male takes several years to attain full adult plumage; after the second moult it resembles an adult female. Some white appears on the mantle after the third moult, and the remainder after the fourth moult. The juvenile is mottled grey on the under-surface. The black-backed magpie is similar to the white-backed forms, but with a black mantle. The female can be identified by the presence of some grey on the lower hind-neck. The two subspecies interbreed, resulting in offspring with a varying amount of black on the mantle, ranging from a few feathers to a narrow band.\n\n         Both sexes have a distinctive carolling song; “quardle oodle ardle wardle doodle”.\n\n         With its large size and strikingly pied plumage, the Australian magpie is not readily confused with any other species.\n\n         Distribution and habitat\n\n        The magpie is found throughout the North Island. In the South Island it is most common from Kaikoura to Southland. It is uncommon in Nelson and inland Marlborough, and is largely absent from Westland, except for the area between Harihari and Westport. The white-backed forms predominate except in Hawke’s Bay and North Canterbury, where black-backed birds make up around 95% of the population.\n        \n        The white-backed forms originate from south-eastern Australia and Tasmania, and the black-backed from northern Australia and southern New Guinea. Australian magpies were also introduced to Fiji.\n         \n         Magpies are most abundant on farmland with shelterbelts of pines, macrocarpas and gums. They inhabit both lowland and hill-country farming districts, and are frequently found in urban habitats such as parks and golf-courses.\n\n      Population\n\n         Australian magpies are common in much of the North Island and the east of the South Island south of Kaikoura. They have declined in some areas, e.g. Wellington, as a result of control programmes.\n         \nEcological and economic impacts\n\n         The Australian magpie has been widely implicated in the predation of native birds and their nests, but much evidence is anecdotal. However, magpies do occasionally kill other birds, mostly smaller species. One was seen to pursue, capture and kill a juvenile goldfinch, and another took 3 newly-hatched banded dotterel chicks from a nest. Most attacks appear to be opportunistic, involving young or weak victims. Many of the attacks by magpies against larger birds are directed towards harriers, and generally cease when the target leaves the territory. This harassment of harriers may even have a protective effect on other species breeding in a magpie’s territory." forKey:@"item_description"];
        [newManagedObject14 setValue:@"http://nzbirdsonline.org.nz/species/australian-magpie" forKey:@"link"];
        [newManagedObject14 setValue:@"white/black" forKey:@"beak_colour"];
        [newManagedObject14 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject14 setValue:@"can fly, walks rather than waddles or hops" forKey:@"behaviour"];
        [newManagedObject14 setValue:@"1" forKey:@"category"];
        [newManagedObject14 setValue:@"black" forKey:@"colour"];
        [newManagedObject14 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject14 setValue:@"Cracticidae" forKey:@"family"];
        [newManagedObject14 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject14 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject14 setValue:@"Australian Magpie" forKey:@"short_name"];
        [newManagedObject14 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url14 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Magpie_Australian_IMG_6747"
//                                               ofType:@"jpg"]];
//        NSData *data14 = [[NSData alloc] initWithContentsOfURL:url14];
//        UIImage *imageSave14=[[UIImage alloc]initWithData:data14];
//        NSData *imageData14 = UIImagePNGRepresentation(imageSave14);
//        [newManagedObject14 setValue:imageData14         forKey:@"image"];
        [newManagedObject14 setValue:@"Magpie_Australian_IMG_6747"         forKey:@"image"];
        
        NSURL *url14t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Magpie_Australian_IMG_6747_TN"
                                               ofType:@"jpg"]];
        NSData *data14t = [[NSData alloc] initWithContentsOfURL:url14t];
        UIImage *imageSave14t=[[UIImage alloc]initWithData:data14t];
        NSData *imageData14t = UIImagePNGRepresentation(imageSave14t);
        [newManagedObject14 setValue:imageData14t         forKey:@"thumbnail"];
        
        
        [newManagedObject14 setValue:@"Australian-Magpie" forKey:@"sound"];
        
        [newManagedObject14 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject14 setValue:NO forKey:@"extra"];
        [newManagedObject14 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject14 = nil;
//        data14 = nil;
//        imageSave14 = nil;
//        imageData14 = nil;
//        url14 = nil;
        
        
        
        // +++++++++++Yellowhammer +++++++++++++
        /*  15
         */
        
        NSManagedObject *newManagedObject15 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject15 setValue:@"Yellowhammer"       forKey:@"name"];
        [newManagedObject15 setValue:@"Yellowhammer" forKey:@"othername"];
        [newManagedObject15 setValue:@"Common. Male bright yellow head, yellow underpart, streaked back; female much duller & more streaked below" forKey:@"item_description"];
        [newManagedObject15 setValue:@"http://www.nzbirds.com/birds/yellowhammer.html" forKey:@"link"];
        [newManagedObject15 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject15 setValue:@"short,pointed" forKey:@"beak_length"];
        [newManagedObject15 setValue:@"can fly, forms small flocks in winter" forKey:@"behaviour"];
        [newManagedObject15 setValue:@"1" forKey:@"category"];
        [newManagedObject15 setValue:@"yellow/brown" forKey:@"colour"];
        [newManagedObject15 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject15 setValue:@"Emberizidae" forKey:@"family"];
        [newManagedObject15 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject15 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject15 setValue:@"Yellowhammer" forKey:@"short_name"];
        [newManagedObject15 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url15 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Yellowhammer_IMG_7001"
//                                               ofType:@"jpg"]];
//        NSData *data15 = [[NSData alloc] initWithContentsOfURL:url15];
//        UIImage *imageSave15=[[UIImage alloc]initWithData:data15];
//        NSData *imageData15 = UIImagePNGRepresentation(imageSave15);
//        [newManagedObject15 setValue:imageData15         forKey:@"image"];
        [newManagedObject15 setValue:@"Yellowhammer_IMG_7001"         forKey:@"image"];
        
        NSURL *url15t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Yellowhammer_IMG_7001_TN"
                                               ofType:@"jpg"]];
        NSData *data15t = [[NSData alloc] initWithContentsOfURL:url15t];
        UIImage *imageSave15t=[[UIImage alloc]initWithData:data15t];
        NSData *imageData15t = UIImagePNGRepresentation(imageSave15t);
        [newManagedObject15 setValue:imageData15t         forKey:@"thumbnail"];
        
        
        [newManagedObject15 setValue:@"goldammer" forKey:@"sound"];
        
        [newManagedObject15 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject15 setValue:NO forKey:@"extra"];
        [newManagedObject15 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject15 = nil;
//        data15 = nil;
//        imageSave15 = nil;
//        imageData15 = nil;
//        url15 = nil;
        
        // +++++++++++Chaffinch +++++++++++++
        /*  16
         */
        
        NSManagedObject *newManagedObject16 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject16 setValue:@"Chaffinch"       forKey:@"name"];
        [newManagedObject16 setValue:@"Fringilla coelebs" forKey:@"othername"];
        [newManagedObject16 setValue:@"Chaffinches are the commonest and most widespread of New Zealand’s introduced finches, and are found in a wide range of habitats from sea-level to 1400 m. They are self-introduced to many off-shore islands. Chaffinches frequently visit suburban gardens, especially in winter, and are often seen feeding with house sparrows and silvereyes around bird-tables, on lawns and in parks. The sexes may segregate into separate flocks in winter, especially males; hence the specific name of coelebs (bachelor).\n\nIdentification\n\n         Male chaffinches are similar in size to a house sparrow, with the females being a little smaller. They are sexually dimorphic; males are brightly coloured in spring and summer with brick-red breasts and chestnut mantles. The crown and nape are greyish- blue and the wings are black with a prominent white wing-bar and shoulder patch. During winter, the colours are duller due to the presence of buff tips to the feathers which wear off by early spring. Females are dull brownish-grey, but with similar wing markings as the males. Both sexes have white in the outer tail-feathers which is conspicuous in flight.\n         \n                               Voice: the call is a familiar ‘chink chink’, uttered by both sexes throughout the year. The male has a short rattling song, frequently repeated, during the breeding season.\nn         \
         Similar species: males are not readily confused with any other species, but the female can be mistaken for a female house sparrow. However, the female chaffinch is slimmer, lacks dark streaks on the upper surface and has prominent white wing markings." forKey:@"item_description"];
        [newManagedObject16 setValue:@"http://en.wikipedia.org/wiki/Common_Chaffinch" forKey:@"link"];
        [newManagedObject16 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject16 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject16 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject16 setValue:@"1" forKey:@"category"];
        [newManagedObject16 setValue:@"yellow/brown" forKey:@"colour"];
        [newManagedObject16 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject16 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject16 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject16 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject16 setValue:@"Common Chaffinch" forKey:@"short_name"];
        [newManagedObject16 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url16 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Chaffinch_2"
//                                               ofType:@"jpg"]];
//        NSData *data16 = [[NSData alloc] initWithContentsOfURL:url16];
//        UIImage *imageSave16=[[UIImage alloc]initWithData:data16];
//        NSData *imageData16 = UIImagePNGRepresentation(imageSave16);
//        [newManagedObject16 setValue:imageData16         forKey:@"image"];
        [newManagedObject16 setValue:@"Chaffinch_2"         forKey:@"image"];
        
        NSURL *url16t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Chaffinch_2_TN"
                                               ofType:@"jpg"]];
        NSData *data16t = [[NSData alloc] initWithContentsOfURL:url16t];
        UIImage *imageSave16t=[[UIImage alloc]initWithData:data16t];
        NSData *imageData16t = UIImagePNGRepresentation(imageSave16t);
        [newManagedObject16 setValue:imageData16t         forKey:@"thumbnail"];
        
        
        [newManagedObject16 setValue:@"chaffinch" forKey:@"sound"];
        
        [newManagedObject16 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject16 setValue:NO forKey:@"extra"];
        [newManagedObject16 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject16 = nil;
//        data16 = nil;
//        imageSave16 = nil;
//        imageData16 = nil;
//        url16 = nil;
        
        
        // +++++++++++Black Swan +++++++++++++
        /*  17
         */
   
        NSManagedObject *newManagedObject17 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject17 setValue:@"Black Swan"       forKey:@"name"];
        [newManagedObject17 setValue:@"Black Swan" forKey:@"othername"];
        [newManagedObject17 setValue:@"A large waterbird, a species of swan, which breeds mainly in the southeast and southwest regions of Australia. The species was hunted to extinction in New Zealand, but later reintroduced. Within Australia they are nomadic, with erratic migration patterns dependent upon climatic conditions. \n\nBlack Swans are large birds with mostly black plumage and red bills. They are monogamous breeders that share incubation duties and cygnet rearing between the sexes. Black Swans can be found singly, or in loose companies numbering into the hundreds or even thousands.\n\n Black Swans are popular birds in zoological gardens and bird collections, and escapees are sometimes seen outside their natural range." forKey:@"item_description"];
        [newManagedObject17 setValue:@"http://en.wikipedia.org/wiki/Black_Swan" forKey:@"link"];
        [newManagedObject17 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject17 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject17 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject17 setValue:@"1" forKey:@"category"];
        [newManagedObject17 setValue:@"black" forKey:@"colour"];
        [newManagedObject17 setValue:@"grey,black" forKey:@"leg_colour"];
        [newManagedObject17 setValue:@"Anatidae" forKey:@"family"];
        [newManagedObject17 setValue:@"water,bush" forKey:@"habitat"];
        [newManagedObject17 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject17 setValue:@"Black Swan" forKey:@"short_name"];
        [newManagedObject17 setValue:@"swan" forKey:@"size_and_shape"];
        
//        NSURL *url17 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"BlackSwanCygnus_atratus"
//                                               ofType:@"jpg"]];
//        NSData *data17 = [[NSData alloc] initWithContentsOfURL:url17];
//        UIImage *imageSave17=[[UIImage alloc]initWithData:data17];
//        NSData *imageData17 = UIImagePNGRepresentation(imageSave17);
//        [newManagedObject17 setValue:imageData17         forKey:@"image"];
        [newManagedObject17 setValue:@"BlackSwanCygnus_atratus"         forKey:@"image"];
        
        NSURL *url17t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"BlackSwanCygnus_atratus_TN"
                                               ofType:@"jpg"]];
        NSData *data17t = [[NSData alloc] initWithContentsOfURL:url17t];
        UIImage *imageSave17t=[[UIImage alloc]initWithData:data17t];
        NSData *imageData17t = UIImagePNGRepresentation(imageSave17t);
        [newManagedObject17 setValue:imageData17t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject17 setValue:@"Black_Swan_20110325_XC74379" forKey:@"sound"];
        
        [newManagedObject17 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject17 setValue:NO forKey:@"extra"];
        [newManagedObject17 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject17 = nil;
//        data17 = nil;
//        imageSave17 = nil;
//        imageData17 = nil;
//        url17 = nil;
      
        // +++++++++++Silvereye +++++++++++++
        /*  18
         */
     
        NSManagedObject *newManagedObject18 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject18 setValue:@"Silvereye"       forKey:@"name"];
        [newManagedObject18 setValue:@"Waxeye/ Tauhou" forKey:@"othername"];
        [newManagedObject18 setValue:@"A small olive green forest bird with white rings around its eyes.\nThese friendly birds were self introduced in the 1800s and now have a wide distribution throughout NZ.\nThe silvereye has a wide distribution throughout New Zealand. They can be found from sea level to above the tree line but they are not abundant in deep forest or open grassland.\nSlightly smaller than a sparrow, the silvereye is olive-green with a ring of white feathers around the eye. Males have slightly brighter plumage than females. They have a fine tapered bill and a brush tipped tongue like the tui and bellbird.\nSilvereye's mainly eat insects, fruit and nectar.\n\nThe silvereye was first recorded in New Zealand in 1832 and since there is no evidence that it was artificially introduced, it is classified as a native species. Its Māori name, tauhou, means stranger or more literally, new arrival." forKey:@"item_description"];
        [newManagedObject18 setValue:@"http://nzbirdsonline.org.nz/?q=node/586" forKey:@"link"];
        [newManagedObject18 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject18 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject18 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject18 setValue:@"1" forKey:@"category"];
        [newManagedObject18 setValue:@"yellow/brown/green" forKey:@"colour"];
        [newManagedObject18 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject18 setValue:@"Zosteropidae" forKey:@"family"];
        [newManagedObject18 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject18 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject18 setValue:@"Silver-eye" forKey:@"short_name"];
        [newManagedObject18 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url18 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Silvereye_DSC09462"
//                                               ofType:@"jpg"]];
//        NSData *data18 = [[NSData alloc] initWithContentsOfURL:url18];
//        UIImage *imageSave18=[[UIImage alloc]initWithData:data18];
//        NSData *imageData18 = UIImagePNGRepresentation(imageSave18);
//        [newManagedObject18 setValue:imageData18         forKey:@"image"];
        [newManagedObject18 setValue:@"Silvereye_DSC09462"         forKey:@"image"];
        
      
        NSURL *url18t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Silvereye_DSC09462_TN"
                                               ofType:@"jpg"]];
        NSData *data18t = [[NSData alloc] initWithContentsOfURL:url18t];
        UIImage *imageSave18t=[[UIImage alloc]initWithData:data18t];
        NSData *imageData18t = UIImagePNGRepresentation(imageSave18t);
        [newManagedObject18 setValue:imageData18t         forKey:@"thumbnail"];
      
        
        [newManagedObject18 setValue:@"silvereye-song-22sy" forKey:@"sound"];
        
        [newManagedObject18 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject18 setValue:NO forKey:@"extra"];
        [newManagedObject18 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject18 = nil;
//        data18 = nil;
//        imageSave18 = nil;
//        imageData18 = nil;
//        url18 = nil;
  
        // +++++++++++Bellbird +++++++++++++
        /*  19
         */
    
        NSManagedObject *newManagedObject19 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject19 setValue:@"Bellbird"       forKey:@"name"];
        [newManagedObject19 setValue:@"Korimako (Anthornis melanura)" forKey:@"othername"];
        [newManagedObject19 setValue:@"Most New Zealanders can easily recognise the bellbird by its melodious song, which Captain Cook described as sounding ‘like small bells exquisitely tuned’.\n\n      Well camouflaged, the bellbird is usually heard before it is seen.\n Females are dull olive-brown, with a slight blue sheen on the head and a pale yellow cheek stripe. Males are olive green, with a purplish head and black outer wing and tail feathers.\n\nBellbirds are unique to New Zealand, occurring on the three main islands, many offshore islands and also the Auckland Islands.\n\nWhen Europeans arrived in New Zealand, bellbirds were common throughout the North and South Islands. \nTheir numbers declined sharply during the 1860s in the North Island and 1880s in the South Island, about the time that ship rats and stoats arrived. For a time it was thought they might vanish from the mainland. Their numbers recovered somewhat from about 1940 onwards, but they are almost completely absent on the mainland north of Hamilton, and are still rare in parts of Wellington, Wairarapa and much of inland Canterbury and Otago.\n\n      Bellbirds live in native forest (including mixed podocarp-hardwood and beech forest) and regenerating forest, especially where there is diverse or dense vegetation. They can be found close to the coast or in vegetation up to about 1200 metres. In the South Island they have been found inhabiting plantations of eucalypts, pines or willows. They can be spotted in urban areas, especially if there is bush nearby.\n\nTypically they require forest and scrub habitats, reasonable cover and good local food sources during the breeding season, since they do not travel far from the nest. However, outside the breeding season they may travel many kilometres to feed, especially males. A pair can raise two broods in a season.\n\nBellbird song comprises three distinct sounds resembling the chiming of bells. They sing throughout the day, but more so in the early morning and late evening. The alarm call is a series of loud, rapidly repeated, harsh staccato notes.\n" forKey:@"item_description"];
        [newManagedObject19 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/bellbird-korimako/facts/" forKey:@"link"];
        [newManagedObject19 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject19 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject19 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject19 setValue:@"1" forKey:@"category"];
        [newManagedObject19 setValue:@"brown/green" forKey:@"colour"];
        [newManagedObject19 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject19 setValue:@"Meliphagidae/ Honeyeaters" forKey:@"family"];
        [newManagedObject19 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject19 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject19 setValue:@"New Zealand Bellbird" forKey:@"short_name"];
        [newManagedObject19 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url19 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Anthornis_melanura_New_Zealand_8"
//                                               ofType:@"jpg"]];
//        NSData *data19 = [[NSData alloc] initWithContentsOfURL:url19];
//        UIImage *imageSave19=[[UIImage alloc]initWithData:data19];
//        NSData *imageData19 = UIImagePNGRepresentation(imageSave19);
//        [newManagedObject19 setValue:imageData19         forKey:@"image"];
        [newManagedObject19 setValue:@"Anthornis_melanura_New_Zealand_8"         forKey:@"image"];
        
        NSURL *url19t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Anthornis_melanura_New_Zealand_8_TN"
                                               ofType:@"jpg"]];
        NSData *data19t = [[NSData alloc] initWithContentsOfURL:url19t];
        UIImage *imageSave19t=[[UIImage alloc]initWithData:data19t];
        NSData *imageData19t = UIImagePNGRepresentation(imageSave19t);
        [newManagedObject19 setValue:imageData19t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject19 setValue:@"bellbird-56" forKey:@"sound"];
        
        [newManagedObject19 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject19 setValue:NO forKey:@"extra"];
        [newManagedObject19 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject19 = nil;
//        data19 = nil;
//        imageSave19 = nil;
//        imageData19 = nil;
//        url19 = nil;
        
        
        // +++++++++++Kiwi +++++++++++++
        /*  20
         */
    
        NSManagedObject *newManagedObject20 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject20 setValue:@"Kiwi (North Island Brown) "       forKey:@"name"];
        [newManagedObject20 setValue:@"Roroa (Apteryx)" forKey:@"othername"];
        [newManagedObject20 setValue:@"The kiwi is the national icon of New Zealand and the unofficial national emblem.\nThe closest relatives to kiwi today are emus and cassowaries in Australia, but also the now-extinct moa of New Zealand. There are five species of kiwi:\n      Brown kiwi (Apteryx mantelli)\n      Rowi (Apteryx rowi)\n      Tokoeka (Apteryx australis)\n      Great spotted kiwi or roroa (Apteryx haastii)\n      Little spotted kiwi (Apteryx owenii)\nNew Zealanders have been called ""Kiwis"" since the nickname was bestowed by Australian soldiers in the First World War.\n\nThe kiwi is a curious bird: it cannot fly, has loose, hair-like feathers, strong legs and no tail. \n\nMostly nocturnal, they are most commonly forest dwellers, making daytime dens and nests in burrows, hollow logs or under dense vegetation. Kiwi are the only bird to have nostrils at the end of its very long bill which is used to probe in the ground, sniffing out invertebrates to eat, along with some fallen fruit. It also has one of the largest egg-to-body weight ratios of any bird - the egg averages 15 per cent of the female's body weight (compared to two per cent for the ostrich).\n\nAdult kiwi usually mate for life, and are strongly territorial. Females are larger than males (up to 3.3 kg and 45 cm). \n\nThe brown kiwi, great spotted kiwi, and the Fiordland and Stewart Island forms of tokoeka are “nationally vulnerable”, the third highest threat ranking in the New Zealand Threat Classification System; and the little spotted kiwi is classified as “at risk (recovering)”.\n\nread the long story here\nhttp://www.teara.govt.nz/en/kiwi/page-1" forKey:@"item_description"];
        [newManagedObject20 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/kiwi/" forKey:@"link"];
        [newManagedObject20 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject20 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject20 setValue:@"can fly, flightless,nocturnal" forKey:@"behaviour"];
        [newManagedObject20 setValue:@"1" forKey:@"category"];
        [newManagedObject20 setValue:@"brown" forKey:@"colour"];
        [newManagedObject20 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject20 setValue:@"Ratites" forKey:@"family"];
        [newManagedObject20 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject20 setValue:@"Nationally Vulnerable" forKey:@"threat_status"];
        [newManagedObject20 setValue:@"North Island Brown Kiwi" forKey:@"short_name"];
        [newManagedObject20 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url20 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"LittleSpottedKiwi_Apteryx_owenii"
//                                               ofType:@"jpg"]];
//        NSData *data20 = [[NSData alloc] initWithContentsOfURL:url20];
//        UIImage *imageSave20=[[UIImage alloc]initWithData:data20];
//        NSData *imageData20 = UIImagePNGRepresentation(imageSave20);
//        [newManagedObject20 setValue:imageData20         forKey:@"image"];
        [newManagedObject20 setValue:@"NorthIslandBrownKiwi_JamesStJohn_red"         forKey:@"image"];
        
        NSURL *url20t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"NorthIslandBrownKiwi_JamesStJohn_TN"
                                               ofType:@"jpg"]];
        NSData *data20t = [[NSData alloc] initWithContentsOfURL:url20t];
        UIImage *imageSave20t=[[UIImage alloc]initWithData:data20t];
        NSData *imageData20t = UIImagePNGRepresentation(imageSave20t);
        [newManagedObject20 setValue:imageData20t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject20 setValue:@"is_kiwi" forKey:@"sound"];
        
        [newManagedObject20 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject20 setValue:NO forKey:@"extra"];
        [newManagedObject20 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject20 = nil;
//        data20 = nil;
//        imageSave20 = nil;
//        imageData20 = nil;
//        url20 = nil;
       
        // +++++++++++Kea +++++++++++++
        /*  21
         */
     
        NSManagedObject *newManagedObject21 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject21 setValue:@"Kea"       forKey:@"name"];
        [newManagedObject21 setValue:@"Nestor notabilis" forKey:@"othername"];
        [newManagedObject21 setValue:@"Rated as one of the most intelligent birds in the world.\nIf you are a frequent visitor to or live in an alpine environment you will know the kea well. Kea and Kaka belong to the NZ parrot superfamily. Raucous cries of ""keeaa"" often give away the presence of these highly social and inquisitive birds. However, their endearing and mischievous behaviour can cause conflict with people.\n\nKea (Nestor  notabilis) are an endemic parrot of the South Island's high country. Although kea are seen in reasonable numbers throughout the South Island, the size of the wild population is unknown - but is estimated at between 1,000 and 5,000 birds.\n\nTo survive in the harsh alpine environment kea have become inquisitive and nomadic social birds - characteristics which help kea to find and utilise new food sources. Their inquisitive natures often cause kea to congregate around novel objects and their strong beaks have enormous manipulative power.\nKea are a protected species.\n\nKea grow up to 50 cm long and although mostly vegetarian, also enjoy grubs and insects.\n\nThe kea is related to the forest kaka (Nestor meridionalis) and is thought to have developed its own special characteristics during the last great ice age by using its unusual powers of curiosity in its search for food in a harsh landscape.\nNests are usually found among boulders in high altitude forest where the birds lay between two and four eggs during the breeding season from July and January." forKey:@"item_description"];
        [newManagedObject21 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/kea/" forKey:@"link"];
        [newManagedObject21 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject21 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject21 setValue:@"can fly, only in southern alps" forKey:@"behaviour"];
        [newManagedObject21 setValue:@"1" forKey:@"category"];
        [newManagedObject21 setValue:@"green" forKey:@"colour"];
        [newManagedObject21 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject21 setValue:@"Strigopoidea" forKey:@"family"];
        [newManagedObject21 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject21 setValue:@"vulnerable" forKey:@"threat_status"];
        [newManagedObject21 setValue:@"New Zealand Kea" forKey:@"short_name"];
        [newManagedObject21 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url21 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"800px-Nestor_notabilis_-Fiordland_National_Park-8a"
//                                               ofType:@"jpg"]];
//        NSData *data21 = [[NSData alloc] initWithContentsOfURL:url21];
//        UIImage *imageSave21=[[UIImage alloc]initWithData:data21];
//        NSData *imageData21 = UIImagePNGRepresentation(imageSave21);
//        [newManagedObject21 setValue:imageData21         forKey:@"image"];
        [newManagedObject21 setValue:@"800px-Nestor_notabilis_-Fiordland_National_Park-8a"         forKey:@"image"];
        
        
        NSURL *url21t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"800px-Nestor_notabilis_-Fiordland_National_Park-8a_TN"
                                               ofType:@"jpg"]];
        NSData *data21t = [[NSData alloc] initWithContentsOfURL:url21t];
        UIImage *imageSave21t=[[UIImage alloc]initWithData:data21t];
        NSData *imageData21t = UIImagePNGRepresentation(imageSave21t);
        [newManagedObject21 setValue:imageData21t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject21 setValue:@"kea-song_DOC" forKey:@"sound"];
        
        [newManagedObject21 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject21 setValue:NO forKey:@"extra"];
        [newManagedObject21 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject21 = nil;
//        data21 = nil;
//        imageSave21 = nil;
//        imageData21 = nil;
//        url21 = nil;
        
        // +++++++++++Kereru +++++++++++++
        /*  22
         */
     
        NSManagedObject *newManagedObject22 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject22 setValue:@"Kererū"       forKey:@"name"];
        [newManagedObject22 setValue:@"Hemiphaga novaeseelandiae/ Wood Pigeon" forKey:@"othername"];
        [newManagedObject22 setValue:@"New Zealand's native pigeon, also known as kererū, kūkū and kūkupa and wood pigeon, is the only disperser of large fruits, such as those of karaka and taraire, we have. The disappearance of the kererū would be a disaster for the regeneration of our native forests.\n\nThe kererū is a large bird with irridescent green and bronze feathers on its head and a smart white vest. The noisy beat of its wings is a distinctive sound in our forests. The pigeon is found in most lowland native forests of the North, South and Stewart/Rakiura islands and many of their neighbouring islands.There are two species of native pigeon, the New Zealand pigeon (Hemiphaga novaeseelandiae) known to the Maori as kererū, or in Northland as kūkū or kūkupa, and the Chatham Islands pigeon (Hemiphaga chathamensis) or parea.\n\nThe parea is found mainly in the south-west of Chatham Island. While there are only about 500 parea left, the species has made a remarkable recovery over the past 20 years,  due to habitat protection and predator control.\nTwo other kinds of native pigeon became extinct on Raoul Island and Norfolk Island last century, probably due to hunting and predation\nSince the extinction of the moa, the native pigeon is now the only seed disperser with a bill big enough to swallow large fruit, such as those of karaka, tawa and taraire.\nIt also eats leaves, buds and flowers, the relative amounts varying seasonally and regionally, e.g. in Northland the birds eat mostly fruit.\n\nKererū are large birds and can measure up to 51 cm from tail to beak, and weigh about 650g.\nLong-lived birds, they breed slowly. Key breeding signals are spectacular display flights performed mainly by territorial males. They nest mainly in spring/early summer producing only one egg per nest, which the parents take turns to look after during the 28-day incubation period.\nThe chick grows rapidly, leaving the nest when about 40 days old. It is fed pigeon milk, a protein-rich milky secretion from the walls of the parents' crops, mixed with fruit pulp.  When much fruit is available, some pairs of kererū will have a large chick in one nest and be incubating an egg in another nearby. Fledglings spend about two weeks with their parents before becoming fully independent, but have remained with their parents during autumn and winter in some cases." forKey:@"item_description"];
        [newManagedObject22 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/nz-pigeon-kereru/" forKey:@"link"];
        [newManagedObject22 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject22 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject22 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject22 setValue:@"1" forKey:@"category"];
        [newManagedObject22 setValue:@"grey" forKey:@"colour"];
        [newManagedObject22 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject22 setValue:@"Pigeons and Doves (Columbidae)" forKey:@"family"];
        [newManagedObject22 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject22 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject22 setValue:@"New Zealand Pigeon" forKey:@"short_name"];
        [newManagedObject22 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url22 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"New_Zealand_Pigeon_Southstar_02"
//                                               ofType:@"jpg"]];
//        NSData *data22 = [[NSData alloc] initWithContentsOfURL:url22];
//        UIImage *imageSave22=[[UIImage alloc]initWithData:data22];
//        NSData *imageData22 = UIImagePNGRepresentation(imageSave22);
//        [newManagedObject22 setValue:imageData22         forKey:@"image"];
        [newManagedObject22 setValue:@"New_Zealand_Pigeon_Southstar_02"         forKey:@"image"];
        
        NSURL *url22t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"New_Zealand_Pigeon_Southstar_02_TN"
                                               ofType:@"jpg"]];
        NSData *data22t = [[NSData alloc] initWithContentsOfURL:url22t];
        UIImage *imageSave22t=[[UIImage alloc]initWithData:data22t];
        NSData *imageData22t = UIImagePNGRepresentation(imageSave22t);
        [newManagedObject22 setValue:imageData22t         forKey:@"thumbnail"];
        
        
        [newManagedObject22 setValue:@"kereru" forKey:@"sound"];
        
        [newManagedObject22 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject22 setValue:NO forKey:@"extra"];
        [newManagedObject22 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject22 = nil;
//        data22 = nil;
//        imageSave22 = nil;
//        imageData22 = nil;
//        url22 = nil;
        
       
        
        // +++++++++++Rifleman +++++++++++++
        /*  23
         */
        
        NSManagedObject *newManagedObject23 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject23 setValue:@"Rifleman"       forKey:@"name"];
        [newManagedObject23 setValue:@"Titipounamou (Acanthisitta chloris)" forKey:@"othername"];
        [newManagedObject23 setValue:@"The Rifleman is New Zealand's smallest endemic bird, with fully grown adults reaching around 8 cm. \n\nThe male Rifleman is bright green on the dorsal side while the female is of a more somber brownish tone and her head and back are flecked with ochre. Male birds typically weigh around 6 g, females 7 g. Both birds are white on their under surfaces and have white eyebrow stripes. \n\nThey have short, rounded wings, a very short tail, and a long thin awl-like bill which is slightly upturned for insertion into cracks. The Rifleman flies quickly with a wing beat producing a characteristic humming sound like a humming bird.The Rifleman is named after a colonial New Zealand regiment because its plumage drew similarities with the military uniform of a rifleman." forKey:@"item_description"];
        [newManagedObject23 setValue:@"http://en.wikipedia.org/wiki/Rifleman_(bird)" forKey:@"link"];
        [newManagedObject23 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject23 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject23 setValue:@"can fly, flies quick, hums" forKey:@"behaviour"];
        [newManagedObject23 setValue:@"1" forKey:@"category"];
        [newManagedObject23 setValue:@"grey" forKey:@"colour"];
        [newManagedObject23 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject23 setValue:@"Acanthisittidae (New Zealand Wrens)" forKey:@"family"];
        [newManagedObject23 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject23 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject23 setValue:@"Rifleman" forKey:@"short_name"];
        [newManagedObject23 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url23 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Rifleman_Acanthisitta_chloris"
//                                               ofType:@"jpg"]];
//        NSData *data23 = [[NSData alloc] initWithContentsOfURL:url23];
//        UIImage *imageSave23=[[UIImage alloc]initWithData:data23];
//        NSData *imageData23 = UIImagePNGRepresentation(imageSave23);
//        [newManagedObject23 setValue:imageData23         forKey:@"image"];
        [newManagedObject23 setValue:@"Rifleman_Acanthisitta_chloris"         forKey:@"image"];
        
        
        NSURL *url23t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Rifleman_Acanthisitta_chloris_TN"
                                               ofType:@"jpg"]];
        NSData *data23t = [[NSData alloc] initWithContentsOfURL:url23t];
        UIImage *imageSave23t=[[UIImage alloc]initWithData:data23t];
        NSData *imageData23t = UIImagePNGRepresentation(imageSave23t);
        [newManagedObject23 setValue:imageData23t         forKey:@"thumbnail"];
        
        
        [newManagedObject23 setValue:@"Rifleman" forKey:@"sound"];
        
        [newManagedObject23 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject23 setValue:NO forKey:@"extra"];
        [newManagedObject23 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject23 = nil;
//        data23 = nil;
//        imageSave23 = nil;
//        imageData23 = nil;
//        url23 = nil;
      
        // +++++++++++Kakariki +++++++++++++
        /*  24
         */
       
        NSManagedObject *newManagedObject24 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject24 setValue:@"Kakariki (yellow-crowned parakeet)"       forKey:@"name"];
        [newManagedObject24 setValue:@"Cyanoramphus auriceps" forKey:@"othername"];
        [newManagedObject24 setValue:@"The three species of Kākāriki or New Zealand parakeets are the most common species of parakeet in the genus Cyanoramphus, family Psittacidae. The birds' Māori name, which is the most commonly used, means small parrot. The three species on mainland New Zealand are the Yellow-crowned Parakeet, Cyanoramphus auriceps, the Red-crowned Parakeet or Red-fronted Parakeet, C. novaezelandiae, and the critically endangered Malherbe's Parakeet (or Orange-fronted Parakeet), C. malherbi. Yellow-crowned parakeets are small, bright green, noisy parrots that spend most of their time high in the forest canopy. They were once extremely common throughout New Zealand, but today are rare or uncommon in most places on the mainland, though they are still common on some predator-free islands and in a few valleys in eastern Fiordland and west Otago.\n\n         The genus Cyanoramphus to which the yellow-crowned parakeet belongs includes five other similar-sized green parrots in the New Zealand region and one each on Norfolk Island and New Caledonia.\n\n        Identification\n\n The yellow-crowned parakeet is a small, forest-dwelling, long-tailed, predominantly green parrot with a yellow crown, a narrow crimson band between the crown and the cere, a red spot on each side of the rump and a blue leading edge to the outer wing. The bill is pale bluish-grey with a black tip and cutting edge; the legs and feet black-brown\n\n          Voice: a characteristic chatter made by both sexes when flying, and a variety of quieter and less distinctive calls.\n\nSimilar species: very similar in appearance to the orange-fronted parakeet, but the yellow-crowned parakeet is brighter green, has a crimson (not orange) band above the cere, and red (not orange) spots on the flanks. Also similar to the red-crowned parakeet which is larger and has a red crown, and a red patch behind the eye.\n\n         Distribution and habitat\n\n         Yellow-crowned parakeets were previously found in forests throughout the main islands of New Zealand and on many offshore islands including the Auckland Islands. It is still present in most large native forests in the three main islands, though it is absent from Mt Egmont, north Taranaki and Northland. It occurs on Little Barrier, the Hen and Chickens, the Chetwodes Islands and Titi Island (outer Pelorus sound), Codfish Island, several smaller islands off Stewart Island and Fiordland and on the Auckland Islands. Yellow-crowned parakeets have been successfully introduced to Mana Island, and to Long Island and Motuara Island in Queen Charlotte Sound. \n\nOn the mainland yellow-crowned parakeets are mostly confined to tall forests, but on islands they are also common in low scrub and even open grassland (Mana Island)." forKey:@"item_description"];
        [newManagedObject24 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/nz-parakeet-kakariki/nz-parakeet-kakariki/" forKey:@"link"];
        [newManagedObject24 setValue:@"black/white" forKey:@"beak_colour"];
        [newManagedObject24 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject24 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject24 setValue:@"1" forKey:@"category"];
        [newManagedObject24 setValue:@"green" forKey:@"colour"];
        [newManagedObject24 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject24 setValue:@"Psittacidae" forKey:@"family"];
        [newManagedObject24 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject24 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject24 setValue:@"Yellow-crowned Parakeet" forKey:@"short_name"];
        [newManagedObject24 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url24 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Cyanoramphus_novaezelandiae_-Kapiti_Island,_New_Zealand-8"
//                                               ofType:@"jpg"]];
//        NSData *data24 = [[NSData alloc] initWithContentsOfURL:url24];
//        UIImage *imageSave24=[[UIImage alloc]initWithData:data24];
//        NSData *imageData24 = UIImagePNGRepresentation(imageSave24);
//        [newManagedObject24 setValue:imageData24         forKey:@"image"];
        [newManagedObject24 setValue:@"Cyanoramphus_novaezelandiae_-Kapiti_Island,_New_Zealand-8"         forKey:@"image"];
        
        NSURL *url24t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Cyanoramphus_novaezelandiae_-Kapiti_Island,_New_Zealand-8_TN"
                                               ofType:@"jpg"]];
        NSData *data24t = [[NSData alloc] initWithContentsOfURL:url24t];
        UIImage *imageSave24t=[[UIImage alloc]initWithData:data24t];
        NSData *imageData24t = UIImagePNGRepresentation(imageSave24t);
        [newManagedObject24 setValue:imageData24t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject24 setValue:@"kakariki" forKey:@"sound"];
        
        [newManagedObject24 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject24 setValue:NO forKey:@"extra"];
        [newManagedObject24 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject24 = nil;
//        data24 = nil;
//        imageSave24 = nil;
//        imageData24 = nil;
//        url24 = nil;
        
      
        
        // +++++++++++Grey warbler +++++++++++++
        /*  25
         */
      
        NSManagedObject *newManagedObject25 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject25 setValue:@"Grey warbler"       forKey:@"name"];
        [newManagedObject25 setValue:@"Riroriro (Gerygone igata)" forKey:@"othername"];
        [newManagedObject25 setValue:@"The grey warbler is New Zealand’s most widely distributed endemic bird species. It vies with rifleman for the title of New Zealand’s smallest bird, with both weighing about 6 g. The title usually goes to rifleman, based on its shorter tail and therefore shorter body length.\n\nThe grey warbler is more often heard than seen, having a loud distinctive song, and tending to spend most of its time in dense vegetation. \n\nIdentification\n\nThe grey warbler is a tiny, slim grey songbird that usually stays among canopy foliage. It is olive-grey above, with a grey face and off-white underparts. The tail is darker grey, getting darker towards the tip, contrasting with white tips to the tail feathers, showing as a prominent white band in flight. The black bill is finely pointed, the eye is bright red, and the legs are black and very slender. Grey warblers often glean insects from the outside of the canopy while hovering, which no other New Zealand bird does, making them identifiable by behaviour from a long distance.\n\nVoice:\n\n a characteristic long trilled song. The song is louder than expected, given the bird’s size. Only males sing, although females do give short chirp calls, usually as a contact call near the male. \n\nSimilar species:\n\n silvereyes are slightly larger, greener above, with buff flanks and (in adults) a characteristic white-eye-ring. In flight, silvereyes have a plain dark tail without a white tip.\n\nDistribution and habitat\n\nThe grey warbler is ubiquitous, occurring everywhere there are trees or shrubs on the three main islands, and on most offshore islands. It is one of the few native species to have maintained their distribution in almost all habitats following human colonisation, including rural and urban areas. They are typically found only in woody vegetation, in mid to high levels of the canopy, making them difficult to observe." forKey:@"item_description"];
        [newManagedObject25 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/grey-warbler-riroriro/" forKey:@"link"];
        [newManagedObject25 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject25 setValue:@"short,pointed" forKey:@"beak_length"];
        [newManagedObject25 setValue:@"can fly, Very active. Absent from open country and alpine areas" forKey:@"behaviour"];
        [newManagedObject25 setValue:@"1" forKey:@"category"];
        [newManagedObject25 setValue:@"grey" forKey:@"colour"];
        [newManagedObject25 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject25 setValue:@"Acanthizidae" forKey:@"family"];
        [newManagedObject25 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject25 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject25 setValue:@"Gray Gerygone" forKey:@"short_name"];
        [newManagedObject25 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url25 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"GreyWarbler_Gerygone1888"
//                                               ofType:@"jpg"]];
//        NSData *data25 = [[NSData alloc] initWithContentsOfURL:url25];
//        UIImage *imageSave25=[[UIImage alloc]initWithData:data25];
//        NSData *imageData25 = UIImagePNGRepresentation(imageSave25);
//        [newManagedObject25 setValue:imageData25         forKey:@"image"];
        [newManagedObject25 setValue:@"GreyWarbler"         forKey:@"image"];
        
        NSURL *url25t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"GreyWarbler_Gerygone1888_TN"
                                               ofType:@"jpg"]];
        NSData *data25t = [[NSData alloc] initWithContentsOfURL:url25t];
        UIImage *imageSave25t=[[UIImage alloc]initWithData:data25t];
        NSData *imageData25t = UIImagePNGRepresentation(imageSave25t);
        [newManagedObject25 setValue:imageData25t         forKey:@"thumbnail"];
        
        
        
        
        [newManagedObject25 setValue:@"grey-warbler-song" forKey:@"sound"];
        
        [newManagedObject25 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject25 setValue:NO forKey:@"extra"];
        [newManagedObject25 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject25 = nil;
//        data25 = nil;
//        imageSave25 = nil;
//        imageData25 = nil;
//        url25 = nil;
        
        
        
        // +++++++++++Blackbird +++++++++++++
        /*  26
         */
    
        NSManagedObject *newManagedObject26 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject26 setValue:@"Blackbird"       forKey:@"name"];
        [newManagedObject26 setValue:@"Turdus merula" forKey:@"othername"];
        [newManagedObject26 setValue:@"The Eurasian blackbird was introduced to New Zealand, and is now our most widely distributed bird species. Adult males are entirely black apart from their yellow bill and eye-ring. Females and juveniles are mostly dark brown, slightly mottled on the belly. Blackbirds are common in a wide range of habitats including suburban gardens, farmland, woodlands and indigenous forests. Their song is given from winter to summer, with the singing male usually perched on a high branch, tree top or power line. They sing most in the early morning and evening. Blackbirds feed mostly on the ground on earthworms, snails, and insects. They also take berries while perched in foliage.\n\nIdentification\n\nThe blackbird is larger than a song thrush and is further distinguished from it by having darker, more uniform plumage, which is entirely black in adult males. Males also have a yellow bill and a yellow eye-ring around their dark eye. Adult females are mostly dark brown on their upperparts, light brown or grey on the throat, and dark brown with slight mottling on the breast and belly; their bill is light brown. Juveniles are similar to adult females, but with light mottling over the body.\n\nVoice: the loud male territorial advertising song is mainly given from July to January. The song is similar to that of the song thrush, but without the repeated phrases that characterise thrush song. Other calls are given throughout the year, including a sharp quickly repeated alarm call made by if a predator threatens.\n\nSimilar species: female and juvenile blackbirds may be confused with song thrush, but thrushes are smaller and slimmer, with creamy-white underparts (speckled with brown) from chin to undertail." forKey:@"item_description"];
        [newManagedObject26 setValue:@"http://en.wikipedia.org/wiki/Common_Blackbird" forKey:@"link"];
        [newManagedObject26 setValue:@"orange" forKey:@"beak_colour"];
        [newManagedObject26 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject26 setValue:@"can fly, Defends its breading territory" forKey:@"behaviour"];
        [newManagedObject26 setValue:@"1" forKey:@"category"];
        [newManagedObject26 setValue:@"black" forKey:@"colour"];
        [newManagedObject26 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject26 setValue:@"Turdidae" forKey:@"family"];
        [newManagedObject26 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject26 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject26 setValue:@"Eurasian Blackbird" forKey:@"short_name"];
        [newManagedObject26 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url26 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Blackbird"
//                                               ofType:@"jpg"]];
//        NSData *data26 = [[NSData alloc] initWithContentsOfURL:url26];
//        UIImage *imageSave26=[[UIImage alloc]initWithData:data26];
//        NSData *imageData26 = UIImagePNGRepresentation(imageSave26);
//        [newManagedObject26 setValue:imageData26         forKey:@"image"];
        [newManagedObject26 setValue:@"Blackbird"         forKey:@"image"];
        
        NSURL *url26t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Blackbird_TN"
                                               ofType:@"jpg"]];
        NSData *data26t = [[NSData alloc] initWithContentsOfURL:url26t];
        UIImage *imageSave26t=[[UIImage alloc]initWithData:data26t];
        NSData *imageData26t = UIImagePNGRepresentation(imageSave26t);
        [newManagedObject26 setValue:imageData26t         forKey:@"thumbnail"];
        
        
        [newManagedObject26 setValue:@"blackbird" forKey:@"sound"];
        
        [newManagedObject26 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject26 setValue:NO forKey:@"extra"];
        [newManagedObject26 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject26 = nil;
//        data26 = nil;
//        imageSave26 = nil;
//        imageData26 = nil;
//        url26 = nil;
        
     
        // +++++++++++Song thrush +++++++++++++
        /*  27
         */
    
        NSManagedObject *newManagedObject27 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject27 setValue:@"Song thrush"       forKey:@"name"];
        [newManagedObject27 setValue:@"Turdus philomelos" forKey:@"othername"];
        [newManagedObject27 setValue:@"The song thrush is easily recognised by its speckled brown-on-cream breast. It is often heard before it is seen, as it is one of the main songsters of suburban New Zealand, with a very long singing season. Thrushes sing from a high branch, at the top of a tree or on power poles and lines. Their distinctive song comprising a wide range of notes, with each phrase typically repeated 2-3 times in succession.\n\nThe Song Thrush is not usually gregarious, although several birds may roost together in winter or be loosely associated in suitable feeding habitats, perhaps with other thrushes such as the Blackbird.\n\n They are common throughout mainland New Zealand, Stewart Island, Chatham Islands and on many off-shore islands. Thrushes frequent a wide range of lowland and hilly habitats including suburban gardens, farmland, woodlands and some forests. They feed mostly on the ground on earthworms and snails, also insects and berries. Song thrushes were introduced from England, and were released widely in New Zealand from 1867.\n\nIdentification\n\nThe song thrush is smaller than a blackbird and is distinguished from the female blackbird by its pale cream underparts speckled with fawn-brown chevrons. The head, back and upper wings and tail are smooth grey-brown with indistinct streaking on the head.  In flight the upper wing is mostly uniform brown. The sexes are alike; juveniles have similar colouring but the speckling on the breast is less distinct.\n\nVoice: distinctive and attractive song comprising a wide range of notes, often repeated, from about May to November, but calling can occur throughout the year. Calling can commence before sunrise. Singing is thought to be by males advertising territorial ownership.\n\nSimilar species: Eurasian blackbirds are larger and darker. Female and juvenile blackbirds are often confused with song thrushes, but do not have the thrush’s cream-coloured underparts overlaid with brown speckles." forKey:@"item_description"];
        [newManagedObject27 setValue:@"http://en.wikipedia.org/wiki/Song_Thrush" forKey:@"link"];
        [newManagedObject27 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject27 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject27 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject27 setValue:@"1" forKey:@"category"];
        [newManagedObject27 setValue:@"brown" forKey:@"colour"];
        [newManagedObject27 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject27 setValue:@"Turdidae" forKey:@"family"];
        [newManagedObject27 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject27 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject27 setValue:@"Song Thrush" forKey:@"short_name"];
        [newManagedObject27 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url27 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Thrush_song_06-03_SCOT"
//                                               ofType:@"jpg"]];
//        NSData *data27 = [[NSData alloc] initWithContentsOfURL:url27];
//        UIImage *imageSave27=[[UIImage alloc]initWithData:data27];
//        NSData *imageData27 = UIImagePNGRepresentation(imageSave27);
//        [newManagedObject27 setValue:imageData27         forKey:@"image"];
        [newManagedObject27 setValue:@"Thrush_song_06-03_SCOT"         forKey:@"image"];
        
        NSURL *url27t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Thrush_song_06-03_SCOT_TN"
                                               ofType:@"jpg"]];
        NSData *data27t = [[NSData alloc] initWithContentsOfURL:url27t];
        UIImage *imageSave27t=[[UIImage alloc]initWithData:data27t];
        NSData *imageData27t = UIImagePNGRepresentation(imageSave27t);
        [newManagedObject27 setValue:imageData27t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject27 setValue:@"Singdrossel_1753" forKey:@"sound"];
        
        [newManagedObject27 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject27 setValue:NO forKey:@"extra"];
        [newManagedObject27 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject27 = nil;
//        data27 = nil;
//        imageSave27 = nil;
//        imageData27 = nil;
//        url27 = nil;
        
      
        // +++++++++++Paradise Duck +++++++++++++
        /*  28
         */
      
        NSManagedObject *newManagedObject28 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject28 setValue:@"Paradise Shelduck"       forKey:@"name"];
        [newManagedObject28 setValue:@"Tadorna variegata" forKey:@"othername"];
        [newManagedObject28 setValue:@"The paradise shelduck is a colourful, conspicuous and noisy waterfowl that could be mistaken for a small goose. It has undergone a remarkable increase in population and distribution since about 1990, including the colonisation of sports fields and other open grassed areas within urban environments. This expansion has occurred in the face of being a gamebird and hunted annually.\n\nIdentification\n\nThe paradise shelduck is a conspicuous and colourful species with contrasting male and female plumages. Between a large duck and a small goose in size, the male is uniformly dark grey or black while the female body is a dark or light chestnut (depending on age and state of moult). The male’s head is black with occasional green iridescence and the female’s head and upper neck is white. Both sexes have a chestnut undertail, black primary wing feathers, green secondary wing feathers and a conspicuously white upper wing surface. Variable amounts of white may occur on the heads of males during the eclipse moult (February-May) and newly-fledged juvenile females may retain an extensive black head with a white face patch until they complete their post-juvenal moult (by May).The bill, legs and feet are dark grey/black. Down-covered ducklings appear initially as “mint humbugs”, patterned brown-and-white. The first feathers are dark, and near-fledged ducklings of both sexes resemble the adult male.\n\nVoice: the male paradise shelduck gives a di-syllabic goose-like honk when alarmed, or in flight. The main female call is more shrill, and more rapid and persistent, particularly during flight. There are a variety of other calls associated with pair formation and maintenance, territory defence, and maintaining contact with flock birds.\n\nSimilar species: vagrant chestnut-breasted shelducks are very similar to male paradise shelducks. They differ in having a white neck ring, chestnut or buff breast, and black undertail.\n\nDistribution and habitat\n\nThe paradise shelduck is New Zealand’s most widely distributed waterfowl, when both geographic spread and habitat use are taken into account. It occurs on North, South and Stewart Islands, all large near-shore islands with grassland (e.g. Kapiti, Great Barrier, D’Urville) and has straggled to distant Raoul and Lord Howe Islands, and to the Chatham Islands from which an as-yet unnamed shelduck species was exterminated by the first Polynesian settlers." forKey:@"item_description"];
        [newManagedObject28 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/paradise-duck-putakitaki/" forKey:@"link"];
        [newManagedObject28 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject28 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject28 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject28 setValue:@"1" forKey:@"category"];
        [newManagedObject28 setValue:@"brown/white" forKey:@"colour"];
        [newManagedObject28 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject28 setValue:@"Anatidae" forKey:@"family"];
        [newManagedObject28 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject28 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject28 setValue:@"Paradise Shelduck" forKey:@"short_name"];
        [newManagedObject28 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url28 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"ParadiseDuck"
//                                               ofType:@"jpg"]];
//        NSData *data28 = [[NSData alloc] initWithContentsOfURL:url28];
//        UIImage *imageSave28=[[UIImage alloc]initWithData:data28];
//        NSData *imageData28 = UIImagePNGRepresentation(imageSave28);
//        [newManagedObject28 setValue:imageData28         forKey:@"image"];
        [newManagedObject28 setValue:@"ParadiseDuck"         forKey:@"image"];
        
        
        NSURL *url28t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"ParadiseDuck_TN"
                                               ofType:@"jpg"]];
        NSData *data28t = [[NSData alloc] initWithContentsOfURL:url28t];
        UIImage *imageSave28t=[[UIImage alloc]initWithData:data28t];
        NSData *imageData28t = UIImagePNGRepresentation(imageSave28t);
        [newManagedObject28 setValue:imageData28t         forKey:@"thumbnail"];
        
        
        [newManagedObject28 setValue:@"Tadorna_variegata100309_16" forKey:@"sound"];
        
        [newManagedObject28 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject28 setValue:NO forKey:@"extra"];
        [newManagedObject28 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject28 = nil;
//        data28 = nil;
//        imageSave28 = nil;
//        imageData28 = nil;
//        url28 = nil;
        
        
        
        // +++++++++++Banded dotterel +++++++++++++
        /*  29
         */
    
        NSManagedObject *newManagedObject29 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject29 setValue:@"Dotterel, Banded"       forKey:@"name"];
        [newManagedObject29 setValue:@"Double banded plover (Charadrius bicinctus)" forKey:@"othername"];
        [newManagedObject29 setValue:@"Dotterels dart around on beaches and mudflats. The banded dotterel is easily identified by its breeding colours being a narrow dark band on its neck and a wide chestnut band on the breast. Its back and wings are fawn. \n\nThe Maori name for dotterel is tuturiwhatu. \n\nThe banded dotterel is the most numerous dotterel in New Zealand and is both endemic (only found here) to New Zealand and a protected species. The banded dotterel breeds in a variety of habitats including on coasts, farms, and on the shores of lakes and riverbeds. \n\nThey are most common in inland Canterbury and the Mackenzie Basin. The male makes several nests for the female to choose from and these are scrapes on sand or soil. Both the male and female incubate two to four eggs. After breeding, most of the inland breeding birds - slightly over half of the total population of 50,000 - migrate to Australia for winter." forKey:@"item_description"];
        [newManagedObject29 setValue:@"http://nzbirdsonline.org.nz/species/banded-dotterel" forKey:@"link"];
        [newManagedObject29 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject29 setValue:@"short,pointed" forKey:@"beak_length"];
        [newManagedObject29 setValue:@"can fly,nest in burrows" forKey:@"behaviour"];
        [newManagedObject29 setValue:@"1" forKey:@"category"];
        [newManagedObject29 setValue:@"brown" forKey:@"colour"];
        [newManagedObject29 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject29 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject29 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject29 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject29 setValue:@"Red-breasted Dotterel" forKey:@"short_name"];
        [newManagedObject29 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url29 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Charadrius_bicinctus_breeding_Ralphs_Bay"
//                                               ofType:@"jpg"]];
//        NSData *data29 = [[NSData alloc] initWithContentsOfURL:url29];
//        UIImage *imageSave29=[[UIImage alloc]initWithData:data29];
//        NSData *imageData29 = UIImagePNGRepresentation(imageSave29);
//        [newManagedObject29 setValue:imageData29         forKey:@"image"];
        [newManagedObject29 setValue:@"Charadrius_bicinctus_breeding_Ralphs_Bay"         forKey:@"image"];
        
        
        NSURL *url29t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Charadrius_bicinctus_breeding_Ralphs_Bay_TN"
                                               ofType:@"jpg"]];
        NSData *data29t = [[NSData alloc] initWithContentsOfURL:url29t];
        UIImage *imageSave29t=[[UIImage alloc]initWithData:data29t];
        NSData *imageData29t = UIImagePNGRepresentation(imageSave29t);
        [newManagedObject29 setValue:imageData29t         forKey:@"thumbnail"];
        
        
        [newManagedObject29 setValue:@"SHOREPLOVER" forKey:@"sound"];
        
        [newManagedObject29 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject29 setValue:NO forKey:@"extra"];
        [newManagedObject29 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject29 = nil;
//        data29 = nil;
//        imageSave29 = nil;
//        imageData29 = nil;
//        url29 = nil;
        
        
        
        // +++++++++++Takahe +++++++++++++
        /*  30
         */
      
        NSManagedObject *newManagedObject30 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject30 setValue:@"Takahe"       forKey:@"name"];
        [newManagedObject30 setValue:@"Porphyrio hochstetteri" forKey:@"othername"];
        [newManagedObject30 setValue:@"Rare, large stocky bird that was thought to be extinct until it was re-discovered near Lake Te Anau (South Island) in 1948. \n\nClose relative to the Pukeko (which is smaller and lighter). \n\nThe South Island takahē is a rare relict of the flightless, vegetarian bird fauna which once ranged New Zealand. Four specimens were collected from Fiordland between 1849 and 1898, after which takahē were considered to be extinct until famously rediscovered in the Murchison Mountains, west of Lake Te Anau, in 1948. Until the 1980s, takahē were confined in the wild to the Murchison Mountains. They have since been translocated to seven islands and several mainland sites, making them more accessible to many New Zealanders. Conservation work by the Department Of Conservation and community groups aims to prevent extinction and restore takahē to sites throughout their original range. \n\nThe success of DOC’s Takahē Recovery Programme relies heavily on a partnership with Mitre 10 who through Mitre 10 Takahē Rescue is helping to ensure the long-term survival of this treasured species.\n\nIdentification:\n\n The South Island takahē is the largest living rail in the world. An enormous gallinule, it has deep blue on the head, neck and underparts, olive green on the wings and back, and a white undertail, The huge conical bill is bright red, paler towards the tip, and extends on to the forehead as a red frontal shield. The stout legs are red, with orange underneath. Juveniles are duller with a blackish-orange beak and dull pink-brown legs.\n\nVoice:\n\n the main calls of takahē are a loud shriek, a quiet hooting contact call, and a muted boom indicating alarm.\n\nSimilar species: the extinct North Island takahē was taller and more slender. Pukeko can fly, and are smaller and more slender, with relatively longer legs, and black on the wings and back." forKey:@"item_description"];
        [newManagedObject30 setValue:@"http://nzbirdsonline.org.nz/species/south-island-takahe" forKey:@"link"];
        [newManagedObject30 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject30 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject30 setValue:@"flightless, sedentary" forKey:@"behaviour"];
        [newManagedObject30 setValue:@"1" forKey:@"category"];
        [newManagedObject30 setValue:@"blue" forKey:@"colour"];
        [newManagedObject30 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject30 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject30 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject30 setValue:@"Nationally Critical" forKey:@"threat_status"];
        [newManagedObject30 setValue:@"Takahe" forKey:@"short_name"];
        [newManagedObject30 setValue:@"goose" forKey:@"size_and_shape"];
        
//        NSURL *url30 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Takahe_Maunga"
//                                               ofType:@"jpg"]];
//        NSData *data30 = [[NSData alloc] initWithContentsOfURL:url30];
//        UIImage *imageSave30=[[UIImage alloc]initWithData:data30];
//        NSData *imageData30 = UIImagePNGRepresentation(imageSave30);
//        [newManagedObject30 setValue:imageData30         forKey:@"image"];
        [newManagedObject30 setValue:@"Takahe_Maunga"         forKey:@"image"];
        
        
        NSURL *url30t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Takahe_Maunga_TN"
                                               ofType:@"jpg"]];
        NSData *data30t = [[NSData alloc] initWithContentsOfURL:url30t];
        UIImage *imageSave30t=[[UIImage alloc]initWithData:data30t];
        NSData *imageData30t = UIImagePNGRepresentation(imageSave30t);
        [newManagedObject30 setValue:imageData30t         forKey:@"thumbnail"];
        
        
        [newManagedObject30 setValue:@"takahe-song-10_DOC" forKey:@"sound"];
        
        [newManagedObject30 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject30 setValue:NO forKey:@"extra"];
        [newManagedObject30 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject30 = nil;
//        data30 = nil;
//        imageSave30 = nil;
//        imageData30 = nil;
//        url30 = nil;
       
        // +++++++++++Pukeko +++++++++++++
        /*  31
         */
        
        NSManagedObject *newManagedObject31 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject31 setValue:@"Pukeko/ Purple Swamphen"       forKey:@"name"];
        [newManagedObject31 setValue:@"Porphyrio porphyrio" forKey:@"othername"];
        [newManagedObject31 setValue:@"Established in NZ ca. 1000 yrs ago they thrived in an environment in which they now face introduced predators like cats and rodents. Live in groups of 3-12; known to group together and shriek loudly to defend nests successfully during attacks by Australasian Harriers.The pukeko is a widespread and easily recognisable bird that has benefitted greatly by the clearing of land for agriculture. In addition to its brilliant red frontal shield and deep violet breast plumage, the pukeko is interesting for having a complex social life. In many areas, pukeko live in permanent social groups and defend a shared territory that is used for both feeding and breeding. Social groups can have multiple breeding males and females, but all eggs are laid in a single nest and the group offspring are raised by all group members.\n\nIdentification\n\nThe pukeko is a large, conspicious rail found throughout New Zealand. The head, breast and throat are deep blue/violet, the back and wings are black, and the under-tail coverts are conspicuously white. The conical bright red bill is connected to a similarly coloured ‘frontal shield’ ornament covering the forehead, the eyes are also red. The legs and feet are orange, with long, slim toes. Females are smaller than males, but similarly coloured. Juveniles are similar to adults but duller, with black eyes and black bill and shield that turn to red around 3 months of age.\n\nVoice: pukeko are very vocal with a variety of calls. Territorial ‘crowing’ is the loudest and most frequently heard call. A variety of contact calls including ‘’n’yip’, ‘hiccup’ and ‘squawk’ are used between adults, and between adults and chicks. The defence call is a loud, shrill screech used when a harrier is nearby. A similar, but deeper and hoarser, call is made during aggressive interactions between individuals. A soft nasal drone is performed during copulation runs.\n\nSimilar species: takahe are about twice the size (in weight) and flightless, with a green back and wing cover. Juveniles may be confused with the spotless crake which lacks a frontal shield and has a more slender bill. Rare vagrant dusky moorhen is more likely to be seen swimming, is not as upright as a pukeko, and is smaller and greyer with a yellow tip to the red bill, and a dark centre to the otherwise white undertail. The equally rare (in New Zealand) black-tailed native-hen is much smaller with a green-and-orange bill, white spots on the flanks and a longer tail that is black underneath. " forKey:@"item_description"];
        [newManagedObject31 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/pukeko/" forKey:@"link"];
        [newManagedObject31 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject31 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject31 setValue:@"flightless,sedentary" forKey:@"behaviour"];
        [newManagedObject31 setValue:@"1" forKey:@"category"];
        [newManagedObject31 setValue:@"blue" forKey:@"colour"];
        [newManagedObject31 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject31 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject31 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject31 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject31 setValue:@"Pukeko/ Purple Swamphen" forKey:@"short_name"];
        [newManagedObject31 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url31 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Pukeko_Porphyrio_porphyrio"
//                                               ofType:@"jpg"]];
//        NSData *data31 = [[NSData alloc] initWithContentsOfURL:url31];
//        UIImage *imageSave31=[[UIImage alloc]initWithData:data31];
//        NSData *imageData31 = UIImagePNGRepresentation(imageSave31);
//        [newManagedObject31 setValue:imageData31         forKey:@"image"];
        [newManagedObject31 setValue:@"Pukeko_Porphyrio_porphyrio"         forKey:@"image"];
        
        NSURL *url31t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Pukeko_Porphyrio_porphyrio_TN"
                                               ofType:@"jpg"]];
        NSData *data31t = [[NSData alloc] initWithContentsOfURL:url31t];
        UIImage *imageSave31t=[[UIImage alloc]initWithData:data31t];
        NSData *imageData31t = UIImagePNGRepresentation(imageSave31t);
        [newManagedObject31 setValue:imageData31t         forKey:@"thumbnail"];
        
        
        
        
        
        [newManagedObject31 setValue:@"Purple_Swamphen_Tiritiri_Matangi_Island" forKey:@"sound"];
        
        [newManagedObject31 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject31 setValue:NO forKey:@"extra"];
        [newManagedObject31 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject31 = nil;
//        data31 = nil;
//        imageSave31 = nil;
//        imageData31 = nil;
//        url31 = nil;
       
        // +++++++++++Harrier Hawk +++++++++++++
        /*  32
         */
     
        NSManagedObject *newManagedObject32 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject32 setValue:@"Harrier Hawk"       forKey:@"name"];
        [newManagedObject32 setValue:@"Harrier Hawk" forKey:@"othername"];
        [newManagedObject32 setValue:@"The swamp harrier is a large, tawny-brown bird of prey that occurs throughout New Zealand. It is an opportunistic hunter that searches for food by slowly quartering the ground with its large wings held in a distinctive shallow V-shape. Adapted to hunt in open habitats, its numbers have benefitted from widespread forest clearance and the development of agriculture. Although carrion is a major component of the harrier’s diet, it also actively hunts live prey such as small birds, mammals and insects. Capable dispersers, birds from New Zealand visit islands as far north as the Kermadec Islands and as far south as Campbell Island. Known for their dramatic ‘sky-dancing’ courtship display the swamp harrier is the largest of the 16 species of harriers found worldwide.\n\nIdentification\n\nOften seen perching on fence posts at the side of the road, swamp harriers are a large, long-legged bird of prey with sizeable taloned feet, prominent facial disks and a strongly hooked bill. Fledglings and juveniles have dark chocolate brown plumage all over, a whitish patch on the nape, brown eyes and a pale yellow cere, eye ring and legs. Although plumage is highly variable, adults generally have a tawny-brown back, a pale cream streaked breast and yellow eyes. They become paler with successive moults. Females are slightly larger than males. Harriers most often search for food low to the ground in a gently rocking glide interspersed with lazy wing beats. When gliding or soaring, their wings are set in a shallow V-shape with upturned fingered wing tips and an outspread tail. The cream/white rump is obvious in flight. They can hover clumsily for short periods.\n\nVoice: harriers mainly vocalise as part of their courtship displays during the breeding season. Their call is a series of same note, high-pitched, short, sharp “kee-o kee-o.” At other times of the year they are generally silent.\n\nSimilar species: sometimes confused with the New Zealand falcon. Falcons very rarely feed on carrion, are smaller and are more often seen in active chasing flight rather than the slow quartering flight typical of the harrier. Also the falcon lacks the obvious cream/pale rump of the harrier and glides with its wings set flat. Juvenile black-backed gulls are a similar size to harriers. However, young gulls have a stout, straight bill and are a more mottled greyish/brown colour. Gulls also have narrower angular wings that unlike harriers they beat almost continually in traversing flight or set rigidly in a slightly downwards droop when soaring/gliding.\n\nDistribution and habitat\n\nSwamp harriers occupy a wider ecological niche in New Zealand than elsewhere in Australasia. Abundant throughout most of New Zealand including the coastal fringe, estuaries, wetlands, pine forest, farmland and high-country areas. Less abundant over large tracts of forest and in urban areas. They are resident on the Chatham Islands, and often reach offshore islands as distant as the Snares, Auckland, Campbell and Kermadec Islands. Harriers are particularly abundant where plentiful food sources are available. They breed in wetlands, areas of long grass and scrubby vegetation.\n\nPopulation\n\nWidespread and very common." forKey:@"item_description"];
        [newManagedObject32 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/" forKey:@"link"];
        [newManagedObject32 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject32 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject32 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject32 setValue:@"1" forKey:@"category"];
        [newManagedObject32 setValue:@"brown" forKey:@"colour"];
        [newManagedObject32 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject32 setValue:@"Accipitridae" forKey:@"family"];
        [newManagedObject32 setValue:@"garden/bush" forKey:@"habitat"];
        [newManagedObject32 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject32 setValue:@"Swamp Harrier" forKey:@"short_name"];
        [newManagedObject32 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url32 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"harrierHawk"
//                                               ofType:@"jpg"]];
//        NSData *data32 = [[NSData alloc] initWithContentsOfURL:url32];
//        UIImage *imageSave32=[[UIImage alloc]initWithData:data32];
//        NSData *imageData32 = UIImagePNGRepresentation(imageSave32);
//        [newManagedObject32 setValue:imageData32         forKey:@"image"];
        [newManagedObject32 setValue:@"harrierHawk"         forKey:@"image"];
        
        NSURL *url32t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"harrierHawk_TN"
                                               ofType:@"jpg"]];
        NSData *data32t = [[NSData alloc] initWithContentsOfURL:url32t];
        UIImage *imageSave32t=[[UIImage alloc]initWithData:data32t];
        NSData *imageData32t = UIImagePNGRepresentation(imageSave32t);
        [newManagedObject32 setValue:imageData32t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject32 setValue:@"HawkSperber_Accnis" forKey:@"sound"];
        
        [newManagedObject32 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject32 setValue:NO forKey:@"extra"];
        [newManagedObject32 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject32 = nil;
//        data32 = nil;
//        imageSave32 = nil;
//        imageData32 = nil;
//        url32 = nil;
       
        // +++++++++++Pied Stilt +++++++++++++
        /*  33
         */
 
        NSManagedObject *newManagedObject33 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject33 setValue:@"Pied Stilt (white headed)"       forKey:@"name"];
        [newManagedObject33 setValue:@"Poaka (Himantopus Leucocephalus)" forKey:@"othername"];
        [newManagedObject33 setValue:@"The pied stilt is a dainty wading bird with, as its name suggests, black-and white-colouration and very long legs. It is common at wetlands and coastal areas throughout New Zealand and may be seen feeding alongside oystercatchers.\n\nPied stilts tend to be shy of people and fly away, yapping, when approached.\\n\nIdentification\n\nThe pied stilt is a medium-large wader with very long pink legs and a long, fine, black bill. The body is mainly white with black back and wings, and black on the back of the head and neck. In flight the white body and black on the back of the neck are conspicuous. The underside of the wings is black, and the long pink legs trailing behind are diagnostic. Juvenile birds look similar to adults but the back of the head and neck are mottled fawn or brown and off-white and there is no black band. The wings are not quite as black as in the mature bird.\n\nVoice: the calls heard most often are high pitched yapping alarm calls. A less strident version is used as a contact call, including by flocks flying at night.\n\nSimilar species: juvenile black stilts may be mistaken for pied stilts. Black stilts are very rare and nest only in the braided rivers of the central South Island, though some migrate to coastal areas and flock with pied stilts. Juvenile black stilts usually have some black on their underparts between the legs and the tail, even if restricted to the flanks. This becomes more extensive at their first moult, and so any stilt with extensive black on the hind belly is likely to be an immature black stilt. Stilts with irregular or mottled black markings are likely to be hybrids between black and pied stilts.\n\nDistribution and habitat\n\nKnown elsewhere as the black-winged stilt, the pied stilt  is  a truly cosmopolitan bird with breeding populations throughout many of the tropical and warmer temperate regions of the world. They are believed to have been in New Zealand since the early 19th century, with the main growth in population from about 1870-1940.\n\nPied stilts live in all kinds of wetlands from brackish estuaries and saltmarshes to freshwater lakes, swamps and braided rivers. They feed in shallow water or mud and roost in shallow water or on banks or sandbanks. After the breeding season, birds migrate from inland locations towards more northerly coastal locations.\n\nPopulation\n\nThere were an estimated 30,000 pied stilts in New Zealand in the early 1990s." forKey:@"item_description"];
        [newManagedObject33 setValue:@"http://en.wikipedia.org/wiki/Black-winged_Stilt" forKey:@"link"];
        [newManagedObject33 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject33 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject33 setValue:@"can fly,forages in shallow water" forKey:@"behaviour"];
        [newManagedObject33 setValue:@"1" forKey:@"category"];
        [newManagedObject33 setValue:@"black/white" forKey:@"colour"];
        [newManagedObject33 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject33 setValue:@"Recurvirostridae" forKey:@"family"];
        [newManagedObject33 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject33 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject33 setValue:@"Australasian Pied Stilt" forKey:@"short_name"];
        [newManagedObject33 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url33 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Adult_and_immature_White-headed_Stilts_PiedStiltHimantopus_leucocephalus_in_the_water"
//                                               ofType:@"jpg"]];
//        NSData *data33 = [[NSData alloc] initWithContentsOfURL:url33];
//        UIImage *imageSave33=[[UIImage alloc]initWithData:data33];
//        NSData *imageData33 = UIImagePNGRepresentation(imageSave33);
//        [newManagedObject33 setValue:imageData33         forKey:@"image"];
        [newManagedObject33 setValue:@"Adult_and_immature_White-headed_Stilts_PiedStiltHimantopus_leucocephalus_in_the_water"         forKey:@"image"];
        
        NSURL *url33t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Adult_and_immature_White-headed_Stilts_PiedStiltHimantopus_leucocephalus_in_the_water_TN"
                                               ofType:@"jpg"]];
        NSData *data33t = [[NSData alloc] initWithContentsOfURL:url33t];
        UIImage *imageSave33t=[[UIImage alloc]initWithData:data33t];
        NSData *imageData33t = UIImagePNGRepresentation(imageSave33t);
        [newManagedObject33 setValue:imageData33t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject33 setValue:@"PiedStilt_WhhSti-20090712_083000" forKey:@"sound"];
        
        [newManagedObject33 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject33 setValue:NO forKey:@"extra"];
        [newManagedObject33 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject33 = nil;
//        data33 = nil;
//        imageSave33 = nil;
//        imageData33 = nil;
//        url33 = nil;
        
        
        // +++++++++++Pheasant +++++++++++++
        /*  34
         */
     
        NSManagedObject *newManagedObject34 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject34 setValue:@"Pheasant"       forKey:@"name"];
        [newManagedObject34 setValue:@"Pheasant" forKey:@"othername"];
        [newManagedObject34 setValue:@"Acclimatisation Societies released about 30 species of upland game birds throughout New Zealand, to provide sport for European colonists. Common pheasants were among the first to be released, in Wellington, Canterbury, Otago and Auckland 1842-1877. They are established throughout open country in the North Island, with local populations topped up by ongoing releases by Fish & Game Councils and private breeders. Numbers are lower in the South Island. Hunting of pheasants and other game birds in New Zealand is managed by Fish & Game New Zealand.\n\nIdentification\n\nThe common pheasant is the largest introduced upland gamebird species established in New Zealand, weighing up to 1.5 kilograms. The male is larger than the female and much more brightly coloured. The most prominent features of the male are its red facial wattle, iridescent blue-green head and neck feathers, distinctive white collar, and long, barred tail feather. The body feathers are red and brown with intricate white margins and black barring. The female is much smaller with a short tail and subtly marked brown feathers with much finer black barring.\n\nVoice: the male has a distinctive loud crow ‘kok-kok’. When flushed, the male utters a loud throaty korrrk alarm call.\n\nSimilar species: adult female and immature common pheasants may resemble helmeted guineafowl but lack the bony casque on the head and white-spotted grey plumage. They may also resemble weka and adult female and immature wild turkeys but are distinguished by having long tapering tail feathers and paler brown plumage.\n\nDistribution\n\nPheasants are most abundant in the northern and western regions of the North Island. In the South Island, it is mainly found in the drier areas of Canterbury and Nelson.\n\nHabitat\n\nIn New Zealand, common pheasants inhabit a wide variety of open habitats, including grasslands, arable and pastural farmland, exotic forestry, deciduous woodland, coastal shrubland and road verges. They have a strong association with areas where ink weed is common." forKey:@"item_description"];
        [newManagedObject34 setValue:@"en.wikipedia.org/wiki/Pheasant" forKey:@"link"];
        [newManagedObject34 setValue:@"white" forKey:@"beak_colour"];
        [newManagedObject34 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject34 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject34 setValue:@"1" forKey:@"category"];
        [newManagedObject34 setValue:@"brown/green" forKey:@"colour"];
        [newManagedObject34 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject34 setValue:@"Phasianidae" forKey:@"family"];
        [newManagedObject34 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject34 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject34 setValue:@"Ring-necked Pheasant" forKey:@"short_name"];
        [newManagedObject34 setValue:@"goose" forKey:@"size_and_shape"];
        
//        NSURL *url34 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Pheasant"
//                                               ofType:@"jpg"]];
//        NSData *data34 = [[NSData alloc] initWithContentsOfURL:url34];
//        UIImage *imageSave34=[[UIImage alloc]initWithData:data34];
//        NSData *imageData34 = UIImagePNGRepresentation(imageSave34);
//        [newManagedObject34 setValue:imageData34         forKey:@"image"];
        [newManagedObject34 setValue:@"Pheasant"         forKey:@"image"];
        
        NSURL *url34t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Pheasant_TN"
                                               ofType:@"jpg"]];
        NSData *data34t = [[NSData alloc] initWithContentsOfURL:url34t];
        UIImage *imageSave34t=[[UIImage alloc]initWithData:data34t];
        NSData *imageData34t = UIImagePNGRepresentation(imageSave34t);
        [newManagedObject34 setValue:imageData34t         forKey:@"thumbnail"];
        
        
        //[newManagedObject34 setValue:@"cockatiel" forKey:@"sound"];
        
        [newManagedObject34 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject34 setValue:NO forKey:@"extra"];
        [newManagedObject34 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject34 = nil;
//        data34 = nil;
//        imageSave34 = nil;
//        imageData34 = nil;
//        url34 = nil;
        
       
        // +++++++++++Peacock +++++++++++++
        /*  35
         */
    
        NSManagedObject *newManagedObject35 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject35 setValue:@"Peacock"       forKey:@"name"];
        [newManagedObject35 setValue:@"Peacock" forKey:@"othername"];
        [newManagedObject35 setValue:@"A large, well-known pheasant. Males have a characteristic display, raising their extravagantly long ornamental tail coverts, during the breeding season. Females move in groups between displaying males. Both sexes are generally tame in park situations but can be very wary in feral populations.\n\nIdentification\n\nA large crested pheasant. Males are deep blue on the breast, neck, head and fan crest, and metallic green on the back and rump. The over-developed upper tail coverts have a tan, lilac and purple-brown sheen and are up to 1.4 m long. In mature males, about 140-150 feathers have ‘eyes’ which are deep blue in the centre and have outer layers of metallic lighter blue, gold and metallic green. The coverts are held up by the rigid tail feathers in their characteristic display, during which the tail coverts are violently shaken. Females are slightly smaller than males and have a coppery brown head, lighter brown throat and the rest of the neck is dull metallic green. The rest of the feathers are speckled brown.\n\nVoice: a series of repeated crowing ka and shrill eow calls of varying frequency given up to 8 times in a row by males, primarily in the breeding season. Other distress and warning calls given throughout the year. Clucking calls are used by females with young and when pointing out food.\n\nDistribution and habitat\n\nPeafowl have been released into the wild many times, mainly through benign neglect of birds kept for display. Peafowl are held on many lifestyle properties, and have become feral in the upper North Island, especially Northland, Auckland, East Cape and mid Hawkes Bay. The largest feral populations are in wooded lowlands and coastal farmland including the upper Wanganui River catchment, northern Mahia Peninsula and pine forests of the South Head of Kaipara Harbour. They are also present in isolated locations in Nelson, Marlborough and Canterbury. Absent from Stewart Island." forKey:@"item_description"];
        [newManagedObject35 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/" forKey:@"link"];
        [newManagedObject35 setValue:@"white" forKey:@"beak_colour"];
        [newManagedObject35 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject35 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject35 setValue:@"1" forKey:@"category"];
        [newManagedObject35 setValue:@"green/blue" forKey:@"colour"];
        [newManagedObject35 setValue:@"grey" forKey:@"leg_colour"];
        [newManagedObject35 setValue:@"Phasianidae" forKey:@"family"];
        [newManagedObject35 setValue:@"garden/bush" forKey:@"habitat"];
        [newManagedObject35 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        [newManagedObject35 setValue:@"Peacock" forKey:@"short_name"];
        [newManagedObject35 setValue:@"swan" forKey:@"size_and_shape"];
        
//        NSURL *url35 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Peacock3"
//                                               ofType:@"jpg"]];
//        NSData *data35 = [[NSData alloc] initWithContentsOfURL:url35];
//        UIImage *imageSave35=[[UIImage alloc]initWithData:data35];
//        NSData *imageData35 = UIImagePNGRepresentation(imageSave35);
//        [newManagedObject35 setValue:imageData35         forKey:@"image"];
        [newManagedObject35 setValue:@"Peacock3"         forKey:@"image"];
        
        NSURL *url35t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Peacock3_TN"
                                               ofType:@"jpg"]];
        NSData *data35t = [[NSData alloc] initWithContentsOfURL:url35t];
        UIImage *imageSave35t=[[UIImage alloc]initWithData:data35t];
        NSData *imageData35t = UIImagePNGRepresentation(imageSave35t);
        [newManagedObject35 setValue:imageData35t         forKey:@"thumbnail"];
        
        
        [newManagedObject35 setValue:@"greypeacockpheasantbarkingcallthaiFarrow" forKey:@"sound"];
        
        [newManagedObject35 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject35 setValue:NO forKey:@"extra"];
        [newManagedObject35 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject35 = nil;
//        data35 = nil;
//        imageSave35 = nil;
//        imageData35 = nil;
//        url35 = nil;
       
        // +++++++++++Little Blue Penguin +++++++++++++
        /*  38
         */
    
        NSManagedObject *newManagedObject36 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject36 setValue:@"Penguin, little blue"       forKey:@"name"];
        [newManagedObject36 setValue:@"Eudyptila minor" forKey:@"othername"];
        [newManagedObject36 setValue:@"The smallest species of penguin. The penguin, which usually grows to an average of 33 cm in height and 43 cmin length, found on the coastlines of southern Australia and New Zealand, with possible records from Chile. \n\nApart from Little Penguins, they have several common names. In Australia, they are also referred to as Fairy Penguins because of their tiny size. In New Zealand, they are also called Little Blue Penguins, or just Blue Penguins, owing to their slate-blue plumage, and they are called Kororā in Māori. Rough estimates (as new colonies continue to be discovered) of the world population are around 350,000-600,000 animals.\n\nThe species is not considered endangered, except for the White-Flippered subspecies found only on Banks Peninsula and nearby Motunau Island in New Zealand. Since the 1960s, the mainland population has declined by 60-70%; though there has been a small increase on Motunau Island. But overall Little Penguin populations have been decreasing as well, with some colonies having been wiped out and other populations continuing to be at risk. However, new colonies have been established in urban areas. \n\nThe greatest threat to Little Penguin populations has been predation (including nest predation) from cats, foxes, large reptiles, ferrets and stoats. Due to their diminutive size and the introduction of new predators, some colonies have been reduced in size by as much as 98% in just a few years, such as the small colony on Middle Island, near Warrnambool, Victoria, which was reduced from approximately 600 penguins in 2001 to less than 10 in 2005. \n\nBecause of this threat of colony collapse, conservationists pioneered an experimental technique using Maremma Sheepdogs to protect the colony and fend off would-be predators." forKey:@"item_description"];
        [newManagedObject36 setValue:@"http://en.wikipedia.org/wiki/Little_Penguin" forKey:@"link"];
        [newManagedObject36 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject36 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject36 setValue:@"flightless,diurnal" forKey:@"behaviour"];
        [newManagedObject36 setValue:@"1" forKey:@"category"];
        [newManagedObject36 setValue:@"grey/black" forKey:@"colour"];
        [newManagedObject36 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject36 setValue:@"Spheniscidae" forKey:@"family"];
        [newManagedObject36 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject36 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject36 setValue:@"Little Penguin" forKey:@"short_name"];
        [newManagedObject36 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url36 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Little_Penguin"
//                                               ofType:@"jpg"]];
//        NSData *data36 = [[NSData alloc] initWithContentsOfURL:url36];
//        UIImage *imageSave36=[[UIImage alloc]initWithData:data36];
//        NSData *imageData36 = UIImagePNGRepresentation(imageSave36);
//        [newManagedObject36 setValue:imageData36         forKey:@"image"];
        [newManagedObject36 setValue:@"LittleBluePenguin_steintil"         forKey:@"image"];
        
        
        NSURL *url36t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"LittleBluePenguin_steintil_TN"
                                               ofType:@"jpg"]];
        NSData *data36t = [[NSData alloc] initWithContentsOfURL:url36t];
        UIImage *imageSave36t=[[UIImage alloc]initWithData:data36t];
        NSData *imageData36t = UIImagePNGRepresentation(imageSave36t);
        [newManagedObject36 setValue:imageData36t         forKey:@"thumbnail"];
        
        
        [newManagedObject36 setValue:@"Little-PenguineEudyptilaMinor_XC98203" forKey:@"sound"];
        
        [newManagedObject36 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject36 setValue:NO forKey:@"extra"];
        [newManagedObject36 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject36 = nil;
//        data36 = nil;
//        imageSave36 = nil;
//        imageData36 = nil;
//        url36 = nil;
     
        // +++++++++++Rosella +++++++++++++
        /*  37
         */
        
        NSManagedObject *newManagedObject37 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject37 setValue:@"Rosella, eastern"       forKey:@"name"];
        [newManagedObject37 setValue:@"Eudyptila minor" forKey:@"othername"];
        [newManagedObject37 setValue:@"A parrot-like bird,the Eastern Rosella (Platycercus eximius) is a native to southeast of the Australian continent and to Tasmania. \n\nIt has been introduced to New Zealand where feral populations are found in the North Island (notably in the northern half of the island and in the Hutt Valley) and in the hills around Dunedin in the South Island." forKey:@"item_description"];
        [newManagedObject37 setValue:@"http://en.wikipedia.org/wiki/Eastern_Rosella" forKey:@"link"];
        [newManagedObject37 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject37 setValue:@"hooked" forKey:@"beak_length"];
        [newManagedObject37 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject37 setValue:@"1" forKey:@"category"];
        [newManagedObject37 setValue:@"red/green/blue/yellow" forKey:@"colour"];
        [newManagedObject37 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject37 setValue:@"Psittacidae" forKey:@"family"];
        [newManagedObject37 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject37 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject37 setValue:@"Eastern Rosella" forKey:@"short_name"];
        [newManagedObject37 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url37 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"RosellaEastern600px-Platycercus_eximius_-Buffalo_Zoo-8-3c"
//                                               ofType:@"jpg"]];
//        NSData *data37 = [[NSData alloc] initWithContentsOfURL:url37];
//        UIImage *imageSave37=[[UIImage alloc]initWithData:data37];
//        NSData *imageData37 = UIImagePNGRepresentation(imageSave37);
//        [newManagedObject37 setValue:imageData37         forKey:@"image"];
        [newManagedObject37 setValue:@"RosellaEastern600px-Platycercus_eximius_-Buffalo_Zoo-8-3c"         forKey:@"image"];
        
        NSURL *url37t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"RosellaEastern600px-Platycercus_eximius_-Buffalo_Zoo-8-3c_TN"
                                               ofType:@"jpg"]];
        NSData *data37t = [[NSData alloc] initWithContentsOfURL:url37t];
        UIImage *imageSave37t=[[UIImage alloc]initWithData:data37t];
        NSData *imageData37t = UIImagePNGRepresentation(imageSave37t);
        [newManagedObject37 setValue:imageData37t         forKey:@"thumbnail"];
        
        
        [newManagedObject37 setValue:@"rosellas" forKey:@"sound"];
        
        [newManagedObject37 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject37 setValue:NO forKey:@"extra"];
        [newManagedObject37 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject37 = nil;
//        data37 = nil;
//        imageSave37 = nil;
//        imageData37 = nil;
//        url37 = nil;
     
        // +++++++++++Weka +++++++++++++
        /*  38
         */
        
        NSManagedObject *newManagedObject38 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject38 setValue:@"Weka (woodhen)"       forKey:@"name"];
        [newManagedObject38 setValue:@"Gallirallus australis" forKey:@"othername"];
        [newManagedObject38 setValue:@"The weka is one of New Zealand’s iconic large flightless birds. Likely derived from a flighted ancestor, weka are 3-6 times larger than banded rails, which are considered their nearest flying relatives. Weka are charismatic birds that are often attracted to human activity. This makes an encounter with a weka a wildlife highlight for many people, as the curious bird searches for any food item that the intruder might bring. \n\nBut people who live alongside weka often have a less charitable opinion, as they have to live with ever-watchful weka snatching opportunities to raid vegetable gardens, pilfer poultry food and eggs, and even steal dog food from the bowl. Unfortunately weka are not as robust as they appear, and have become extinct over large tracts of the mainland. Causes of extinction are complex, and are likely to be due to interactions between climatic conditions (especially drought) and predator numbers (especially ferrets, stoats and dogs). Fortunately, weka still thrive at many accessible sites, including on Kawau, Mokoia, Kapiti, Ulva and Chatham Islands, the Marlborough Sounds, North Westland, and parts of the Abel Tasman, Heaphy and Milford Tracks.\n\nIdentification\n\nThe weka is a large flightless rail that can have extremely variable plumage. Most birds are predominantly mid-brown, those on the Chatham Islands are tawny, those from Stewart Island are chestnut, and a proportion in Fiordland and on some islands near Stewart Island are almost black. Most birds have their dorsal feathers streaked with black, and all have their longest wing and tail feathers boldly barred with black. As adults, all have red eyes, a strong pointed bill and strong legs. North Island birds are predominantly grey-breasted with grey bills and brown legs. Western, Stewart Island and buff weka (the latter on Chatham Islands) can vary from having a grey to brown-grey breast with a wide brown breast-band, and having grey to pink bills and brown to pink legs.\n\nVoice: spacing calls are generally given at dawn and in the half hour after sunset. They are a characteristic coo..eet given as a duet by members of a pair, with the male call lower and slower than the female. Other calls include booming, and soft clucking contact calls.\n\nSimilar species: the banded rail is much smaller and more boldly marked, including a rufous eye-stripe on an otherwise pale grey face, a broad orange breast band, and underparts boldly barred with black-and-white. Female common pheasants have smaller heads, shorter bills, much longer tails, and will fly if pressed.\n\nDistribution and habitat\n\nWeka strongholds include Russell Peninsula, Kawakawa Bay and Opotiki-Motu in the North Island, and the Marlborough Sounds, North-west Nelson, the West Coast north of Ross, and Fiordland in the South Island. Also on many islands." forKey:@"item_description"];
        [newManagedObject38 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/weka/" forKey:@"link"];
        [newManagedObject38 setValue:@"reddish" forKey:@"beak_colour"];
        [newManagedObject38 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject38 setValue:@"flightless,nocturnal" forKey:@"behaviour"];
        [newManagedObject38 setValue:@"1" forKey:@"category"];
        [newManagedObject38 setValue:@"brown" forKey:@"colour"];
        [newManagedObject38 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject38 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject38 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject38 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject38 setValue:@"Weka" forKey:@"short_name"];
        [newManagedObject38 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url38 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"WekaGallirallus_australis_Willowbank_Wildlife_Reserve_Christchurch"
//                                               ofType:@"jpg"]];
//        NSData *data38 = [[NSData alloc] initWithContentsOfURL:url38];
//        UIImage *imageSave38=[[UIImage alloc]initWithData:data38];
//        NSData *imageData38 = UIImagePNGRepresentation(imageSave38);
//        [newManagedObject38 setValue:imageData38         forKey:@"image"];
        [newManagedObject38 setValue:@"WekaGallirallus_australis_Willowbank_Wildlife_Reserve_Christchurch"         forKey:@"image"];
        
        NSURL *url38t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"WekaGallirallus_australis_Willowbank_Wildlife_Reserve_Christchurch_TN"
                                               ofType:@"jpg"]];
        NSData *data38t = [[NSData alloc] initWithContentsOfURL:url38t];
        UIImage *imageSave38t=[[UIImage alloc]initWithData:data38t];
        NSData *imageData38t = UIImagePNGRepresentation(imageSave38t);
        [newManagedObject38 setValue:imageData38t         forKey:@"thumbnail"];
        
        
        [newManagedObject38 setValue:@"Weka_Song" forKey:@"sound"];
        
        [newManagedObject38 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject38 setValue:NO forKey:@"extra"];
        [newManagedObject38 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject38 = nil;
//        data38 = nil;
//        imageSave38 = nil;
//        imageData38 = nil;
//        url38 = nil;
        
        // +++++++++++Shag, spotted +++++++++++++
        /*  39
         */
        
        NSManagedObject *newManagedObject39 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject39 setValue:@"Shag, spotted"       forKey:@"name"];
        [newManagedObject39 setValue:@"Stictocarbo punctatus" forKey:@"othername"];
        [newManagedObject39 setValue:@"The spotted shag or parekareka (Stictocarbo punctatus) is a species of cormorant endemic to New Zealand. Originally classified as Phalacrocorax punctatus, it is sufficiently different in appearance from typical members of that genus that to be for a time placed in a separate genus, Stictocarbo, along with another similar species, the Pitt shag.\n\nCompared with typical cormorants, the spotted shag is a light-coloured bird. Its back is brown. Its belly is pale blue-grey (often appearing white), and the white continues up the sides of the neck and face, but the throat and the top of the head are dark blue-green. In the mating season, it has an obvious double crest. There is little sexual dimorphism.\n\nSpotted shags feed at sea, often in substantial flocks, taking their prey from mid-water rather than the bottom. It is likely that pilchard and anchovy are important prey species.\n\nSpotted shags nest in colonies of 10-700 pairs, these colonies are generally found on the ledges of coastal cliffs  or on rocky islets.\n\nIn the South Island, they are particularly readily observed around Banks Peninsula; there is a large nesting colony immediately south of the city of Christchurch. In Wellington Harbour there is a large colony on a rocky outcrop known as 'Shag Rock' just off the south-west end of Matiu/Somes Island.\n\nIn the Hauraki Gulf there is a breeding colony on Tarahiki Island.\n\nThe spotted shag was featured on a 60-cent New Zealand postage stamp first issued in 1988, in a series devoted to native birds." forKey:@"item_description"];
        [newManagedObject39 setValue:@"http://nzbirdsonline.org.nz/species/spotted-shag" forKey:@"link"];
        [newManagedObject39 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject39 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject39 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject39 setValue:@"1" forKey:@"category"];
        [newManagedObject39 setValue:@"black/grey" forKey:@"colour"];
        [newManagedObject39 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject39 setValue:@"Phalacrocoracidae" forKey:@"family"];
        [newManagedObject39 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject39 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject39 setValue:@"Spotted Shag" forKey:@"short_name"];
        [newManagedObject39 setValue:@"goose" forKey:@"size_and_shape"];
        
//        NSURL *url39 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"SpottedShag_Phalacrocorax_punctatus_AucklandZoo"
//                                               ofType:@"jpg"]];
//        NSData *data39 = [[NSData alloc] initWithContentsOfURL:url39];
//        UIImage *imageSave39=[[UIImage alloc]initWithData:data39];
//        NSData *imageData39 = UIImagePNGRepresentation(imageSave39);
//        [newManagedObject39 setValue:imageData39         forKey:@"image"];
        [newManagedObject39 setValue:@"SpottedShag_Phalacrocorax_punctatus_AucklandZoo"         forKey:@"image"];
        
        NSURL *url39t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"SpottedShag_Phalacrocorax_punctatus_AucklandZoo_TN"
                                               ofType:@"jpg"]];
        NSData *data39t = [[NSData alloc] initWithContentsOfURL:url39t];
        UIImage *imageSave39t=[[UIImage alloc]initWithData:data39t];
        NSData *imageData39t = UIImagePNGRepresentation(imageSave39t);
        [newManagedObject39 setValue:imageData39t         forKey:@"thumbnail"];
        
        
        [newManagedObject39 setValue:@"SHAG_Phalacrocorax_magellanicus" forKey:@"sound"];
        
        [newManagedObject39 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject39 setValue:NO forKey:@"extra"];
        [newManagedObject39 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject39 = nil;
//        data39 = nil;
//        imageSave39 = nil;
//        imageData39 = nil;
//        url39 = nil;
        
        
        // +++++++++++Shag, little +++++++++++++
        /*  40
         */
        
        NSManagedObject *newManagedObject40 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject40 setValue:@"Shag, little"       forKey:@"name"];
        [newManagedObject40 setValue:@"Microcarbo melanoleucos" forKey:@"othername"];
        [newManagedObject40 setValue:@"A coastal bird, also called cormorant or fregate bird. The bird family Phalacrocoracidae or the cormorants is represented by some 40 species of cormorants and shags. It lives near bodies of water such as swamps, lakes, lagoons, estuaries and the coastline.\n\nThe little shag is the most widely distributed shag species in New Zealand, found in both marine and freshwater habitats, on the coast as well as on inland lakes, ponds, rivers and streams. It also has the most variable plumage of any New Zealand shag. The face, throat, breast and belly plumage range from completely black through to white, with a range of partial combinations in between. These pose a challenge to identification, at least until the observer becomes familiar with the little shag’s diagnostic short-billed and long-tailed silhouette, along with its small size and stubby yellow bill. Shape alone is sufficient to identify a little shag.\n\nIdentification\n\nThe little shag is a small shag that exhibits bewildering plumage variation. Most adults are black with white cheeks and throat, a colour morph sometimes referred to as a ‘white-throated shag’. At the other extreme, 8-60% of adults (depending on location) have completely white underparts, from face to undertail, indistinguishable from the little pied shags/cormorants of Australia. ‘Intermediate morph’ or ‘smudgy’ are terms used for about 5% of birds that have white faces and throats and variegated patches of black and white on the breast and belly. All three morphs develop a crest during the breeding season. The bill is short, stout and yellow, dark on the ridge. The eye is brown, and facial skin yellow. Legs and feet are black. The pied morph of the little shag is more common in the north of New Zealand. In 1987, white-breasted birds made up 60% of the population in the Far North, 32% in Auckland, 15% in the rest of the North Island, but just 8% in the South Island, where the white-throated morph is predominant.\n\nThe first plumage of juveniles is either white-breasted or entirely black. Examples of each type can be present in the same nest where the adults are of different plumage forms. The all-black fledglings develop a white throat after becoming independent and until then can be confused with little black shags (but note differences in bill colour and shape). \n\nVoice: silent except at nesting colonies, where males give characteristic bi- or tri-syllabic ‘cooing’ sounds during courtship displays. A greeting call, consisting of a series of notes, uh, uh, uh, uh, fading away, is used by both sexes when approaching the nest to change over or to bring food.\n\nSimilar species: black shag, pied shag, and little pied shag all have plumage that is similar to one of the patterns seen in adult or juvenile little shag colour morphs. In all ages and plumages, little shags can be distinguished from these three other species by their small size combined with a short, stout yellow bill and relatively long tail." forKey:@"item_description"];
        [newManagedObject40 setValue:@"http://en.wikipedia.org/wiki/Cormorant" forKey:@"link"];
        [newManagedObject40 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject40 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject40 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject40 setValue:@"1" forKey:@"category"];
        [newManagedObject40 setValue:@"black/white" forKey:@"colour"];
        [newManagedObject40 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject40 setValue:@"Phalacrocoracidae" forKey:@"family"];
        [newManagedObject40 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject40 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject40 setValue:@"Little Pied Cormorant" forKey:@"short_name"];
        [newManagedObject40 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url40 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Shag_IMG_7093"
//                                               ofType:@"jpg"]];
//        NSData *data40 = [[NSData alloc] initWithContentsOfURL:url40];
//        UIImage *imageSave40=[[UIImage alloc]initWithData:data40];
//        NSData *imageData40 = UIImagePNGRepresentation(imageSave40);
//        [newManagedObject40 setValue:imageData40         forKey:@"image"];
        [newManagedObject40 setValue:@"Shag_IMG_7093"         forKey:@"image"];
        
        NSURL *url40t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Shag_IMG_7093_TN"
                                               ofType:@"jpg"]];
        NSData *data40t = [[NSData alloc] initWithContentsOfURL:url40t];
        UIImage *imageSave40t=[[UIImage alloc]initWithData:data40t];
        NSData *imageData40t = UIImagePNGRepresentation(imageSave40t);
        [newManagedObject40 setValue:imageData40t         forKey:@"thumbnail"];
        
        
        
        [newManagedObject40 setValue:@"SHAGAuklandIs_FL Enderby26Nov2000" forKey:@"sound"];
        
        [newManagedObject40 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject40 setValue:NO forKey:@"extra"];
        [newManagedObject40 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject40 = nil;
//        data40 = nil;
//        imageSave40 = nil;
//        imageData40 = nil;
//        url40 = nil;
        
        // +++++++++++Kingfisher +++++++++++++
        /*  41
         */
        
        NSManagedObject *newManagedObject41 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject41 setValue:@"Kingfisher"       forKey:@"name"];
        [newManagedObject41 setValue:@"Kotare" forKey:@"othername"];
        [newManagedObject41 setValue:@"The sacred kingfisher is one of the best known birds in New Zealand due to the iconic photographs published over many years by Geoff Moon. These early images showed in detail the prey, the foraging skills and the development of chicks in the nest and as fledgings. Equally recognisable is the hunched silhouette waiting patiently on a powerline or other elevated perch over an estuary or mudflat which converts in a flash to a streak of green diving steeply to catch a prey item.\n\nKingfishers are found widely in New Zealand in a wide range of habitats: the key ingredients are elevated observation posts to hunt from, banks or suitable standing trees to excavate nests in, and open or semi-open habitats which support a range of prey items.\n\nIdentification\n\nA distinctive bird with a green-blue back, buff to yellow undersides and a large black bill. It has a broad black eye-stripe from lores to ear-coverts, and a white collar in adults. The underparts vary with wear; orange buff to buff when fresh but fading to cream or white when worn. The bill is black with a narrow pale strip on the lower mandible; the iris is dark brown with a black orbital ring. The legs and feet are grey or pink-brown.There are slight difference between the sexes, with females greener and duller above. Immatures are duller, with buff feather edges on upper parts and brownish mottling on the chest and collar. The distinctive hunched silhouette on power-lines over water, and direct flight between perch and food and return to perch are characteristic. Flight swift and direct with rapid shallow wing beats interspersed with fast glides.\n\nKingfishers have a wide range of unmusical calls, the most distinctive of which is the staccato ‘kek-kek-kek’ territorial call.\n\nThe distinctive green-blue back and cap along with heavy black bill distinguishes it from other species.\n\nDistribution\n\nPresent on all three main islands and the Kermadec Islands. Vagrant to the Chatham Islands, and absent from the subantartic islands. Recorded in both coastal and inland freshwater habitats. Common on farmland with trees, and along river banks. Uncommon well inland and in mountainous regions. More frequently encountered in the North Island than in the southern South Island.\n\nHabitat\n\nA wide range of forest, river margins, farmland, lakes estuaries and rocky coastlines; anywhere where there is water or open country with adjacent elevated perches.\n\nPopulation\n\nCommon and widely distributed: Kingfishers congregate in coastal districts and lowlands during winter." forKey:@"item_description"];
        [newManagedObject41 setValue:@"http://nzbirdsonline.org.nz/species/sacred-kingfisher" forKey:@"link"];
        [newManagedObject41 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject41 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject41 setValue:@"can fly,very shy, fast flier, preys on small animals" forKey:@"behaviour"];
        [newManagedObject41 setValue:@"1" forKey:@"category"];
        [newManagedObject41 setValue:@"green/blue" forKey:@"colour"];
        [newManagedObject41 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject41 setValue:@"Alcedinidae" forKey:@"family"];
        [newManagedObject41 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject41 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject41 setValue:@"Sacred Kingfisher" forKey:@"short_name"];
        [newManagedObject41 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url41 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Kingfisher_IMG_6929"
//                                               ofType:@"jpg"]];
//        NSData *data41 = [[NSData alloc] initWithContentsOfURL:url41];
//        UIImage *imageSave41=[[UIImage alloc]initWithData:data41];
//        NSData *imageData41 = UIImagePNGRepresentation(imageSave41);
//        [newManagedObject41 setValue:imageData41         forKey:@"image"];
        [newManagedObject41 setValue:@"Kingfisher_IMG_6929"         forKey:@"image"];
        
        NSURL *url41t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Kingfisher_IMG_6929_TN"
                                               ofType:@"jpg"]];
        NSData *data41t = [[NSData alloc] initWithContentsOfURL:url41t];
        UIImage *imageSave41t=[[UIImage alloc]initWithData:data41t];
        NSData *imageData41t = UIImagePNGRepresentation(imageSave41t);
        [newManagedObject41 setValue:imageData41t         forKey:@"thumbnail"];
        
        //[newManagedObject41 setValue:@"SHAGAuklandIs_FL Enderby26Nov2000" forKey:@"sound"];
        
        [newManagedObject41 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject41 setValue:NO forKey:@"extra"];
        [newManagedObject41 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject41 = nil;
//        data41 = nil;
//        imageSave41 = nil;
//        imageData41 = nil;
//        url41 = nil;
        
        // +++++++++++Myna +++++++++++++
        /*  43
         */
        
        NSManagedObject *newManagedObject43 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject43 setValue:@"Myna"       forKey:@"name"];
        [newManagedObject43 setValue:@"Myna" forKey:@"othername"];
        [newManagedObject43 setValue:@"A relatively abundand bird, hugely competitive. The common myna (Acridotheres tristis), sometimes spelled mynah, also sometimes known as \"Indian myna\", is a member of the family Sturnidae (starlings and mynas) native to Asia. An omnivorous open woodland bird with a strong territorial instinct, the myna has adapted extremely well to urban environments.\n\nThe common myna is an important motif in Indian culture and appears both in Sanskrit and Prakrit literature. \"Myna\" is derived from the Hindi language mainā which itself is derived from Sanskrit madanā.\n\nThe range of the common myna is increasing at such a rapid rate that in 2000 the IUCN Species Survival Commission declared it one of the world's most invasive species and one of only three birds in the top 100 species that pose an impact to biodiversity, agriculture and human interests. In particular, the species poses a serious threat to the ecosystems of Australia where it was named \"The Most Important Pest/Problem\".\n\nThe common myna is readily identified by the brown body, black hooded head and the bare yellow patch behind the eye. The bill and legs are bright yellow. There is a white patch on the outer primaries and the wing lining on the underside is white. The sexes are similar and birds are usually seen in pairs." forKey:@"item_description"];
        [newManagedObject43 setValue:@"http://en.wikipedia.org/wiki/Myna" forKey:@"link"];
        [newManagedObject43 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject43 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject43 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject43 setValue:@"1" forKey:@"category"];
        [newManagedObject43 setValue:@"grey/brown/white" forKey:@"colour"];
        [newManagedObject43 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject43 setValue:@"Sturnidae" forKey:@"family"];
        [newManagedObject43 setValue:@"coast/garden/bush" forKey:@"habitat"];
        [newManagedObject43 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject43 setValue:@"Myna" forKey:@"short_name"];
        [newManagedObject43 setValue:@"blackbird" forKey:@"size_and_shape"];
        
//        NSURL *url43 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Myna_768px-Acridotheres_tristis_-Sydney,_Australia-8"
//                                               ofType:@"jpg"]];
//        NSData *data43 = [[NSData alloc] initWithContentsOfURL:url43];
//        UIImage *imageSave43=[[UIImage alloc]initWithData:data43];
//        NSData *imageData43 = UIImagePNGRepresentation(imageSave43);
//        [newManagedObject43 setValue:imageData43         forKey:@"image"];
        [newManagedObject43 setValue:@"Myna_768px-Acridotheres_tristis_-Sydney,_Australia-8"         forKey:@"image"];
        
        NSURL *url43t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Myna_768px-Acridotheres_tristis_-Sydney,_Australia-8_TN"
                                               ofType:@"jpg"]];
        NSData *data43t = [[NSData alloc] initWithContentsOfURL:url43t];
        UIImage *imageSave43t=[[UIImage alloc]initWithData:data43t];
        NSData *imageData43t = UIImagePNGRepresentation(imageSave43t);
        [newManagedObject43 setValue:imageData43t         forKey:@"thumbnail"];
        
        
        //[newManagedObject43 setValue:@"SHAGAuklandIs_FL Enderby26Nov2000" forKey:@"sound"];
        
        [newManagedObject43 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject43 setValue:NO forKey:@"extra"];
        [newManagedObject43 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject43 = nil;
//        data43 = nil;
//        imageSave43 = nil;
//        imageData43 = nil;
//        url43 = nil;
       
 
        
        // +++++++++++Dunnock +++++++++++++
        /*  44
         */
        
        NSManagedObject *newManagedObject44 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject44 setValue:@"Dunnock"       forKey:@"name"];
        [newManagedObject44 setValue:@"Dunnock" forKey:@"othername"];
        [newManagedObject44 setValue:@"Dunnocks are small brown songbirds that were introduced from England into multiple regions of New Zealand between 1865 and 1896. They are a common sight in urban gardens and open country in southern New Zealand, but are scarcer in the northern North Island. The drab appearance of dunnocks is compensated by their stunningly complex breeding behaviours.\n\nIdentification\n\nDunnocks are small, slim songbirds with sombre brown plumage, streaked with darker brown on the back and flanks, and merging into the greyish eyebrow, chin, throat and breast. The blackish bill is fine and pointed, the iris of adults is red-brown, and the legs orange-brown. The sexes are alike; juveniles are similar but have brown eyes.\n\nVoice: the song is a thin warble, similar in structure to a blackbird’s song, given by the male usually from a perch high in a tree. The contact call – a high pitched tseep – is a familiar sound of southern New Zealand suburbs, farms and shrublands in autumn and winter.\n\nSimilar species: with their drab brown plumage, and tendency to forage on the ground, dunnocks superficially resemble house sparrows. However, house sparrows are larger, have a robust, triangular-shaped bill, and have more patterned upperparts, including a pale bar on the inner wing." forKey:@"item_description"];
        [newManagedObject44 setValue:@"http://en.wikipedia.org/wiki/Dunnock" forKey:@"link"];
        [newManagedObject44 setValue:@"grey/black" forKey:@"beak_colour"];
        [newManagedObject44 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject44 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject44 setValue:@"0" forKey:@"category"];
        [newManagedObject44 setValue:@"brown" forKey:@"colour"];
        [newManagedObject44 setValue:@"orange/brown" forKey:@"leg_colour"];
        [newManagedObject44 setValue:@"Prunellidae" forKey:@"family"];
        [newManagedObject44 setValue:@"garden/bush/coast" forKey:@"habitat"];
        [newManagedObject44 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject44 setValue:@"Dunnock" forKey:@"short_name"];
        [newManagedObject44 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url44 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Dunnock_IMG_7140"
//                                               ofType:@"jpg"]];
//        NSData *data44 = [[NSData alloc] initWithContentsOfURL:url44];
//        UIImage *imageSave44=[[UIImage alloc]initWithData:data44];
//        NSData *imageData44 = UIImagePNGRepresentation(imageSave44);
//        [newManagedObject44 setValue:imageData44         forKey:@"image"];
        [newManagedObject44 setValue:@"Dunnock_IMG_7140"         forKey:@"image"];
        
        NSURL *url44t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Dunnock_IMG_7140_TN"
                                               ofType:@"jpg"]];
        NSData *data44t = [[NSData alloc] initWithContentsOfURL:url44t];
        UIImage *imageSave44t=[[UIImage alloc]initWithData:data44t];
        NSData *imageData44t = UIImagePNGRepresentation(imageSave44t);
        [newManagedObject44 setValue:imageData44t         forKey:@"thumbnail"];
        
        
        //[newManagedObject44 setValue:@"SHAGAuklandIs_FL Enderby26Nov2000" forKey:@"sound"];
        
        [newManagedObject44 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject44 setValue:NO forKey:@"extra"];
        [newManagedObject44 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject44= nil;
//        data44 = nil;
//        imageSave44 = nil;
//        imageData44 = nil;
//        url44 = nil;
        
        
        
        // +++++++++++Greenfinch +++++++++++++
        /*  45
         */
        
        NSManagedObject *newManagedObject45 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject45 setValue:@"Greenfinch"       forKey:@"name"];
        [newManagedObject45 setValue:@"Carduelis chloris" forKey:@"othername"];
        [newManagedObject45 setValue:@"Greenfinches are the largest and most stockily built of New Zealand’s introduced finches. A heavy bill allows the bird to crack larger seeds than other species can manage. They were introduced from Britain by Acclimatisation Societies between 1862 and 1868, and are now common throughout much of the mainland. Greenfinches feed mostly on seeds, including those from a number of crops; therefore they are regarded as a pest in some districts. Large flocks are frequent outside the breeding season, often mixed with other species of finches.\n\nIdentification\n\nGreenfinches are similar in size to, but more thickset than a house sparrow. They are sexually dimorphic; males are green, varying in intensity, with some yellow on the abdomen. There are bright yellow bars on the leading edges of the wings. The female, by contrast, is dull and sparrow-like with little yellow on the wings. Juveniles are similar to the adult female, but more streaked.\n\nVoice: the male has a not unpleasant song during the breeding season, and also utters a loud dzweee call frequently during this time.\n\nSimilar species: the male greenfinch is similar in colour to both the silvereye and the endemic bellbird. It can be distinguished from both of these by its far heavier bill, and larger size in comparison with the silvereye. The female could be confused with the female house sparrow, but is more olive-brown in general colouration, and also more finely streaked.The Greenfinch has been introduced into both Australia and New Zealand from Europe. The Greenfinch is 15 cm long with a wing span of 24.5 to 27.5 cm. It is similar in size and shape to a House Sparrow, but is mainly green, with yellow in the wings and tail. The female and young birds are duller and have brown tones on the back. The bill is thick and conical. The song contains wheezes and twitters, and the male has a butterfly display flight." forKey:@"item_description"];
        [newManagedObject45 setValue:@"http://en.wikipedia.org/wiki/European_Greenfinch" forKey:@"link"];
        [newManagedObject45 setValue:@"orange" forKey:@"beak_colour"];
        [newManagedObject45 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject45 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject45 setValue:@"0" forKey:@"category"];
        [newManagedObject45 setValue:@"green" forKey:@"colour"];
        [newManagedObject45 setValue:@"orange/red" forKey:@"leg_colour"];
        [newManagedObject45 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject45 setValue:@"garden/bush" forKey:@"habitat"];
        [newManagedObject45 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject45 setValue:@"European Greenfinch" forKey:@"short_name"];
        [newManagedObject45 setValue:@"blackbird" forKey:@"size_and_shape"];
        
        //        NSURL *url45 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                               pathForResource:@"Dunnock_IMG_7140"
        //                                               ofType:@"jpg"]];
        //        NSData *data45 = [[NSData alloc] initWithContentsOfURL:url45];
        //        UIImage *imageSave45=[[UIImage alloc]initWithData:data45];
        //        NSData *imageData45 = UIImagePNGRepresentation(imageSave45);
        //        [newManagedObject45 setValue:imageData45         forKey:@"image"];
        [newManagedObject45 setValue:@"Carduelis_chloris_AuthorOlivierFromFranceWikiCommons"         forKey:@"image"];
        
        NSURL *url45t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Carduelis_chloris_TN"
                                                ofType:@"jpg"]];
        NSData *data45t = [[NSData alloc] initWithContentsOfURL:url45t];
        UIImage *imageSave45t=[[UIImage alloc]initWithData:data45t];
        NSData *imageData45t = UIImagePNGRepresentation(imageSave45t);
        [newManagedObject45 setValue:imageData45t         forKey:@"thumbnail"];
        
        
        //[newManagedObject45 setValue:@"SHAGAuklandIs_FL Enderby26Nov2000" forKey:@"sound"];
        
        [newManagedObject45 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject45 setValue:NO forKey:@"extra"];
        [newManagedObject45 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject45= nil;
        //        data45 = nil;
        //        imageSave45 = nil;
        //        imageData45 = nil;
        //        url45 = nil;
        
        
        
        // +++++++++++Shining Cuckoo +++++++++++++
        /*  46
         */
        
        NSManagedObject *newManagedObject46 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject46 setValue:@"Shining Cuckoo"       forKey:@"name"];
        [newManagedObject46 setValue:@"Chrysococcyx lucidus" forKey:@"othername"];
        [newManagedObject46 setValue:@"It is the world’s smallest cuckoo, being only 15 to 17 centimetres (5.9 to 6.7 in) in length, and parasitises chiefly dome-shaped nests of various Gerygone species, having a range that largely corresponds with the distribution of that genus. It may also parasitise other Acanthizidae species, and is also the most southerly ranging brood parasitic bird species in the world, extending to 45°S in New Zealand. \n\nHard to spot and easier to hear, the Shining Bronze Cuckoo has metallic golden or coppery green upperparts and white cheeks and underparts barred with dark green. The female is similar with a more purplish sheen to the crown and nape and bronzer-tinged barring on the belly. The bill is black and the feet are black with yellow undersides." forKey:@"item_description"];
        [newManagedObject46 setValue:@"http://en.wikipedia.org/wiki/Shining_Cuckoo" forKey:@"link"];
        [newManagedObject46 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject46 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject46 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject46 setValue:@"0" forKey:@"category"];
        [newManagedObject46 setValue:@"green" forKey:@"colour"];
        [newManagedObject46 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject46 setValue:@"Cuculidae" forKey:@"family"];
        [newManagedObject46 setValue:@"garden/bush/coast" forKey:@"habitat"];
        [newManagedObject46 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject46 setValue:@"Shining Bronze-Cuckoo" forKey:@"short_name"];
        [newManagedObject46 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        //        NSURL *url46 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                               pathForResource:@"Dunnock_IMG_7140"
        //                                               ofType:@"jpg"]];
        //        NSData *data46 = [[NSData alloc] initWithContentsOfURL:url46];
        //        UIImage *imageSave46=[[UIImage alloc]initWithData:data46];
        //        NSData *imageData46 = UIImagePNGRepresentation(imageSave46);
        //        [newManagedObject46 setValue:imageData46         forKey:@"image"];
        [newManagedObject46 setValue:@"Chrysococcyx_lucidus_JamesNiland_Brisbane_Queensland_Australia"         forKey:@"image"];
        
        NSURL *url46t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Chrysococcyx_lucidus_-Brisbane,_Queensland,_Australia_TN"
                                                ofType:@"jpg"]];
        NSData *data46t = [[NSData alloc] initWithContentsOfURL:url46t];
        UIImage *imageSave46t=[[UIImage alloc]initWithData:data46t];
        NSData *imageData46t = UIImagePNGRepresentation(imageSave46t);
        [newManagedObject46 setValue:imageData46t         forKey:@"thumbnail"];
        
        
        [newManagedObject46 setValue:@"Shining_BronzeCuckoo" forKey:@"sound"];
        
        [newManagedObject46 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject46 setValue:NO forKey:@"extra"];
        [newManagedObject46 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject46= nil;
        //        data46 = nil;
        //        imageSave46 = nil;
        //        imageData46 = nil;
        //        url46 = nil;
        
        
        
        // +++++++++++Welcome Swallow +++++++++++++
        /*  47
         */
        
        NSManagedObject *newManagedObject47 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject47 setValue:@"Welcome Swallow"       forKey:@"name"];
        [newManagedObject47 setValue:@"Hirundo neoxena" forKey:@"othername"];
        [newManagedObject47 setValue:@"It is a species native to Australia and nearby islands, and self-introduced into New Zealand in the middle of the twentieth century. It is very similar to the Pacific Swallow with which it is often considered conspecific. \n\nMetallic blue-black above, light grey below on the breast and belly, and rusty on the forehead, throat and upper breast. \n\nIt has a long forked tail, with a row of white spots on the individual feathers. These birds are about 15 cm (6 in) long, including the outer tail feathers which are slightly shorter in the female. " forKey:@"item_description"];
        [newManagedObject47 setValue:@"http://en.wikipedia.org/wiki/Welcome_Swallow" forKey:@"link"];
        [newManagedObject47 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject47 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject47 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject47 setValue:@"0" forKey:@"category"];
        [newManagedObject47 setValue:@"blue/orange" forKey:@"colour"];
        [newManagedObject47 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject47 setValue:@"Prunellidae" forKey:@"family"];
        [newManagedObject47 setValue:@"bush/coast" forKey:@"habitat"];
        [newManagedObject47 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject47 setValue:@"Welcome Swallow" forKey:@"short_name"];
        [newManagedObject47 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        //        NSURL *url47 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                               pathForResource:@"Dunnock_IMG_7140"
        //                                               ofType:@"jpg"]];
        //        NSData *data47 = [[NSData alloc] initWithContentsOfURL:url47];
        //        UIImage *imageSave47=[[UIImage alloc]initWithData:data47];
        //        NSData *imageData47 = UIImagePNGRepresentation(imageSave47);
        //        [newManagedObject47 setValue:imageData47         forKey:@"image"];
        [newManagedObject47 setValue:@"commonswikimedia.orgwikiFileWelcome_Swallowjpg800px-Welcome_Swallow"         forKey:@"image"];
        
        NSURL *url47t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Welcome_Swallow_TN"
                                                ofType:@"jpg"]];
        NSData *data47t = [[NSData alloc] initWithContentsOfURL:url47t];
        UIImage *imageSave47t=[[UIImage alloc]initWithData:data47t];
        NSData *imageData47t = UIImagePNGRepresentation(imageSave47t);
        [newManagedObject47 setValue:imageData47t         forKey:@"thumbnail"];
        
        
        [newManagedObject47 setValue:@"Hirundotahitica" forKey:@"sound"];
        
        [newManagedObject47 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject47 setValue:NO forKey:@"extra"];
        [newManagedObject47 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject47= nil;
        //        data47 = nil;
        //        imageSave47 = nil;
        //        imageData47 = nil;
        //        url47 = nil;
        
// V2 starts here
        // +++++++++++ Kaka +++++++++++++
        /*  48 http://tomassobekphotography.co.nz/gallery3/index.php/Trips/Stewart-Island-to-West-Coast-Dec-2013/Kaka_tree_branch
         (Tomas Sobek)
         */
        NSManagedObject *newManagedObject48 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject48 setValue:@"Kaka"       forKey:@"name"];
        [newManagedObject48 setValue:@"Nestor meridionalis" forKey:@"othername"];
        [newManagedObject48 setValue:@"The New Zealand Kaka is a medium sized parrot, measuring 45 cm  in length and weighing from 390 to 560 g , with an average of 452 g. It is closely related to the Kea, but has darker plumage and is more arboreal.\n\nThe forehead and crown are greyish-white and the nape is greyish-brown. The neck and abdomen are more reddish, while the wings are more brownish. Both sub-species have a strongly patterned brown/green/grey plumage with orange and scarlet flashes under the wings; color variants which show red to yellow coloration especially on the breast are sometimes found. This group of parrots is unusual, retaining more primitive features lost in most other parrots, because it split off from the rest around 100 million years ago. The calls include a harsh ka-aa and a whistling u-wiia.\n\nDistribution and habitat:\n\n The New Zealand Kaka lives in lowland and mid-altitude native forest. Its strongholds are currently the offshore reserves of Kapiti Island, Codfish Island and Little Barrier Island. It is breeding rapidly in the mainland island sanctuary at Zealandia (Karori Wildlife Sanctuary/Wellington), with over 300 birds banded since their reintroduction in 2002." forKey:@"item_description"];
        [newManagedObject48 setValue:@"http://en.wikipedia.org/wiki/New_Zealand_kaka" forKey:@"link"];
        [newManagedObject48 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject48 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject48 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject48 setValue:@"0" forKey:@"category"];
        [newManagedObject48 setValue:@"brown/red" forKey:@"colour"];
        [newManagedObject48 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject48 setValue:@"Nestoridae" forKey:@"family"];
        [newManagedObject48 setValue:@"bush/mountain" forKey:@"habitat"];
        [newManagedObject48 setValue:@"Nationally Vulnerable" forKey:@"threat_status"];
        [newManagedObject48 setValue:@"Kaka" forKey:@"short_name"];
        [newManagedObject48 setValue:@"duck" forKey:@"size_and_shape"];
        
       
        [newManagedObject48 setValue:@"Kaka_on_Branch"         forKey:@"image"];
        
        NSURL *url48t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Kaka_on_Branch_TN"
                                                ofType:@"jpg"]];
        NSData *data48t = [[NSData alloc] initWithContentsOfURL:url48t];
        UIImage *imageSave48t=[[UIImage alloc]initWithData:data48t];
        NSData *imageData48t = UIImagePNGRepresentation(imageSave48t);
        [newManagedObject48 setValue:imageData48t         forKey:@"thumbnail"];
        
        
        [newManagedObject48 setValue:@"south-island-kaka_DOC" forKey:@"sound"];
        
        [newManagedObject48 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject48 setValue:NO forKey:@"extra"];
        [newManagedObject48 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject48= nil;

        // +++++++++++ Redpoll +++++++++++++
        /*  49
         */
        NSManagedObject *newManagedObject49 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject49 setValue:@"Redpoll"       forKey:@"name"];
        [newManagedObject49 setValue:@"Redpoll" forKey:@"othername"];
        [newManagedObject49 setValue:@"Redpolls are the smallest of New Zealand’s introduced finches. The Redpoll is a small brownish-streaked songbird species with a bright red crown patch and a stubby yellowsh bill. Adult males have a variable amount of pink on the lower throat and breast which only appears after the second moult; some adult females and first-year males may have a slight pink flush on the breast and juveniles look similar to adult females but are paler and lack any red on the crown. \n\nThe redpoll is widespread throughout the South Island, and is also found on many off-shore islands. In the North Island, it is found in all regions, but is generally less abundant than in the South Island." forKey:@"item_description"];
        [newManagedObject49 setValue:@"http://en.wikipedia.org/wiki/Redpoll" forKey:@"link"];
        [newManagedObject49 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject49 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject49 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject49 setValue:@"0" forKey:@"category"];
        [newManagedObject49 setValue:@"brown/red" forKey:@"colour"];
        [newManagedObject49 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject49 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject49 setValue:@"open country, bush" forKey:@"habitat"];
        [newManagedObject49 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject49 setValue:@"Redpoll" forKey:@"short_name"];
        [newManagedObject49 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject49 setValue:@"RedpollAndyMorffew"         forKey:@"image"];
        
        NSURL *url49t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"RedpollAndyMorffew_TN"
                                                ofType:@"jpg"]];
        NSData *data49t = [[NSData alloc] initWithContentsOfURL:url49t];
        UIImage *imageSave49t=[[UIImage alloc]initWithData:data49t];
        NSData *imageData49t = UIImagePNGRepresentation(imageSave49t);
        [newManagedObject49 setValue:imageData49t         forKey:@"thumbnail"];
        
        
        //[newManagedObject49 setValue:@"" forKey:@"sound"];
        
        [newManagedObject49 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject49 setValue:NO forKey:@"extra"];
        [newManagedObject49 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject49= nil;

        // +++++++++++ Rock Pigeon +++++++++++++
        /*  50 -https://www.flickr.com/photos/prasad-vibhu/5660933336/in/photolist-9fi5TB-9fi7bH-9fi4Mk-guU3em-9fmikj-9fibci-guVnB9-9fi6Ep-9fieBH-9fmq19-9fmk89-9kmMZz-4jXWSf-4TrAgv-dYeiUN-jNvKSq-9KAQbw-azFWWV-fUH3ZT-ebbBCD-6cZrBb-eNPGZh-5h92MZ-6vWQsa-8FCU4o-63MCiZ-8VPvcf-6aDFsb-e3e4Ry-7wPt4e-9CeLfU-4Gh9m6-2eiP6P-7vFqVW-7vBBQv-7vFr5L-823rH5-7vFr95-823rD9-7vBBUr-7vBBC4-7vBBSp-7vBBFV-7vFqMy-udj1n-aQn6Yx-5LvcTX-6qurK7-5LzrLJ-3RP78p/ Vibhu Prasad
         */
        NSManagedObject *newManagedObject50 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject50 setValue:@"Rock Pigeon"       forKey:@"name"];
        [newManagedObject50 setValue:@"Rock Pigeon" forKey:@"othername"];
        [newManagedObject50 setValue:@"Bill: Short and slightly curved with a white crop at the base\n\nSize: 13-14 inches long with 25-inch wingspan, stocky body and pointed wings\n\nColors: Blue gray, black, white, brown, iridescent\n\nMarkings: Pigeons have a wide range of color and marking variations due to escaped domestic birds and fancy stock breeding. Typical pigeons are a blue gray overall with an iridescent neck that reflects blue, green and purple. Birds may have thick black wing bars and most pigeons are light underneath the wings. Eyes and legs are orange or reddish. Additional color variations include white, brown, tan or mottled birds.\n\nThese birds thrive in human habitats and are most populous in large cities but can also be found in suburban and rural locations. Pigeons do not migrate.\n\nBecause pigeons are so used to humans, they often seem semi-tame and will readily approach passersby for food. Large flocks of pigeons are constantly foraging or birds will roost in close contact with one another. Pigeons are very agile fliers that can reach speeds up to 85 miles per hour with their tapered, falcon-like wings.\n\nWhen commuting between roosting and foraging sites, rock pigeons fly directly and quickly with steady-paced wing beats. They may travel several kilometres to reach foraging sites. Rock pigeons generally forage in pairs or as a loose flock, with almost all searching for food being carried out while walking about on the ground. Often during spring and summer, males at foraging sites will court females. This involves the male standing erect with head bowed, plumage puffed out and tail fanned, walking and running about the female while cooing loudly. Nest sites are vigorously defended, sometimes resulting in fights for occupancy." forKey:@"item_description"];
        [newManagedObject50 setValue:@"http://birding.about.com/od/birdprofiles/p/rockpigeon.htm" forKey:@"link"];
        [newManagedObject50 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject50 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject50 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject50 setValue:@"0" forKey:@"category"];
        [newManagedObject50 setValue:@"grey" forKey:@"colour"];
        [newManagedObject50 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject50 setValue:@"Columbidae" forKey:@"family"];
        [newManagedObject50 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject50 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject50 setValue:@"Rock Pigeon" forKey:@"short_name"];
        [newManagedObject50 setValue:@"pigeon" forKey:@"size_and_shape"];
        

        [newManagedObject50 setValue:@"RockPigeon"         forKey:@"image"];
        
        NSURL *url50t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"RockPigeon_TN"
                                                ofType:@"jpg"]];
        NSData *data50t = [[NSData alloc] initWithContentsOfURL:url50t];
        UIImage *imageSave50t=[[UIImage alloc]initWithData:data50t];
        NSData *imageData50t = UIImagePNGRepresentation(imageSave50t);
        [newManagedObject50 setValue:imageData50t         forKey:@"thumbnail"];
        
        
        //[newManagedObject50 setValue:@"" forKey:@"sound"];
        
        [newManagedObject50 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject50 setValue:NO forKey:@"extra"];
        [newManagedObject50 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject50= nil;

        // +++++++++++ Skylark +++++++++++++
        /*  51 -https://www.flickr.com/photos/nottsexminer/6886717978/in/photolist-4Ykfd6-f4TwEC-sNWah-cRorW9-eLzR8d-6qqAuw-a2yLMk-7AWweg-buyfgw-b1JGqi-7AWw54-7fuXb3-buyejS-m9dxhb-7AWvTK-acto2d-a2BCYN-actnWq-oemuyL-a2yKdD-8jD8U5-ojGkqm-mTZXxB-6qqvkA-omUS7W-6q1iFo-dW3fDo-jQhHQJ-nYV8Pp-k7hw26-idJ1JE-8uNH6q-7koFa5-2K47ez-7B1kDY-e4PKfn-7kjMFB-5dXRuZ-bWCdsk-ouvEfk-ofMN5x-8uKDg6-gKkG4f-f1cWvB-dzzsvZ-7fr4Dg-8CQyhN-nCGnS-5F6FcX-nWPnh5 (Nottsexminer)
         */
        NSManagedObject *newManagedObject51 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject51 setValue:@"Skylark"       forKey:@"name"];
        [newManagedObject51 setValue:@"Alauda arvensis" forKey:@"othername"];
                [newManagedObject51 setValue:@"The skylark is a small brown bird, somewhat larger than a sparrow but smaller than a starling. It is streaky brown with a small crest, which can be raised when the bird is excited or alarmed, and a white-sided tail. The wings also have a white rear edge, visible in flight. It is renowned for its display flight, vertically up in the air. Its recent and dramatic population declines make it a Red List species.\n\nThese birds are 14–18 cm long and live in cultivation, heath, natural steppe and other open habitats. Their characteristic songs are delivered in flight.\n\nTheir diet consists of seeds, supplemented with insects in the breeding season. They nest on the ground in tufts of grass, with three to six eggs per clutch. They form flocks when not breeding." forKey:@"item_description"];
        [newManagedObject51 setValue:@"http://nzbirdsonline.org.nz/species/eurasian-skylark" forKey:@"link"];
        [newManagedObject51 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject51 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject51 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject51 setValue:@"0" forKey:@"category"];
        [newManagedObject51 setValue:@"brown" forKey:@"colour"];
        [newManagedObject51 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject51 setValue:@"Larks (Alaudidae)" forKey:@"family"];
        [newManagedObject51 setValue:@"bush/coast/garden" forKey:@"habitat"];
        [newManagedObject51 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject51 setValue:@"Eurasian Sky Lark" forKey:@"short_name"];
        [newManagedObject51 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject51 setValue:@"Skylark"         forKey:@"image"];
        
        NSURL *url51t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Skylark_TN"
                                                ofType:@"jpg"]];
        NSData *data51t = [[NSData alloc] initWithContentsOfURL:url51t];
        UIImage *imageSave51t=[[UIImage alloc]initWithData:data51t];
        NSData *imageData51t = UIImagePNGRepresentation(imageSave51t);
        [newManagedObject51 setValue:imageData51t         forKey:@"thumbnail"];
        
        
        //[newManagedObject51 setValue:@"" forKey:@"sound"];
        
        [newManagedObject51 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject51 setValue:NO forKey:@"extra"];
        [newManagedObject51 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject51= nil;

        // +++++++++++ Albatross +++++++++++++
        /*  52
         */
        NSManagedObject *newManagedObject52 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject52 setValue:@"Albatross, Northern Royal"       forKey:@"name"];
        [newManagedObject52 setValue:@"toroa" forKey:@"othername"];
        [newManagedObject52 setValue:@"The northern royal albatross is a huge white albatross with black upperwings. It usually mates for life and breeds only in New Zealand. Biennial breeding takes place primarily on The Sisters and The Forty-Fours Islands in the Chatham Islands. There is also a tiny colony at Taiaroa Head near Dunedin on the mainland of New Zealand, which is a major tourist attraction.\n\nNorthern royal albatross can be sighted throughout the Southern Ocean at any time of the year. Non-breeding and immature birds, including newly fledged birds, undertake a downwind circumnavigation in the Southern Ocean. The main wintering grounds are off the coasts of southern South America. They are generally solitary foragers and forage predominantly over continental shelves to shelf edges.\n\nIdentification\n\nThe northern royal albatross has a white body including the mantle, unlike smaller albatrosses referred to as mollymawks (which have dark backs). The head is white though a small number of females may show some black speckling on the crown. The wings are long and narrow with black upperwings and white underwings apart from a black leading edge between the carpal joint and wingtip. The white tail feathers are occasionally tipped in black. The heavily hooked bill is pale pink with a black cutting edge on the upper mandible. The legs and large webbed feet are a flesh colour. The bill and tarsus are darker pink when rearing chicks. Males are somewhat larger than females.\n\nVoice: northern royal albatrosses are usually silent at sea, but they may produce some croaking and gurgling sound when feeding around vessels.\n\nSimilar species: southern royal albatross adults have at least some white on the upperwings (if not predominantly so). Juvenile southern royal albatrosses have black upperwings, but differ from northern royal albatross in having a white leading edge to the upperwing, and the absence of black on the leading edge of the underwing between the carpal joint and wingtip. \n\nDistribution and habitat:\n\nWhen not breeding, northern royal albatrosses range widely throughout the Southern Ocean, though rarely into Antarctic waters. The breeding range is restricted to the Chatham Islands (Forty-Fours, Big and Little Sister Islands) and Taiaroa Head on the Otago Peninsula.  While breeding, they generally forage over the Chatham Rise, and are less common farther north than East Cape, North Island. The majority of the population spends their non-breeding period off both coasts of southern South America, especially over the continental shelf and slope off Chile, and the Patagonian shelf off Argentina.\n\nPopulation\n\nThe total breeding population in the Chatham Islands colonies (99% of the total) is estimated at c. 6,500-7,000 pairs, with c. 5,200-5,800 pairs breeding each year. Nearly 30 pairs breed each year at Taiaroa Head which supports 1% of the population. Although the Taiaroa Head colony is increasing, the trend for the overall population remains unknown due to the lack of recent data from the Chatham Islands." forKey:@"item_description"];
        [newManagedObject52 setValue:@"http://nzbirdsonline.org.nz/species/northern-royal-albatross" forKey:@"link"];
        [newManagedObject52 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject52 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject52 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject52 setValue:@"0" forKey:@"category"];
        [newManagedObject52 setValue:@"white/black" forKey:@"colour"];
        [newManagedObject52 setValue:@"pale" forKey:@"leg_colour"];
        [newManagedObject52 setValue:@"Diomedeidae" forKey:@"family"];
        [newManagedObject52 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject52 setValue:@"Naturally Uncommon" forKey:@"threat_status"];
        [newManagedObject52 setValue:@"Northern Royal Albatross" forKey:@"short_name"];
        [newManagedObject52 setValue:@"albatross" forKey:@"size_and_shape"];
        
        
        [newManagedObject52 setValue:@"NorthernRoyalAlbatross_Ben"         forKey:@"image"];
        
        NSURL *url52t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"NorthernRoyalAlbatross_Ben_TN"
                                                ofType:@"jpg"]];
        NSData *data52t = [[NSData alloc] initWithContentsOfURL:url52t];
        UIImage *imageSave52t=[[UIImage alloc]initWithData:data52t];
        NSData *imageData52t = UIImagePNGRepresentation(imageSave52t);
        [newManagedObject52 setValue:imageData52t         forKey:@"thumbnail"];
        
        
        //[newManagedObject52 setValue:@"" forKey:@"sound"];
        
        [newManagedObject52 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject52 setValue:NO forKey:@"extra"];
        [newManagedObject52 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject52= nil;

        // +++++++++++ Kiwi(s)? +++++++++++++
        /*  53
         */
//        NSManagedObject *newManagedObject53 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
//        
//        //Set Bird_attributes
//        [newManagedObject53 setValue:@"Kiwi, little spotted"       forKey:@"name"];
//        [newManagedObject53 setValue:@"kiwi pukupuku" forKey:@"othername"];
//        [newManagedObject53 setValue:@"Species Information\
//        Breeding and ecology\
//        The smallest of the five kiwi species. Formerly widespread on both main islands, but now confined to offshore islands and one mainland sanctuary. Flightless, with tiny vestigial wings and no tail. Nocturnal, therefore more often heard than seen. Male gives a repeated high-pitched ascending whistle, female gives a slower and lower pitched warbling whistle. Light brownish grey finely mottled or banded horizontally with white, long pale bill, short pale legs, toes and claws.\
//        \
//        Identification\
//        \
//        Small pale kiwi. Light brownish grey finely mottled or banded horizontally with white, long pale bill, short pale legs and toes.\
//        \
//    Voice:  Male gives a high-pitched ascending whistle, female gives a slower and lower pitched ascending trill; both sexes repeat calls 25-35 times per sequence.\
//        \
//        Similar species: juvenile great spotted kiwi pass through a stage when they are similar to little spotted kiwi, but great spotted kiwi have dark legs and toes, and darker plumage.\
//        \
//        Distribution and habitat\
//        \
//        Formerly widespread in forest and scrub on both the North and South Islands. By the time of European settlement they had virtually disappeared from the North Island, with only one specimen collected (Mt Hector, Tararua Range, 1875) and another reported from near Pirongia in 1882. Still common in Nelson, Westland and Fiordland through to the early 1900s, but gradually disappeared, leaving a small relict population on D’Urville Island. It is believed that five little spotted kiwi were introduced to Kapiti Island from the Jackson Bay area in 1912, and they flourished on the island. Since 1983, birds have been transferred from Kapiti to establish new populations on Hen, Tiritiri Matangi, Motuihe, Red Mercury, Long (Marlborough Sounds), and Chalky Islands, and to Zealandia/Karori Sanctuary (Wellington). Two D’Urville birds were transferred to Long Island (Marlborough Sounds).\
//        \
//        Population\
//        \
//        About 1650 birds in 2012. Kapiti Island is the stronghold for the species, with c.1200 birds; Zealandia 120; Tiritiri Matangi 80; Red Mercury 70; Hen Island 50; Long 50; Chalky 50; Motuihe 30." forKey:@"item_description"];
//        [newManagedObject53 setValue:@"http://nzbirdsonline.org.nz/species/little-spotted-kiwi" forKey:@"link"];
//        [newManagedObject53 setValue:@"brown" forKey:@"beak_colour"];
//        [newManagedObject53 setValue:@"long" forKey:@"beak_length"];
//        [newManagedObject53 setValue:@"flightless,nocturnal" forKey:@"behaviour"];
//        [newManagedObject53 setValue:@"0" forKey:@"category"];
//        [newManagedObject53 setValue:@"brown" forKey:@"colour"];
//        [newManagedObject53 setValue:@"brown" forKey:@"leg_colour"];
//        [newManagedObject53 setValue:@"Casuariiformes" forKey:@"family"];
//        [newManagedObject53 setValue:@"bush" forKey:@"habitat"];
//        [newManagedObject53 setValue:@"Recovering" forKey:@"threat_status"];
//        [newManagedObject53 setValue:@"Little spotted kiwi" forKey:@"short_name"];
//        [newManagedObject53 setValue:@"duck" forKey:@"size_and_shape"];
//        
//
//        [newManagedObject53 setValue:@"LittleSpottedKiwi_Apteryx_owenii_TN"         forKey:@"image"];
//        
//        NSURL *url53t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                                pathForResource:@"LittleSpottedKiwi_Apteryx_owenii_TN"
//                                                ofType:@"jpg"]];
//        NSData *data53t = [[NSData alloc] initWithContentsOfURL:url53t];
//        UIImage *imageSave53t=[[UIImage alloc]initWithData:data53t];
//        NSData *imageData53t = UIImagePNGRepresentation(imageSave53t);
//        [newManagedObject53 setValue:imageData53t         forKey:@"thumbnail"];
//        
//        
//        [newManagedObject53 setValue:@"Kiwi" forKey:@"sound"];
//        
//        [newManagedObject53 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
//        [newManagedObject53 setValue:NO forKey:@"extra"];
//        [newManagedObject53 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
//        
//        [context save:NULL];
//        newManagedObject53= nil;

        // +++++++++++ Buller's shearwater +++++++++++++
        /*  54 - https://www.flickr.com/photos/gregthebusker/6248646906/in/photolist-awaX2u-awaWW9-aw8fZB-6LCjtL-6LCjqG-Y6bta-Y6b4M-FYRi7-6Z1Tc-8g6kvm-5AnSGb-5G8QtG-d9hbv7-d9hboG-----8adCiq-eUqeN-eUqeP-eR5U9-j4zWTz-asoq7f-fUJYy8-8DAjDB-gacWv-d9hbfb-d9hbgE-8g6iVd-d9hbi5-d9hbwm-d9hbk5-8g34rz-4xXLYS-8g6iBQ-FYRcd-2XRheh-fUK9q3-7nMASV-7nRvsd-6fPKZP-6fPHvg-6fTU5A-7ayVfv-fFhYYq-LKuSr-fibri-7ayTR4-fF1p6v/ (Greg Schechter)
         */
        NSManagedObject *newManagedObject54 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject54 setValue:@"Buller's shearwater"       forKey:@"name"];
        [newManagedObject54 setValue:@"Buller's shearwater" forKey:@"othername"];
        [newManagedObject54 setValue:@"A medium-large shearwater, brown-grey above and white below, with long broad wings, a dark-brown cap extending to just below the eyes, contrasting sharply with their white cheeks. The upper body surface is brown-grey with darker brown-black feathers running across the upper wings in an M-shape, and brown-grey on the rump contrasting with the much darker tail. The entire underside including the underwings is white. In the hand, the bill (38-45 mm long) is grey-black with a sharp hook to seize prey. The legs and feet are dark brown-mauve on the outside and pink on the inside.\n\nVoice: the calls of Buller’s shearwaters resemble those of sooty shearwaters with wailing, cooing and groaning sounds.\n\nSimilar species:\n\n several other large brown-above-and-white-below shearwaters occur rarely in New Zealand waters; none have the strongly patterned two-tone upper-surface of the Buller’s shearwater. Pale morph wedge-tailed shearwaters are more uniformly dark above and duskier on the underwing. Great shearwater has a pale nape contrasting strongly with a blackish cap, a pale crescent on the rump, and a variable dark belly patch. Pink-footed shearwater has a pink bill with a dark tip, and is darker underneath than the very white Buller’s shearwater.\n\nFrom Cook Strait north and especially in the Hauraki Gulf and Bay of Plenty, Buller’s shearwaters occur alongside the smaller fluttering shearwater, which is uniformly dark brown above, duskier below (especially on the underwings), and flaps more than Buller’s shearwater.\
         Similar species: Wedge-tailed shearwater, Great shearwater, Pink-footed shearwater, Fluttering shearwater" forKey:@"item_description"];
        [newManagedObject54 setValue:@"http://nzbirdsonline.org.nz/species/bullers-shearwater" forKey:@"link"];
        [newManagedObject54 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject54 setValue:@"long,hooked" forKey:@"beak_length"];
        [newManagedObject54 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject54 setValue:@"0" forKey:@"category"];
        [newManagedObject54 setValue:@"black,white" forKey:@"colour"];
        [newManagedObject54 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject54 setValue:@"Procellariidae" forKey:@"family"];
        [newManagedObject54 setValue:@"water" forKey:@"habitat"];
        [newManagedObject54 setValue:@"naturally uncommon" forKey:@"threat_status"];
        [newManagedObject54 setValue:@"Buller's shearwater" forKey:@"short_name"];
        [newManagedObject54 setValue:@"goose" forKey:@"size_and_shape"];
        
        
        [newManagedObject54 setValue:@"BullersShearwater"         forKey:@"image"];
        
        NSURL *url54t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"BullersShearwater_TN"
                                                ofType:@"jpg"]];
        NSData *data54t = [[NSData alloc] initWithContentsOfURL:url54t];
        UIImage *imageSave54t=[[UIImage alloc]initWithData:data54t];
        NSData *imageData54t = UIImagePNGRepresentation(imageSave54t);
        [newManagedObject54 setValue:imageData54t         forKey:@"thumbnail"];
        
        
        //[newManagedObject54 setValue:@"" forKey:@"sound"];
        
        [newManagedObject54 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject54 setValue:NO forKey:@"extra"];
        [newManagedObject54 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject54= nil;

        // +++++++++++ Caspian Tern +++++++++++++
        /*  55
         */
        NSManagedObject *newManagedObject55 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject55 setValue:@"Tern, Caspian"       forKey:@"name"];
        [newManagedObject55 setValue:@"Taranui" forKey:@"othername"];
        [newManagedObject55 setValue:@"The world's largest tern with a length of 48–60 cm (19–24 in), a wingspan of 127–145 cm (50–57 in) and a weight of 530–782 g (18.7–27.6 oz). Adult birds have black legs, and a long thick red-orange bill with a small black tip. They have a white head with a black cap and white neck, belly and tail. The upper wings and back are pale grey; the underwings are pale with dark primary feathers.\n\n In flight, the tail is less forked than other terns and wing tips black on the underside. In winter, the black cap is still present (unlike many other terns), but with some white streaking on the forehead. \n\nThe call is a loud heron-like croak." forKey:@"item_description"];
        [newManagedObject55 setValue:@"http://en.wikipedia.org/wiki/Caspian_tern" forKey:@"link"];
        [newManagedObject55 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject55 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject55 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject55 setValue:@"0" forKey:@"category"];
        [newManagedObject55 setValue:@"grey,white" forKey:@"colour"];
        [newManagedObject55 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject55 setValue:@"Sternidae" forKey:@"family"];
        [newManagedObject55 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject55 setValue:@"Nationally Vulnerable" forKey:@"threat_status"];
        [newManagedObject55 setValue:@"Caspian Tern" forKey:@"short_name"];
        [newManagedObject55 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject55 setValue:@"CaspianTern_Steintil"         forKey:@"image"];
        
        NSURL *url55t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"CaspianTern_Steintil_TN"
                                                ofType:@"jpg"]];
        NSData *data55t = [[NSData alloc] initWithContentsOfURL:url55t];
        UIImage *imageSave55t=[[UIImage alloc]initWithData:data55t];
        NSData *imageData55t = UIImagePNGRepresentation(imageSave55t);
        [newManagedObject55 setValue:imageData55t         forKey:@"thumbnail"];
        
        
        //[newManagedObject55 setValue:@"" forKey:@"sound"];
        
        [newManagedObject55 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject55 setValue:NO forKey:@"extra"];
        [newManagedObject55 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject55= nil;

        // +++++++++++ Black billed gull +++++++++++++
        /*  56  (https://www.flickr.com/photos/seabirdnz/5216875830/in/set-72157625228303867
         */
        NSManagedObject *newManagedObject56 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject56 setValue:@"Gull, Black-billed "       forKey:@"name"];
        [newManagedObject56 setValue:@"Buller's gull" forKey:@"othername"];
        [newManagedObject56 setValue:@"The black-billed gull (Chroicocephalus bulleri), also known as Buller's gull, is a species of gull in the Laridae family. It is found only in New Zealand and has the undesirable status of being the most threatened gull species in the world.\n\nThe black-billed gull is a lightly coloured gull with a small amount of black on its wingtips. It has a long, thin, black bill with a bright red interior, and reddish black feet and white eyes. The juvenile has a flesh coloured bill with a dark tip and dark brown eyes. As juvenile red-billed gulls display similarly dark bills and feet they may be confused with this species.\n\nThe black-billed gull is more slender and elegant than the red-billed gull, with a longer bill. Breeding adults have a white head, neck, rump, tail and underparts, and pale silver-grey wings and back. The outer primaries are mainly white with white-tipped black margins. A diagnostic white leading edge to the wing shows in flight. The bill and legs are black; during late incubation and hatching the legs become vibrant blood red. The eye is white, and the eye-ring red. Non-breeding adults have a bi-coloured bill, reddish at the base with a black tip and line through the middle.\n\nThe black-billed gull is endemic to New Zealand. Its natural habitats are rivers, freshwater lakes, freshwater marshes, sandy shores, pastureland, and urban areas. It is threatened by habitat loss. About 78% of the population breeds in the Southland Region on the southern end of South Island, New Zealand, especially beside the Mataura, the Oreti, the Aparima and Waiau Rivers. On the North Island, breeding sites are typically sand-spits, shell banks, lake margins and river flats. It feeds on fish, terrestrial, freshwater and marine invertebrates and visits farmland and refuse tips.\n\nSimilar species: in non-breeding plumage, black-billed gulls have a bi-coloured bill and red legs, and may be confused with red-billed gulls. Juvenile black-billed gulls are most confusing, as they have a dark outer leading edge to the wing (this is white in older age classes). In all plumages, black-billed gull has a longer, finer bill. Red-billed gull is darker grey with a black patch through the middle of the outer primaries, diagnostic in flight. The red bill (which is shorter and thicker) and legs lose the brighter tones of summer during autumn/winter. Adult red-billed gulls do not acquire a contrasting bi-coloured bill, though do have darker shades of red near tip and through the middle of the bill." forKey:@"item_description"];
        [newManagedObject56 setValue:@"http://en.wikipedia.org/wiki/Black-billed_gull" forKey:@"link"];
        [newManagedObject56 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject56 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject56 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject56 setValue:@"0" forKey:@"category"];
        [newManagedObject56 setValue:@"white/grey" forKey:@"colour"];
        [newManagedObject56 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject56 setValue:@"Laridae" forKey:@"family"];
        [newManagedObject56 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject56 setValue:@"nationally endangered" forKey:@"threat_status"];
        [newManagedObject56 setValue:@"Black-billed gull" forKey:@"short_name"];
        [newManagedObject56 setValue:@"pigeon" forKey:@"size_and_shape"];
        
        
        [newManagedObject56 setValue:@"Black_billed_gull"         forKey:@"image"];
        
        NSURL *url56t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Black_billed_gull_TN"
                                                ofType:@"jpg"]];
        NSData *data56t = [[NSData alloc] initWithContentsOfURL:url56t];
        UIImage *imageSave56t=[[UIImage alloc]initWithData:data56t];
        NSData *imageData56t = UIImagePNGRepresentation(imageSave56t);
        [newManagedObject56 setValue:imageData56t         forKey:@"thumbnail"];
        
        
        //[newManagedObject56 setValue:@"" forKey:@"sound"];
        
        [newManagedObject56 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject56 setValue:NO forKey:@"extra"];
        [newManagedObject56 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject56= nil;

        // +++++++++++ White Faced Heron +++++++++++++
        /*  57
         */
        NSManagedObject *newManagedObject57 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject57 setValue:@"White Faced Heron"       forKey:@"name"];
        [newManagedObject57 setValue:@"Egretta Novaehollandiae" forKey:@"othername"];
        [newManagedObject57 setValue:@"The white-faced heron (Egretta novaehollandiae) also known as the white-fronted heron, and incorrectly as the grey heron, or blue crane, is a common bird throughout most of Australasia, including New Guinea, the islands of Torres Strait, Indonesia, New Zealand, the islands of the Subantarctic, and all but the driest areas of Australia.\n\nIt is a relatively small heron, pale, slightly bluish-grey, with yellow legs and white facial markings. It can be found almost anywhere near shallow water, fresh or salt, and although it is prompt to depart the scene on long, slow-beating wings if disturbed, it will boldly raid suburban fish ponds." forKey:@"item_description"];
        [newManagedObject57 setValue:@"http://en.wikipedia.org/wiki/Redpoll" forKey:@"link"];
        [newManagedObject57 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject57 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject57 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject57 setValue:@"0" forKey:@"category"];
        [newManagedObject57 setValue:@"grey/white" forKey:@"colour"];
        [newManagedObject57 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject57 setValue:@"Ardeidae" forKey:@"family"];
        [newManagedObject57 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject57 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject57 setValue:@"White Faced Heron" forKey:@"short_name"];
        [newManagedObject57 setValue:@"Swan" forKey:@"size_and_shape"];
        
        
        [newManagedObject57 setValue:@"WhiteFacedHeron"         forKey:@"image"];
        
        NSURL *url57t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"WhiteFacedHeron_TN"
                                                ofType:@"jpg"]];
        NSData *data57t = [[NSData alloc] initWithContentsOfURL:url57t];
        UIImage *imageSave57t=[[UIImage alloc]initWithData:data57t];
        NSData *imageData57t = UIImagePNGRepresentation(imageSave57t);
        [newManagedObject57 setValue:imageData57t         forKey:@"thumbnail"];
        
        
        //[newManagedObject57 setValue:@"" forKey:@"sound"];
        
        [newManagedObject57 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject57 setValue:NO forKey:@"extra"];
        [newManagedObject57 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject57= nil;

        
        // +++++++++++ White fronted tern +++++++++++++
        /*  59 (https://www.flickr.com/photos/seabirdnz/5480572279/in/set-72157625228303867)
         */
        NSManagedObject *newManagedObject59 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject59 setValue:@"Tern, White fronted"       forKey:@"name"];
        [newManagedObject59 setValue:@"tara, kahawai bird, sea-swallow, swallow tail" forKey:@"othername"];
        [newManagedObject59 setValue:@"The white-fronted tern (Sterna striata) is the most common tern of New Zealand. It rarely swims, apart from bathing, despite having webbed feet. The species is protected.\n\nWhite-fronted terns feed in large flocks by plunge diving on shoals of smelt and pilchards which have been driven to the surface by larger fish and are easily caught. Like all terns they fly with their heads and bills pointing down to see their prey.\n\nThe white-fronted tern is the most common tern on the New Zealand coastline, at times occurring in flocks of many hundreds or even thousands of birds. It is mainly a marine species that is seldom found far from the coast. The name ‘white-fronted’ refers to the ‘frons’ or forehead, where a thin strip of white separates the black cap from the black bill. Most other ‘capped’ terns, including the black-fronted tern, have black caps that reach the bill when in breeding plumage. The scientific name striata refers to the finely-barred (striated) dorsal plumage of recently fledged white-fronted terns, as the original description and name was based on a juvenile bird painted by William Ellis, surgeon’s second mate on the Discovery, on Captain Cook’s third visit to New Zealand.\n\nIdentification:\n\n         \
         The white-fronted tern is a medium-sized, long-tailed sea tern that is common around New Zealand coasts. It is pale grey above and white below, with a black cap that is separated from the bill by a white band (or by an entirely white fore-crown in non-breeding plumage). The tail is white and forked; the length of the tail and depth of the fork decrease in size outside of the breeding season. The outer edge of the first primary has a narrow black or brownish-black band. In the breeding season, the black cap extends from the white frontal strip down to the back of neck. Outside of the breeding season the cap recedes, leaving the forehead white. The eyelids, eyes and bill are black, and the legs vary from black to dull red-brown. Sexes are similar but females are slightly smaller. Immature birds are similar to non-breeding adults. They have the black nape streaked with white and the wing coverts and distinctive light brown mottling. Recently fledged birds have fine blackish barring (striations) over the back and wing coverts.\n\nCalls: \n\n         the main call is a high-pitched siet; a harsh keark or keeahk is uttered by birds defending their nests.\n\nSimilar species: \n\nthe white-fronted tern is easily distinguished from the two other widespread New Zealand tern species (the much larger Caspian tern, and smaller, darker black-fronted tern), but is very similar to the Arctic tern and especially the common tern, which are rare visitors to New Zealand. The white-fronted tern is the largest and palest of the three species." forKey:@"item_description"];
        [newManagedObject59 setValue:@"en.wikipedia.org/wiki/White-fronted_tern" forKey:@"link"];
        [newManagedObject59 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject59 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject59 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject59 setValue:@"0" forKey:@"category"];
        [newManagedObject59 setValue:@"white/grey/black" forKey:@"colour"];
        [newManagedObject59 setValue:@"black/red" forKey:@"leg_colour"];
        [newManagedObject59 setValue:@"Sternidae" forKey:@"family"];
        [newManagedObject59 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject59 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject59 setValue:@"White fronted tern" forKey:@"short_name"];
        [newManagedObject59 setValue:@"pigeon" forKey:@"size_and_shape"];
        
        
        [newManagedObject59 setValue:@"WhiteFrontedTern"         forKey:@"image"];
        
        NSURL *url59t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"WhiteFrontedTern_TN"
                                                ofType:@"jpg"]];
        NSData *data59t = [[NSData alloc] initWithContentsOfURL:url59t];
        UIImage *imageSave59t=[[UIImage alloc]initWithData:data59t];
        NSData *imageData59t = UIImagePNGRepresentation(imageSave59t);
        [newManagedObject59 setValue:imageData59t         forKey:@"thumbnail"];
        
        
        //[newManagedObject59 setValue:@"" forKey:@"sound"];
        
        [newManagedObject59 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject59 setValue:NO forKey:@"extra"];
        [newManagedObject59 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject59= nil;

        // +++++++++++ Bar-tailed godwit +++++++++++++
        /*  60
         */
        NSManagedObject *newManagedObject60 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject60 setValue:@"Bar-tailed godwit"       forKey:@"name"];
        [newManagedObject60 setValue:@"Bar-tailed godwit" forKey:@"othername"];
        [newManagedObject60 setValue:@"Their brown and grey plumage echoes the intertidal mudflats where they forage, and for much of their time in New Zealand they are relatively nondescript birds. But there is nothing nondescript about the migrations of bar-tailed godwits. They perform the longest nonstop flights of any non-seabird, and, unlike a seabird, there is no chance of an inflight snack.\n\nGodwits hold cultural significance for many New Zealanders. For Maori they were birds of mystery, (‘Who has seen the nest of the Kuaka?’) and were believed to accompany spirits of the departed; but they were also a source of food. They are the most numerous tundra-breeding shorebird species to occur in New Zealand, with around 90,000 here each year. Virtually all New Zealand birds are from the baueri subspecies breeding in western Alaska.  They are relatively common at many harbours and estuaries around the country. \n\nFollowing the breeding season, birds generally begin arriving from early September, usually after a non-stop 8-9 days flight. They begin departing on northern migration from early March, heading for refuelling sites around the Yellow Sea. They do not breed until their fourth year, so each southern winter there are hundreds of non-breeding birds remaining in New Zealand." forKey:@"item_description"];
        [newManagedObject60 setValue:@"http://nzbirdsonline.org.nz/?q=node/670" forKey:@"link"];
        [newManagedObject60 setValue:@"grey/red" forKey:@"beak_colour"];
        [newManagedObject60 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject60 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject60 setValue:@"0" forKey:@"category"];
        [newManagedObject60 setValue:@"brown" forKey:@"colour"];
        [newManagedObject60 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject60 setValue:@"Scolopacidae" forKey:@"family"];
        [newManagedObject60 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject60 setValue:@"recovering" forKey:@"threat_status"];
        [newManagedObject60 setValue:@"Bar-tailed godwit" forKey:@"short_name"];
        [newManagedObject60 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject60 setValue:@"BarTailedGodwit"         forKey:@"image"];
        
        NSURL *url60t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"BarTailedGodwit_TN"
                                                ofType:@"jpg"]];
        NSData *data60t = [[NSData alloc] initWithContentsOfURL:url60t];
        UIImage *imageSave60t=[[UIImage alloc]initWithData:data60t];
        NSData *imageData60t = UIImagePNGRepresentation(imageSave60t);
        [newManagedObject60 setValue:imageData60t         forKey:@"thumbnail"];
        
        
        //[newManagedObject60 setValue:@"" forKey:@"sound"];
        
        [newManagedObject60 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject60 setValue:NO forKey:@"extra"];
        [newManagedObject60 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject60= nil;

        // +++++++++++ NZ dotterel +++++++++++++
        /*  61
         */
        NSManagedObject *newManagedObject61 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject61 setValue:@"Dotterel, New Zealand"       forKey:@"name"];
        [newManagedObject61 setValue:@"NZ dotterel" forKey:@"othername"];
        [newManagedObject61 setValue:@"The New Zealand dotterel is a familiar bird of sandy east coast beaches in the northern North Island, but is sparsely distributed around much of the rest of the country. There are two widely separated subspecies: the northern New Zealand dotterel is more numerous, and breeds around the North Island; the southern New Zealand dotterel was formerly widespread in the South Island, and now breeds only on Stewart Island. Southern New Zealand dotterels are larger, heavier, and darker than northern New Zealand dotterels.\n\nCoastal development and human recreational activities on beaches are having a growing impact on the northern subspecies; dotterels are often described as ‘appealing’, and local communities are increasingly championing them – providing advocacy and organising protection programmes to improve breeding success.\n\nIdentification\n\nThe New Zealand dotterel is a heavily-built plover, and is the largest species in the genus Charadrius (c.31 species). The upperparts are brown, darker in the southern subspecies, and the underparts are  off-white in autumn-early winter, becoming orange-red (also darker in southern birds) from about May onwards. The depth and extent of red colour varies individually and seasonally, but males are generally darker than females. The bill is heavy and black, and the legs mid-grey. First-winter birds have pure white underparts, with legs yellowish to pale grey.\n\nVoice: the common call is a sharp chip, often heard before the bird is seen. The call indicates alertness, with the rate increasing as the perceived threat level rises. The same call is also used to maintain contact. A high-pitched tseep is used to warn chicks to stay hidden. A long rattling churr is used when chasing intruders. A sharp werr-wit is used during territory boundary disputes.\n\nSimilar species: occasional confusion with eclipse or juvenile banded dotterel, but New Zealand dotterel is much larger, and bill heavier. Juvenile or eclipse New Zealand dotterel is similar to eclipse greater sand plover (rare in New Zealand) but that has slimmer body, longer legs, and the head appears larger in proportion to the body." forKey:@"item_description"];
        [newManagedObject61 setValue:@"http://nzbirdsonline.org.nz/species/new-zealand-dotterel" forKey:@"link"];
        [newManagedObject61 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject61 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject61 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject61 setValue:@"0" forKey:@"category"];
        [newManagedObject61 setValue:@"brown/red" forKey:@"colour"];
        [newManagedObject61 setValue:@"grey" forKey:@"leg_colour"];
        [newManagedObject61 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject61 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject61 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject61 setValue:@"NZ dotterel" forKey:@"short_name"];
        [newManagedObject61 setValue:@"pigeon" forKey:@"size_and_shape"];
        
        
        [newManagedObject61 setValue:@"NZDotterel"         forKey:@"image"];
        
        NSURL *url61t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"NZDotterel_TN"
                                                ofType:@"jpg"]];
        NSData *data61t = [[NSData alloc] initWithContentsOfURL:url61t];
        UIImage *imageSave61t=[[UIImage alloc]initWithData:data61t];
        NSData *imageData61t = UIImagePNGRepresentation(imageSave61t);
        [newManagedObject61 setValue:imageData61t         forKey:@"thumbnail"];
        
        
        [newManagedObject61 setValue:@"nz-dotterel-song_DOC" forKey:@"sound"];
        
        [newManagedObject61 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject61 setValue:NO forKey:@"extra"];
        [newManagedObject61 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject61= nil;

        // +++++++++++ Crested Grebe +++++++++++++
        /*  62 (https://www.flickr.com/photos/seabirdnz/8191735243/in/set-72157625228303867)
         */
        NSManagedObject *newManagedObject62 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject62 setValue:@"Crested Grebe"       forKey:@"name"];
        [newManagedObject62 setValue:@"Crested Grebe" forKey:@"othername"];
        [newManagedObject62 setValue:@"The Australasian crested grebe is majestic and distinctive diving bird that is usually seen on the southern lakes of New Zealand where it breeds. It has a slender neck, sharp black bill and head with a distinctive black double crest and bright chestnut and black cheek frills, which it uses in its complex and bizarre mating displays. It is unusual for the way it carries its young on its back when swimming.\n\n The crested grebe belongs to an ancient order of diving water birds found on every continent in the world. They are rarely seen on land except when they clamber onto their nests on the lake shore. The Australasian crested grebe occurs in New Zealand and Australia but it is threatened in both countries and the New Zealand population probably numbers fewer than 600 birds.\n\nIdentification\n\nCrested grebes are moderate sized water birds that may be mistaken for waterfowl or shags at a distance. Both sexes have a long, slender neck, fine black bill and head with a distinctive black double crest and bright chestnut and black cheek frills. The upper plumage is a dark chestnut-brown, the under parts silvery white, and the wings have a distinctive white patches that are only seen in flight. Unlike birds in Europe, they appear to retain full breeding plumage throughout the year and duller birds without crests are probably young of the year. The feet have a peculiar lobed structure and are set relatively far back on the body – a design to increase the efficiency and speed of diving. The head and neck of the young are striped black-and-white and the body plumage is grey.\n\nVoice:\n\n a range of loud growling, grunting and barking calls that travel far across water.\n\nSimilar species:\n\n the other New Zealand grebes (dabchick, Australasian little grebe and hoary-headed grebe) are all very small in comparison and lack the head crests and tippets. At a distance could be confused with black or little shags, which have a similar silhouette and diving behaviour." forKey:@"item_description"];
        [newManagedObject62 setValue:@"http://nzbirdsonline.org.nz/species/australasian-crested-grebe" forKey:@"link"];
        [newManagedObject62 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject62 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject62 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject62 setValue:@"0" forKey:@"category"];
        [newManagedObject62 setValue:@"brown/red" forKey:@"colour"];
        [newManagedObject62 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject62 setValue:@"Podicipedidae" forKey:@"family"];
        [newManagedObject62 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject62 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject62 setValue:@"Crested Grebe" forKey:@"short_name"];
        [newManagedObject62 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject62 setValue:@"CrestedGrebe"         forKey:@"image"];
        
        NSURL *url62t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"CrestedGrebe_TN"
                                                ofType:@"jpg"]];
        NSData *data62t = [[NSData alloc] initWithContentsOfURL:url62t];
        UIImage *imageSave62t=[[UIImage alloc]initWithData:data62t];
        NSData *imageData62t = UIImagePNGRepresentation(imageSave62t);
        [newManagedObject62 setValue:imageData62t         forKey:@"thumbnail"];
        
        
        //[newManagedObject62 setValue:@"" forKey:@"sound"];
        
        [newManagedObject62 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject62 setValue:NO forKey:@"extra"];
        [newManagedObject62 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject62= nil;

     

        // +++++++++++ White heron +++++++++++++
        /*  64 (https://www.flickr.com/photos/seabirdnz/9370315084/in/set-72157625228303867
         */
        NSManagedObject *newManagedObject64 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject64 setValue:@"White heron"       forKey:@"name"];
        [newManagedObject64 setValue:@"(Eastern) Great Egret" forKey:@"othername"];
        [newManagedObject64 setValue:@"The white heron or kotuku is well-loved by the New Zealand people, but it is rarely seen except by those who specifically seek it out. Its sole New Zealand breeding site near Okarito Lagoon in Westland is well-known and well-protected, but elsewhere it is 'He kotuku rerenga tahi' or the bird of single flight, implying something seen perhaps once in a lifetime. When seen in close proximity it is a magnificent bird, with its large size and clean white plumage.\n\nA large white heron with a long yellow bill, long dark legs and a very long neck. When breeding, the bill becomes grey-black and long filamentous plumes develop, mainly on the back. \n\nIn flight, the white heron tucks its heads back into its shoulders so that the length of its neck is hidden, giving it a hunched appearance. When walking, the white heron has an elegant upright stance showing the extreme length of its neck. When resting it is more hunched with its head tucked in, making the birds appear more bulky. Important identification characters when separating white herons from other white egret species in New Zealand include overall size, relative neck length, bill colour and shape, and how far the gape (i.e. the corner of the mouth) extends back in relation to the eye. The white heron is the largest, longest-necked of the egrets, and the gape extends well behind the eye.\n\nVoice: a harsh croak." forKey:@"item_description"];
        [newManagedObject64 setValue:@"http://nzbirdsonline.org.nz/species/white-heron" forKey:@"link"];
        [newManagedObject64 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject64 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject64 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject64 setValue:@"0" forKey:@"category"];
        [newManagedObject64 setValue:@"white" forKey:@"colour"];
        [newManagedObject64 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject64 setValue:@"Ardeidae" forKey:@"family"];
        [newManagedObject64 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject64 setValue:@"Nationally critical" forKey:@"threat_status"];
        [newManagedObject64 setValue:@"White heron" forKey:@"short_name"];
        [newManagedObject64 setValue:@"swan" forKey:@"size_and_shape"];
        
        
        [newManagedObject64 setValue:@"WhiteHeron"         forKey:@"image"];
        
        NSURL *url64t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"WhiteHeron_TN"
                                                ofType:@"jpg"]];
        NSData *data64t = [[NSData alloc] initWithContentsOfURL:url64t];
        UIImage *imageSave64t=[[UIImage alloc]initWithData:data64t];
        NSData *imageData64t = UIImagePNGRepresentation(imageSave64t);
        [newManagedObject64 setValue:imageData64t         forKey:@"thumbnail"];
        
        
        [newManagedObject64 setValue:@"white-heron-song_DOC" forKey:@"sound"];
        
        [newManagedObject64 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject64 setValue:NO forKey:@"extra"];
        [newManagedObject64 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject64= nil;

        // +++++++++++ Cattle Egret +++++++++++++
        /*  65 (https://www.flickr.com/photos/seabirdnz/10865633923/in/set-72157625228303867)
         */
        NSManagedObject *newManagedObject65 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject65 setValue:@"Cattle Egret"       forKey:@"name"];
        [newManagedObject65 setValue:@"Cattle Egret" forKey:@"othername"];
        [newManagedObject65 setValue:@"The cattle egret is a widely but patchily distributed Australian migrant, reaching New Zealand in variable numbers each autumn to overwinter. It is generally found associating with cattle and sheep.\n\nIdentification: A small, stocky egret, similar in size to a white-faced heron, but not as slim and with a shorter neck. When standing, cattle egrets typically have a rather hunched posture, and when feeding they have a jerky walking action. Non-breeding plumage is entirely white, with a stout, slightly decurved yellow bill, yellow facial skin and grey legs. There is a distinctive jowl of feathers under the lower mandible. In breeding plumage there are extensive areas of ginger on the crown, neck and mantle, and long plumes on the neck and back; the legs become yellow and the bill is reddish. Birds recently arrived in New Zealand often have varying traces of breeding plumage remaining, and many colour-up prior to departure in the spring.\n\nVoice: normally silent, except during breeding and at roosts, when various croaking and chattering calls are made." forKey:@"item_description"];
        [newManagedObject65 setValue:@"http://nzbirdsonline.org.nz/species/cattle-egret" forKey:@"link"];
        [newManagedObject65 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject65 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject65 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject65 setValue:@"0" forKey:@"category"];
        [newManagedObject65 setValue:@"white/orange" forKey:@"colour"];
        [newManagedObject65 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject65 setValue:@"Ardeidae" forKey:@"family"];
        [newManagedObject65 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject65 setValue:@"migrant" forKey:@"threat_status"];
        [newManagedObject65 setValue:@"Cattle Egret" forKey:@"short_name"];
        [newManagedObject65 setValue:@"swan" forKey:@"size_and_shape"];
        
        
        [newManagedObject65 setValue:@"CattleEgret"         forKey:@"image"];
        
        NSURL *url65t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"CattleEgret_TN"
                                                ofType:@"jpg"]];
        NSData *data65t = [[NSData alloc] initWithContentsOfURL:url65t];
        UIImage *imageSave65t=[[UIImage alloc]initWithData:data65t];
        NSData *imageData65t = UIImagePNGRepresentation(imageSave65t);
        [newManagedObject65 setValue:imageData65t         forKey:@"thumbnail"];
        
        
        //[newManagedObject65 setValue:@"" forKey:@"sound"];
        
        [newManagedObject65 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject65 setValue:NO forKey:@"extra"];
        [newManagedObject65 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject65= nil;

        // +++++++++++ Royal Spoonbill +++++++++++++
        /*  66
         */
        NSManagedObject *newManagedObject66 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject66 setValue:@"Royal Spoonbill"       forKey:@"name"];
        [newManagedObject66 setValue:@"Royal Spoonbill" forKey:@"othername"];
        [newManagedObject66 setValue:@"Breeding and ecology: The stately royal spoonbill is one of six spoonbill species worldwide, and the only one that breeds in New Zealand. This large white waterbird was first recorded in New Zealand at Castlepoint in 1861. Sightings increased through the 1900s, with breeding first recorded next to the white heron colony at Okarito, south Westland, in 1949. Since then it has successfully colonised New Zealand from Australia and is now widespread, breeding at multiple sites on both main islands, and dispersing to coastal sites across the country after the breeding season. In flight, birds hold their neck outstretched and trail legs behind, looking rather awkward, like a \"Dr Seuss\" cartoon bird. Their closest relatives are the ibises.\n\nIdentification:\n\n A large, bulky, long-legged waterbird with white plumage and black spoon-shaped bill, facial skin, legs and feet. During the breeding season, adults grow distinctive long white crest feathers on the back of the head or nape, up to 20 cm long in males. The crest is raised during mating displays revealing pink skin beneath. The bill is 136 - 220 mm long; the wingspan is circa 120 cm. Breeding birds have a creamy-yellow breast, a yellow patch above each eye, and a red patch in the middle of the forehead in front of the crest feathers. Females are slightly smaller than males, with shorter legs and bill. Outside the breeding season the crest feathers are smaller and the rest of the plumage often appears soiled. Juveniles resemble non-breeding adults but are slightly smaller with a shorter bill, dark tips to the main flight feathers, and lack a crest and coloured face patches. When wading in shallow water it often submerges the bill and repeatedly sweeps it in a wide arc in search of prey.\n\nVoice: grunts, groans and hisses with chew and cho calls made at the nest.\n\nSimilar species: \n\nthere are two records of the similar yellow-billed spoonbill in New Zealand, which is slightly larger and heavier, with a pale yellowish bill and legs. The white heron is taller and thinner with a slender, pointed, bright yellow bill." forKey:@"item_description"];
        [newManagedObject66 setValue:@"http://nzbirdsonline.org.nz/species/royal-spoonbill" forKey:@"link"];
        [newManagedObject66 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject66 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject66 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject66 setValue:@"0" forKey:@"category"];
        [newManagedObject66 setValue:@"white" forKey:@"colour"];
        [newManagedObject66 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject66 setValue:@"Threskiornithidae" forKey:@"family"];
        [newManagedObject66 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject66 setValue:@"Naturally Uncommon" forKey:@"threat_status"];
        [newManagedObject66 setValue:@"Royal Spoonbill" forKey:@"short_name"];
        [newManagedObject66 setValue:@"swan" forKey:@"size_and_shape"];
        
        
        [newManagedObject66 setValue:@"RoyalSpoonbill"         forKey:@"image"];
        
        NSURL *url66t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"RoyalSpoonbill_TN"
                                                ofType:@"jpg"]];
        NSData *data66t = [[NSData alloc] initWithContentsOfURL:url66t];
        UIImage *imageSave66t=[[UIImage alloc]initWithData:data66t];
        NSData *imageData66t = UIImagePNGRepresentation(imageSave66t);
        [newManagedObject66 setValue:imageData66t         forKey:@"thumbnail"];
        
        
        //[newManagedObject66 setValue:@"" forKey:@"sound"];
        
        [newManagedObject66 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject66 setValue:NO forKey:@"extra"];
        [newManagedObject66 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject66= nil;

        // +++++++++++ Plover (spur-winged) +++++++++++++
        /*  67 - Masked Lapwing (https://www.flickr.com/photos/bareego/7282969228/in/set-72157629923731599 James Niland
         */
        NSManagedObject *newManagedObject67 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject67 setValue:@"Plover (spur-winged)"       forKey:@"name"];
        [newManagedObject67 setValue:@"Masked Lapwing" forKey:@"othername"];
        [newManagedObject67 setValue:@"The New Zealand spur-winged plover population has a unique conservation trajectory among our native bird species. In just over 80 years since the first breeding record, it has gone from a fully protected native to having that protection removed in 2010. First recorded breeding near Invercargill in 1932, it subsequently spread northwards through the country, becoming established in Northland in the 1980s. \n\nA bird of open country, it is an obtrusive, noisy addition to habitats ranging from riverbeds and sea and lakeshores to agricultural pasture and urban parklands. \n\nCommon names for birds can be a linguistic minefield, but our spur-winged plover should not to be confused with a species of the same name that occurs in central Africa. Given that it is actually a lapwing, perhaps it would have been easier if we had adopted its Australian name - masked lapwing." forKey:@"item_description"];
        [newManagedObject67 setValue:@"http://nzbirdsonline.org.nz/species/spur-winged-plover" forKey:@"link"];
        [newManagedObject67 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject67 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject67 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject67 setValue:@"0" forKey:@"category"];
        [newManagedObject67 setValue:@"grey/white/black" forKey:@"colour"];
        [newManagedObject67 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject67 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject67 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject67 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject67 setValue:@"Masked Lapwing" forKey:@"short_name"];
        [newManagedObject67 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject67 setValue:@"MaskedLapwing_JamesNiland"         forKey:@"image"];
        
        NSURL *url67t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"MaskedLapwing_JamesNiland_TN"
                                                ofType:@"jpg"]];
        NSData *data67t = [[NSData alloc] initWithContentsOfURL:url67t];
        UIImage *imageSave67t=[[UIImage alloc]initWithData:data67t];
        NSData *imageData67t = UIImagePNGRepresentation(imageSave67t);
        [newManagedObject67 setValue:imageData67t         forKey:@"thumbnail"];
        
        
        //[newManagedObject67 setValue:@"" forKey:@"sound"];
        
        [newManagedObject67 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject67 setValue:NO forKey:@"extra"];
        [newManagedObject67 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject67= nil;

        // +++++++++++ other Kiwis (Great Spotted) +++++++++++++
        /*  68
         */
        NSManagedObject *newManagedObject68 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject68 setValue:@"Kiwi (Great Spotted)"       forKey:@"name"];
        [newManagedObject68 setValue:@"roa, roroa" forKey:@"othername"];
                [newManagedObject68 setValue:@"The second largest of the five kiwi species. \n\nWidespread in forest, scrub, upland tussock grasslands and subalpine zones of the north-western South Island. Flightless, with tiny vestigial wings and no tail. Nocturnal, therefore more often heard than seen. Male gives a repeated high-pitched ascending whistle, female gives a slower and lower pitched ascending whistle. Plumage brownish grey finely mottled or banded horizontally with white, long pale bill, short dark legs and toes, often with dark or dark streaked claws. Large pale kiwi. Brownish grey finely mottled or banded horizontally with white, long pale bill, short dark legs and toes, often with dark or dark streaked claws.\n\nVoice:\n\n  Male gives a high-pitched ascending whistle repeated 10-20 times, female gives a slower and lower pitched ascending trill repeated 10-15 times.\n\nSimilar species: Juvenile great spotted kiwi pass through a stage when they are similar to little spotted kiwi, but little spotted kiwi have pale legs, toes and claws. Similar to hybrid rowi or little spotted kiwi, but great spotted kiwi have much more massive legs." forKey:@"item_description"];
        [newManagedObject68 setValue:@"http://nzbirdsonline.org.nz/species/great-spotted-kiwi" forKey:@"link"];
        [newManagedObject68 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject68 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject68 setValue:@"flightless,nocturnal" forKey:@"behaviour"];
        [newManagedObject68 setValue:@"0" forKey:@"category"];
        [newManagedObject68 setValue:@"grey/brown" forKey:@"colour"];
        [newManagedObject68 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject68 setValue:@"Apterygidae" forKey:@"family"];
        [newManagedObject68 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject68 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject68 setValue:@"Kiwi" forKey:@"short_name"];
        [newManagedObject68 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject68 setValue:@"GreatSpottedKiwi_J_Brew"         forKey:@"image"];
        
        NSURL *url68t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"GreatSpottedKiwi_J_Brew_TN"
                                                ofType:@"jpg"]];
        NSData *data68t = [[NSData alloc] initWithContentsOfURL:url68t];
        UIImage *imageSave68t=[[UIImage alloc]initWithData:data68t];
        NSData *imageData68t = UIImagePNGRepresentation(imageSave68t);
        [newManagedObject68 setValue:imageData68t         forKey:@"thumbnail"];
        
        
        //[newManagedObject68 setValue:@"" forKey:@"sound"];
        
        [newManagedObject68 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject68 setValue:NO forKey:@"extra"];
        [newManagedObject68 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject68= nil;

        // +++++++++++ NZ Falcon +++++++++++++
        /*  69 https://www.flickr.com/photos/seabirdnz/6191551344/in/set-72157625228303867
         */
        NSManagedObject *newManagedObject69 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject69 setValue:@"Falcon (NZ)"       forKey:@"name"];
        [newManagedObject69 setValue:@"Bush hawk, Bush falcon, Sparrow hawk, Kareare" forKey:@"othername"];
        [newManagedObject69 setValue:@"The New Zealand falcon is a magpie-sized raptor that feeds predominantly on live prey. \n\nAdapted to hunt within the dense New Zealand forests they are also found in more open habitats such as tussocklands and roughly grazed hill country. More recently they have been discovered breeding in exotic pine plantations. Laying their eggs in simple scrapes they can nest in a variety of locations, from within the epiphytes that grow in large trees, to on the ground under small rocky outcrops. \n\nWhere they nest on the ground they are well known for attacking intruders, including humans, with aggressive dive-bombing strikes to the head." forKey:@"item_description"];
        [newManagedObject69 setValue:@"http://nzbirdsonline.org.nz/species/new-zealand-falcon" forKey:@"link"];
        [newManagedObject69 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject69 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject69 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject69 setValue:@"0" forKey:@"category"];
        [newManagedObject69 setValue:@"brown/red" forKey:@"colour"];
        [newManagedObject69 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject69 setValue:@"Falconidae" forKey:@"family"];
        [newManagedObject69 setValue:@"bush, garden" forKey:@"habitat"];
        [newManagedObject69 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject69 setValue:@"NZ Falcon" forKey:@"short_name"];
        [newManagedObject69 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject69 setValue:@"NZFalcon"         forKey:@"image"];
        
        NSURL *url69t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"NZFalcon_TN"
                                                ofType:@"jpg"]];
        NSData *data69t = [[NSData alloc] initWithContentsOfURL:url69t];
        UIImage *imageSave69t=[[UIImage alloc]initWithData:data69t];
        NSData *imageData69t = UIImagePNGRepresentation(imageSave69t);
        [newManagedObject69 setValue:imageData69t         forKey:@"thumbnail"];
        
        
        [newManagedObject69 setValue:@"nz-falcon-song-12_female_DOC" forKey:@"sound"];
        
        [newManagedObject69 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject69 setValue:NO forKey:@"extra"];
        [newManagedObject69 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject69= nil;

        // +++++++++++ Mallard +++++++++++++
        /*  70
         */
        NSManagedObject *newManagedObject70 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject70 setValue:@"Mallard"       forKey:@"name"];
        [newManagedObject70 setValue:@"Mallard" forKey:@"othername"];
        [newManagedObject70 setValue:@"As a consequence of both their gamefarm origin and hybridisation, the plumages of New Zealand’s mallards are highly variable, especially the females, and males in breeding plumage are duller and less striking than wild northern hemisphere mallards.\n\nIdentification\n\nMallards are the ducks that gather en masse whenever bread is thrown out at an urban pond. Drakes are about 10% larger than females. In breeding plumage, drakes have the head and neck glossy dark green, separated from the maroon breast by a thin white collar. The back and flanks are pale grey, and the rump and undertail blackish, with curled black upper tail coverts. The secondary flight feathers are metallic blue, forming a ‘speculum’ on the trailling edge of the inner upper-wing. The speculum has thin black then slightly broader white edges at front and rear. The underwing is white. The bill is yellowish, the eye dark, and legs and feet bright orange. Females are dull brown with feathers edged with buff, and have an indistinct dark eye-stripe on an otherwise featureless face. The bill is brownish-grey, orange at base, sides and tip and the legs and feet orange. The wing pattern and leg colour are the same as for males. Males in eclipse resemble females, but with head and neck greyish, retaining some green, and the breast chestnut. Juveniles resemble females. The plumage of New Zealand mallards is highly variable due to hybridisation with grey ducks, and also many domesticated mallard varieties that have escaped into the wild population.\n\nVoice: Female gives typical decrescendo call of about 6-8 loud quacks in a row, soft quacks in communication with ducklings, and a rapid “gag gag gag” repulsion call in courting displays and when pursued by males. Males give soft “raeb raeb” call of variable length.\n\nSimilar species:\n\n females are easily confused with grey ducks from which they can be distinguished by leg colour, bill colour and pattern, less diffuse eye and bill stripes and their more mottled face. Hybrids with grey duck are confusingly variable in most characteristics, especially in face patterning of females. A narrow white or pale fawn anterior speculum stripe (alar bar) on the wing is indicative of recent hybrid ancestry." forKey:@"item_description"];
        [newManagedObject70 setValue:@"http://nzbirdsonline.org.nz/species/mallard" forKey:@"link"];
        [newManagedObject70 setValue:@"yellow/black" forKey:@"beak_colour"];
        [newManagedObject70 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject70 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject70 setValue:@"0" forKey:@"category"];
        [newManagedObject70 setValue:@"brown/black/green" forKey:@"colour"];
        [newManagedObject70 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject70 setValue:@"Anatidae" forKey:@"family"];
        [newManagedObject70 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject70 setValue:@"Introduced and Naturalised" forKey:@"threat_status"];
        [newManagedObject70 setValue:@"Mallard" forKey:@"short_name"];
        [newManagedObject70 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject70 setValue:@"Mallard"         forKey:@"image"];
        
        NSURL *url70t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Mallard_TN"
                                                ofType:@"jpg"]];
        NSData *data70t = [[NSData alloc] initWithContentsOfURL:url70t];
        UIImage *imageSave70t=[[UIImage alloc]initWithData:data70t];
        NSData *imageData70t = UIImagePNGRepresentation(imageSave70t);
        [newManagedObject70 setValue:imageData70t         forKey:@"thumbnail"];
        
        
        //[newManagedObject70 setValue:@"" forKey:@"sound"];
        
        [newManagedObject70 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject70 setValue:NO forKey:@"extra"];
        [newManagedObject70 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject70= nil;

       

        // +++++++++++ Kakapo +++++++++++++
        /*  72 https://www.flickr.com/photos/whatscapes/3918356449/in/photolist-aCY4AL-aCUekg-aCUcP2-aCY5wh-aCY4kL-aCUeQP-aCUNwT-aCUdXT-aCUepB-aCUdxB-aCY56u-aCUd9H------npAAWF-npT9f4-nrDtsX-npB5sU-npTpZR-dvV5mu-ousaBW-9SpJ1D-avZe9w-4NQvgo-5MWgpP-4qfPxi-ap7LJg-5HHuLo-edXiK5-mYZirY-mYXkED-aDunJp-oqUMxJ-oqUP4Q-oqUMRE-op68Rd-o9Co15-op68Ju-o9Dq8t-o9Cnmj-op68kd-oeZqPu-6YjD5G-nw1X6h-nxLaN8-4ZE3Qn-6YfARP (Mark Whatmough)
         */
        NSManagedObject *newManagedObject72 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject72 setValue:@"Kakapo"       forKey:@"name"];
        [newManagedObject72 setValue:@"Owl-Parrot,Night parrot" forKey:@"othername"];
       [newManagedObject72 setValue:@"The kakapo is critically endangered; as of August 2018, the total known adult population was 148 living animals. All carry radio transmitters and are intensively monitored and managed. Because of the introduction of predators such as cats, rats, ferrets, and stoats during European colonisation, the kakapo was almost wiped out. Conservation efforts began in the 1890s, but they were not very successful until the implementation of the Kakapo Recovery Programme in 1995.\nIt is possible there are a few birds remaining on Stewart Island, and perhaps even a few in Fiordland.\n\n Once found throughout New Zealand, kakapo started declining in range and abundance after the arrival of Maori. They disappeared from the North Island by about 1930, but persisted longer in the wetter parts of the South Island. The last birds died out in Fiordland in the late 1980s. A population of less than two hundred birds was discovered on Stewart Island in 1977, but this population was also declining due to cat predation. During the 1980s and 1990s the entire known population was transferred to Codfish Island off the coast of Stewart Island, Maud Island in the Marlborough Sounds and Little Barrier Island in the Hauraki Gulf. Since then birds have been moved between Codfish, Maud and Little Barrier Islands as well as to and from newly predator-free Chalky and Anchor Islands in Fiordland. \n\nKakapo now occur only on forested islands, though they previously appeared to have inhabited a wide range of vegetation types." forKey:@"item_description"];
        [newManagedObject72 setValue:@"http://en.wikipedia.org/wiki/kakapo" forKey:@"link"];
        [newManagedObject72 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject72 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject72 setValue:@"flightless" forKey:@"behaviour"];
        [newManagedObject72 setValue:@"0" forKey:@"category"];
        [newManagedObject72 setValue:@"green" forKey:@"colour"];
        [newManagedObject72 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject72 setValue:@"Strigoidae" forKey:@"family"];
        [newManagedObject72 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject72 setValue:@"Nationally critical" forKey:@"threat_status"];
        [newManagedObject72 setValue:@"Kakapo" forKey:@"short_name"];
        [newManagedObject72 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject72 setValue:@"Kakapo"         forKey:@"image"];
        
        NSURL *url72t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Kakapo_TN"
                                                ofType:@"jpg"]];
        NSData *data72t = [[NSData alloc] initWithContentsOfURL:url72t];
        UIImage *imageSave72t=[[UIImage alloc]initWithData:data72t];
        NSData *imageData72t = UIImagePNGRepresentation(imageSave72t);
        [newManagedObject72 setValue:imageData72t         forKey:@"thumbnail"];
//
//        
        [newManagedObject72 setValue:@"kakapo-male-song_DOC_18" forKey:@"sound"];
        
        [newManagedObject72 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject72 setValue:NO forKey:@"extra"];
        [newManagedObject72 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject72= nil;

        // +++++++++++ Whitehead +++++++++++++
        /*  73
         */
        NSManagedObject *newManagedObject73 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject73 setValue:@"Whitehead"       forKey:@"name"];
        [newManagedObject73 setValue:@"pōpokatea, Whitehead" forKey:@"othername"];
        [newManagedObject73 setValue:@"Whiteheads are gregarious songbirds that live in noisy groups of up to 8 members and that are often heard before they are seen. They are only found in the North Island where they inhabit mostly the canopy regions of tall dense forest. Their numbers have been in decline but relocations in recent years have seen some very good results with several newly established populations. Whiteheads are the only North Island hosts for the long-tailed cuckoo.\n\nWhiteheads are small songbirds with a compact body, short tail and bill and long legs. The head and underparts are white or whitish. Upperparts, wings and tail are brown-grey. Bill, legs and eyes are dark.\n\nVoice:\n\n whitehead song is a characteristic viu viu viu zir zir zir zir or canary-like twitter. Several other chirps or chatters are used for constant communication within the group.\n\nSimilar species:\n\n although some species such as sparrow and silvereye are similar in size, the distinct white head and underparts make the whitehead easily distinguishable from other small passerines.\n\nDistribution and habitat:\n\n The whitehead occurs only in the North Island of New Zealand. Its mainland distribution is south of a line connecting the Pirongia Forest, Hamilton and Te Aroha. It is locally common though patchily distributed south of this line, and to the north is limited to offshore islands and one fenced translocation site. Whiteheads are naturally common on Little Barrier and Kapiti Islands, and have been successfully introduced to Tiritiri Matangi Island, Motuora Island and Tawharanui Regional Park in the Auckland area, plus Maungatautari, Mana Island and Karori Sanctuary. Attempts to establish whiteheads in the Waitakere ranges (Ark in the Park) and at Cape Sanctuary (Hawke’s Bay) are continuing, and in 2011 or 2012 they were released on Moturoa Island (Bay of Islands) and Motuihe, Rangitoto and Motutapu Islands in the Hauraki Gulf. Although found most commonly in tall native forest and dense shrubland, whiteheads also occur in mature pine plantations." forKey:@"item_description"];
        [newManagedObject73 setValue:@"http://nzbirdsonline.org.nz/species/whitehead" forKey:@"link"];
        [newManagedObject73 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject73 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject73 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject73 setValue:@"0" forKey:@"category"];
        [newManagedObject73 setValue:@"grey/white" forKey:@"colour"];
        [newManagedObject73 setValue:@"grey" forKey:@"leg_colour"];
        [newManagedObject73 setValue:@"Pachycephalidae" forKey:@"family"];
        [newManagedObject73 setValue:@"garden,bush" forKey:@"habitat"];
        [newManagedObject73 setValue:@"Not threatened" forKey:@"threat_status"];
        [newManagedObject73 setValue:@"Whitehead" forKey:@"short_name"];
        [newManagedObject73 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject73 setValue:@"Whitehead_TN"         forKey:@"image"];
        
        NSURL *url73t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Whitehead_TN"
                                                ofType:@"jpg"]];
        NSData *data73t = [[NSData alloc] initWithContentsOfURL:url73t];
        UIImage *imageSave73t=[[UIImage alloc]initWithData:data73t];
        NSData *imageData73t = UIImagePNGRepresentation(imageSave73t);
        [newManagedObject73 setValue:imageData73t         forKey:@"thumbnail"];
        
        
        [newManagedObject73 setValue:@"whitehead-song-56_DOC" forKey:@"sound"];
        
        [newManagedObject73 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject73 setValue:NO forKey:@"extra"];
        [newManagedObject73 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject73= nil;

        // +++++++++++ Fernbird +++++++++++++
        /*  74
         */
        NSManagedObject *newManagedObject74 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject74 setValue:@"Fernbird"       forKey:@"name"];
        [newManagedObject74 setValue:@"mātātā, Fernbird" forKey:@"othername"];
        [newManagedObject74 setValue:@"More often heard than seen, fernbirds are skulking sparrow-sized, well-camouflaged birds that on the three main islands are found mainly in dense, low wetland vegetation. They have disappeared from large areas of New Zealand, including Wairarapa, Wellington and Canterbury, but remain common on the West Coast and in pockets of suitable habitat from Northland to Stewart Island. \n\nFernbirds occupy drier shrubland and tussock habitat at a few sites, including in the Far North and on some islands. A small long-tailed songbird that is predominantly streaked brown above and pale below, with loosely-barbed plain brown tail feathers that give birds a distinctive tattered appearance, a pointed greyish-black bill and long pinkish-red legs. The mainland subspecies have a chestnut cap and a prominent pale superciliary stripe. Similar species: Dunnock\n\nFernbirds are closely related to the grassbirds Megalurus of Australia and Africa, and are sometimes included in that genus." forKey:@"item_description"];
        [newManagedObject74 setValue:@"http://nzbirdsonline.org.nz/species/fernbird" forKey:@"link"];
        [newManagedObject74 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject74 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject74 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject74 setValue:@"0" forKey:@"category"];
        [newManagedObject74 setValue:@"brown" forKey:@"colour"];
        [newManagedObject74 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject74 setValue:@"Megaluridae" forKey:@"family"];
        [newManagedObject74 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject74 setValue:@"Declining" forKey:@"threat_status"];
        [newManagedObject74 setValue:@"Fernbird" forKey:@"short_name"];
        [newManagedObject74 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject74 setValue:@"Fernbird_BrianRalphs"         forKey:@"image"];
        
        NSURL *url74t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Fernbird_BrianRalphs_TN"
                                                ofType:@"jpg"]];
        NSData *data74t = [[NSData alloc] initWithContentsOfURL:url74t];
        UIImage *imageSave74t=[[UIImage alloc]initWithData:data74t];
        NSData *imageData74t = UIImagePNGRepresentation(imageSave74t);
        [newManagedObject74 setValue:imageData74t         forKey:@"thumbnail"];
        
        
        [newManagedObject74 setValue:@"" forKey:@"sound"];
        
        [newManagedObject74 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject74 setValue:NO forKey:@"extra"];
        [newManagedObject74 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject74= nil;

        // +++++++++++ Wrybill +++++++++++++
        /*  75 https://www.flickr.com/photos/seabirdnz/8168586847/in/set-72157625228303867 or
         (https://www.flickr.com/photos/seabirdnz/5162801993/in/set-72157625228303867)
         */
        NSManagedObject *newManagedObject75 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject75 setValue:@"Wrybill"       forKey:@"name"];
        [newManagedObject75 setValue:@"Wrybill" forKey:@"othername"];
        [newManagedObject75 setValue:@"Breeding and ecology: The wrybill is a small pale plover which breeds only in braided rivers of the South Island. It is the only bird in the world with a laterally-curved bill (always curved to the right), which it uses to reach insect larvae under rounded riverbed stones. Wrybills are completely dependent on braided rivers for breeding; all their life stages are predominantly grey, and highly cryptic among the greywacke shingle of the riverbeds.\n\nThe wrybill is an internal migrant. After breeding, almost the entire population migrates north to winter in the harbours of the northern North Island, notably the Firth of Thames and Manukau Harbour. On their wintering grounds, wrybills form dense flocks at high-water roosts; the highly-coordinated aerial manoeuvres of these flocks have been described as resembling a flung scarf.\n\nIdentification:\n\n Wrybills are small, pale plovers that are much more approachable than most New Zealand waders. Their underparts are white, with a black upper breast band from mid-winter to the end of the breeding season. The upper parts and sides of the face are pale grey, and the forehead white. The bill is long and black, with the distal third curved 12-26° to the right. The legs are dark grey to black. The sexes are alike in eclipse plumage; juveniles lack the black breast band. In breeding plumage, males are distinguishable by a black line above the forehead; this is highly variable however, and difficult to see in some individuals.\n\nSimilar species: wrybills are unlikely to be mistaken for other species in breeding plumage or if the bill is seen well. In eclipse plumage the banded dotterel is superficially similar, but has browner upper parts and short straight bill. Confusion is possible with some rare transequatorial migrant waders, notably sanderling and terek sandpiper, but these lack the black breast band, and their bill shapes differ.\n\nDistribution: Wrybills breed only in the South Island, east of the main divide. The large majority of the population breeds in Canterbury between the Waimakariri River in the north, and the rivers of the upper Waitaki (Mackenzie) Basin in the south. Main strongholds are the Rakaia, upper Rangitata, and Mackenzie Basin. Four rivers in Otago (Hunter, Makarora, Matukituki, and Dart) and two in North Canterbury (Ashley and Waiau) have small populations. Wrybills previously bred in Marlborough, but their breeding range has contracted southwards over the past 120 years.\n\nFrom January to July, wrybills are present in harbours of the northern North Island, mainly Manukau and Firth of Thames, smaller flocks elsewhere. During migration, small flocks are often seen briefly at South Island east coast lakes and estuaries, and flocks may settle at rivermouths in the southwestern North Island.\n\nHabitat:\n\n Wrybills breed exclusively on braided riverbeds. On their wintering grounds, they feed on inter-tidal mudflats in harbours and estuaries. High-water roosts are usually near foraging areas, commonly on local shellbanks and beaches;  occasionally on pasture. In the upper Manukau Harbour, birds regularly roost on roofs of large buildings; occasionally on tarmac at Auckland Airport. On migration, flocks generally follow coastlines, but are not averse to flying overland. A high proportion of the population passes through Lake Ellesmere on both migrations." forKey:@"item_description"];
        [newManagedObject75 setValue:@"http://nzbirdsonline.org.nz/species/wrybill" forKey:@"link"];
        [newManagedObject75 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject75 setValue:@"curved" forKey:@"beak_length"];
        [newManagedObject75 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject75 setValue:@"0" forKey:@"category"];
        [newManagedObject75 setValue:@"grey/white" forKey:@"colour"];
        [newManagedObject75 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject75 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject75 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject75 setValue:@"Nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject75 setValue:@"Wrybill" forKey:@"short_name"];
        [newManagedObject75 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject75 setValue:@"Wrybill_Ben"         forKey:@"image"];
        
        NSURL *url75t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Wrybill_Ben_TN"
                                                ofType:@"jpg"]];
        NSData *data75t = [[NSData alloc] initWithContentsOfURL:url75t];
        UIImage *imageSave75t=[[UIImage alloc]initWithData:data75t];
        NSData *imageData75t = UIImagePNGRepresentation(imageSave75t);
        [newManagedObject75 setValue:imageData75t         forKey:@"thumbnail"];
        
        
        //[newManagedObject75 setValue:@"" forKey:@"sound"];
        
        [newManagedObject75 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject75 setValue:NO forKey:@"extra"];
        [newManagedObject75 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject75= nil;

        // +++++++++++ NZ Pipit +++++++++++++
        /*  76 (https://www.flickr.com/photos/angrysunbird/4406421185/in/photolist-9jtwCP-GZxR7-7Ho4v4 (Duncan)
         )
         */
        NSManagedObject *newManagedObject76 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject76 setValue:@"Pipit (NZ)"       forKey:@"name"];
        [newManagedObject76 setValue:@"NZ Pipit, pīhoihoi" forKey:@"othername"];
        [newManagedObject76 setValue:@"The New Zealand pipit is a small brown-and-white songbird that resembles a lark, but has longer legs, and walks rather than hops. \n\nThey are birds of open country, including the tideline of sandy beaches, rough pasture, river beds and above the tree-line. Pipits are members of the wagtail family, and frequently flick their long tails as they walk. In flight their tails have narrow white sides – a character shared with skylarks, chaffinches, yellowhammers and cirl buntings." forKey:@"item_description"];
        [newManagedObject76 setValue:@"http://nzbirdsonline.org.nz/species/new-zealand-pipit" forKey:@"link"];
        [newManagedObject76 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject76 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject76 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject76 setValue:@"0" forKey:@"category"];
        [newManagedObject76 setValue:@"brown" forKey:@"colour"];
        [newManagedObject76 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject76 setValue:@"Motacillidae" forKey:@"family"];
        [newManagedObject76 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject76 setValue:@"declining" forKey:@"threat_status"];
        [newManagedObject76 setValue:@"NZ Pipit" forKey:@"short_name"];
        [newManagedObject76 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject76 setValue:@"NZPipit"         forKey:@"image"];
        
        NSURL *url76t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"NZPipit_TN"
                                                ofType:@"jpg"]];
        NSData *data76t = [[NSData alloc] initWithContentsOfURL:url76t];
        UIImage *imageSave76t=[[UIImage alloc]initWithData:data76t];
        NSData *imageData76t = UIImagePNGRepresentation(imageSave76t);
        [newManagedObject76 setValue:imageData76t         forKey:@"thumbnail"];
        
        
        //[newManagedObject76 setValue:@"" forKey:@"sound"];
        
        [newManagedObject76 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject76 setValue:NO forKey:@"extra"];
        [newManagedObject76 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject76= nil;

        // +++++++++++ Red-necked stint +++++++++++++
        /*  77  Red-necked stint (https://www.flickr.com/photos/seabirdnz/10050327045/in/set-72157625228303867)
         */
        NSManagedObject *newManagedObject77 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject77 setValue:@"Red-necked stint"       forKey:@"name"];
        [newManagedObject77 setValue:@"rufous-necked stint" forKey:@"othername"];
        [newManagedObject77 setValue:@"Stints are the smallest of the migratory waders – barely the size of a sparrow.\n\n The red-necked stint is the only stint species to regularly occur in New Zealand, with up to 200 spending the southern summer here each year. \n\nThey are most often seen at high-tide roosts associating with other small waders, especially wrybills, and other sandpipers. A tiny wader with dark legs and a short straight black bill, which in breeding plumage has a distinctive rufous ‘balaclava’ but otherwise is pale grey-brown above and off-white below throughout the year. The dorsal feathers have dark shafts and pale fringes, the flight feathers are dark and the rump is white with a dark centre." forKey:@"item_description"];
        [newManagedObject77 setValue:@"http://nzbirdsonline.org.nz/species/red-necked-stint" forKey:@"link"];
        [newManagedObject77 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject77 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject77 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject77 setValue:@"0" forKey:@"category"];
        [newManagedObject77 setValue:@"grey/brown" forKey:@"colour"];
        [newManagedObject77 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject77 setValue:@"Scolopacidae" forKey:@"family"];
        [newManagedObject77 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject77 setValue:@"Migrant" forKey:@"threat_status"];
        [newManagedObject77 setValue:@"Red-necked stint" forKey:@"short_name"];
        [newManagedObject77 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject77 setValue:@"Red_necked_stint"         forKey:@"image"];
        
        NSURL *url77t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Red_necked_stint_TN"
                                                ofType:@"jpg"]];
        NSData *data77t = [[NSData alloc] initWithContentsOfURL:url77t];
        UIImage *imageSave77t=[[UIImage alloc]initWithData:data77t];
        NSData *imageData77t = UIImagePNGRepresentation(imageSave77t);
        [newManagedObject77 setValue:imageData77t         forKey:@"thumbnail"];
        
        
        //[newManagedObject77 setValue:@"" forKey:@"sound"];
        
        [newManagedObject77 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject77 setValue:NO forKey:@"extra"];
        [newManagedObject77 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject77= nil;

        
        // +++++++++++ North-Island Robin +++++++++++++
        /*  78  https://www.flickr.com/photos/angrysunbird/5501206978/ (Duncan)
         */
        NSManagedObject *newManagedObject78 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject78 setValue:@"North-Island Robin"       forKey:@"name"];
        [newManagedObject78 setValue:@"Toutouwai" forKey:@"othername"];
        [newManagedObject78 setValue:@"The North Island robin occurs in forest and scrub habitats. It can be recognised by its erect stance and relatively long legs, and spends much time foraging on the ground. \n\nIt is a territorial species, males in particular inhabiting the same patch of mainland forest of 1-5 ha throughout their lives. Male are great songsters, particularly bachelors, singing loudly and often for many minutes at a time. \n\nWhere robins are regularly exposed to people, such as along public walking tracks, they become quite confiding, often approaching to within a metre of a person sitting quietly. Naïve juveniles will sometimes stand on a person’s boot." forKey:@"item_description"];
        [newManagedObject78 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/north-island-robin-toutouwai/" forKey:@"link"];
        [newManagedObject78 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject78 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject78 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject78 setValue:@"0" forKey:@"category"];
        [newManagedObject78 setValue:@"brown/grey/black" forKey:@"colour"];
        [newManagedObject78 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject78 setValue:@"Petroicidae" forKey:@"family"];
        [newManagedObject78 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject78 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject78 setValue:@"North-Island Robin" forKey:@"short_name"];
        [newManagedObject78 setValue:@"sparrow" forKey:@"size_and_shape"];
        
        
        [newManagedObject78 setValue:@"NorthIsland_Robin_Duncan"         forKey:@"image"];
        
        NSURL *url78t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"NorthIsland_Robin_Duncan_TN"
                                                ofType:@"jpg"]];
        NSData *data78t = [[NSData alloc] initWithContentsOfURL:url78t];
        UIImage *imageSave78t=[[UIImage alloc]initWithData:data78t];
        NSData *imageData78t = UIImagePNGRepresentation(imageSave78t);
        [newManagedObject78 setValue:imageData78t         forKey:@"thumbnail"];
        
        
        [newManagedObject78 setValue:@"north-island-robin-song_DOC" forKey:@"sound"];
        
        [newManagedObject78 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject78 setValue:NO forKey:@"extra"];
        [newManagedObject78 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject78= nil;
        
        
        // +++++++++++ Banded Rail +++++++++++++
        /* 79
         */
        
         // +++++++++++ Bittern +++++++++++++
         /* 80
          */
        
        
        
        // +++++++++++ Australasian Shoveler +++++++++++++
        /*  81  (https://www.flickr.com/photos/digitaltrails/183116387/in/photolist-dnEud8-a5zGqi-dRx5jF-a5zFqi-8fBvKk-mYVFoH-okT9NR-bmFfZN-diXVW2-8fBxhT-fkdehr-a5CzhG-hnaWeK-hnbzQh-fdbXeJ-kMbk3F-nav99P-75XVty-ddAYJd-8YqTse-hbw86-kMbmDg-9bzno2-9bzjJn digitaltrails)
         */
        NSManagedObject *newManagedObject81 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject81 setValue:@"Australasian Shoveler"       forKey:@"name"];
        [newManagedObject81 setValue:@"spoonbill, spoony, New Zealand shoveler" forKey:@"othername"];
        [newManagedObject81 setValue:@"Shovelers are specialist filter-feeding waterfowl with a large spoon-shaped or shovel-shaped bill that is almost twice as broad at its tip than at its base and which is the bird’s most conspicuous feature. Fine lamellae extend along most of the edge of the upper mandible and it is by pushing water through this lamellae curtain that small plankton and fine seeds are extracted.\n\nAustralasian shovelers are sexually dimorphic. The males are highly coloured most of the year, when they have a blue-grey head and neck with a distinctive white crescentic band at the base of its large spatulate black bill. The breast is a mottled brown and white after breeding but becomes progressively pure white as the nuptial moult proceeds during May. Its chestnut flank is offset by a large white patch at the tail base. The eye is yellow and the legs bright orange. Females are uniformly mottled light brown with dull brown bill and eye, and brown-orange legs. In flight  Australasian shovelers have a distinctive profile with a ridiculously large bill, sharp pointed wings and very rapid wingbeats. The blue, white and green patches on the upper wing contrast with the white underwing.\n\nVoice: \n\nAustralasian shovelers are rarely vocal. Displaying males have a rapid “chuff-chuff” call, and females may give a typical descending quack quack quack." forKey:@"item_description"];
        [newManagedObject81 setValue:@"http://nzbirdsonline.org.nz/species/australasian-shoveler" forKey:@"link"];
        [newManagedObject81 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject81 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject81 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject81 setValue:@"0" forKey:@"category"];
        [newManagedObject81 setValue:@"brown/red/black" forKey:@"colour"];
        [newManagedObject81 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject81 setValue:@"Anatidae" forKey:@"family"];
        [newManagedObject81 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject81 setValue:@"Not Threatened" forKey:@"threat_status"];
        [newManagedObject81 setValue:@"Australasian Shoveler" forKey:@"short_name"];
        [newManagedObject81 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject81 setValue:@"AustralasianShoveler_digitaltrails"         forKey:@"image"];
        
        NSURL *url81t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"AustralasianShoveler_digitaltrails_TN"
                                                ofType:@"jpg"]];
        NSData *data81t = [[NSData alloc] initWithContentsOfURL:url81t];
        UIImage *imageSave81t=[[UIImage alloc]initWithData:data81t];
        NSData *imageData81t = UIImagePNGRepresentation(imageSave81t);
        [newManagedObject81 setValue:imageData81t         forKey:@"thumbnail"];
        
        
        //[newManagedObject81 setValue:@"" forKey:@"sound"];
        
        [newManagedObject81 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject81 setValue:NO forKey:@"extra"];
        [newManagedObject81 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject81= nil;
        
        // +++++++++++ Little spotted Kiwi +++++++++++++
        /*  82
         */
        NSManagedObject *newManagedObject82 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject82 setValue:@"Kiwi (Little Spotted)"       forKey:@"name"];
        [newManagedObject82 setValue:@"Kiwi pukupuku" forKey:@"othername"];
        [newManagedObject82 setValue:@"The smallest of the five kiwi species. Formerly widespread on both main islands, but now confined to offshore islands and one mainland sanctuary. Flightless, with tiny vestigial wings and no tail. Nocturnal, therefore more often heard than seen. Male gives a repeated high-pitched ascending whistle, female gives a slower and lower pitched warbling whistle. Light brownish grey finely mottled or banded horizontally with white, long pale bill, short pale legs, toes and claws.\n\nIdentification\n\nSmall pale kiwi. Light brownish grey finely mottled or banded horizontally with white, long pale bill, short pale legs and toes.\n\nVoice:  Male gives a high-pitched ascending whistle, female gives a slower and lower pitched ascending trill; both sexes repeat calls 25-35 times per sequence.\n\nSimilar species: juvenile great spotted kiwi pass through a stage when they are similar to little spotted kiwi, but great spotted kiwi have dark legs and toes, and darker plumage.\n\nDistribution and habitat\n\nFormerly widespread in forest and scrub on both the North and South Islands. By the time of European settlement they had virtually disappeared from the North Island, with only one specimen collected (Mt Hector, Tararua Range, 1875) and another reported from near Pirongia in 1882. Still common in Nelson, Westland and Fiordland through to the early 1900s, but gradually disappeared, leaving a small relict population on D’Urville Island. It is believed that five little spotted kiwi were introduced to Kapiti Island from the Jackson Bay area in 1912, and they flourished on the island. Since 1983, birds have been transferred from Kapiti to establish new populations on Hen, Tiritiri Matangi, Motuihe, Red Mercury, Long (Marlborough Sounds), and Chalky Islands, and to Zealandia/Karori Sanctuary (Wellington). Two D’Urville birds were transferred to Long Island (Marlborough Sounds).\n\nPopulation\n\nAbout 1650 birds in 2012. Kapiti Island is the stronghold for the species, with c.1200 birds; Zealandia 120; Tiritiri Matangi 80; Red Mercury 70; Hen Island 50; Long 50; Chalky 50; Motuihe 30." forKey:@"item_description"];
        [newManagedObject82 setValue:@"http://nzbirdsonline.org.nz/species/little-spotted-kiwi" forKey:@"link"];
        [newManagedObject82 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject82 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject82 setValue:@"flightless" forKey:@"behaviour"];
        [newManagedObject82 setValue:@"0" forKey:@"category"];
        [newManagedObject82 setValue:@"brown" forKey:@"colour"];
        [newManagedObject82 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject82 setValue:@"Casuariiformes" forKey:@"family"];
        [newManagedObject82 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject82 setValue:@"Recovering" forKey:@"threat_status"];
        [newManagedObject82 setValue:@"Little Spotted Kiwi" forKey:@"short_name"];
        [newManagedObject82 setValue:@"duck" forKey:@"size_and_shape"];
        
        
        [newManagedObject82 setValue:@"LittleSpottedKiwi_Apteryx_owenii_REDUCEDSIZE"         forKey:@"image"];
        
        NSURL *url82t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"LittleSpottedKiwi_Apteryx_owenii_TN"
                                                ofType:@"jpg"]];
        NSData *data82t = [[NSData alloc] initWithContentsOfURL:url82t];
        UIImage *imageSave82t=[[UIImage alloc]initWithData:data82t];
        NSData *imageData82t = UIImagePNGRepresentation(imageSave82t);
        [newManagedObject82 setValue:imageData82t         forKey:@"thumbnail"];
        
        
        //[newManagedObject82 setValue:@"" forKey:@"sound"];
        
        [newManagedObject82 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject82 setValue:NO forKey:@"extra"];
        [newManagedObject82 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject82= nil;
  
        
        // +++++++++++ Pied Shag +++++++++++++
        /*  83
         */
                NSManagedObject *newManagedObject83 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
                //Set Bird_attributes
                [newManagedObject83 setValue:@"Shag, Pied"       forKey:@"name"];
                [newManagedObject83 setValue:@"Pied Shag" forKey:@"othername"];
        [newManagedObject83 setValue:@"This large black-and-white shag is often seen individually or in small groups roosting on rocky headlands, trees or artificial structures. In regions where it occurs it can usually be readily seen about harbours and estuaries associated with cities or towns. Unlike most other shag species, the pied shag is reasonably confiding, allowing close approach when roosting or nesting in trees. It generally forages alone, but occasionally in small groups when prey is abundant.\n\nIdentification\n\nPied shags mainly inhabit coastal habitats about much of New Zealand. Adults have the crown, back of the neck, mantle, rump, wings, thighs and tail black, although on close inspection the upper wing coverts are grey-black with a thin black border. The face, throat, sides of neck and underparts are white. The long, hooked beak is grey, the iris is green, and legs and feet black. On breeding adults, the skin in front of the eye is yellow, at the base of beak is pink or pink-red, and the eye-ring is blue. Non-breeding adults have paler skin colours than breeders. \n\nVoice:\n\n generally silent away from nesting colonies, but quite vocal at colonies during pair formation, nest building and when one of a pair returns to nest during incubation. \n\nSimilar species:\n\n the pied morph of the little shag is much smaller and has a short stubby yellow beak. Both the king shag and pied morph of the Stewart Island shag have black heads with white throats, patches of white feathers on the upper wings, and pink feet. Juveniles and immatures of black shag can be difficult to distinguish from the similar-sized juveniles and immatures of pied shag. Both can have underparts from nearly all brown to nearly all white. Juvenile black shags have dark heads and upper throat, and have extensive yellowish facial skin about base of the beak, whereas the yellow is only in front of the eye on the pied shag.\n\nDistribution and habitat\n\nThe pied shag has a mainly coastal breeding distribution, occurring in three separate areas of New Zealand. Northern North Island: colonies on the western and eastern coasts of Northland and Auckland, and extending down to East Cape. Central New Zealand: Wellington, Nelson, Marlborough and Canterbury as far south as Banks Peninsula. Southern South Island: Fiordland and Stewart Island. Pied shags mainly forage in coastal marine waters, harbours and estuaries, but occasionally also in freshwater lakes and ponds close to the coast. An examination of numbers of pairs at colonies during three periods (pre 1980, 1980-1999, post 1999), suggests that populations in the northern North Island and southern South Island are in decline, while those in central New Zealand are increasing." forKey:@"item_description"];
                [newManagedObject83 setValue:@"http://nzbirdsonline.org.nz/species/pied-shag" forKey:@"link"];
                [newManagedObject83 setValue:@"red,pale" forKey:@"beak_colour"];
                [newManagedObject83 setValue:@"long" forKey:@"beak_length"];
                [newManagedObject83 setValue:@"can fly, shy" forKey:@"behaviour"];
                [newManagedObject83 setValue:@"0" forKey:@"category"];
                [newManagedObject83 setValue:@"black,white" forKey:@"colour"];
                [newManagedObject83 setValue:@"black" forKey:@"leg_colour"];
                [newManagedObject83 setValue:@"Phalacrocoracidae" forKey:@"family"];
                [newManagedObject83 setValue:@"coast" forKey:@"habitat"];
                [newManagedObject83 setValue:@"Nationally Vulnerable" forKey:@"threat_status"];
                [newManagedObject83 setValue:@"pied cormorant" forKey:@"short_name"];
                [newManagedObject83 setValue:@"duck" forKey:@"size_and_shape"];
        
        
                [newManagedObject83 setValue:@"PiedShag_steintil"         forKey:@"image"];
        
                NSURL *url83t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                        pathForResource:@"PiedShag_steintil_TN"
                                                        ofType:@"jpg"]];
                NSData *data83t = [[NSData alloc] initWithContentsOfURL:url83t];
                UIImage *imageSave83t=[[UIImage alloc]initWithData:data83t];
                NSData *imageData83t = UIImagePNGRepresentation(imageSave83t);
                [newManagedObject83 setValue:imageData83t         forKey:@"thumbnail"];
        
        
                //[newManagedObject83 setValue:@"Kiwi" forKey:@"sound"];
        
                [newManagedObject83 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
                [newManagedObject83 setValue:NO forKey:@"extra"];
                [newManagedObject83 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
                [context save:NULL];
                newManagedObject83= nil;
        
        
        // +++++++++++ Saddleback +++++++++++++
        /*  84
         */
                NSManagedObject *newManagedObject84 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
                //Set Bird_attributes
                [newManagedObject84 setValue:@"Saddleback"       forKey:@"name"];
                [newManagedObject84 setValue:@"North Island saddleback" forKey:@"othername"];
        [newManagedObject84 setValue:@"North Island saddlebacks are conspicuous and easily observed in regenerating scrub, forests and coastal forests. They call frequently, particularly in response to disturbance, and are very active, noisy foragers. They are about the size of a European blackbird. Saddlebacks were widespread at European contact, but rapidly declined on the mainland following the introduction of predatory mammals, especially ship rats and stoats. By the early 1900s, North Island saddlebacks were confined to a single population on Hen Island (Taranga) off the northeast coast of the North Island. A series of successful translocations was initiated by the New Zealand Wildlife Service in the 1960s, and there are now 15 island populations and five at predator-fenced mainland sites.\n\nIdentification\n\nNorth Island saddlebacks have striking black plumage, a rufous chestnut saddle across their back, bright red wattles (that get larger with age) and a thin gold band on the leading edge of the saddle. Sexes are alike, although males usually have larger wattles than females of the same age. Juveniles are similar but their plumage lacks the sheen of adults, with dusty brown tips on black body feathers, the gold band is absent, and they have small wattles.\n\nVoice: a loud chattering call cheet te-te-te-te is uttered throughout the day. Territorial male birds sing male rhythmical song which is characterised by 2-4 introductory chips followed by a series of highly stereotyped and repeated phrases. Over 200 different types of male rhythmical song have been recorded. Male and female birds also give sexually dimorphic quiet calls which are very soft and flute like.\n\nSimilar species: the closely related South Island saddleback now confined to small islands and one fenced sanctuary, all south of Cook Strait.\n\nDistribution\n\nThe single remaining natural population of around 500 birds is on Hen Island.  There are mainland populations at five fenced sanctuaries, Karori Sanctuary (2002), Bushy Park (2006),Tawharanui Regional Park (2012), Cape Sanctuary, Hawke’s Bay (2013) and Maungatautari (2013).\n\nHabitat\n\nNorth Island saddlebacks frequent coastal and inland forests, particularly scrubby regenerating areas, ranging from sea level to more than 600 m above sea level.\n\nPopulation\n\nNorth Island saddlebacks can be very abundant in suitable habitat free of introduced mammals. Recent population estimates suggest there are more than 7000 birds across all populations. However, many of the island estimates are not based on formal counts and the actual number is likely to be much higher.\n" forKey:@"item_description"];
                [newManagedObject84 setValue:@"http://nzbirdsonline.org.nz/species/north-island-saddleback" forKey:@"link"];
                [newManagedObject84 setValue:@"black" forKey:@"beak_colour"];
                [newManagedObject84 setValue:@"short" forKey:@"beak_length"];
                [newManagedObject84 setValue:@"can fly,shy" forKey:@"behaviour"];
                [newManagedObject84 setValue:@"0" forKey:@"category"];
                [newManagedObject84 setValue:@"black/brown" forKey:@"colour"];
                [newManagedObject84 setValue:@"black" forKey:@"leg_colour"];
                [newManagedObject84 setValue:@"Callaeidae" forKey:@"family"];
                [newManagedObject84 setValue:@"bush" forKey:@"habitat"];
                [newManagedObject84 setValue:@"Recovering" forKey:@"threat_status"];
                [newManagedObject84 setValue:@"Saddleback" forKey:@"short_name"];
                [newManagedObject84 setValue:@"blackbird" forKey:@"size_and_shape"];
        
        
                [newManagedObject84 setValue:@"Saddleback_Duncan"         forKey:@"image"];
        
                NSURL *url84t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                        pathForResource:@"Saddleback_Duncan_TN"
                                                        ofType:@"jpg"]];
                NSData *data84t = [[NSData alloc] initWithContentsOfURL:url84t];
                UIImage *imageSave84t=[[UIImage alloc]initWithData:data84t];
                NSData *imageData84t = UIImagePNGRepresentation(imageSave84t);
                [newManagedObject84 setValue:imageData84t         forKey:@"thumbnail"];
        
        
                [newManagedObject84 setValue:@"north-island-saddleback-song_DOC" forKey:@"sound"];
        
                [newManagedObject84 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
                [newManagedObject84 setValue:NO forKey:@"extra"];
                [newManagedObject84 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
                [context save:NULL];
                newManagedObject84= nil;
       
        // +++++++++++ California quail +++++++++++++
        /*  85
         */
        NSManagedObject *newManagedObject85 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject85 setValue:@"California Quail"       forKey:@"name"];
        [newManagedObject85 setValue:@"California Quail" forKey:@"othername"];
        [newManagedObject85 setValue:@"California quail are stocky, predominantly grey and brown, with a diagnostic forward-curling black plume rising erect from the top of their heads. Males have a black chin and cheeks edged with white, and separate white ‘eyebrows’ join on the forehead. The breast is blue-grey and the lower belly cream to rust brown with distinctive black scalloping, which merges into strong, pale streaks on the dark brown flanks. \n\nThe female is slightly smaller, duller and browner, with some streaking on the neck and a more subdued scalloping on the belly, but with equally bold streaking on the flanks. Immature birds are similar to the female but a lighter brown. The female’s crest plume is much smaller than the male’s. Both sexes have fine speckling on the nape, which is bolder in the male. \n\nThere is no seasonal change in plumage. California quail have short, rounded wings and a relatively long tail. Their legs and bill are black and sturdy, with the bill being slightly hooked.\n\nForaging quail pace sedately, but when disturbed they run at speed, their feet a blur of movement, or burst into flight with noisy, rapid wingbeats.\
         " forKey:@"item_description"];
        [newManagedObject85 setValue:@"http://nzbirdsonline.org.nz/species/california-quail" forKey:@"link"];
        [newManagedObject85 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject85 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject85 setValue:@"can fly,shy" forKey:@"behaviour"];
        [newManagedObject85 setValue:@"0" forKey:@"category"];
        [newManagedObject85 setValue:@"grey/brown" forKey:@"colour"];
        [newManagedObject85 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject85 setValue:@"Phasianidae" forKey:@"family"];
        [newManagedObject85 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject85 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        [newManagedObject85 setValue:@"plumed quail" forKey:@"short_name"];
        [newManagedObject85 setValue:@"blackbird" forKey:@"size_and_shape"];
        
        
        [newManagedObject85 setValue:@"CaliforniaQuail_SidMosdell"         forKey:@"image"];
        
        NSURL *url85t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"CaliforniaQuail_SidMosdell_TN"
                                                ofType:@"jpg"]];
        NSData *data85t = [[NSData alloc] initWithContentsOfURL:url85t];
        UIImage *imageSave85t=[[UIImage alloc]initWithData:data85t];
        NSData *imageData85t = UIImagePNGRepresentation(imageSave85t);
        [newManagedObject85 setValue:imageData85t         forKey:@"thumbnail"];
        
        
        //[newManagedObject85 setValue:@"Kiwi" forKey:@"sound"];
        
        [newManagedObject85 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject85 setValue:NO forKey:@"extra"];
        [newManagedObject85 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject85= nil;
      
        //        ///++++  ***********************************
        NSManagedObject *newManagedObject92 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        //NSLog(@"Blue Duck/Whio");
        
        //Set Bird_attributes: Blue Duck
        [newManagedObject92 setValue:@"Blue duck" forKey:@"name"];
        [newManagedObject92 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject92 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject92 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject92 setValue:@"1" forKey:@"category"];
        [newManagedObject92 setValue:@"black,grey" forKey:@"colour"];
        [newManagedObject92 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject92 setValue:@"Anatidae" forKey:@"family"];
        [newManagedObject92 setValue:@"water,bush" forKey:@"habitat"];
        
        
        [newManagedObject92 setValue:@"BlueDuck_Whio_JulienCarnot_Flickr" forKey:@"image"];
        
        NSURL *url92t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"BlueDuck_Whio_JulienCarnot_Flickr_TN"
                                                ofType:@"jpg"]];
        
        NSData *data92t = [[NSData alloc] initWithContentsOfURL:url92t];
        UIImage *imageSave92t=[[UIImage alloc]initWithData:data92t];
        NSData *imageData92t = UIImagePNGRepresentation(imageSave92t);
        
        [newManagedObject92 setValue:imageData92t forKey:@"thumbnail"];
        
        
        [newManagedObject92 setValue:@"The blue duck is one of a handful of torrent duck species worldwide. It is a river specialist which inhabits clean, fast flowing streams in the forested upper catchments of New Zealand rivers. Nesting along the riverbanks, they are at high risk of attack from stoats and rats.\n\n   Their Maori name is whio whio, and they are found nowhere else in the world.\n       They are believed to have appeared at a very early stage in evolutionary history. Their blue duck's isolation in New Zealand has meant that it has a number of unique anatomical and behavioural features. The whio features on our $10 note, and are rarer than some species of kiwi.\n\nUnique features\n\nIt is one of only three species amongst the world’s other 159 waterfowl that live year round on fast-flowing rivers. The others are found in South America and New Guinea. In contrast to other waterfowl, blue ducks obtain all their food (consisting almost exclusively of aquatic insect larvae) and even rear their young, in the fast moving rapids and riffles of their home territories.\n\nPhysical features\n\nBlue ducks have unique features such as streamlined head and large webbed feet to enable them to feed in fast moving water. The upper bill has a thick semicircular, fleshy ‘lip’ that overlaps the lower bill allowing them to scrape off insect larvae that cling to rocks, without wear and tear. The male makes a distinctive high-pitched aspirate sound – “whio”, contrasting with the guttural and rattle-like call of the female.\n  Adult length: 530mm; males 1000g; females 800g\n   Blue ducks moult between December and May.\n\nBehaviour\nThey are mainly active during early morning and late evening periods, hiding during the day in log-jams, caves and other such places – some populations have adopted an almost nocturnal existence. Blue ducks vigorously defend their river territories all the year round. The size of each pair’s territory can vary (average is about 1.5km) depending on the quality of the habitat and food available.\n\nNesting\n     Blue ducks nest between August and October, laying 4-9 creamy white eggs. The female incubates the eggs for 35 days and chicks can fly when about 70 days old. Nesting and egg incubation of four to seven eggs is undertaken by the female while the male stands guard. Nests are shallow, twig, grass and down-lined scrapes in caves, under river-side vegetation or in log-jams, and are therefore very prone to spring floods. For this, and other reasons, their breeding success is extremely variable from one year to the next\n\nHabitat\n    Blue duck require bouldery rivers and streams within forested catchments which provide high water quality, low sediment loadings, stable banks and abundant and diverse invertebrate communities.         With such habitat requirements, blue duck are key indicators of river system health. The higher the number of breeding pairs of blue duck on a given stretch of river, the greater the life supporting capacity of that river." forKey:@"item_description"];
        [newManagedObject92 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject92 setValue:@"http://www.doc.govt.nz/nature/native-animals/birds/birds-a-z/blue-duck-whio/" forKey:@"link"];
        [newManagedObject92 setValue:@"Whio" forKey:@"othername"];
        [newManagedObject92 setValue:@"Blue Duck" forKey:@"short_name"];
        [newManagedObject92 setValue:@"duck" forKey:@"size_and_shape"];
        [newManagedObject92 setValue:@"blue-duck_DOC" forKey:@"sound"];
        [newManagedObject92 setValue:@"nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject92 setValue:false forKey:@"extra"];
        [newManagedObject92 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject92 = nil;
        
        
        //        ///++++  ***********************************
        NSManagedObject *newManagedObject93 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        //NSLog(@"Yellow Eyed Penguin");
        
        //Set Bird_attributes: Yellow-eyed penguin
        [newManagedObject93 setValue:@"Yellow-eyed penguin" forKey:@"name"];
        [newManagedObject93 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject93 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject93 setValue:@"flightless" forKey:@"behaviour"];
        [newManagedObject93 setValue:@"1" forKey:@"category"];
        [newManagedObject93 setValue:@"black,yellow,white,red" forKey:@"colour"];
        [newManagedObject93 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject93 setValue:@"Spheniscidae" forKey:@"family"];
        [newManagedObject93 setValue:@"water" forKey:@"habitat"];
        
        
        [newManagedObject93 setValue:@"Yellow_Eyed_Penguin_HaraldSelke_Flickr" forKey:@"image"];
        
        NSURL *url93t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Yellow_Eyed_Penguin_HaraldSelke_Flickr_TN"
                                                ofType:@"jpg"]];
        
        NSData *data93t = [[NSData alloc] initWithContentsOfURL:url93t];
        UIImage *imageSave93t=[[UIImage alloc]initWithData:data93t];
        NSData *imageData93t = UIImagePNGRepresentation(imageSave93t);
        
        [newManagedObject93 setValue:imageData93t forKey:@"thumbnail"];
        
        
        [newManagedObject93 setValue:@"Unique to New Zealand, the hōiho, or yellow-eyed penguin, is thought to be one of the world's rarest penguin species.\n         Yellow-eyed penguins/hōiho are found along the south-east South Island and on Banks Peninsula, on Stewart Island/Rakiura and its outliers, Codfish Island/Whenua Hou, the Auckland Islands and Campbell Island.\n\nFacts\n   The yellow-eyed penguin/hōiho (Megadyptes antipodes) is named because of its yellow iris and distinctive yellow head band. Adults are slate grey in colour, with a white belly and flesh-coloured feet that become bright pink during exercise. Hōiho chicks are covered in thick, brown fluffy down, which begins to shed once their juvenile plumage develops at around 70 days. Hōiho chicks fledge between 98 to 120 days. Their juvenile plumage is different to adults and can be distinguished by their grey iris, grey head band and dull head plumage. Adults (2 to 25 years) have a yellow iris and yellow band on their crown. Once a juvenile bird undergoes its first moult in the year after fledging, it acquires the yellow band and eye colouring of an adult. The Māori name hōiho means 'noise shouter'. This refers to their shrill call, often heard when they encounter their mate or others at their breeding site.\n\nDiet\nTheir diet is made of small to medium sized fish such as sprat, red cod, blue cod, ahuru, opalfish, silversides and squid. Hōiho are very selective and dive to the sea floor to gather their prey.\n\nLifespan\nThe average lifespan is 8 years, but several birds have reached over 25 years of age.\n\nSize\nAdults reach up to 65 cm in height and weigh around 5 to 5.5 kg. Before moulting adults and juveniles can weigh up to 9 kg. During the moult hōiho must sit ashore for 25 days and grow new feathers, and they are unable to go to sea.\n\nBehaviour\nUnlike other penguin species, hōiho are not typically colonial, and their breeding areas cannot be called 'colonies'. Hōiho seek out private nesting areas with a solid back and a roof for egg laying. Two eggs are laid in a shallow bowl lined with delicately gathered sticks, ferns and fronds.  Hōiho are philopatric, which means they usually come back to the area they were born to breed. Juveniles may wander in their first year, with female hōiho beginning breeding between 2-3 years, and male hōiho starting breeding between 3-6 years of age. Adults stay near their breeding area for life, and do not migrate elsewhere during the non-breeding part of the year. Yellow-eyed penguins are wild, and do not become habituated to human disturbance. As a result they are not suitable for holding in permanent captivity.\n\nHabitat\nThreats include habitat destruction, predation, disease and human interference.         The yellow-eyed penguin is equally dependant on marine and land habitats, which include forest and coastal scrubland. A great deal of community effort has been put into providing nesting sites and shelter on grazed pasturelands on the Otago Peninsula and North Otago. These habitats provide nesting opportunities, as well as social areas and loafing space, and a space to take refuge during the 25-day moult each year. The yellow-eyed penguin's marine habitat is equally important because it provides food, and allows for dispersal and movement between land habitats.\n" forKey:@"item_description"];
        [newManagedObject93 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject93 setValue:@"http://www.doc.govt.nz/nature/native-animals/birds/birds-a-z/penguins/yellow-eyed-penguin-hoiho/" forKey:@"link"];
        [newManagedObject93 setValue:@"Hoiho" forKey:@"othername"];
        [newManagedObject93 setValue:@"Yellow eyed penguin" forKey:@"short_name"];
        [newManagedObject93 setValue:@"duck" forKey:@"size_and_shape"];
        [newManagedObject93 setValue:@"yellow-eyed-penguin_DOC" forKey:@"sound"];
        [newManagedObject93 setValue:@"nationally vulnerable" forKey:@"threat_status"];
        [newManagedObject93 setValue:false forKey:@"extra"];
        [newManagedObject93 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject93 = nil;
        
        
        //        ///++++  ***********************************
        NSManagedObject *newManagedObject94 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        //NSLog(@"Bittern");
        
        //Set Bird_attributes: Australasian Bittern
        [newManagedObject94 setValue:@"Bittern" forKey:@"name"];
        [newManagedObject94 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject94 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject94 setValue:@"can fly" forKey:@"behaviour"];
        [newManagedObject94 setValue:@"1" forKey:@"category"];
        [newManagedObject94 setValue:@"brown" forKey:@"colour"];
        [newManagedObject94 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        [newManagedObject94 setValue:@"Ardeidae" forKey:@"family"];
        [newManagedObject94 setValue:@"water,bush" forKey:@"habitat"];
        
        
        [newManagedObject94 setValue:@"Australasian_Bittern_FrankZed_Flickr" forKey:@"image"];
        
        NSURL *url94t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Australasian_Bittern_FrankZed_Flickr_TN"
                                                ofType:@"jpg"]];
        
        NSData *data94t = [[NSData alloc] initWithContentsOfURL:url94t];
        UIImage *imageSave94t=[[UIImage alloc]initWithData:data94t];
        NSData *imageData94t = UIImagePNGRepresentation(imageSave94t);
        
        [newManagedObject94 setValue:imageData94t forKey:@"thumbnail"];
        
        
        [newManagedObject94 setValue:@"The Australasian bittern (Botaurus poiciloptilus), or matuku as it is known to Māori, is a large, heron-sized bird. They are rarely seen because of their secretive behaviour and excellent camouflage. They are most active at dawn, dusk and through the night.\n\n         They live in wetlands throughout New Zealand, although there are fewer than 1,000. When Europeans arrived they were abundant, but now it is rare to see more than one at a time. Australasian bittern are also found in Australia and New Caledonia, but populations there have declined dramatically and they are now classed globally as endangered.\n\n         In New Zealand, they are mainly found in wetlands of Northland, Waikato, East Coast of the North Island, and the West Coast of the South Island. The most important site nationally for bittern is Whangamarino Wetland in the Waikato.\n\n         Matuku breed deep in wetlands. The distinctive booming calls of male matuku can be heard at the beginning of the breeding season and are often the only sign that they are present in a wetland. The breeding season is long (spread over 10 months) although most eggs are laid in November and December. Birds lays up to 6 eggs.\n       Matuku feed, mostly at night, on fish, eels, frogs, freshwater crayfish and aquatic insects.\n Matuku are important to Māori. They appear in language as part of legends, stories, early pictures and metaphor and there are numerous place names referring to them. They were important for food and their feathers were used for ceremonial decoration.\nThey are a potential indicator of wetland health because they are dependent on the presence of high quality and ecologically diverse habitats and rich food supplies.\n " forKey:@"item_description"];
        [newManagedObject94 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject94 setValue:@"http://www.doc.govt.nz/nature/native-animals/birds/birds-a-z/australasian-bittern-matuku/" forKey:@"link"];
        [newManagedObject94 setValue:@"Matuku" forKey:@"othername"];
        [newManagedObject94 setValue:@"Botaurus poiciloptilus" forKey:@"short_name"];
        [newManagedObject94 setValue:@"swan" forKey:@"size_and_shape"];
        [newManagedObject94 setValue:@"australasian-bittern_DOC" forKey:@"sound"];
        [newManagedObject94 setValue:@"endangered" forKey:@"threat_status"];
        [newManagedObject94 setValue:false forKey:@"extra"];
        [newManagedObject94 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        
        [context save:NULL];
        newManagedObject94 = nil;
        
        
        
//        // +++++++++++ Template  +++++++++++++
//        /*  85
//         */
//        NSManagedObject *newManagedObject85 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
//
//        //Set Bird_attributes
//        [newManagedObject85 setValue:@"California Quail"       forKey:@"name"];
//        [newManagedObject85 setValue:@"California Quail" forKey:@"othername"];
//        [newManagedObject85 setValue:@"California quail are stocky, predominantly grey and brown, with a diagnostic forward-curling black plume rising erect from the top of their heads. Males have a black chin and cheeks edged with white, and separate white ‘eyebrows’ join on the forehead. The breast is blue-grey and the lower belly cream to rust brown with distinctive black scalloping, which merges into strong, pale streaks on the dark brown flanks. \n\nThe female is slightly smaller, duller and browner, with some streaking on the neck and a more subdued scalloping on the belly, but with equally bold streaking on the flanks. Immature birds are similar to the female but a lighter brown. The female’s crest plume is much smaller than the male’s. Both sexes have fine speckling on the nape, which is bolder in the male. \n\nThere is no seasonal change in plumage. California quail have short, rounded wings and a relatively long tail. Their legs and bill are black and sturdy, with the bill being slightly hooked.\n\nForaging quail pace sedately, but when disturbed they run at speed, their feet a blur of movement, or burst into flight with noisy, rapid wingbeats.\
//         " forKey:@"item_description"];
//        [newManagedObject85 setValue:@"http://nzbirdsonline.org.nz/species/california-quail" forKey:@"link"];
//        [newManagedObject85 setValue:@"black" forKey:@"beak_colour"];
//        [newManagedObject85 setValue:@"short" forKey:@"beak_length"];
//        [newManagedObject85 setValue:@"can fly,shy" forKey:@"behaviour"];
//        [newManagedObject85 setValue:@"0" forKey:@"category"];
//        [newManagedObject85 setValue:@"grey/brown" forKey:@"colour"];
//        [newManagedObject85 setValue:@"brown" forKey:@"leg_colour"];
//        [newManagedObject85 setValue:@"Phasianidae" forKey:@"family"];
//        [newManagedObject85 setValue:@"bush" forKey:@"habitat"];
//        [newManagedObject85 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
//        [newManagedObject85 setValue:@"plumed quail" forKey:@"short_name"];
//        [newManagedObject85 setValue:@"blackbird" forKey:@"size_and_shape"];
//
//
//        [newManagedObject85 setValue:@"CaliforniaQuail_SidMosdell"         forKey:@"image"];
//
//        NSURL *url85t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                                pathForResource:@"CaliforniaQuail_SidMosdell_TN"
//                                                ofType:@"jpg"]];
//        NSData *data85t = [[NSData alloc] initWithContentsOfURL:url85t];
//        UIImage *imageSave85t=[[UIImage alloc]initWithData:data85t];
//        NSData *imageData85t = UIImagePNGRepresentation(imageSave85t);
//        [newManagedObject85 setValue:imageData85t         forKey:@"thumbnail"];
//
//
//        //[newManagedObject85 setValue:@"Kiwi" forKey:@"sound"];
//
//        [newManagedObject85 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
//        [newManagedObject85 setValue:NO forKey:@"extra"];
//        [newManagedObject85 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
//
//        [context save:NULL];
//        newManagedObject85= nil;
        

        
////      SUGGESTIONS:
        
//        Fiordland crested penguin ?
//        South Island robin?
//        Stewart island kiwi?
        
        
        //        // +++++++++++ Coot  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  95
        //         */
        //        NSManagedObject *newManagedObject95 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject95 setValue:@"Australian Coot"       forKey:@"name"];
        //        [newManagedObject95 setValue:@"Fulica atra australis" forKey:@"othername"];
        //        [newManagedObject95 setValue:@"The Australian coot is a smart, dark-grey, duck-like waterbird, instantly recognisable from its bright white bill and frontal shield. Coots are related to gallinules – the branch of the rail family that includes pukeko and takahe. Out of the water, a coot’s stance is more like a small pukeko than a duck. But instead of the pukeko’s long thin toes, coots have broad fleshy lobes on their short toes, used to give propulsion when swimming. The Australian coot is a recent arrival in New Zealand, first recorded breeding here in 1958. Their colonisation partially fills the niche left vacant by the extinction of the New Zealand coot, which was widespread before the arrival of Maori.\Identification\
        Adult Australian coots are entirely slate-grey with a white bill and frontal shield. They have red eyes and large grey feet with lobed toes. Sexes are alike. Juvenile and immature birds have duller and paler colouring, with some pale grey on the chin and throat. They have brown eyes and smaller frontal shields. Coots are rarely seen in flight, where they differ from scaup in that their legs trail behind their tails in flight.\
    Voice: a loud discordant krark.\
        Similar species: New Zealand scaup have similar body size, shape, colouration and diving behaviour, but differ in having a blue-grey bill and no frontal shield, plus males have a yellow eye, and females often have white around the bill base (cf. blackish facial feathers in coots).\
        Distribution and habitat:\
        Australian coots are found throughout mainland New Zealand other than Northland, but there are few parts of the country where they are abundant. Coots are entirely aquatic, and there are large parts of the country that do not have their preferred freshwater lakes and ponds with submerged vegetation and reedy, grassy islands or edges.\
            Single coots, possibly the same bird, have occurred as vagrants on Stewart Island (December 2012) and the Snares Islands (April 2013). Coots have reached Macquarie Island Island at least twice, with at least 7 birds in May-October 1957, and one in June-October 1975.\
            \
        Population:\
            \
            The Australian coot is a subspecies of the Eurasian coot that self-introduced into New Zealand from Australia in the 20th century, and was first recorded breeding in New Zealand on Lake Hayes, Otago in 1958. There were about 2,000 coots estimated to be present in New Zealand in 2005.\
            \
            Coots reached New Zealand on many occasions before they established, with at least 9 records from the South Island between 1875 (Lovells Flat, Otago) and 1957 (Heathcote River, Christchurch), before the first eggs and chicks were seen at Lake Hayes in November 1958. The first North Island record was at Lake Tutira, Hawkes Bay in 1954. There was an influx of coots in or before 1957, and they rapidly established as a breeding species.\
            \
        Threats and conservation :\
            \
            As a self-introduced species, Australian coots are automatically covered by the Wildlife Act, and are fully protected. They are well-established in New Zealand, with no recognised threats.   .\" forKey:@"item_description"];
        //        [newManagedObject95 setValue:@"http://www.nzbirdsonline.org.nz/species/australian-coot" forKey:@"link"];
        //        [newManagedObject95 setValue:@"white" forKey:@"beak_colour"];
        //        [newManagedObject95 setValue:@"short,pointed" forKey:@"beak_length"];
        //        [newManagedObject95 setValue:@"can fly" forKey:@"behaviour"];
        //        [newManagedObject95 setValue:@"0" forKey:@"category"];
        //        [newManagedObject95 setValue:@"black" forKey:@"colour"];
        //        [newManagedObject95 setValue:@"grey" forKey:@"leg_colour"];
        //        [newManagedObject95 setValue:@"Rallidae" forKey:@"family"];
        //        [newManagedObject95 setValue:@"water" forKey:@"habitat"];
        //        [newManagedObject95 setValue:@"Native/ Naturally uncommon" forKey:@"threat_status"];
        //        [newManagedObject95 setValue:@"Coot" forKey:@"short_name"];
        //        [newManagedObject95 setValue:@"duck" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject95 setValue:@"AustralianCoot"         forKey:@"image"];
        //
        //        NSURL *url95t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"AustralianCoot_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data95t = [[NSData alloc] initWithContentsOfURL:url95t];
        //        UIImage *imageSave95t=[[UIImage alloc]initWithData:data95t];
        //        NSData *imageData95t = UIImagePNGRepresentation(imageSave95t);
        //        [newManagedObject95 setValue:imageData95t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject95 setValue:@"Coot" forKey:@"sound"];
        //
        //        [newManagedObject95 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject95 setValue:NO forKey:@"extra"];
        //        [newManagedObject95 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject95= nil;
        //

        
        //        // +++++++++++ Brown Teal  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  96
        //         */
        //        NSManagedObject *newManagedObject96 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject96 setValue:@"Brown Teal"       forKey:@"name"];
        //        [newManagedObject96 setValue:@"Brown Teal" forKey:@"othername"];
        //        [newManagedObject96 setValue:@"Brown Teal.\
        //         " forKey:@"item_description"];
        //        [newManagedObject96 setValue:@"http://www.nzbirdsonline.org.nz/species/brown-teal" forKey:@"link"];
        //        [newManagedObject96 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject96 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject96 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject96 setValue:@"0" forKey:@"category"];
        //        [newManagedObject96 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject96 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject96 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject96 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject96 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject96 setValue:@"brown teal" forKey:@"short_name"];
        //        [newManagedObject96 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject96 setValue:@"BrownTeal"         forKey:@"image"];
        //
        //        NSURL *url96t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"BrownTeal_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data96t = [[NSData alloc] initWithContentsOfURL:url96t];
        //        UIImage *imageSave96t=[[UIImage alloc]initWithData:data96t];
        //        NSData *imageData96t = UIImagePNGRepresentation(imageSave96t);
        //        [newManagedObject96 setValue:imageData95t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject96 setValue:@"BrownTeal" forKey:@"sound"];
        //
        //        [newManagedObject96 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject96 setValue:NO forKey:@"extra"];
        //        [newManagedObject96 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject96= nil;
        //

        
        //        // +++++++++++ Scaup  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  97
        //         */
        //        NSManagedObject *newManagedObject97 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject97 setValue:@"Scaup"       forKey:@"name"];
        //        [newManagedObject97 setValue:@"New Zealand Scaup" forKey:@"othername"];
        //        [newManagedObject97 setValue:@"New Zealand Scaup.\
        //         " forKey:@"item_description"];
        //        [newManagedObject97 setValue:@"http://www.nzbirdsonline.org.nz/species/new-zealand-scaup" forKey:@"link"];
        //        [newManagedObject97 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject97 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject97 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject97 setValue:@"0" forKey:@"category"];
        //        [newManagedObject97 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject97 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject97 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject97 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject97 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject97 setValue:@"plumed quail" forKey:@"short_name"];
        //        [newManagedObject97 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject97 setValue:@"Scaup"         forKey:@"image"];
        //
        //        NSURL *url97t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"Scaup_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data97t = [[NSData alloc] initWithContentsOfURL:url97t];
        //        UIImage *imageSave97t=[[UIImage alloc]initWithData:data97t];
        //        NSData *imageData97t = UIImagePNGRepresentation(imageSave97t);
        //        [newManagedObject97 setValue:imageData97t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject97 setValue:@"NewZealandScaup" forKey:@"sound"];
        //
        //        [newManagedObject97 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject97 setValue:NO forKey:@"extra"];
        //        [newManagedObject97 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject97= nil;
        //

        //        // +++++++++++ Canada Goose  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  98
        //         */
        //        NSManagedObject *newManagedObject98 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject98 setValue:@"Canada Goose"       forKey:@"name"];
        //        [newManagedObject98 setValue:@"Canada Goose" forKey:@"othername"];
        //        [newManagedObject98 setValue:@"Canada Goose.\
        //         " forKey:@"item_description"];
        //        [newManagedObject98 setValue:@"http://www.nzbirdsonline.org.nz/species/canada-goose" forKey:@"link"];
        //        [newManagedObject98 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject98 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject98 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject98 setValue:@"0" forKey:@"category"];
        //        [newManagedObject98 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject98 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject98 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject98 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject98 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject98 setValue:@"plumed quail" forKey:@"short_name"];
        //        [newManagedObject98 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject98 setValue:@"CanadaGoose"         forKey:@"image"];
        //
        //        NSURL *url98t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"CanadaGoose_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data98t = [[NSData alloc] initWithContentsOfURL:url98t];
        //        UIImage *imageSave98t=[[UIImage alloc]initWithData:data98t];
        //        NSData *imageData98t = UIImagePNGRepresentation(imageSave98t);
        //        [newManagedObject98 setValue:imageData98t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject98 setValue:@"CanadaGoose" forKey:@"sound"];
        //
        //        [newManagedObject98 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject98 setValue:NO forKey:@"extra"];
        //        [newManagedObject98 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject98= nil;
        //

        //        // +++++++++++ Guinea Fowl  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  99
        //         */
        //        NSManagedObject *newManagedObject99 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject99 setValue:@"Guinea Fowl"       forKey:@"name"];
        //        [newManagedObject99 setValue:@"Guinea Fowl" forKey:@"othername"];
        //        [newManagedObject99 setValue:@"Guinea Fowl.\
        //         " forKey:@"item_description"];
        //        [newManagedObject99 setValue:@"http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl" forKey:@"link"];
        //        [newManagedObject99 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject99 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject99 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject99 setValue:@"0" forKey:@"category"];
        //        [newManagedObject99 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject99 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject99 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject99 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject99 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject99 setValue:@"Canada Goose" forKey:@"short_name"];
        //        [newManagedObject99 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject99 setValue:@"GuineaFowl"         forKey:@"image"];
        //
        //        NSURL *url99t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"CanadaGoose_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data99t = [[NSData alloc] initWithContentsOfURL:url99t];
        //        UIImage *imageSave99t=[[UIImage alloc]initWithData:data99t];
        //        NSData *imageData99t = UIImagePNGRepresentation(imageSave99t);
        //        [newManagedObject99 setValue:imageData99t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject99 setValue:@"GuineaFowl" forKey:@"sound"];
        //
        //        [newManagedObject99 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject99 setValue:NO forKey:@"extra"];
        //        [newManagedObject99 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject99= nil;
        //
        //        // +++++++++++ Brown Creeper  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  100
        //         */
        //        NSManagedObject *newManagedObject100 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject100 setValue:@"Brown Creeper"       forKey:@"name"];
        //        [newManagedObject100 setValue:@"Brown Creeper" forKey:@"othername"];
        //        [newManagedObject100 setValue:@"Brown Creeper.\
        //         " forKey:@"item_description"];
        //        [newManagedObject100 setValue:@"http://www.nzbirdsonline.org.nz/species/brown-creeper" forKey:@"link"];
        //        [newManagedObject100 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject100 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject100 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject100 setValue:@"0" forKey:@"category"];
        //        [newManagedObject100 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject100 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject100 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject100 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject100 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject100 setValue:@"Brown Creeper" forKey:@"short_name"];
        //        [newManagedObject100 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject100 setValue:@"Brown Creeper"         forKey:@"image"];
        //
        //        NSURL *url100t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"Brown Creeper_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data100t = [[NSData alloc] initWithContentsOfURL:url100t];
        //        UIImage *imageSave100t=[[UIImage alloc]initWithData:data100t];
        //        NSData *imageData100t = UIImagePNGRepresentation(imageSave100t);
        //        [newManagedObject100 setValue:imageData100t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject100 setValue:@"BrownCreeper" forKey:@"sound"];
        //
        //        [newManagedObject100 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject100 setValue:NO forKey:@"extra"];
        //        [newManagedObject100 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject100= nil;
        //
        //        // +++++++++++ North-Island Kokako  +++++++++++++
        // new additions:
        // Coot, Australian -http://www.nzbirdsonline.org.nz/species/australian-coot
        // brown teal -http://www.nzbirdsonline.org.nz/species/brown-teal
        // scaup - http://www.nzbirdsonline.org.nz/species/new-zealand-scaup
        // canada goose - http://www.nzbirdsonline.org.nz/species/canada-goose
        // nz crate - ??
        // guinea fowl - http://www.nzbirdsonline.org.nz/species/helmeted-guineafowl
        // brown creeper - http://www.nzbirdsonline.org.nz/species/brown-creeper
        // kokako (North Island) - http://www.nzbirdsonline.org.nz/species/north-island-kokako
        //        /*  101
        //         */
        //        NSManagedObject *newManagedObject101 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject101 setValue:@"Kokako"       forKey:@"name"];
        //        [newManagedObject101 setValue:@"Kokako" forKey:@"othername"];
        //        [newManagedObject101 setValue:@"Kokako.\
        //         " forKey:@"item_description"];
        //        [newManagedObject101 setValue:@"http://www.nzbirdsonline.org.nz/species/north-island-kokako" forKey:@"link"];
        //        [newManagedObject101 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject101 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject101 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject101 setValue:@"0" forKey:@"category"];
        //        [newManagedObject101 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject101 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject101 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject101 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject101 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject101 setValue:@"Kokako (NI)" forKey:@"short_name"];
        //        [newManagedObject101 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject101 setValue:@"Kokako"         forKey:@"image"];
        //
        //        NSURL *url101t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"Kokako_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data101t = [[NSData alloc] initWithContentsOfURL:url101t];
        //        UIImage *imageSave101t=[[UIImage alloc]initWithData:data101t];
        //        NSData *imageData101t = UIImagePNGRepresentation(imageSave101t);
        //        [newManagedObject101 setValue:imageData101t         forKey:@"thumbnail"];
        //
        //
        //        [newManagedObject101 setValue:@"kokako-song_DOC" forKey:@"sound"];
        //
        //        [newManagedObject101 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject101 setValue:NO forKey:@"extra"];
        //        [newManagedObject101 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject101= nil;
        //
        
////      SUGGESTIONS:

//        Fiordland crested penguin 102
//        South Island robin 103
//        Stewart island kiwi 104


        //        /*  102 Fjordland Crested Penguin
        //         */
        //        NSManagedObject *newManagedObject102 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject102 setValue:@"Fjordland Crested Penguin"       forKey:@"name"];
        //        [newManagedObject102 setValue:@"Fjordland Crested Penguin" forKey:@"othername"];
        //        [newManagedObject102 setValue:@"Fiordland crested penguins are endemic to New Zealand, breeding in small colonies on inaccessible headlands and islets along the shores of south-western South Island and Stewart Island. They can be seen and heard on landing beaches during July – December. Populations have declined considerably in range and numbers since human arrival. Immediate threats include fisheries bycatch, introduced predators, and human disturbance. Identification: Adult Fiordland crested penguins have dark blue-grey/black upperparts (which turn brown when approaching moult), often darker on the head. A broad yellow eyebrow stripe (crest) starts at the nostril and extends well past the eye, drooping down the neck; 3-6 whitish stripes on the cheeks are displayed when agitated. The underparts are silky white. The moderately large orange bill has a thin strip of black skin at the base (cf. broader bare pink skin on Snares crested penguin). Females have smaller bills (bill depth < 24 mm) than males (bill depth >24 mm). The eyes are brownish-red, and feet and legs pinkish-white above and blackish-brown behind and on the soles. Juveniles have short, thin pale-yellow eyebrow stripes and mottled whitish chin and throat. The dorsal plumage of newly-fledged chicks is distinctly bluish, fading to black with wear, then to mid-brown before moulting. Voice: calls include loud braying or trumpeting, high pitched contact calls, and low-pitched hissing and growling. Calls are similar to those of Snares crested penguins. Similar species: Fiordland crested penguins are most similar to Snares crested penguin, which (as adults) have dark cheeks, a larger bill with prominent pink skin at the base, and narrower eye-brow stripes. All other crested penguins are also similar, especially when immature, but note broad eye-brow stripes, throat and cheeks greyish white, and absence of bare skin at bill base in immature Fiordland crested penguins. Recently fledged young (which are smaller than adults and bluish dorsally) may be confused with little penguins when swimming, but are twice as large and have at least some yellow above the eye" forKey:@"item_description"];
        //        [newManagedObject102 setValue:@"http://nzbirdsonline.org.nz/species/fiordland-crested-penguin" forKey:@"link"];
        //        [newManagedObject102 setValue:@"" forKey:@"beak_colour"];
        //        [newManagedObject102 setValue:@"" forKey:@"beak_length"];
        //        [newManagedObject102 setValue:@"" forKey:@"behaviour"];
        //        [newManagedObject102 setValue:@"0" forKey:@"category"];
        //        [newManagedObject102 setValue:@"" forKey:@"colour"];
        //        [newManagedObject102 setValue:@"" forKey:@"leg_colour"];
        //        [newManagedObject102 setValue:@"" forKey:@"family"];
        //        [newManagedObject102 setValue:@"" forKey:@"habitat"];
        //        [newManagedObject102 setValue:@"" forKey:@"threat_status"];
        //        [newManagedObject102 setValue:@"Fjordland Crested Penguin" forKey:@"short_name"];
        //        [newManagedObject102 setValue:@"" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject102 setValue:@"FjordlandCrestedPenguin"         forKey:@"image"];
        //
        //        NSURL *url102t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"FjordlandCrestedPenguin_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data102t = [[NSData alloc] initWithContentsOfURL:url102t];
        //        UIImage *imageSave102t=[[UIImage alloc]initWithData:data102t];
        //        NSData *imageData102t = UIImagePNGRepresentation(imageSave102t);
        //        [newManagedObject102 setValue:imageData102t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject102 setValue:@"FjordlandCrestedPenguin" forKey:@"sound"];
        //
        //        [newManagedObject102 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject102 setValue:NO forKey:@"extra"];
        //        [newManagedObject102 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject102= nil;
        
        //        /*  103 South Island Robin
        //         */
        //        NSManagedObject *newManagedObject103 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject103 setValue:@"South Island Robin"       forKey:@"name"];
        //        [newManagedObject103 setValue:@"South Island Robin" forKey:@"othername"];
        //        [newManagedObject103 setValue:@"The South Island robin is a familiar bird to those who venture into the South Island back-country. It occurs in forest and scrub habitats, where it spends much time foraging on the ground, and can be recognised by its erect stance and relatively long legs. It is a territorial species, males in particular inhabiting the same patch of forest throughout their lives. Males are great songsters, particularly bachelors, singing loudly and often for many minutes at a time. Where robins are regularly exposed to people, such as along public walking tracks, they become quite confiding, often approaching to within a metre of a person sitting quietly. Juveniles will sometimes stand on a person’s boot. Identification: The adult male South Island robin is dark grey-black over the head, neck, mantle and upper chest; the flight feathers and tail are brownish-black, and the lower chest and belly white to yellowish white with a sharp demarcation between black and white on chest. Adult females are light to dark grey over the upper body. They further differ from males in the  white chest-belly area being smaller and not having such a distinct demarcation between grey and white feathering. Juveniles are similar to females, but often with a smaller or no white patch on the underparts. Adults of both sexes are able to expose a small white spot of feathers above the base of the beak during intraspecific and interspecific interactions. Voice: South Island robins have four recognisable vocalisations. Fullsong is a series of phrases given loudly by males only, generally from a high perch. Robins can be heard giving fullsong year round, but particularly during the breeding season. It is used to indicate territorial occupancy and to attract a mate – bachelors spend much more time singing than paired males. Subsong is similar to fullsong but given at much less volume, is given by both sexes, and most frequently during the moult. The downscale is a series of very loud ‘chuck’ calls, descending in tone, and which start in rapid succession and finish slowly. The call lasts 3-4 seconds, is given by both sexes, and is most frequently heard during the non-breeding season (January-June). The fourth vocalisation type is the ‘chuck’, which is given as single notes (contact calls) or in rapid succession and loudly (as an alarm call) when a predator is nearby. Similar species:there are no species that are similar to the robin in the South Island or Stewart Island. Robins are much larger and lack the white wing-bars of tomtits. Distribution: The South Island robin has a disjunct distribution through both the South and Stewart Islands. Its strongholds in the South Island are Marlborough, Nelson, West Coast as far south as about Harihari, and through Fiordland, with outliers at Jackson Bay and Dunedin. A comparison of the Ornithological Society of New Zealand’s atlas scheme results of 1969-79 and 1999-2004 suggest that the South Island robin’s distribution has changed little during the 20 year interval. Several populations, particularly on islands, have been established by translocations. Habitat: Robins occur in mature forest, scrub, and exotic plantations, particularly those that are fairly mature with an open understorey. They seem to favour moist areas where there is an open understorey under a closed canopy on fertile soils. Habitats that tend to be shunned are those with widely scattered trees and where the ground is covered by grasses or sparse vegetation on stony, droughty soils. Population: South Island robin is patchily distributed through its range, and is absent from some seemingly suitable areas while common in others. Pairs have territories of 1-5 ha on the mainland, although populations on pest-free islands can occur at much greater densities (0.2-0.6 ha / pair). \" forKey:@"item_description"];
        //        [newManagedObject103 setValue:@"http://nzbirdsonline.org.nz/species/south-island-robin" forKey:@"link"];
        //        [newManagedObject103 setValue:@"black" forKey:@"beak_colour"];
        //        [newManagedObject103 setValue:@"short" forKey:@"beak_length"];
        //        [newManagedObject103 setValue:@"can fly,shy" forKey:@"behaviour"];
        //        [newManagedObject103 setValue:@"0" forKey:@"category"];
        //        [newManagedObject103 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject103 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject103 setValue:@"Phasianidae" forKey:@"family"];
        //        [newManagedObject103 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject103 setValue:@"Introduced and Naturalized" forKey:@"threat_status"];
        //        [newManagedObject103 setValue:@"South Island Robin" forKey:@"short_name"];
        //        [newManagedObject103 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject103 setValue:@"SouthIslandRobin"         forKey:@"image"];
        //
        //        NSURL *url103t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"SouthIslandRobin_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data103t = [[NSData alloc] initWithContentsOfURL:url103t];
        //        UIImage *imageSave103t=[[UIImage alloc]initWithData:data103t];
        //        NSData *imageData103t = UIImagePNGRepresentation(imageSave103t);
        //        [newManagedObject103 setValue:imageData103t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject103 setValue:@"SouthIslandRobin" forKey:@"sound"];
        //
        //        [newManagedObject103 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject103 setValue:NO forKey:@"extra"];
        //        [newManagedObject103 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject103= nil;
        
        //        /*  104 Stewart Island Kiwi
        //         */
        //        NSManagedObject *newManagedObject104 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        //
        //        //Set Bird_attributes
        //        [newManagedObject104 setValue:@"Stewart Island Kiwi"       forKey:@"name"];
        //        [newManagedObject104 setValue:@"Stewart Island Kiwi" forKey:@"othername"];
        //        [newManagedObject104 setValue:@"The Stewart Island tokoeka is the largest of the kiwi. Fiordland tokoeka are also very large, but Haast birds are smaller. Widespread in forest, scrub, tussock grasslands and subalpine zones of the south-western South Island and on Stewart Island. Flightless, with tiny vestigial wings and no tail. Generally nocturnal, therefore more often heard than seen, except on Stewart Island where birds often forage during the day. Male gives a repeated high-pitched ascending whistle, female gives a deeper throaty cry. A range of colours from rufous brown in Haast, to brown and dark brown elsewhere, streaked lengthways with reddish brown and black. Feather tips feel soft. Long pale bill, short legs and toes. Identification: Large brown kiwi. Rufous to dark brown soft feathers streaked with brown and black; long pale bill, short pale legs and toes. Voice:  Male gives a high-pitched ascending whistle repeated 15-25 times, female gives a slower and lower pitched hoarse guttural call repeated 10-20 times. Similar species: rowi are smaller and greyer. The calls of weka are similar to the call of the male tokoeka, but weka have two-syllable calls, and usually have fewer repetitions. Distribution [and habitat: ]Sparse to locally common in native forests, scrub, tussock grassland and subalpine zones in parts of the Haast Range and Arawhata Valley; Fiordland, from Milford Sound to Preservation Inlet and east to Lake Te Anau, including many of the larger islands such as Secretary and Resolution Islands; Stewart Island and Ulva Island. Fiordland tokoeka were introduced to Kapiti Island in 1908, where they have hybridised with North Island brown kiwi. Recently, Haast tokoeka have been introduced to Coal and Rarotoka Islands, and to the Orokonui Ecosanctuary, Dunedin, and small islands in Lakes Te Anau and Manapouri are used as crèche sites for this taxon. Before human settlement of New Zealand tokoeka were widespread throughout the southern and eastern part of the South Island as far north as North Canterbury. Population: About 30,000 birds in 2012; Haast tokoeka, c. 350 birds; Fiordland tokoeka, c. 15,000 birds; Stewart Island tokoeka, c. 15,000 birds.\" forKey:@"item_description"];
        //        [newManagedObject104 setValue:@"http://nzbirdsonline.org.nz/species/southern-brown-kiwi" forKey:@"link"];
        //        [newManagedObject104 setValue:@"brown" forKey:@"beak_colour"];
        //        [newManagedObject104 setValue:@"long" forKey:@"beak_length"];
        //        [newManagedObject104 setValue:@"flightless" forKey:@"behaviour"];
        //        [newManagedObject104 setValue:@"0" forKey:@"category"];
        //        [newManagedObject104 setValue:@"grey/brown" forKey:@"colour"];
        //        [newManagedObject104 setValue:@"brown" forKey:@"leg_colour"];
        //        [newManagedObject104 setValue:@"Apterygidae" forKey:@"family"];
        //        [newManagedObject104 setValue:@"bush" forKey:@"habitat"];
        //        [newManagedObject104 setValue:@"Nationally Endangered" forKey:@"threat_status"];
        //        [newManagedObject104 setValue:@"Southern Brown Kiwi" forKey:@"short_name"];
        //        [newManagedObject104 setValue:@"blackbird" forKey:@"size_and_shape"];
        //
        //
        //        [newManagedObject104 setValue:@"StewartIslandKiwi"         forKey:@"image"];
        //
        //        NSURL *url104t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
        //                                                pathForResource:@"StewartIslandKiwi_TN"
        //                                                ofType:@"jpg"]];
        //        NSData *data104t = [[NSData alloc] initWithContentsOfURL:url104t];
        //        UIImage *imageSave104t=[[UIImage alloc]initWithData:data104t];
        //        NSData *imageData104t = UIImagePNGRepresentation(imageSave104t);
        //        [newManagedObject104 setValue:imageData104t         forKey:@"thumbnail"];
        //
        //
        //        //[newManagedObject104 setValue:@"StewartIslandKiwi" forKey:@"sound"];
        //
        //        [newManagedObject104 setValue:dateRepresentingThisDay forKey:@"date_last_changed"];
        //        [newManagedObject104 setValue:NO forKey:@"extra"];
        //        [newManagedObject104 setValue:[NSNumber numberWithBool:1] forKey:@"favourite"];
        //
        //        [context save:NULL];
        //        newManagedObject104= nil;
        
        
        //**************
        
        
        //*******************************************************
        //This one is required for MAsterViewController.m where CurrentSpot value is updated
        NSManagedObject *newManagedObject42 = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentSpot" inManagedObjectContext:context];
        [newManagedObject42 setValue:@"unknown" forKey:@"name"];
        [context save:NULL];
        newManagedObject42 = nil;
        
        
        //*******************************************************
        
        context = nil;
        // LOGGING
        /*
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Bird_attributes" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchedObjects) {
            NSLog(@"Name: %@", [info valueForKey:@"name"]);
            //NSManagedObject *item_description = [info valueForKey:@"item_description"];
            NSLog(@"Link: %@", [info valueForKey:@"Link"]);
            //NSLog(@"Picture: %@", [info valueForKey:@"image"]);
            NSLog(@"favourite: %@", [info valueForKey:@"favourite"]);
        }
        */
        
	}
    return _persistentStoreCoordinator;
}
- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    // Set the time components manually
//    [dateComps setHour:0];
//    [dateComps setMinute:0];
//    [dateComps setSecond:0];
//    
    // Convert back
   // NSDateComponents *dateComps =[calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:spot.dateLastChanged];
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

#pragma mark - Application's directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)newScratchManagedObjectContext {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

@end
