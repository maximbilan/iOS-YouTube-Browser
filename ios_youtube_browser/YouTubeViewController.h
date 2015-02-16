//
//  YouTubeViewController.h
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/16/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPlayerView;

@interface YouTubeViewController : UIViewController

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@property (nonatomic, strong) NSString *videoId;

@end
