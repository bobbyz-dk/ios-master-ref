//
//  TwitterViewController.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 03/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterApi.h"

@interface TwitterViewController ()

@end

TwitterApi *twitter;

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLastTweetLoaded:) name:@"LastTweetLoadedEvent" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnRetrieveTweet:(id)sender {
  
    if(!twitter) {
        twitter = [[TwitterApi alloc] initWithCredentials:@"LdJKh0djdb0EQ4Xpx3Dj7GPdZ" secret:@"q2DbC408vUra3Ehpab0rGozhGI2JGLFeDNBflIUwI16mG3BvbP"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadLastTweetEvent" object:[_txtScreenName text]];
}

- (void)onLastTweetLoaded:(NSNotification *)notif {
    __block NSString *tweet = [notif object];
    [_lblResult setText:tweet];
}
@end
