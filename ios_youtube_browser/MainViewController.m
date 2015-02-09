//
//  MainViewController.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/9/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import "MainViewController.h"
#import "MainMenuTableCell.h"

#import "AFNetworking.h"

static NSString * const MainMenuTableCellId = @"MainMenuTableCellId";

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	data = [NSMutableArray array];
}

- (void)fetchYoutubeData:(NSString *)searchString
{
	
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MainMenuTableCell *cell = (MainMenuTableCell *)[tableView dequeueReusableCellWithIdentifier:MainMenuTableCellId];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
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
