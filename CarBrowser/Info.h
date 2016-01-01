//
//  Info.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 8/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Info : NSManagedObject

@property (nonatomic, retain) NSString * imagename;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * segmentname;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;

@end
