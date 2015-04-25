//
//  ViewController.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 15/03/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtTekst;

- (IBAction)btnGemTekst:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblTekst;

@end

