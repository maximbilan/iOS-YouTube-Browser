//
//  MainViewController.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/9/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import "MainViewController.h"
#import "MainMenuTableCell.h"

#import "YouTubeViewController.h"

#import "AFNetworking.h"
#import "YTPlayerView.h"
#import "WaitSpinner.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "NSString+ValidURL.h"

#define ENABLE_LOG 1

static NSString * const MainMenuTableCellId = @"MainMenuTableCellId";
static NSString * const YouTubeSearchUrl = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&type=video&videoCaption=closedCaption&key=%@&maxResults=%@";
static NSString * const YouTubeSearchByIDUrl = @"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=%@&maxResults=%@";
static NSString * const YouTubeStatsUrl = @"https://www.googleapis.com/youtube/v3/videos?id=%@&part=statistics&key=%@";
static NSString * const YouTubeAppKey = @"AIzaSyCs0lcHGW2oW88FO8FeR8j_hXMc9oCG6p0";
static const NSInteger YouTubeMaxResults = 50;

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *data;
	NSMutableArray *statsData;
	BOOL isSearchVideoId;
	NSString *searchVideoId;
	
	WaitSpinner *waitSpinner;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	waitSpinner = [[WaitSpinner alloc] init];
	
	data = [NSMutableArray array];
	statsData = [NSMutableArray array];
}

- (void)fetchYoutubeData:(NSString *)searchString
{
	NSString *str = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *url = [NSString stringWithFormat:isSearchVideoId ? YouTubeSearchByIDUrl : YouTubeSearchUrl, str, YouTubeAppKey, @(YouTubeMaxResults)];
	
	AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
	[sessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef ENABLE_LOG
		NSLog(@"JSON: %@", responseObject);
#endif
		NSDictionary *d = (NSDictionary *)responseObject;
		if (d) {
			if ([d valueForKey:@"items"]) {
				NSArray *items = d[@"items"];
				if (items) {
					[data removeAllObjects];
					[data addObjectsFromArray:items];
					
					[self fetchYoutubeStats];
				}
			}
		}
		[waitSpinner hide];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef ENABLE_LOG
		NSLog(@"Error: %@", error);
#endif
		[waitSpinner hide];
	}];
}

