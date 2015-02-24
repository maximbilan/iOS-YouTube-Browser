# iOS YouTube Browser Sample

This tutorial explains how to create simple <i>iOS</i> application which working with <i>YouTube API<i/>.

First of all, you should create <i>Google</i> account, if you haven’t. Go to <a href="https://console.developers.google.com/project">Google Developers Console</a> and create the project.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img1.png)

In created project, you will have lots of settings, statistics, something else. For your application we need to enable <i>YouTube API</i>.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img2.png)

Also you need to create <i>iOS</i> key by this <a href="https://code.google.com/apis/console/?noredirect">link</a> on the <i>API</i> access tab and ‘Create new iOS key’ button.

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img3.png)

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img4.png)

Now all settings were set up.

We have two question for our simple application. How to receive data from <i>YouTube</i>? And how to play <i>YouTube</i> videos in <i>UIKit</i>?

For receiving the data we will use the next <a href="https://developers.google.com/apis-explorer/#p/youtube/v3/youtube.search.list">request</a>. Google provides lots of information about API, you can found <a href="https://developers.google.com/youtube/v3/">here</a>. Full information about API, <a href="https://developers.google.com/youtube/v3/sample_requests">samples</a>, etc.

Sample code for request using <i>AFNetworking</i>:

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

Here not comfortable for reading the code, see <a href="https://github.com/maximbilan/ios_youtube_browser/blob/master/ios_youtube_browser/MainViewController.m">here</a>.

And second question. For this you can use the <a href="https://github.com/youtube/youtube-ios-player-helper">YouTube Player</a>. It’s great control. And really simple usage:

<pre>
[self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
</pre>

I think it doesn’t make sense to explain the details, just go to <a href="https://github.com/maximbilan/ios_youtube_browser">github</a> and will use the sample ☺

![alt tag](https://raw.github.com/maximbilan/ios_youtube_browser/master/img/img5.png)

That’s all. Happy coding!!!
