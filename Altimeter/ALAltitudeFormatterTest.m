//
//  ALAltitudeFormatterTest.m
//  Altimeter
//
//  Created by Guillaume Legrain on 18/5/14.
//  Copyright (c) 2014 Guillaume Legrain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ALAltitudeFormatter.h"

@interface ALAltitudeFormatterTest : XCTestCase

@end

@implementation ALAltitudeFormatterTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testZeroMeters
{
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:0];
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"0 m"];
    XCTAssert([output  isEqualToAttributedString:expected], @"Expected %@ to be 0 m", output);
}

- (void)testDecimalMeters
{
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:3.14159];
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"3.1 m"];
    [expected addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(1, 2)];
    XCTAssert([output  isEqualToAttributedString:expected], @"Expected %@ to be %@", output, expected);
}

- (void)test4122Meters
{
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:4122];
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"4 122 m"];
    XCTAssert([output  isEqualToAttributedString:expected], @"Expected %@ to be %@", output, expected);
}

- (void)test4122dot1Meters
{
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:4122.1];
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"4 122.1 m"];
    [expected addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 2)];
    XCTAssert([output  isEqualToAttributedString:expected], @"Expected %@ to be %@", output, expected);
}

- (void)test1000dot1Meters
{
    ALAltitudeFormatter *altitudeFormatter = [[ALAltitudeFormatter alloc] init];
    NSMutableAttributedString *output = [altitudeFormatter mutableAttributtedStringFromLocationDistance:1000.1];
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"1 000.1 m"];
    [expected addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 2)];
    XCTAssert([output  isEqualToAttributedString:expected], @"Expected %@ to be %@", output, expected);
}
@end
