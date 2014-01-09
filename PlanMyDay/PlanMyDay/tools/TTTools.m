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

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (void)showPopUpOk:(NSDictionary *)parametrs{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[parametrs objectForKey:@"title"] message:[parametrs objectForKey:@"message"] delegate:self cancelButtonTitle:[parametrs objectForKey:@"titleButton"] otherButtonTitles:nil];
//    UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
//    someTextView.backgroundColor = [UIColor clearColor];
//    someTextView.textColor = [UIColor whiteColor];
//    someTextView.editable = NO;
//    someTextView.font = [UIFont systemFontOfSize:15];
//    someTextView.text = @"Enter Text Here";
//    [alert addSubview:someTextView];
    [alert show];
}

+ (UIButton*)makeButtonStyled:(UIButton*)button{
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    return button;
}
+ (NSString *)convertDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dt = [formatter stringFromDate:date];
    return dt;
}

@end
