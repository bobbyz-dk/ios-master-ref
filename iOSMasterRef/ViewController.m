//
//  ViewController.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 15/03/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrTekst;

-(void)loadData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.txtTekst.delegate = self;
    self.tblTekst.delegate = self;
    self.tblTekst.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tekst.db"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGemTekst:(UIButton *)sender {
    NSString *query = [NSString stringWithFormat:@"insert into tekst values(null, '%@')", self.txtTekst.text];
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else {
        NSLog(@"Could not execute the query.");
    }
}

-(void)loadData {
    NSString *query = @"select * from tekst";
    
    if (self.arrTekst != nil) {
        self.arrTekst = nil;
    }
    self.arrTekst = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    [self.tblTekst reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrTekst.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfTekst = [self.dbManager.arrColumnNames indexOfObject:@"tekst"];
    NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTekst objectAtIndex:indexPath.row] objectAtIndex:indexOfTekst]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTekst objectAtIndex:indexPath.row] objectAtIndex:indexOfId]];
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
