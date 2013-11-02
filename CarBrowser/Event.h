//
//  Event.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 8/06/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;

@end
