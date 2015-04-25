//
//  TwitterApi.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 06/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "TwitterApi.h"

@implementation TwitterApi {
    
}

@synthesize key;
@synthesize secret;

- (id)initWithCredentials:(NSString *) key secret:(NSString *) secret {
    
    if((self = [super init])) {
        
        self.key = key;
        self.secret = secret;
    
        [[Twitter sharedInstance] startWithConsumerKey:key consumerSecret:secret];
        [Fabric with:@[TwitterKit]];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadLastTweet:) name:@"LoadLastTweetEvent" object:nil];
    }
    return self;
}

- (void)onLoadLastTweet:(NSNotification *)notif {
    __block NSString *result;
    NSString *screenName = [notif object];
    
    NSString *StatusesUserTimelineEndpoint = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *params = @{@"screen_name":screenName, @"count":@"1"};
    
    [TwitterKit logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if(guestSession) {
            NSError *clientError;
            NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                     URLRequestWithMethod:@"GET"
                                     URL:StatusesUserTimelineEndpoint
                                     parameters:params
                                     error:&clientError];
            
            if(request) {
                [[[Twitter sharedInstance] APIClient]
                 sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                     if(data) {
                         NSError *jsonError;
                         NSDictionary *json = [NSJSONSerialization
                                               JSONObjectWithData:data
                                               options:0
                                               error:&jsonError];
                         result = [[(NSArray*)json objectAtIndex:0] objectForKey:@"text"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"LastTweetLoadedEvent" object:result];
                     }
                     else {
                         NSLog(@"Error: %@", connectionError);
                     }
                 }];
            }
            else {
                NSLog(@"Error: %@", clientError);
            }
        }
        else {
            NSLog(@"Unable to log in as guest: %@", [error localizedDescription]);
        }
    }];

}

@end

