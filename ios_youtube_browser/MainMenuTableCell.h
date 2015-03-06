//
//  MainMenuTableCell.h
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 2/9/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPlayerView;

@interface MainMenuTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;

@end
