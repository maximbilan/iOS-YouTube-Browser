# iOS YouTube Browser Sample

This tutorial explains how to create simple iOS application which working with YouTube API.

First of all, you should create Google account, if you haven’t. Go to Google Developers Console and create the project.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img1.png)

In created project, you will have lots of settings, statistics, something else. For your application we need to enable YouTube API.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img2.png)

Also you need to create iOS key by this link on the API access tab and ‘Create new iOS key’ button.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img3.png)

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img4.png)

Now all settings were set up.

We have two question for our simple application. How to receive data from YouTube? And how to play YouTube videos in UIKit?

For receiving the data we will use the next request. Google provides lots of information about API, you can found here. Full information about API, samples, etc.

Sample code for request using AFNetworking:

<pre>
static NSString * const YouTubeBaseUrl = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&type=video&videoCaption=closedCaption&key=%@&maxResults=%@";
static NSString * const YouTubeAppKey = @"AIzaSyCs0lcHGW2oW88FO8FeR8j_hXMc9oCG6p0";
static const NSInteger YouTubeMaxResults = 50;

...

NSString *str = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *url = [NSString stringWithFormat:YouTubeBaseUrl, str, YouTubeAppKey, @(YouTubeMaxResults)];
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
[manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
   NSLog(@"JSON: %@", responseObject);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   NSLog(@"Error: %@", error);
}];
</pre>

Here not comfortable for reading the code, see here.

And second question. For this you can use the YouTube Player.It’s great control. And really simple usage:

<pre>
[self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
</pre>

I think it doesn’t make sense to explain the details , just go to github and will use the sample ☺

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img5.png)

That’s all. Happy coding!!!
