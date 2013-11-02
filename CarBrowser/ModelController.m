//
//  ModelController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 21/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "ModelController.h"

@interface ModelController ()
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
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
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
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
    
   
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSURL *documentsDirectory = [paths objectAtIndex:0];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite"];
    //NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"NZBirder.sqlite"];
    
//    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"NZBirder.sqlite"];

//    //ALTERNATIVELY: Uncomment this to delete a stale SQLLite DB after schema changes
//    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NZBirder.sqlite"];
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//    NSLog(@"Deleting DB");
//    BOOL firstRun = YES;
    
    //OR THIS
    BOOL firstRun = NO;
    
    //Easily check whether this is first run of app
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NZBirder" ofType:@"sqlite"]];
        NSError* err = nil;
        //firstRun = YES;
        NSLog(@"Copying DB");
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            firstRun = YES;
            NSLog(@"Oops, couldn't copy preloaded data");
        }
        
    }
    
    
    //AND THEN PRETEND IT's OUR FIRST RUN so as to create the SQLLite DB
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]){ // isDirectory:NULL]) {
		firstRun = YES;
        NSLog(@"this is my first run");
	}
    
   
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
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
    }
    
    /*
	 If this is the first run, populate a new store with events whose timestamps are spaced every 7 days throughout 2013.
	 */
	if (firstRun) {
		NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
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
        
        //Insert some Spot as an example
        NSManagedObject *newManagedSpotObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
        
        //NSNumber *lat = -40.36;
        
        
        //Set Bird_attributes: Morepork
        [newManagedSpotObject1 setValue:@"TestSpotPalm" forKey:@"name"];
        //[newManagedSpotObject1 setValue:@"-40" forKey:@"latitude"];
        //[newManagedSpotObject1 setValue:@"175" forKey:@"longitude"];
        
        [context save:&error];
		
        
        //someBird
        NSManagedObject *newManagedObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        
        NSLog(@"Morepork");
        
        
        //Set Bird_attributes: Morepork
        [newManagedObject1 setValue:@"Morepork" forKey:@"name"];
        [newManagedObject1 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject1 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject1 setValue:@"nocturnal, fly silently" forKey:@"behaviour"];
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
        
        
        
        [newManagedObject1 setValue:@"The morepork is NZ’s only surviving native owl. Often heard in the forest at dusk and throughout the night, the morepork is known for its haunting, melancholic call. It was introduced to New Zealand between 1906 and 1910 to try to control smaller introduced birds.\nMorepork are commonly found in forests throughout mainland New Zealand and on offshore islands. They are less common within the drier open regions of Canterbury and Otago. They are classified as not threatened.\n\nPhysical description\nMorepork are speckled brown with yellow eyes set in a dark facial mask. They have a short tail.\nThe females are bigger than the males.\nHead to tail they measure around 29cm and the average weight is about 175g.\nThey have acute hearing and are sensitive to light.\nThey can turn their head through 280 degrees.\n\nNocturnal birds of prey\nMorepork are nocturnal, hunting at night for large invertebrates including beetles, weta, moths and spiders. They will also take small birds, rats and mice. They fly silently as they have soft fringes on the edge of the wing feathers. They catch prey using large sharp talons or beak. By day they roost in the cavities of trees or in thick vegetation. If they are visible during the day they can get mobbed by other birds and are forced to move.\n\nNesting and breeding\nMorepork nest in tree cavities, in clumps of epiphytes or among rocks and roots.\nThe female can lay up to three eggs, but generally two, usually between September and November.\nThe female alone incubates the eggs for about 20 to 32 days during which time the male brings in food for her.\nOnce the chicks hatch, the female stays mainly on the nest until the owlets are fully feathered.\nThey fledge around 37-42 days.\nDepending on food supply often only one chick survives and the other may be eaten.\n\nMaori tradition\nIn Maori tradition the morepork was seen as a watchful guardian. It belonged to the spirit world as it is a bird of the night. Although the more-pork or ruru call was thought to be a good sign, the high pitched, piercing, ‘yelp’ call was thought to be an ominous forewarning of bad news or events." forKey:@"item_description"];
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
        [newManagedObject2 setValue:@"restless" forKey:@"behaviour"];
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
        [newManagedObject2 setValue:@"Grey_Fantail" forKey:@"image"];
        
        NSURL *url2t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Grey_Fantail_TN"
                                              ofType:@"jpg"]];
        
        NSData *data2t = [[NSData alloc] initWithContentsOfURL:url2t];
        UIImage *imageSave2t=[[UIImage alloc]initWithData:data2t];
        NSData *imageData2t = UIImagePNGRepresentation(imageSave2t);
        
        [newManagedObject2 setValue:imageData2t forKey:@"thumbnail"];
        
        
        [newManagedObject2 setValue:@"Known for its friendly ‘cheet cheet’ call and energetic flying antics, the aptly named fantail is one of the most common and widely distributed native birds on the New Zealand mainland.\n\nIt is easily recognized by its long tail which opens to a fan. It has a small head and bill and has two colour forms, pied and melanistic or black. The pied birds are grey-brown with white and black bands.\n\nThe fantail is widespread throughout New Zealand and its offshore islands, including the Chatham Islands and Snares Islands. It is common in most regions of the country, except in the dry, open country of inland Marlborough and Central Otago, where frosts and snow falls are too harsh for it. It also breeds widely in Australia and some Pacific Islands.\nThe fantail is one of the few native bird species in New Zealand that has been able to adapt to an environment greatly altered by humans. Originally a bird of open native forests and scrub, it is now also found in exotic plantation forests, in orchards and in gardens. Fantails stay in pairs all year but high mortality means that they seldom survive more than one season.\nThe success of the species is largely due to the fantail’s prolific and early breeding. Juvenile males can start breeding between 2–9 months old, and females can lay as many as 5 clutches in one season, with between 2–5 eggs per clutch.\nFantail populations fluctuate greatly from year to year, especially when winters are prolonged or severe storms hit in spring. However, since they are prolific breeders, they are able to spring back quickly after such events.\nBoth adults incubate eggs for about 14 days and the chicks fledge at about 13 days. Both adults will feed the young, but as soon as the female starts building the next nest the male takes over the role of feeding the previous brood. Young are fed about every 10 minutes – about 100 times per day!\nIn Māori mythology the fantail was responsible for the presence of death in the world. Maui, thinking he could eradicate death by successfully passing through the goddess of death, Hine-nui-te-po, tried to enter the goddess’s sleeping body through the pathway of birth. The fantail, warned by Maui to be quiet, began laughing and woke Hine-nuite- po, who was so angry that she promptly killed Maui.\n\nDid you know?\nFantails use three methods to catch insects. The first, called hawking, is used where vegetation is open and the birds can see for long distances. Fantails use a perch to spot swarms of insects and then fly at the prey, snapping several insects at a time.\nThe second method that fantails use in denser vegetation is called flushing. The fantail flies around to disturb insects, flushing them out before eating them.\nFeeding associations are the third way fantails find food. Every tramper is familiar with this method, where the fantail follows another bird or animal to capture insects disturbed by their movements. Fantails frequently follow feeding silvereyes, whiteheads, parakeets and saddlebacks, as well as people.\n " forKey:@"item_description"];
        [newManagedObject2 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject2 setValue:@"http://en.wikipedia.org/wiki/Fantail" forKey:@"link"];
        [newManagedObject2 setValue:@"Piwakawaka" forKey:@"othername"];
        [newManagedObject2 setValue:@"New Zealand Fantail" forKey:@"short_name"];
        [newManagedObject2 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject2 setValue:@"fantail" forKey:@"sound"];
        [newManagedObject2 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject3 setValue:@"great imitator of other birds" forKey:@"behaviour"];
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
        
        [newManagedObject3 setValue:@"Tūī are common throughout New Zealand in forests, towns and on off-shore islands. They are adaptable and are found not only in native forests, bush reserves and bush remnants but also in suburban areas, particularly in winter if there is a flowering gum about.\nCan often be heard singing their beautiful melodies long before they are spotted. If you are fortunate to glimpse one you will recognise them by their distinctive white tuft under their throat, which contrasts dramatically with the metallic blue-green sheen to their underlying black colour.\n\nTūī are unique (endemic) to New Zealand and belong to the honeyeater family, which means they feed mainly on nectar from flowers of native plants such as kōwhai, puriri, rewarewa, kahikatea, pohutukawa, rātā and flax. Occasionally they will eat insects too. Tūī are important pollinators of many native trees and will fly large distances, especially during winter for their favourite foods.\nTūī will live where there is a balance of ground cover, shrubs and trees. Tūī are quite aggressive, and will chase other tūī and other species (such as bellbird, silvereye and kereru) away from good food sources.\n\nAn ambassador for successful rejuvenation\nA good sign of a successful restoration programme, in areas of New Zealand, is the sound of the tūī warbling in surrounding shrubs. These clever birds are often confusing to the human ear as they mimic sounds such as the calls of the bellbird. They combine bell-like notes with harsh clicks, barks, cackles and wheezes.\n\nBreeding facts\nCourting takes place between September and October when they sing high up in the trees in the early morning and late afternoon. Display dives, where the bird will fly up in a sweeping arch and then dive at speed almost vertically, are also associated with breeding. Only females build nests, which are constructed from twigs, fine grasses and moss.\n\nWhere can tūī be found\nThe tūī can be found throughout the three main islands of New Zealand. The Chatham Islands have their own subspecies of tūī that differs from the mainland variety mostly in being larger." forKey:@"item_description"];
        [newManagedObject3 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject3 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/tui/" forKey:@"link"];
        [newManagedObject3 setValue:@"Prosthemadera novaeseelandiae" forKey:@"othername"];
        [newManagedObject3 setValue:@"Tui" forKey:@"short_name"];
        [newManagedObject3 setValue:@"blackbird" forKey:@"size_and_shape"];
        [newManagedObject3 setValue:@"tui2" forKey:@"sound"];
        [newManagedObject3 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject4 setValue:@"only bird to mate face to face" forKey:@"behaviour"];
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
        
        
        [newManagedObject4 setValue:@"The stitchbird/hihi (Notiomystis cincta) is one of New Zealand’s rarest birds.  A medium-sized forest species, hihi compete with tui and bellbirds for nectar, insects and small fruits.\nBut apart from diet, hihi share few qualities with tui and bellbird, which are members of the honeyeater family.  Recent DNA analysis has shown that hihi are in fact the sole representative of another bird family found only in New Zealand whose closest relatives may be the iconic wattlebirds that include kokako, saddleback and the extinct huia.\nHow to recognise hihi\n\nMale and female hihi look quite different.  He flaunts a flashy plumage of black head with white ‘ear’ tufts, bright yellow shoulder bars and breast bands and a white wing bar and has a mottled tan-grey-brown body.\nShe is more subdued with an olive-grey-brown body cover, white wing bars and small white ‘ear’ tufts.  They both have small cat-like whiskers around the beak and large bright eyes.\nHihi can be recognised by their posture of an upward tilted tail and strident call from which the name ‘stitchbird’ derives.  A 19th century ornithologist Sir Walter Buller described the call made by the male hihi as resembling the word ‘stitch’.  This call sounds a little like two stones being repeatedly stuck together.  Both males and females also have a range of warble-like calls and whistles.\n\nUnique characteristics\nUnlike most other birds, hihi build their nests in tree cavities.  The nest is complex with a stick base topped with a nest cup of finer twigs and lined with fern scales, lichen and spider web.\nHihi have a diverse and unusual mating system.  A female may breed with a single male or with several.  These arrangements can make determining the parentage of chicks a challenge.  Hihi are also the only birds known to sometimes mate face to face.\n\nHihi research\n    An active research programme with Massey and Auckland universities, as well as other institutes, has greatly increased our knowledge of hihi biology.\nHihi have been found to have a fascinating and complex mating system.  Males pair up with a female in their territory while also seeking to mate with other females in the neighbourhood.  To ensure the chicks are his, males need to produce large amounts of sperm to dilute that of other males.  And to avoid wasting this, the male has to assess exactly when a female is ready to breed.  In the days leading up to laying, when a female is weighed down with developing eggs, a number of males may chase her for hours at a time, all attempting to mate with her.\nResearch has also resulted in developing techniques for managing nesting behaviour, for example, managing nest mites, cross fostering and sexing of chicks and habitat suitability.\nManagement of the captive population at the Pukaha Mount Bruce National Wildlife Centre in eastern Wairarapa has also contributed to understanding the role of avian diseases in managing hihi populations.  Diseases such as Aspergillosis, a fungal infection of the respiratory tract, and Coccidiosis, an intestinal parasite, have been found to affect wild hihi survivial.\nCurrent research programmes include developing a technique to measure the size of the Little Barrier hihi population and assess its health and viability.  Another study, on Tiritiri Matangi, is looking at the effect of carotenoid availability on hihi health (carotenoids are used for the yellow colour in male hihi feathers and egg yolk, and are important for health).\n      \n\nWhere to find:  —Little Barrier, Tiritiri Matangi, Kapiti Islands, Kaori Wildlife Sanctuary (Zealandia)." forKey:@"item_description"];
        [newManagedObject4 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject4 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/stitchbird/" forKey:@"link"];
        [newManagedObject4 setValue:@"Tauhou/Hihi" forKey:@"othername"];
        [newManagedObject4 setValue:@"Stitchbird" forKey:@"short_name"];
        [newManagedObject4 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject4 setValue:@"Hihi_Stitchbird" forKey:@"sound"];
        [newManagedObject4 setValue:@"vulnerable" forKey:@"threat_status"];
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
        
        
        [newManagedObject5 setValue:@"Richard Owen, who became director of London’s Museum of Natural History, was the first to recognise that a bone fragment he was shown in 1839 came from a large bird. When later sent collections of bird bones, he managed to reconstruct moa skeletons. In this photograph, published in 1879, he stands next to the largest of all moa, Dinornis maximus (now D. novaezealandiae), while holding the first bone fragment he had examined 40 years earlier. Richard Owen, Memoirs on the extinct wingless birds of New Zealand. Vol. 2. London: John van Voorst, 1879, plate XCVII" forKey:@"item_description"];
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
        [newManagedObject6 setValue:@"loud,gregarious,flocks" forKey:@"behaviour"];
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
        
        
        [newManagedObject6 setValue:@"found abundantly in and near the coastal areas of NZ" forKey:@"item_description"];
        [newManagedObject6 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject6 setValue:@"http://www.teara.govt.nz/en/gulls-terns-and-skuas/page-2" forKey:@"link"];
        [newManagedObject6 setValue:@"Tarapunga/ Larus novaehollandiae" forKey:@"othername"];
        [newManagedObject6 setValue:@"Red-billed Gull" forKey:@"short_name"];
        [newManagedObject6 setValue:@"pigeon" forKey:@"size_and_shape"];
        [newManagedObject6 setValue:@"redbilledgull" forKey:@"sound"];
        [newManagedObject6 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject7 setValue:@"good glider" forKey:@"behaviour"];
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
        
        
        
        [newManagedObject7 setValue:@"found abundantly in and near the coastal areas of NZ" forKey:@"item_description"];
        [newManagedObject7 setValue:@"orange" forKey:@"leg_colour"];
        [newManagedObject7 setValue:@"http://www.teara.govt.nz/en/gulls-terns-and-skuas/page-1" forKey:@"link"];
        [newManagedObject7 setValue:@"Karoro/ Larus dominicanus" forKey:@"othername"];
        [newManagedObject7 setValue:@"Kelp Gull" forKey:@"short_name"];
        [newManagedObject7 setValue:@"goose" forKey:@"size_and_shape"];
        [newManagedObject7 setValue:@"blackbackedgull" forKey:@"sound"];
        [newManagedObject7 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject8 setValue:@"very vocal" forKey:@"behaviour"];
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
        
        [newManagedObject8 setValue:@"Previously shot for food, now found around many of the coastal areas of NZ" forKey:@"item_description"];
        [newManagedObject8 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject8 setValue:@"http://www.teara.govt.nz/en/wading-birds/page-2" forKey:@"link"];
        [newManagedObject8 setValue:@"black oystercatcher, tōrea pango" forKey:@"othername"];
        [newManagedObject8 setValue:@"Variable Oystercatcher" forKey:@"short_name"];
        [newManagedObject8 setValue:@"pigeon" forKey:@"size_and_shape"];
        [newManagedObject8 setValue:@"oystercatcher" forKey:@"sound"];
        [newManagedObject8 setValue:@"rapidly recovering" forKey:@"threat_status"];
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
        [newManagedObject9 setValue:@"gregarious, curious" forKey:@"behaviour"];
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
        
        
        [newManagedObject9 setValue:@"Introduced, now found abundantly in almost all areas of NZ. This is the most widely distributed wild bird." forKey:@"item_description"];
        [newManagedObject9 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject9 setValue:@"http://en.wikipedia.org/wiki/Sparrow" forKey:@"link"];
        [newManagedObject9 setValue:@"House sparrow" forKey:@"othername"];
        [newManagedObject9 setValue:@"House Sparrow" forKey:@"short_name"];
        [newManagedObject9 setValue:@"sparrow" forKey:@"size_and_shape"];
        [newManagedObject9 setValue:@"Sparrow_XC112666-Pasdom_Sohar_27dec2009" forKey:@"sound"];
        [newManagedObject9 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject10 setValue:@"Adults are mostly white, with black flight feathers at the wingtips and lining the trailing edge of the wing. The central tail feathers are also black. The head is yellow, with a pale blue-grey bill edged in black, and blue-rimmed eyes. Their breeding habitat is on islands and the coast of New Zealand, Victoria and Tasmania, with 87% of the adult population in New Zealand. These birds are plunge divers and spectacular fishers, plunging into the ocean at high speed. They mainly eat squid and forage fish which school near the surface. It has the same colours and similar appearance to the Northern Gannet. They normally nest in large colonies on coastal islands. In New Zealand there are colonies of over 10,000 breeding pairs each at Three Kings Islands, Whakaari / White Island and Gannet Island. There is a large protected colony on the mainland at Cape Kidnappers (6,500 pairs). There are also mainland colonies at Muriwai and Farewell Spit, as well as numerous other island colonies. Gannet pairs may remain together over several seasons. They perform elaborate greeting rituals at the nest, stretching their bills and necks skywards and gently tapping bills together. The adults mainly stay close to colonies, whilst the younger birds disperse." forKey:@"item_description"];
        [newManagedObject10 setValue:@"http://www.teara.govt.nz/en/gannets-and-boobies/page-2" forKey:@"link"];
        [newManagedObject10 setValue:@"grey" forKey:@"beak_colour"];
        [newManagedObject10 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject10 setValue:@"Up to 1.8m wingspan. Hunt by diving with up to 100km/h so they can catch fish deeper than most other fishing airborne bird species. An air sac under the skin in their face cushions the impact on the water. " forKey:@"behaviour"];
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
        [newManagedObject11 setValue:@"largely insectivore/fruit in winter" forKey:@"behaviour"];
        [newManagedObject11 setValue:@"1" forKey:@"category"];
        [newManagedObject11 setValue:@"black" forKey:@"colour"];
        [newManagedObject11 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject11 setValue:@"Petroicidae" forKey:@"family"];
        [newManagedObject11 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject11 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject11 setValue:@"Tomtit" forKey:@"short_name"];
        [newManagedObject11 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url11 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"SI_Tomtit_male2"
//                                               ofType:@"jpg"]];
//        NSData *data11 = [[NSData alloc] initWithContentsOfURL:url11];
//        UIImage *imageSave11=[[UIImage alloc]initWithData:data11];
//        NSData *imageData11 = UIImagePNGRepresentation(imageSave11);
//        [newManagedObject11 setValue:imageData11         forKey:@"image"];
        [newManagedObject11 setValue:@"SI_Tomtit_male2"         forKey:@"image"];
        
        NSURL *url11t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"SI_Tomtit_male2_TN"
                                               ofType:@"jpg"]];
        NSData *data11t = [[NSData alloc] initWithContentsOfURL:url11t];
        UIImage *imageSave11t=[[UIImage alloc]initWithData:data11t];
        NSData *imageData11t = UIImagePNGRepresentation(imageSave11t);
        [newManagedObject11 setValue:imageData11t         forKey:@"thumbnail"];
        
        
        //[newManagedObject11 setValue:@"tomtit" forKey:@"sound"];
        
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
        [newManagedObject12 setValue:@"commonly seen" forKey:@"item_description"];
        [newManagedObject12 setValue:@"http://en.wikipedia.org/wiki/Starling" forKey:@"link"];
        [newManagedObject12 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject12 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject12 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject12 setValue:@"1" forKey:@"category"];
        [newManagedObject12 setValue:@"black" forKey:@"colour"];
        [newManagedObject12 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject12 setValue:@"Sturnidae" forKey:@"family"];
        [newManagedObject12 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject12 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject13 setValue:@"Commonly kept and bred in captivity around the world because of their distinctive appearance and pleasant song" forKey:@"item_description"];
        [newManagedObject13 setValue:@"http://www.nzbirds.com/birds/goldfinch.html" forKey:@"link"];
        [newManagedObject13 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject13 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject13 setValue:@"group together in winter" forKey:@"behaviour"];
        [newManagedObject13 setValue:@"1" forKey:@"category"];
        [newManagedObject13 setValue:@"brown/red/yellow" forKey:@"colour"];
        [newManagedObject13 setValue:@"red/brown" forKey:@"leg_colour"];
        [newManagedObject13 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject13 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject13 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject14 setValue:@"commonly seen, spends much time on the ground" forKey:@"item_description"];
        [newManagedObject14 setValue:@"http://en.wikipedia.org/wiki/Australian_Magpie" forKey:@"link"];
        [newManagedObject14 setValue:@"white/black" forKey:@"beak_colour"];
        [newManagedObject14 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject14 setValue:@"walks rather than waddles or hops" forKey:@"behaviour"];
        [newManagedObject14 setValue:@"1" forKey:@"category"];
        [newManagedObject14 setValue:@"black" forKey:@"colour"];
        [newManagedObject14 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject14 setValue:@"Cracticidae" forKey:@"family"];
        [newManagedObject14 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject14 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject15 setValue:@"forms small flocks in winter" forKey:@"behaviour"];
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
        [newManagedObject16 setValue:@"Frequently seen" forKey:@"item_description"];
        [newManagedObject16 setValue:@"http://en.wikipedia.org/wiki/Common_Chaffinch" forKey:@"link"];
        [newManagedObject16 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject16 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject16 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject16 setValue:@"1" forKey:@"category"];
        [newManagedObject16 setValue:@"yellow/brown" forKey:@"colour"];
        [newManagedObject16 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject16 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject16 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject16 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject17 setValue:@"A large waterbird, a species of swan, which breeds mainly in the southeast and southwest regions of Australia. The species was hunted to extinction in New Zealand, but later reintroduced. Within Australia they are nomadic, with erratic migration patterns dependent upon climatic conditions. Black Swans are large birds with mostly black plumage and red bills. They are monogamous breeders that share incubation duties and cygnet rearing between the sexes. Black Swans can be found singly, or in loose companies numbering into the hundreds or even thousands. Black Swans are popular birds in zoological gardens and bird collections, and escapees are sometimes seen outside their natural range." forKey:@"item_description"];
        [newManagedObject17 setValue:@"http://en.wikipedia.org/wiki/Black_Swan" forKey:@"link"];
        [newManagedObject17 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject17 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject17 setValue:@"" forKey:@"behaviour"];
        [newManagedObject17 setValue:@"1" forKey:@"category"];
        [newManagedObject17 setValue:@"black" forKey:@"colour"];
        [newManagedObject17 setValue:@"grey,black" forKey:@"leg_colour"];
        [newManagedObject17 setValue:@"Notiomystis" forKey:@"family"];
        [newManagedObject17 setValue:@"water,bush" forKey:@"habitat"];
        [newManagedObject17 setValue:@"threatened" forKey:@"threat_status"];
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
        [newManagedObject18 setValue:@"A small olive green forest bird with white rings around its eyes.\nThese friendly birds were self introduced in the 1800s and now have a wide distribution throughout NZ.\nThe silvereye has a wide distribution throughout New Zealand. They can be found from sea level to above the tree line but they are not abundant in deep forest or open grassland.\nSlightly smaller than a sparrow, the silvereye is olive-green with a ring of white feathers around the eye. Males have slightly brighter plumage than females. They have a fine tapered bill and a brush tipped tongue like the tui and bellbird.\nSilvereye's mainly eat insects, fruit and nectar.\nThe silvereye was first recorded in New Zealand in 1832 and since there is no evidence that it was artificially introduced, it is classified as a native species. Its Māori name, tauhou, means stranger or more literally, new arrival." forKey:@"item_description"];
        [newManagedObject18 setValue:@"http://en.wikipedia.org/wiki/Fantail" forKey:@"link"];
        [newManagedObject18 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject18 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject18 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject18 setValue:@"1" forKey:@"category"];
        [newManagedObject18 setValue:@"yellow/brown/green" forKey:@"colour"];
        [newManagedObject18 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject18 setValue:@"Zosteropidae" forKey:@"family"];
        [newManagedObject18 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject18 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject19 setValue:@"Most New Zealanders can easily recognise the bellbird by its melodious song, which Captain Cook described as sounding ‘like small bells exquisitely tuned’.\n      Well camouflaged, the bellbird is usually heard before it is seen.\n Females are dull olive-brown, with a slight blue sheen on the head and a pale yellow cheek stripe. Males are olive green, with a purplish head and black outer wing and tail feathers.\n\nBellbirds are unique to New Zealand, occurring on the three main islands, many offshore islands and also the Auckland Islands.\n\nWhen Europeans arrived in New Zealand, bellbirds were common throughout the North and South Islands. \nTheir numbers declined sharply during the 1860s in the North Island and 1880s in the South Island, about the time that ship rats and stoats arrived. For a time it was thought they might vanish from the mainland. Their numbers recovered somewhat from about 1940 onwards, but they are almost completely absent on the mainland north of Hamilton, and are still rare in parts of Wellington, Wairarapa and much of inland Canterbury and Otago.\n      Bellbirds live in native forest (including mixed podocarp-hardwood and beech forest) and regenerating forest, especially where there is diverse or dense vegetation. They can be found close to the coast or in vegetation up to about 1200 metres. In the South Island they have been found inhabiting plantations of eucalypts, pines or willows. They can be spotted in urban areas, especially if there is bush nearby.\nTypically they require forest and scrub habitats, reasonable cover and good local food sources during the breeding season, since they do not travel far from the nest. However, outside the breeding season they may travel many kilometres to feed, especially males. A pair can raise two broods in a season.\nBellbird song comprises three distinct sounds resembling the chiming of bells. They sing throughout the day, but more so in the early morning and late evening. The alarm call is a series of loud, rapidly repeated, harsh staccato notes.\n" forKey:@"item_description"];
        [newManagedObject19 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/bellbird-korimako/facts/" forKey:@"link"];
        [newManagedObject19 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject19 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject19 setValue:@"odd and quirky" forKey:@"behaviour"];
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
        [newManagedObject20 setValue:@"Kiwi, N.I. Brown "       forKey:@"name"];
        [newManagedObject20 setValue:@"Roroa (Apteryx)" forKey:@"othername"];
        [newManagedObject20 setValue:@"The kiwi is the national icon of New Zealand and the unofficial national emblem.\nThe closest relatives to kiwi today are emus and cassowaries in Australia, but also the now-extinct moa of New Zealand. There are five species of kiwi:\n      Brown kiwi (Apteryx mantelli)\n      Rowi (Apteryx rowi)\n      Tokoeka (Apteryx australis)\n      Great spotted kiwi or roroa (Apteryx haastii)\n      Little spotted kiwi (Apteryx owenii)\nNew Zealanders have been called ""Kiwis"" since the nickname was bestowed by Australian soldiers in the First World War.\nThe kiwi is a curious bird: it cannot fly, has loose, hair-like feathers, strong legs and no tail. Mostly nocturnal, they are most commonly forest dwellers, making daytime dens and nests in burrows, hollow logs or under dense vegetation. Kiwi are the only bird to have nostrils at the end of its very long bill which is used to probe in the ground, sniffing out invertebrates to eat, along with some fallen fruit. It also has one of the largest egg-to-body weight ratios of any bird - the egg averages 15 per cent of the female's body weight (compared to two per cent for the ostrich).\nAdult kiwi usually mate for life, and are strongly territorial. Females are larger than males (up to 3.3 kg and 45 cm). The brown kiwi, great spotted kiwi, and the Fiordland and Stewart Island forms of tokoeka are “nationally vulnerable”, the third highest threat ranking in the New Zealand Threat Classification System; and the little spotted kiwi is classified as “at risk (recovering)”.\n\nread the long story here\nhttp://www.teara.govt.nz/en/kiwi/page-1" forKey:@"item_description"];
        [newManagedObject20 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/kiwi/" forKey:@"link"];
        [newManagedObject20 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject20 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject20 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject20 setValue:@"1" forKey:@"category"];
        [newManagedObject20 setValue:@"brown" forKey:@"colour"];
        [newManagedObject20 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject20 setValue:@"Ratites" forKey:@"family"];
        [newManagedObject20 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject20 setValue:@"threatened" forKey:@"threat_status"];
        [newManagedObject20 setValue:@"North Island Brown Kiwi" forKey:@"short_name"];
        [newManagedObject20 setValue:@"duck" forKey:@"size_and_shape"];
        
//        NSURL *url20 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"LittleSpottedKiwi_Apteryx_owenii"
//                                               ofType:@"jpg"]];
//        NSData *data20 = [[NSData alloc] initWithContentsOfURL:url20];
//        UIImage *imageSave20=[[UIImage alloc]initWithData:data20];
//        NSData *imageData20 = UIImagePNGRepresentation(imageSave20);
//        [newManagedObject20 setValue:imageData20         forKey:@"image"];
        [newManagedObject20 setValue:@"LittleSpottedKiwi_Apteryx_owenii"         forKey:@"image"];
        
        NSURL *url20t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"LittleSpottedKiwi_Apteryx_owenii_TN"
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
        [newManagedObject21 setValue:@"Rated as one of the most intelligent birds in the world.\nIf you are a frequent visitor to or live in an alpine environment you will know the kea well. Kea and Kaka belong to the NZ parrot superfamily. Raucous cries of ""keeaa"" often give away the presence of these highly social and inquisitive birds. However, their endearing and mischievous behaviour can cause conflict with people.\n\nKea (Nestor  notabilis) are an endemic parrot of the South Island's high country. Although kea are seen in reasonable numbers throughout the South Island, the size of the wild population is unknown - but is estimated at between 1,000 and 5,000 birds.\nTo survive in the harsh alpine environment kea have become inquisitive and nomadic social birds - characteristics which help kea to find and utilise new food sources. Their inquisitive natures often cause kea to congregate around novel objects and their strong beaks have enormous manipulative power.\nKea are a protected species.\nKea grow up to 50 cm long and although mostly vegetarian, also enjoy grubs and insects.\nThe kea is related to the forest kaka (Nestor meridionalis) and is thought to have developed its own special characteristics during the last great ice age by using its unusual powers of curiosity in its search for food in a harsh landscape.\nNests are usually found among boulders in high altitude forest where the birds lay between two and four eggs during the breeding season from July and January." forKey:@"item_description"];
        [newManagedObject21 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/kea/" forKey:@"link"];
        [newManagedObject21 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject21 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject21 setValue:@"only in southern alps" forKey:@"behaviour"];
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
        
        
        
        [newManagedObject21 setValue:@"kea2" forKey:@"sound"];
        
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
        [newManagedObject22 setValue:@"New Zealand's native pigeon, also known as kererū, kūkū and kūkupa and wood pigeon, is the only disperser of large fruits, such as those of karaka and taraire, we have. The disappearance of the kererū would be a disaster for the regeneration of our native forests.\n\nThe kererū is a large bird with irridescent green and bronze feathers on its head and a smart white vest. The noisy beat of its wings is a distinctive sound in our forests. The pigeon is found in most lowland native forests of the North, South and Stewart/Rakiura islands and many of their neighbouring islands.There are two species of native pigeon, the New Zealand pigeon (Hemiphaga novaeseelandiae) known to the Maori as kererū, or in Northland as kūkū or kūkupa, and the Chatham Islands pigeon (Hemiphaga chathamensis) or parea.\n\nThe parea is found mainly in the south-west of Chatham Island. While there are only about 500 parea left, the species has made a remarkable recovery over the past 20 years,  due to habitat protection and predator control.\nTwo other kinds of native pigeon became extinct on Raoul Island and Norfolk Island last century, probably due to hunting and predation\nSince the extinction of the moa, the native pigeon is now the only seed disperser with a bill big enough to swallow large fruit, such as those of karaka, tawa and taraire.\nIt also eats leaves, buds and flowers, the relative amounts varying seasonally and regionally, e.g. in Northland the birds eat mostly fruit.\nKererū are large birds and can measure up to 51 cm from tail to beak, and weigh about 650g.\nLong-lived birds, they breed slowly. Key breeding signals are spectacular display flights performed mainly by territorial males. They nest mainly in spring/early summer producing only one egg per nest, which the parents take turns to look after during the 28-day incubation period.\nThe chick grows rapidly, leaving the nest when about 40 days old. It is fed pigeon milk, a protein-rich milky secretion from the walls of the parents' crops, mixed with fruit pulp.  When much fruit is available, some pairs of kererū will have a large chick in one nest and be incubating an egg in another nearby. Fledglings spend about two weeks with their parents before becoming fully independent, but have remained with their parents during autumn and winter in some cases." forKey:@"item_description"];
        [newManagedObject22 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/nz-pigeon-kereru/" forKey:@"link"];
        [newManagedObject22 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject22 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject22 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject22 setValue:@"1" forKey:@"category"];
        [newManagedObject22 setValue:@"grey" forKey:@"colour"];
        [newManagedObject22 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject22 setValue:@"Pigeons and Doves (Columbidae)" forKey:@"family"];
        [newManagedObject22 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject22 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject23 setValue:@"The Rifleman is New Zealand's smallest endemic bird, with fully grown adults reaching around 8 cm. The male Rifleman is bright green on the dorsal side while the female is of a more somber brownish tone and her head and back are flecked with ochre. Male birds typically weigh around 6 g, females 7 g. Both birds are white on their under surfaces and have white eyebrow stripes. They have short, rounded wings, a very short tail, and a long thin awl-like bill which is slightly upturned for insertion into cracks. The Rifleman flies quickly with a wing beat producing a characteristic humming sound like a humming bird.The Rifleman is named after a colonial New Zealand regiment because its plumage drew similarities with the military uniform of a rifleman." forKey:@"item_description"];
        [newManagedObject23 setValue:@"http://en.wikipedia.org/wiki/Rifleman_(bird)" forKey:@"link"];
        [newManagedObject23 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject23 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject23 setValue:@"flies quick, hums" forKey:@"behaviour"];
        [newManagedObject23 setValue:@"1" forKey:@"category"];
        [newManagedObject23 setValue:@"grey" forKey:@"colour"];
        [newManagedObject23 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject23 setValue:@"Acanthisittidae (New Zealand Wrens)" forKey:@"family"];
        [newManagedObject23 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject23 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject24 setValue:@"Kakariki"       forKey:@"name"];
        [newManagedObject24 setValue:@"Cyanoramphus novaezelandiae" forKey:@"othername"];
        [newManagedObject24 setValue:@"The three species of Kākāriki or New Zealand parakeets are the most common species of parakeet in the genus Cyanoramphus, family Psittacidae. The birds' Māori name, which is the most commonly used, means small parrot. The three species on mainland New Zealand are the Yellow-crowned Parakeet, Cyanoramphus auriceps, the Red-crowned Parakeet or Red-fronted Parakeet, C. novaezelandiae, and the critically endangered Malherbe's Parakeet (or Orange-fronted Parakeet), C. malherbi." forKey:@"item_description"];
        [newManagedObject24 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/nz-parakeet-kakariki/nz-parakeet-kakariki/" forKey:@"link"];
        [newManagedObject24 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject24 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject24 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject24 setValue:@"1" forKey:@"category"];
        [newManagedObject24 setValue:@"green" forKey:@"colour"];
        [newManagedObject24 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject24 setValue:@"Psittacidae" forKey:@"family"];
        [newManagedObject24 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject24 setValue:@"unknown" forKey:@"threat_status"];
        [newManagedObject24 setValue:@"Red-fronted Parakeet" forKey:@"short_name"];
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
        [newManagedObject25 setValue:@"The grey warbler/riroriro (Gerygone igata) is a relatively inconspicuous grey bird that flits about the canopy of the forest but its call permeates the forest and takes the edge off a hard uphill slog for any attentive tramper.\nThese diminutive insectivorous birds busy themselves along branches seeking out small invertebrates.\nGrey warbler was the surprise recipient of the title of New Zealand's best-loved bird in 2007." forKey:@"item_description"];
        [newManagedObject25 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/grey-warbler-riroriro/" forKey:@"link"];
        [newManagedObject25 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject25 setValue:@"short,pointed" forKey:@"beak_length"];
        [newManagedObject25 setValue:@"Very active. Absent from open country and alpine areas" forKey:@"behaviour"];
        [newManagedObject25 setValue:@"1" forKey:@"category"];
        [newManagedObject25 setValue:@"grey" forKey:@"colour"];
        [newManagedObject25 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject25 setValue:@"Acanthizidae" forKey:@"family"];
        [newManagedObject25 setValue:@"bush/garden" forKey:@"habitat"];
        [newManagedObject25 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject25 setValue:@"Gray Gerygone" forKey:@"short_name"];
        [newManagedObject25 setValue:@"sparrow" forKey:@"size_and_shape"];
        
//        NSURL *url25 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"GreyWarbler_Gerygone1888"
//                                               ofType:@"jpg"]];
//        NSData *data25 = [[NSData alloc] initWithContentsOfURL:url25];
//        UIImage *imageSave25=[[UIImage alloc]initWithData:data25];
//        NSData *imageData25 = UIImagePNGRepresentation(imageSave25);
//        [newManagedObject25 setValue:imageData25         forKey:@"image"];
        [newManagedObject25 setValue:@"GreyWarbler_Gerygone1888"         forKey:@"image"];
        
        NSURL *url25t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"GreyWarbler_Gerygone1888_TN"
                                               ofType:@"jpg"]];
        NSData *data25t = [[NSData alloc] initWithContentsOfURL:url25t];
        UIImage *imageSave25t=[[UIImage alloc]initWithData:data25t];
        NSData *imageData25t = UIImagePNGRepresentation(imageSave25t);
        [newManagedObject25 setValue:imageData25t         forKey:@"thumbnail"];
        
        
        
        
        //[newManagedObject25 setValue:@"kakariki" forKey:@"sound"];
        
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
        [newManagedObject26 setValue:@"Common introduced garden bird. Male and female dimorph: male black, female brown." forKey:@"item_description"];
        [newManagedObject26 setValue:@"http://en.wikipedia.org/wiki/Common_Blackbird" forKey:@"link"];
        [newManagedObject26 setValue:@"orange" forKey:@"beak_colour"];
        [newManagedObject26 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject26 setValue:@"Defends its breading territory" forKey:@"behaviour"];
        [newManagedObject26 setValue:@"1" forKey:@"category"];
        [newManagedObject26 setValue:@"black" forKey:@"colour"];
        [newManagedObject26 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject26 setValue:@"Turdidae" forKey:@"family"];
        [newManagedObject26 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject26 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject27 setValue:@"Common garden bird. Male and female dimorph." forKey:@"item_description"];
        [newManagedObject27 setValue:@"http://en.wikipedia.org/wiki/Song_Thrush" forKey:@"link"];
        [newManagedObject27 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject27 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject27 setValue:@"The Song Thrush is not usually gregarious, although several birds may roost together in winter or be loosely associated in suitable feeding habitats, perhaps with other thrushes such as the Blackbird." forKey:@"behaviour"];
        [newManagedObject27 setValue:@"1" forKey:@"category"];
        [newManagedObject27 setValue:@"brown" forKey:@"colour"];
        [newManagedObject27 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject27 setValue:@"Turdidae" forKey:@"family"];
        [newManagedObject27 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject27 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject28 setValue:@"Common bird. Male and female dimorph." forKey:@"item_description"];
        [newManagedObject28 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/paradise-duck-putakitaki/" forKey:@"link"];
        [newManagedObject28 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject28 setValue:@"duck" forKey:@"beak_length"];
        [newManagedObject28 setValue:@"odd and quirky" forKey:@"behaviour"];
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
        [newManagedObject29 setValue:@"Banded dotterel"       forKey:@"name"];
        [newManagedObject29 setValue:@"Double banded plover (Charadrius bicinctus)" forKey:@"othername"];
        [newManagedObject29 setValue:@"Dotterels dart around on beaches and mudflats. The banded dotterel is easily identified by its breeding colours being a narrow dark band on its neck and a wide chestnut band on the breast. Its back and wings are fawn. The Maori name for dotterel is tuturiwhatu. The banded dotterl is the most numerous dotterel in New Zealand and is both endemic (only found here) to New Zealand and a protected species. The banded dotterel breeds in a variety of habitats including on coasts, farms, and on the shores of lakes and riverbeds. They are most common in inland Canterbury and the Mackenzie Basin. The male makes several nests for the female to choose from and these are scrapes on sand or soil. Both the male and female incubate two to four eggs. After breeding most of the inland breeding birds, slightly over half of the total population of 50,000, migrate to Australia for winter." forKey:@"item_description"];
        [newManagedObject29 setValue:@"http://en.wikipedia.org/wiki/Charadrius_bicinctus" forKey:@"link"];
        [newManagedObject29 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject29 setValue:@"short,pointed" forKey:@"beak_length"];
        [newManagedObject29 setValue:@"nest in burrows" forKey:@"behaviour"];
        [newManagedObject29 setValue:@"1" forKey:@"category"];
        [newManagedObject29 setValue:@"brown" forKey:@"colour"];
        [newManagedObject29 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject29 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject29 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject29 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject30 setValue:@"Rare, large stocky bird that was thought to be extinct until it was re-discovered near Lake Te Anau (South Island) in 1948. Close relative to the Pukeko (which is smaller and lighter)" forKey:@"item_description"];
        [newManagedObject30 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/takahe/" forKey:@"link"];
        [newManagedObject30 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject30 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject30 setValue:@"flightless, sedentary" forKey:@"behaviour"];
        [newManagedObject30 setValue:@"1" forKey:@"category"];
        [newManagedObject30 setValue:@"blue" forKey:@"colour"];
        [newManagedObject30 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject30 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject30 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject30 setValue:@"endangered" forKey:@"threat_status"];
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
        
        
        //[newManagedObject30 setValue:@"cockatiel" forKey:@"sound"];
        
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
        [newManagedObject31 setValue:@"Established in NZ ca. 1000 yrs ago they thrived in an environment in which they now face introduced predators like cats and rodents. Live in groups of 3-12; known to group together and shriek loudly to defend nests successfully during attacks by Australasian Harriers. " forKey:@"item_description"];
        [newManagedObject31 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/pukeko/" forKey:@"link"];
        [newManagedObject31 setValue:@"red" forKey:@"beak_colour"];
        [newManagedObject31 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject31 setValue:@"flightless,sedentary" forKey:@"behaviour"];
        [newManagedObject31 setValue:@"1" forKey:@"category"];
        [newManagedObject31 setValue:@"blue" forKey:@"colour"];
        [newManagedObject31 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject31 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject31 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject31 setValue:@"endangered" forKey:@"threat_status"];
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
        [newManagedObject32 setValue:@"A bird of prey" forKey:@"item_description"];
        [newManagedObject32 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/" forKey:@"link"];
        [newManagedObject32 setValue:@"brown" forKey:@"beak_colour"];
        [newManagedObject32 setValue:@"hook" forKey:@"beak_length"];
        [newManagedObject32 setValue:@"" forKey:@"behaviour"];
        [newManagedObject32 setValue:@"1" forKey:@"category"];
        [newManagedObject32 setValue:@"brown" forKey:@"colour"];
        [newManagedObject32 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject32 setValue:@"Accipitridae" forKey:@"family"];
        [newManagedObject32 setValue:@"garden/bush" forKey:@"habitat"];
        [newManagedObject32 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject33 setValue:@"Extremely long legs, feed on aquatic insects, ground nesting near water." forKey:@"item_description"];
        [newManagedObject33 setValue:@"http://en.wikipedia.org/wiki/Black-winged_Stilt" forKey:@"link"];
        [newManagedObject33 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject33 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject33 setValue:@"forages in shallow water" forKey:@"behaviour"];
        [newManagedObject33 setValue:@"1" forKey:@"category"];
        [newManagedObject33 setValue:@"black/white" forKey:@"colour"];
        [newManagedObject33 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject33 setValue:@"Recurvirostridae" forKey:@"family"];
        [newManagedObject33 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject33 setValue:@"Least concern" forKey:@"threat_status"];
        [newManagedObject33 setValue:@"Pied Stilt" forKey:@"short_name"];
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
        [newManagedObject34 setValue:@"An introduced bird, captivity and in farming operations" forKey:@"item_description"];
        [newManagedObject34 setValue:@"en.wikipedia.org/wiki/Pheasant" forKey:@"link"];
        [newManagedObject34 setValue:@"white" forKey:@"beak_colour"];
        [newManagedObject34 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject34 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject34 setValue:@"1" forKey:@"category"];
        [newManagedObject34 setValue:@"brown/green" forKey:@"colour"];
        [newManagedObject34 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject34 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject34 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject34 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject35 setValue:@"An introduced bird, captivity" forKey:@"item_description"];
        [newManagedObject35 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/" forKey:@"link"];
        [newManagedObject35 setValue:@"white" forKey:@"beak_colour"];
        [newManagedObject35 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject35 setValue:@"odd and quirky" forKey:@"behaviour"];
        [newManagedObject35 setValue:@"1" forKey:@"category"];
        [newManagedObject35 setValue:@"green/blue" forKey:@"colour"];
        [newManagedObject35 setValue:@"grey" forKey:@"leg_colour"];
        [newManagedObject35 setValue:@"Charadriidae" forKey:@"family"];
        [newManagedObject35 setValue:@"garden" forKey:@"habitat"];
        [newManagedObject35 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject36 setValue:@"The smallest species of penguin. The penguin, which usually grows to an average of 33 cm in height and 43 cmin length, found on the coastlines of southern Australia and New Zealand, with possible records from Chile. Apart from Little Penguins, they have several common names. In Australia, they are also referred to as Fairy Penguins because of their tiny size. In New Zealand, they are also called Little Blue Penguins, or just Blue Penguins, owing to their slate-blue plumage, and they are called Kororā in Māori. Rough estimates (as new colonies continue to be discovered) of the world population are around 350,000-600,000 animals.The species is not considered endangered, except for the White-Flippered subspecies found only on Banks Peninsula and nearby Motunau Island in New Zealand. Since the 1960s, the mainland population has declined by 60-70%; though there has been a small increase on Motunau Island. But overall Little Penguin populations have been decreasing as well, with some colonies having been wiped out and other populations continuing to be at risk. However, new colonies have been established in urban areas. The greatest threat to Little Penguin populations has been predation (including nest predation) from cats, foxes, large reptiles, ferrets and stoats. Due to their diminutive size and the introduction of new predators, some colonies have been reduced in size by as much as 98% in just a few years, such as the small colony on Middle Island, near Warrnambool, Victoria, which was reduced from approximately 600 penguins in 2001 to less than 10 in 2005. Because of this threat of colony collapse, conservationists pioneered an experimental technique using Maremma Sheepdogs to protect the colony and fend off would-be predators." forKey:@"item_description"];
        [newManagedObject36 setValue:@"http://en.wikipedia.org/wiki/Little_Penguin" forKey:@"link"];
        [newManagedObject36 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject36 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject36 setValue:@"diurnal" forKey:@"behaviour"];
        [newManagedObject36 setValue:@"1" forKey:@"category"];
        [newManagedObject36 setValue:@"grey/black" forKey:@"colour"];
        [newManagedObject36 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject36 setValue:@"Spheniscidae" forKey:@"family"];
        [newManagedObject36 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject36 setValue:@"endangered" forKey:@"threat_status"];
        [newManagedObject36 setValue:@"Little Penguin" forKey:@"short_name"];
        [newManagedObject36 setValue:@"pigeon" forKey:@"size_and_shape"];
        
//        NSURL *url36 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                               pathForResource:@"Little_Penguin"
//                                               ofType:@"jpg"]];
//        NSData *data36 = [[NSData alloc] initWithContentsOfURL:url36];
//        UIImage *imageSave36=[[UIImage alloc]initWithData:data36];
//        NSData *imageData36 = UIImagePNGRepresentation(imageSave36);
//        [newManagedObject36 setValue:imageData36         forKey:@"image"];
        [newManagedObject36 setValue:@"Little_Penguin"         forKey:@"image"];
        
        
        NSURL *url36t = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Little_Penguin_TN"
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
        [newManagedObject37 setValue:@"A parrot-like bird,the Eastern Rosella (Platycercus eximius) is a native to southeast of the Australian continent and to Tasmania. It has been introduced to New Zealand where feral populations are found in the North Island (notably in the northern half of the island and in the Hutt Valley) and in the hills around Dunedin in the South Island." forKey:@"item_description"];
        [newManagedObject37 setValue:@"http://en.wikipedia.org/wiki/Eastern_Rosella" forKey:@"link"];
        [newManagedObject37 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject37 setValue:@"hooked" forKey:@"beak_length"];
        [newManagedObject37 setValue:@"" forKey:@"behaviour"];
        [newManagedObject37 setValue:@"1" forKey:@"category"];
        [newManagedObject37 setValue:@"red/green/blue/yellow" forKey:@"colour"];
        [newManagedObject37 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject37 setValue:@"Psittacidae" forKey:@"family"];
        [newManagedObject37 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject37 setValue:@"unknown" forKey:@"threat_status"];
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
        [newManagedObject38 setValue:@"A rare bird, threatened" forKey:@"item_description"];
        [newManagedObject38 setValue:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/weka/" forKey:@"link"];
        [newManagedObject38 setValue:@"reddish" forKey:@"beak_colour"];
        [newManagedObject38 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject38 setValue:@"nocturnal" forKey:@"behaviour"];
        [newManagedObject38 setValue:@"1" forKey:@"category"];
        [newManagedObject38 setValue:@"brown" forKey:@"colour"];
        [newManagedObject38 setValue:@"red" forKey:@"leg_colour"];
        [newManagedObject38 setValue:@"Rallidae" forKey:@"family"];
        [newManagedObject38 setValue:@"bush" forKey:@"habitat"];
        [newManagedObject38 setValue:@"vulnerable" forKey:@"threat_status"];
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
        [newManagedObject39 setValue:@"Phalacrocorax punctatus" forKey:@"othername"];
        [newManagedObject39 setValue:@"A rare bird, threatened" forKey:@"item_description"];
        [newManagedObject39 setValue:@"http://en.wikipedia.org/wiki/Spotted_Shag" forKey:@"link"];
        [newManagedObject39 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject39 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject39 setValue:@"" forKey:@"behaviour"];
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
        
        
        // +++++++++++Shag, bronze +++++++++++++
        /*  40
         */
        
        NSManagedObject *newManagedObject40 = [NSEntityDescription insertNewObjectForEntityForName:@"Bird_attributes" inManagedObjectContext:context];
        
        //Set Bird_attributes
        [newManagedObject40 setValue:@"Shag, little"       forKey:@"name"];
        [newManagedObject40 setValue:@"Microcarbo melanoleucos" forKey:@"othername"];
        [newManagedObject40 setValue:@"A coastal bird, also called cormorant or fregate bird. The bird family Phalacrocoracidae or the cormorants is represented by some 40 species of cormorants and shags. The species ranges across New Zealand, from Stewart Island to Northland, and across mainland Australia (although not in the arid interior of the west of the country) and Tasmania and Indonesia. Widespread and common, it lives near bodies of water such as swamps, lakes, lagoons, estuaries and the coastline." forKey:@"item_description"];
        [newManagedObject40 setValue:@"http://en.wikipedia.org/wiki/Cormorant" forKey:@"link"];
        [newManagedObject40 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject40 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject40 setValue:@"" forKey:@"behaviour"];
        [newManagedObject40 setValue:@"1" forKey:@"category"];
        [newManagedObject40 setValue:@"black/white" forKey:@"colour"];
        [newManagedObject40 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject40 setValue:@"Phalacrocoracidae" forKey:@"family"];
        [newManagedObject40 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject40 setValue:@"Naturally uncommon" forKey:@"threat_status"];
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
        [newManagedObject41 setValue:@"A surprisingly abundant bird. With its sturdy bill the kingfisher can dig nesting holes into clayey reiver banks. " forKey:@"item_description"];
        [newManagedObject41 setValue:@"http://blog.forestandbird.org.nz/the-kingfisher-a-true-thug/#more-1047" forKey:@"link"];
        [newManagedObject41 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject41 setValue:@"long" forKey:@"beak_length"];
        [newManagedObject41 setValue:@"very shy, fast flier, preys on small animals" forKey:@"behaviour"];
        [newManagedObject41 setValue:@"1" forKey:@"category"];
        [newManagedObject41 setValue:@"green/blue" forKey:@"colour"];
        [newManagedObject41 setValue:@"brown" forKey:@"leg_colour"];
        [newManagedObject41 setValue:@"Alcedinidae" forKey:@"family"];
        [newManagedObject41 setValue:@"coast" forKey:@"habitat"];
        [newManagedObject41 setValue:@"unknown" forKey:@"threat_status"];
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
        [newManagedObject43 setValue:@"A relatively abundand bird, hugely competitive. " forKey:@"item_description"];
        [newManagedObject43 setValue:@"http://en.wikipedia.org/wiki/Myna" forKey:@"link"];
        [newManagedObject43 setValue:@"yellow" forKey:@"beak_colour"];
        [newManagedObject43 setValue:@"medium" forKey:@"beak_length"];
        [newManagedObject43 setValue:@"nocturnal" forKey:@"behaviour"];
        [newManagedObject43 setValue:@"1" forKey:@"category"];
        [newManagedObject43 setValue:@"grey/brown/white" forKey:@"colour"];
        [newManagedObject43 setValue:@"yellow" forKey:@"leg_colour"];
        [newManagedObject43 setValue:@"Sturnidae" forKey:@"family"];
        [newManagedObject43 setValue:@"coast/garden/bush" forKey:@"habitat"];
        [newManagedObject43 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject44 setValue:@"Relatively abundant in the South, scarcer in the north, introduced bird. Similar to a house sparrow though smaller." forKey:@"item_description"];
        [newManagedObject44 setValue:@"http://en.wikipedia.org/wiki/Dunnock" forKey:@"link"];
        [newManagedObject44 setValue:@"grey/black" forKey:@"beak_colour"];
        [newManagedObject44 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject44 setValue:@"unknown" forKey:@"behaviour"];
        [newManagedObject44 setValue:@"0" forKey:@"category"];
        [newManagedObject44 setValue:@"brown" forKey:@"colour"];
        [newManagedObject44 setValue:@"orange/brown" forKey:@"leg_colour"];
        [newManagedObject44 setValue:@"Prunellidae" forKey:@"family"];
        [newManagedObject44 setValue:@"garden/bush/coast" forKey:@"habitat"];
        [newManagedObject44 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject45 setValue:@"The Greenfinch has been introduced into both Australia and New Zealand from Europe. The Greenfinch is 15 cm long with a wing span of 24.5 to 27.5 cm. It is similar in size and shape to a House Sparrow, but is mainly green, with yellow in the wings and tail. The female and young birds are duller and have brown tones on the back. The bill is thick and conical. The song contains wheezes and twitters, and the male has a butterfly display flight." forKey:@"item_description"];
        [newManagedObject45 setValue:@"http://en.wikipedia.org/wiki/European_Greenfinch" forKey:@"link"];
        [newManagedObject45 setValue:@"orange" forKey:@"beak_colour"];
        [newManagedObject45 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject45 setValue:@"unknown" forKey:@"behaviour"];
        [newManagedObject45 setValue:@"0" forKey:@"category"];
        [newManagedObject45 setValue:@"green" forKey:@"colour"];
        [newManagedObject45 setValue:@"orange/red" forKey:@"leg_colour"];
        [newManagedObject45 setValue:@"Fringillidae" forKey:@"family"];
        [newManagedObject45 setValue:@"garden/bush" forKey:@"habitat"];
        [newManagedObject45 setValue:@"least concern" forKey:@"threat_status"];
        [newManagedObject45 setValue:@"European Greenfinch" forKey:@"short_name"];
        [newManagedObject45 setValue:@"sparrow" forKey:@"size_and_shape"];
        
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
        [newManagedObject46 setValue:@"It is the world’s smallest cuckoo, being only 15 to 17 centimetres (5.9 to 6.7 in) in length, and parasitises chiefly dome-shaped nests of various Gerygone species, having a range that largely corresponds with the distribution of that genus. It may also parasitise other Acanthizidae species, and is also the most southerly ranging brood parasitic bird species in the world, extending to 45°S in New Zealand. Hard to spot and easier to hear, the Shining Bronze Cuckoo has metallic golden or coppery green upperparts and white cheeks and underparts barred with dark green. The female is similar with a more purplish sheen to the crown and nape and bronzer-tinged barring on the belly. The bill is black and the feet are black with yellow undersides." forKey:@"item_description"];
        [newManagedObject46 setValue:@"http://en.wikipedia.org/wiki/Shining_Cuckoo" forKey:@"link"];
        [newManagedObject46 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject46 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject46 setValue:@"unknown" forKey:@"behaviour"];
        [newManagedObject46 setValue:@"0" forKey:@"category"];
        [newManagedObject46 setValue:@"green" forKey:@"colour"];
        [newManagedObject46 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject46 setValue:@"Cuculidae" forKey:@"family"];
        [newManagedObject46 setValue:@"garden/bush/coast" forKey:@"habitat"];
        [newManagedObject46 setValue:@"least concern" forKey:@"threat_status"];
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
        [newManagedObject47 setValue:@"It is a species native to Australia and nearby islands, and self-introduced into New Zealand in the middle of the twentieth century. It is very similar to the Pacific Swallow with which it is often considered conspecific. Metallic blue-black above, light grey below on the breast and belly, and rusty on the forehead, throat and upper breast. It has a long forked tail, with a row of white spots on the individual feathers. These birds are about 15 cm (6 in) long, including the outer tail feathers which are slightly shorter in the female. " forKey:@"item_description"];
        [newManagedObject47 setValue:@"http://en.wikipedia.org/wiki/Welcome_Swallow" forKey:@"link"];
        [newManagedObject47 setValue:@"black" forKey:@"beak_colour"];
        [newManagedObject47 setValue:@"short" forKey:@"beak_length"];
        [newManagedObject47 setValue:@"unknown" forKey:@"behaviour"];
        [newManagedObject47 setValue:@"0" forKey:@"category"];
        [newManagedObject47 setValue:@"blue/orange" forKey:@"colour"];
        [newManagedObject47 setValue:@"black" forKey:@"leg_colour"];
        [newManagedObject47 setValue:@"Prunellidae" forKey:@"family"];
        [newManagedObject47 setValue:@"bush/coast" forKey:@"habitat"];
        [newManagedObject47 setValue:@"least concern" forKey:@"threat_status"];
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
        
        // V2
        // +++++++++++ Kaka +++++++++++++
        /*  48
         */
        // +++++++++++ Redpoll +++++++++++++
        /*  49
         */
        // +++++++++++ Rock Pigeon +++++++++++++
        /*  50
         */
        // +++++++++++ Skylark +++++++++++++
        /*  51
         */
        // +++++++++++ Shag(s)? +++++++++++++
        /*  52
         */
        // +++++++++++ Kiwi(s)? +++++++++++++
        /*  53
         */
        // +++++++++++ Buller's shearwater +++++++++++++
        /*  54
         */
        // +++++++++++ Caspian Tern +++++++++++++
        /*  55
         */
        // +++++++++++ Black-billed Gull +++++++++++++
        /*  56
         */
        // +++++++++++ White Faced Heron +++++++++++++
        /*  57
         */
        // +++++++++++ Albatross +++++++++++++
        /*  58
         */
        
        
        
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
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
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

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)newScratchManagedObjectContext {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

@end
