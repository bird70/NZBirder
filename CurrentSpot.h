//
//  CurrentSpot.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 20/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CurrentSpot : NSManagedObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSDate * date_last_changed;
@property (nonatomic, retain) NSString * name;

@end
