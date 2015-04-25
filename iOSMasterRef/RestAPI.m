//
//  RestApi.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 07/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "RestApi.h"
#import "Comment.h"

@implementation RestApi

NSString *BACKEND = @"http://192.168.1.103:2403";

- (id)init {
    
    if((self = [super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPostComment:) name:@"PostCommentEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetComments:) name:@"GetCommentsEvent" object:nil];
    }
    return self;
}

- (void)onPostComment:(NSNotification *)notif {
    Comment *comment = [notif object];
    NSDictionary *body = @{@"text":comment.text, @"email":comment.email, @"created":comment.created};
    NSError* error = nil;
    id bodyData = [NSJSONSerialization dataWithJSONObject:body
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    
    //Prepare to establish the connection
    NSString *restUrl = [NSString stringWithFormat:@"%@/%@", BACKEND, @"comment"];
    NSURL *url = [NSURL URLWithString:restUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
             [self receivedPostCommentResponse:(NSHTTPURLResponse*)response data:data];
         //else if ([data length] == 0 && error == nil)
         //[delegate emptyReply];
         //else if (error != nil && error.code == NSURLErrorTimedOut)
         //[delegate timedOut];
         else if (error != nil)
             [self receivedPostCommentError:error];
     }];

}

- (void)receivedPostCommentResponse:(NSHTTPURLResponse *)response data:(NSData *)data {
    NSMutableDictionary *responseData =[[NSMutableDictionary alloc] init];
    
    [responseData setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"responseStatus"];
    
    if (response.statusCode == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentPostedEvent" object:self userInfo:nil];
    }
    
}

- (void)receivedPostCommentError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)onGetComments:(NSNotification *)notif {
    
    //Prepare to establish the connection
    NSString *restUrl = [NSString stringWithFormat:@"%@/%@", BACKEND, @"comment"];
    NSURL *url = [NSURL URLWithString:restUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    //Make the request
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
             [self receivedComments:(NSHTTPURLResponse*)response data:data];
         //else if ([data length] == 0 && error == nil)
         //[delegate emptyReply];
         //else if (error != nil && error.code == NSURLErrorTimedOut)
         //[delegate timedOut];
         else if (error != nil)
             [self receivedCommentsError:error];
     }];
}

- (void) receivedComments:(NSHTTPURLResponse *)response data:(NSData *)data {
    NSError *error = nil;
    
    if (response.statusCode == 200) {
        
        //Parse the data as a series of Note objects
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentsReceivedEvent" object:self userInfo:json];
    }
}

- (void) receivedCommentsError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end
