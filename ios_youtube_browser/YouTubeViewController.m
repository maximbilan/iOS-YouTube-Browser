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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
