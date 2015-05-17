//
//  GPSViewController.h
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 01/05/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface GPSViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;

- (IBAction)btnShowLocation:(id)sender;

@end
