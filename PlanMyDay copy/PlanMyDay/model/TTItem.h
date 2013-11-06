//
//  TTItem.h
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 5/24/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTItem : NSObject
{
    NSString *strClientName;
    NSString *strProjectName;
    NSString *strTaskName;
    NSDate   *dtStartDate;
    NSDate   *dtStartTime;
    int      *numPlaningDuration;
    int      *numRealDuration;
    int      *numRate;
    NSString *strColor;
}
@property(nonatomic, retain) NSString *strClientName;
@property(nonatomic, retain) NSString *strProjectName;
@property(nonatomic, retain) NSString *strTaskName;
@property(nonatomic, retain) NSDate   *dtStartTime;
@property(nonatomic, retain) NSDate   *dtStartDate;
@property(nonatomic, assign) int      *numPlaningDuration;
@property(nonatomic, assign) int      *numRealDuration;
@property(nonatomic, assign) int      *numRate;
@property(nonatomic, retain) NSString *strColor;

-(void)clear;
@end
