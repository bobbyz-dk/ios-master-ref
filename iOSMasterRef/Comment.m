//
//  Comment.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 07/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize text;
@synthesize email;
@synthesize created;

- (id)initWithText:(NSString*)text email:(NSString*)email created:(NSString*)created {
    if((self = [super init])) {
        
        self.text = text;
        self.email = email;
        if(created)
            self.created = created;
        else {
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-dd-MM HH:mm:ss"];
            self.created = [dateFormat stringFromDate:date];
        }
    }
    return self;
}

@end
