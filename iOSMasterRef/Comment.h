//
//  Comment.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 07/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, retain) NSString *text, *email, *created;

- (id)initWithText:(NSString*)text email:(NSString*)email created:(NSString*)created;

@end
