//
//  ViewController.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/9/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=YouTube+Data+API&type=video&videoCaption=closedCaption&key=AIzaSyCs0lcHGW2oW88FO8FeR8j_hXMc9oCG6p0" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

//https://www.googleapis.com/youtube/v3/channels?part=contentDetails

//https://www.googleapis.com/youtube/v3/videos?id=7lCDEYXw3mM&key=YOUR_API_KEY&part=snippet,contentDetails,statistics,status

//https://www.googleapis.com/youtube/v3/search?part=snippet&q=YouTube+Data+API&type=video&videoCaption=closedCaption&key=AIzaSyCs0lcHGW2oW88FO8FeR8j_hXMc9oCG6p0

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
