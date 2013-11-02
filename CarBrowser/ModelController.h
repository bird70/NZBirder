//
//  ModelController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 19/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelController : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

+ (ModelController *)sharedController;

@end
