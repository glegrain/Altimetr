//
//  ALAltitudeFormatter.h
//  Altimeter
//
//  Created by Guillaume Legrain on 18/5/14.
//  Copyright (c) 2014 Guillaume Legrain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface ALAltitudeFormatter : NSNumberFormatter

- (NSMutableAttributedString *)mutableAttributtedStringFromLocationDistance:(CLLocationDistance)altitude;

@end
