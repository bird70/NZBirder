//
//  BirdDetailViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Bird;

@interface BirdDetailViewController : UIViewController

<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}



@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) Bird *bird;
@property (weak, nonatomic) NSArray *birds;


@property (weak, nonatomic) IBOutlet UILabel *familyLabel;

- (IBAction)triggerBirdDescriptionVC:(UIBarButtonItem *)sender;
- (IBAction)backToList:(UIBarButtonItem *)sender;

- (IBAction) playAudio;
+ imageWithRoundedCornersSize;

@end
