//
//  ALViewController.m
//  Altimeter
//
//  Created by Guillaume Legrain on 24/4/14.
//  Copyright (c) 2014 Guillaume Legrain. All rights reserved.
//

#import "ALViewController.h"
#import "ALAltitudeFormatter.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate]; // Because we have a black background
    

    // Rotate vertical accuracy to vertical
    //self.verticalAccuracyProgress.transform = CGAffineTransformMakeRotation(M_PI * 0.5); FIXME
    
    
    
    if (_locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    
    // Check if the application is authorized to use location services
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        // The application is not authorized to use location services,
        // so a dialog will warn the user to authorize location services
        UIAlertView *notAuthorizedAlert = [[UIAlertView alloc] initWithTitle:@"Authorization Error" message:@"The application is not authorized to use location services, please check your Location Services in Privacy > Location." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [notAuthorizedAlert show];
    }
    
    if (_location == nil)
        self.location = [[CLLocation alloc] init];
    
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
    // Disable coordsLabel editing
    self.coordsLabel.delegate = self;
    self.coordsLabel.inputView = [[UIView alloc] init];
    //[self.coordsLabel setEnabled:NO];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    
    NSNumber *altitude = [NSNumber numberWithDouble:self.location.altitude];
    
    #if (TARGET_IPHONE_SIMULATOR)
    altitude = [NSNumber numberWithDouble:4122.1];
    #endif
    
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:0];
    
    // Format altitude
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:1];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setGroupingSeparator:@" "];
    [numberFormatter setGroupingSize:3];
    
    NSString *altitudeStr = [NSString stringWithFormat:@"%@ m",[numberFormatter stringFromNumber:altitude]];

    
    // make decimal part smaller
    NSMutableAttributedString *altitudeString = [[NSMutableAttributedString alloc]initWithString:altitudeStr];
    [altitudeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(altitudeStr.length - 4, 2)];
    
    // negative value in accuracy indicates that the altitude value is invalid.
    // Accuracy is in meters.
    NSString *verticalAccuracyString;
    if (self.location.verticalAccuracy < 0) {
        verticalAccuracyString = @"Not available";
    } else {
        verticalAccuracyString = [NSString stringWithFormat:@"+/- %f m", self.location.verticalAccuracy];
    }
    #if (TARGET_IPHONE_SIMULATOR)
    verticalAccuracyString = @"+/- 5.000000 m";
    #endif
    
    // Update UI

    self.verticalAccuracyLabel.text = [NSString stringWithFormat:@"Vertical accuracy: %@", verticalAccuracyString];
    self.horizontalAccuracyLabel.text = [NSString stringWithFormat:@"Horizontal accuracy: +/- %f m", self.location.horizontalAccuracy];

    [self updateProgressBar: self.horizontalAccuracyProgress withAccuracy:self.location.horizontalAccuracy];
    [self updateProgressBar:self.verticalAccuracyProgress withAccuracy:self.location.verticalAccuracy];
    
    #if (TARGET_IPHONE_SIMULATOR)
    [self updateProgressBar:self.verticalAccuracyProgress withAccuracy:5];
    #endif
    
    self.alitudeLabel.attributedText = altitudeString;
    self.coordsLabel.text = [NSString stringWithFormat:@"%f %f", self.location.coordinate.latitude, self.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", error);
   
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // This can occur when Core Location is first starting up and isn’t able to immediately determine its position
        return; // retry
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message: error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

}

- (void)updateProgressBar:(UIProgressView *)progressView withAccuracy:(CLLocationDistance) accuracy
{
    float progress;
    if (accuracy < 100 && accuracy > 0) {
        progress = 1 - accuracy/100;
    } else {
        progress = 0;
    }
    
    [progressView setProgress: progress animated:YES];
    if (accuracy < 10) {
        progressView.progressTintColor = [UIColor greenColor];
    } else if (accuracy > 100) {
        progressView.progressTintColor = [UIColor redColor];
    } else if (accuracy < 20) {
        progressView.progressTintColor = [UIColor yellowColor];
    } else {
        progressView.progressTintColor = [UIColor orangeColor];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range    replacementString:(NSString *)string{
    return NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // User taped outside the textField, close it
    [self.coordsLabel endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



@end
