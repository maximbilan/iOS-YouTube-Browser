//
//  NSString+ValidURL.m
//  ios_youtube_browser
//
//  Created by Maxim Bilan on 10/20/15.
//  Copyright © 2015 Maxim Bilan. All rights reserved.
//

#import "NSString+ValidURL.h"

@implementation NSString (ValidURL)

- (BOOL)isValidURL
{
	NSUInteger length = [self length];
	
	// Empty strings should return NO
	if (length > 0) {
		NSError *error = nil;
		NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
		if (dataDetector && !error) {
			NSRange range = NSMakeRange(0, length);
			NSRange notFoundRange = (NSRange){NSNotFound, 0};
			NSRange linkRange = [dataDetector rangeOfFirstMatchInString:self options:0 range:range];
			if (!NSEqualRanges(notFoundRange, linkRange) && NSEqualRanges(range, linkRange)) {
				return YES;
			}
		}
		else {
			NSLog(@"Could not create link data detector: %@ %@", [error localizedDescription], [error userInfo]);
		}
	}
	return NO;
}

@end
