//
//  ALViewController.h
//  Altimeter
//
//  Created by Guillaume Legrain on 24/4/14.
//  Copyright (c) 2014 Guillaume Legrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ALViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UILabel *alitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UITextField *coordsLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *horizontalAccuracyProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *verticalAccuracyProgress;

@end
