//
//  YouTubeViewController.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/16/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import "YouTubeViewController.h"

#import "YTPlayerView.h"

#define YTPLAYERVIEW_SHOW_INFO

@interface YouTubeViewController ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation YouTubeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (self.videoId) {
#ifdef YTPLAYERVIEW_SHOW_INFO
		[self.playerView loadWithVideoId:self.videoId];
#else
		[self.playerView loadWithVideoId:self.videoId playerVars:@{ @"showinfo" : @(0) }];
#endif
	}
}

@end
