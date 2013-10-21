//
//  TTTools.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 10/12/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTools : NSObject

+(NSString*)hexFromStr:(NSString*)str;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
