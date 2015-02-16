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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