- (void)fetchYoutubeStats
{
	[statsData removeAllObjects];
	
	[waitSpinner showInView:self.view];
	
	NSInteger dataCount = data.count;
	__block NSInteger requestCount = 0;
	
	__weak MainViewController *controller = self;
	void (^checkIsFinish)(void) = ^(void) {
		if (requestCount == dataCount - 1) {
			[waitSpinner hide];
			[controller.tableView reloadData];
		}
		++requestCount;
	};
	
	
	for (NSDictionary *object in data) {
		BOOL wasRequest = NO;
		if (object) {
			
			if (!isSearchVideoId) {
				if ([object valueForKey:@"id"]) {
					NSDictionary *idDict = [object valueForKey:@"id"];
					if (idDict) {
						if ([idDict valueForKey:@"videoId"]) {
							NSString *videoId = idDict[@"videoId"];
							if (videoId && videoId.length > 0) {
								wasRequest = YES;
								
								NSString *url = [NSString stringWithFormat:YouTubeStatsUrl, videoId, YouTubeAppKey];
								AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
								[sessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
								} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef ENABLE_LOG
									NSLog(@"JSON: %@", responseObject);
#endif
									NSDictionary *responseDict = (NSDictionary *)responseObject;
									if (responseDict) {
										[statsData addObject:responseDict];
									}
									checkIsFinish();
								} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef ENABLE_LOG
									NSLog(@"Error: %@", error);
#endif
									checkIsFinish();
								}];
							}
						}
					}
				}
			}
			else {
				if (searchVideoId && searchVideoId.length > 0) {
					wasRequest = YES;
					
					NSString *url = [NSString stringWithFormat:YouTubeStatsUrl, searchVideoId, YouTubeAppKey];
					AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
					[sessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
						
					} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef ENABLE_LOG
						NSLog(@"JSON: %@", responseObject);
#endif
						NSDictionary *responseDict = (NSDictionary *)responseObject;
						if (responseDict) {
							[statsData addObject:responseDict];
						}
						checkIsFinish();
					} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef ENABLE_LOG
						NSLog(@"Error: %@", error);
#endif
						checkIsFinish();
					}];
				}
			}
		}
		
		if (!wasRequest) {
			checkIsFinish();
		}
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MainMenuTableCell *cell = (MainMenuTableCell *)[tableView dequeueReusableCellWithIdentifier:MainMenuTableCellId];
	
	NSString *ytVideoId = nil;
	NSString *ytDefaultThumbnail = nil;
	NSString *ytMediumThumbnail = nil;
	NSString *ytHighThumbnail = nil;
	
	NSString *ytTitle = nil;
	NSString *ytDescription = nil;
	NSString *ytChannel = nil;
	NSString *ytPublishedAt = nil;
	
	NSDictionary *object = data[indexPath.row];
	if (object) {
		
		if (isSearchVideoId) {
			ytVideoId = searchVideoId;
		}
		else {
			if ([object valueForKey:@"id"]) {
				NSDictionary *idDict = [object valueForKey:@"id"];
				if (idDict) {
					if ([idDict valueForKey:@"videoId"]) {
						NSString *videoId = idDict[@"videoId"];
						if (videoId && videoId.length > 0) {
							ytVideoId = videoId;
						}
					}
				}
			}
		}
		
		if ([object valueForKey:@"snippet"]) {
			NSDictionary *snippet = [object valueForKey:@"snippet"];
			if (snippet) {
				if ([snippet valueForKey:@"thumbnails"]) {
					NSDictionary *thumbnails = [snippet valueForKey:@"thumbnails"];
					if (thumbnails) {
						if ([thumbnails valueForKey:@"default"]) {
							NSDictionary *defaultThumbnail = [thumbnails valueForKey:@"default"];
							if (defaultThumbnail) {
								ytDefaultThumbnail = defaultThumbnail[@"url"];
							}
						}
						
						if ([thumbnails valueForKey:@"medium"]) {
							NSDictionary *mediumThumbnail = [thumbnails valueForKey:@"medium"];
							if (mediumThumbnail) {
								ytMediumThumbnail = mediumThumbnail[@"url"];
							}
						}
						
						if ([thumbnails valueForKey:@"high"]) {
							NSDictionary *highThumbnail = [thumbnails valueForKey:@"high"];
							if (highThumbnail) {
								ytHighThumbnail = highThumbnail[@"url"];
							}
						}
					}
				}
				
				if ([snippet valueForKey:@"title"]) {
					ytTitle = snippet[@"title"];
				}
				
				if ([snippet valueForKey:@"description"]) {
					ytDescription = snippet[@"description"];
				}
				
				if ([snippet valueForKey:@"channelTitle"]) {
					ytChannel = snippet[@"channelTitle"];
				}
				
				if ([snippet valueForKey:@"publishedAt"]) {
					ytPublishedAt = snippet[@"publishedAt"];
				}
			}
		}
		
		if (ytTitle) {
			cell.titleLabel.text = ytTitle;
		}
		if (ytDescription) {
			cell.descriptionTextView.text = ytDescription;
		}
		if (ytChannel) {
			cell.channelLabel.text = ytChannel;
		}
//		if (ytPublishedAt) {
//			cell.dateLabel.text = ytPublishedAt;
//		}
		
		[cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:ytMediumThumbnail]];
	}
	
	NSString *ytViewCount = nil;
	NSString *ytLikeCount = nil;
	
	NSDictionary *objectStats = statsData[indexPath.row];
	if (objectStats) {
		if (objectStats[@"items"]) {
			NSArray *items = (NSArray *)[objectStats valueForKey:@"items"];
			if (items && items.count > 0) {
				NSDictionary *item = items[0];
				if (item) {
					if (item[@"statistics"]) {
						NSDictionary *stats = [item valueForKey:@"statistics"];
						if (stats[@"viewCount"]) {
							NSInteger viewCount = [[stats valueForKey:@"viewCount"] integerValue];
							ytViewCount = [NSString stringWithFormat:@"%@ views", @(viewCount)];
						}
						if (stats[@"likeCount"]) {
							NSInteger likeCount = [[stats valueForKey:@"likeCount"] integerValue];
							ytLikeCount = [NSString stringWithFormat:@"%@ likes", @(likeCount)];
						}
					}
				}
			}
		}
		
		if (ytViewCount) {
			cell.viewCountLabel.text = ytViewCount;
		}
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Search action

- (IBAction)searchAction:(UIButton *)sender
{
	if (self.searchTextField.text.length > 0) {
		[waitSpinner showInView:self.view];
		NSString *str = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
		
		isSearchVideoId = NO;
		if ([str isValidURL]) {
			
			NSString *url = str;
			NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)"
																				   options:NSRegularExpressionCaseInsensitive
																					 error:nil];
			NSTextCheckingResult *match = [regex firstMatchInString:url
															options:0
															  range:NSMakeRange(0, [url length])];
			NSRange range = [match rangeAtIndex:0];
			str = [url substringWithRange:range];
			
			isSearchVideoId = YES;
			searchVideoId = str;
		}
		
		[self fetchYoutubeData:str];
	}
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	
	YouTubeViewController *controller = [segue destinationViewController];
	
	NSString *ytVideoId = nil;
	NSString *ytTitle = nil;
	NSDictionary *object = data[indexPath.row];
	if (object) {
	
		if (isSearchVideoId) {
			ytVideoId = searchVideoId;
		}
		else {
			if ([object valueForKey:@"id"]) {
				NSDictionary *idDict = [object valueForKey:@"id"];
				if (idDict) {
					if ([idDict valueForKey:@"videoId"]) {
						NSString *videoId = idDict[@"videoId"];
						if (videoId && videoId.length > 0) {
							ytVideoId = videoId;
						}
					}
				}
			}
		}
		
		if ([object valueForKey:@"snippet"]) {
			NSDictionary *snippet = [object valueForKey:@"snippet"];
			if (snippet) {
				if ([snippet valueForKey:@"title"]) {
					ytTitle = snippet[@"title"];
				}
			}
		}
	}
	
	controller.videoId = ytVideoId;
	controller.navigationItem.title = ytTitle;
}

@end
