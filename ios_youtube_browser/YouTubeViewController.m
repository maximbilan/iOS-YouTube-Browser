//
//  YouTubeViewController.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/16/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import "YouTubeViewController.h"

#import "YTPlayerView.h"

@interface YouTubeViewController ()

@end

@implementation YouTubeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (self.videoId) {
		[self.playerView loadWithVideoId:self.videoId];
	}
}

@end
