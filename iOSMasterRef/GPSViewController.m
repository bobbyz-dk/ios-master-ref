//
//  GPSViewController.m
//  iOSMasterRef
//
//  Created by Bobby Nielsen on 01/05/15.
//  Copyright (c) 2015 CreatorMinds. All rights reserved.
//

#import "GPSViewController.h"

@implementation GPSViewController {
    CLLocationManager *locationManager;
}

@synthesize lblLongitude;
@synthesize lblLatitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
}

- (IBAction)btnShowLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        lblLongitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        lblLatitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

@end
