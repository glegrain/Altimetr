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
    NSString *integerPartString = [NSString stringWithFormat:@"%d",[altitudeNumber intValue]];
    NSUInteger integerPartLength = integerPartString.length;
    BOOL hasDecimalPart = !(altitude == floor(altitude));
    
    NSString *unitString = @" m";
    
    NSString *altitudeStr = [[self stringFromNumber:altitudeNumber] stringByAppendingString:unitString];
    
    // make decimal part smaller
    NSMutableAttributedString *altitudeString = [[NSMutableAttributedString alloc] initWithString:altitudeStr];
    if (hasDecimalPart) {
        NSUInteger formattedIntegerPartLength = integerPartLength + integerPartLength/self.groupingSize;
      [altitudeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30]
                             range:NSMakeRange(formattedIntegerPartLength, 1 + self.maximumFractionDigits)];
    }
    
    return altitudeString;
}
@end
