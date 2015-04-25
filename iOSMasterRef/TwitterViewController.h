//
//  TwitterViewController.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 03/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

- (IBAction)btnRetrieveTweet:(id)sender;
- (void)onLastTweetLoaded:(NSNotification *)notif;

@end
