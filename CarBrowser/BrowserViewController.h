//
//  BrowserViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 14/08/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *browserView;
@property (weak, nonatomic) NSString *externalLink;
@property (weak, nonatomic) IBOutlet UILabel *labelURL;

@end
