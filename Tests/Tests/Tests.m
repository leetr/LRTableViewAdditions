//
//  LRTableViewTestsTests.m
//  LRTableViewTestsTests
//
//  Created by Denis Smirnov on 2014-04-22.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests : XCTestCase

@end

@implementation Tests

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

- (void)test1Eq1
{
    XCTAssert(1 == 1, @"This should always be true");
}
@end
