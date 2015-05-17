//
//  RestViewController.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 07/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "RestViewController.h"
#import "RestApi.h"
#import "Comment.h"

@interface RestViewController ()

@property (nonatomic, strong) NSArray *arrComments;

@end

@implementation RestViewController {
    SocketIO *socketIO;
}

NSString *wsUrlString = @"http://192.168.1.103:2403";
NSString *wsHost = @"192.168.1.103";
NSInteger wsPort = 2403;

@synthesize txtComment;
@synthesize txtEmail;

RestApi *rest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rest = [[RestApi alloc] init];
    self.tblComments.delegate = self;
    self.tblComments.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCommentPosted:) name:@"CommentPostedEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCommentReceived:) name:@"CommentsReceivedEvent" object:nil];
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    //[socketIO setResourceName:@"comment"];
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                wsHost, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,
                                @"auth", NSHTTPCookieName,
                                @"12345678123456768", NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSArray *cookies = [NSArray arrayWithObjects:cookie, nil];
    
    //socketIO.cookies = cookies;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"transport", @"polling",
                                nil];
    
    [socketIO connectToHost:wsHost onPort:wsPort withParams:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPost:(id)sender {
    if([[txtComment text] length] > 0 && [[txtEmail text] length] > 0) {
        Comment *comment = [[Comment alloc] initWithText:[txtComment text] email:[txtEmail text] created:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostCommentEvent" object:comment];
    }
}

- (void)onCommentPosted:(NSNotification *)notif {
    //__block NSString *result = [notif object]; // copyWithZone unrecognized selector exception

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post result" message:@"Posted!"/*result*/ delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (IBAction)btnGet:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCommentsEvent" object:nil];
}

- (void)onCommentReceived:(NSNotification *)notif {
    self.arrComments = [notif userInfo];
    NSLog(@"Gotten");
    [self.tblComments reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrComments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellComment" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrComments objectAtIndex:indexPath.row] objectForKey:@"text"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrComments objectAtIndex:indexPath.row] objectForKey:@"created"]];
    
    return cell;
}

- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Socket.IO connected.");
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSLog(@"Socket.IO didReceiveEvent.");
}

-(void)socketIO:(SocketIO *)socket onError:(NSError *)error {
    if ([error code] == SocketIOUnauthorized) {
        NSLog(@"Socket.IO Not authorized.");
    } else {
        NSLog(@"Socket.IO Err: %@.", error);
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Socket.IO disconnected. Err: %@.", error);
}

@end
