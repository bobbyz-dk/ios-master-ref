
//
//  TwitterApi.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 06/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#ifndef iOSMasterRef_TwitterApi_h
#define iOSMasterRef_TwitterApi_h


#endif

#import <Foundation/Foundation.h>

@interface TwitterApi : NSObject 

- (id)initWithCredentials:(NSString *) key secret:(NSString *) secret;
- (void)onLoadLastTweet:(NSNotification *)notif;

@property (retain) NSString *key;
@property (retain) NSString *secret;

@end