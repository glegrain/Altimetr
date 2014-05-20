//
//  ALAltitudeFormatter.m
//  Altimeter
//
//  Created by Guillaume Legrain on 18/5/14.
//  Copyright (c) 2014 Guillaume Legrain. All rights reserved.
//

#import "ALAltitudeFormatter.h"

@implementation ALAltitudeFormatter

- (id)init
{
    self = [super init];
    if (self) {
        [self setMaximumFractionDigits:1];
        [self setUsesGroupingSeparator:YES];
        [self setGroupingSeparator:@" "];
        [self setGroupingSize:3];
    }
    return self;
}


- (NSMutableAttributedString *)mutableAttributtedStringFromLocationDistance:(CLLocationDistance)altitude
{
    NSNumber *altitudeNumber = [NSNumber numberWithDouble:altitude];
    NSUInteger integerPartLength = [NSString stringWithFormat:@"%ul",[altitudeNumber integerValue]].length;
    const NSDecimal decimalPart = [altitudeNumber decimalValue];
    //NSUInteger decimalPartLength = NSDecimalString(&decimalPart, [NSLocale currentLocale]).length;
    
    NSUInteger decimalPartLength = decimalPart._length;
    NSString *unitString = @" m";
    
    NSString *altitudeStr = [[self stringFromNumber:altitudeNumber] stringByAppendingString:unitString];
    
    // make decimal part smaller
    NSMutableAttributedString *altitudeString = [[NSMutableAttributedString alloc] initWithString:altitudeStr];
    if (decimalPartLength > 0) {
      [altitudeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30]
                             range:NSMakeRange(integerPartLength - 1, 1 + self.maximumFractionDigits)];
    }
    
    return altitudeString;
}
@end
