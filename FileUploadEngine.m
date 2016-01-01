//
//  FileUploadEngine.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/10/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "FileUploadEngine.h"

@implementation FileUploadEngine

- (MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *) path{
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    return op;
}

@end
