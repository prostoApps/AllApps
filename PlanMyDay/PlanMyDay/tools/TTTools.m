//
//  TTTools.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 10/12/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTTools.h"

@implementation TTTools

+(NSString*)hexFromStr:(NSString*)str
{
    NSData* nsData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const char* data = [nsData bytes];
    NSUInteger len = nsData.length;
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < len; ++i)[hex appendFormat:@"%0.2hhx", data[i]];
    return hex;
}

@end
