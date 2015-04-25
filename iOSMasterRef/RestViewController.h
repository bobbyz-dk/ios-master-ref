//
//  RestViewController.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 07/04/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;


- (IBAction)btnPost:(id)sender;
- (IBAction)btnGet:(id)sender;

@end
