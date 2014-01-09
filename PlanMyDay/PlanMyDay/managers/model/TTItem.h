//
//  TTItem.h
//  TimeTracker
//
//  Created by ProstoApps* on 5/24/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const STR_ALL_CLIENTS;
extern NSString *const STR_ALL_PROJECTS;
extern NSString *const STR_ALL_TASKS;

extern NSString *const STR_CLIENT_NAME;
extern NSString *const STR_CLIENT_SKYPE;
extern NSString *const STR_CLIENT_PHONE;
extern NSString *const STR_CLIENT_MAIL;
extern NSString *const STR_CLIENT_NOTES;
extern NSString *const STR_PROJECT_NAME;
extern NSString *const STR_TASK_NAME;
extern NSString *const STR_TASK_COLOR;
extern NSString *const STR_THIS_TASK_IS_CHECKED;
extern NSString *const STR_START_DATE;
extern NSString *const STR_END_DATE;
extern NSString *const STR_DURATION;
extern NSString *const STR_ARC;

extern NSString *const STR_COLOR_CARROT;
extern NSString *const STR_COLOR_CUCUMBER;
extern NSString *const STR_COLOR_PLUM;
extern NSString *const STR_COLOR_STRAWBERRY;
//extern NSString *const VIEW_STATISTICS;
//extern NSString *const VIEW_STATISTICS;
//extern NSString *const VIEW_STATISTICS;

@interface TTItem : NSObject
{
    NSString *strClientName;
    NSString *strProjectName;
    NSString *strTaskName;
    NSDate   *dtStartDate;
    NSDate   *dtStartTime;
    NSDate   *dtEndDate;
    NSTimeInterval      *numPlaningDuration;
    double   *numRealDuration;
    int      *numRate;
    NSString *strColor;
    NSString *strIsChecked;
}
@property(nonatomic, retain) NSString *strClientName;
@property(nonatomic, retain) NSString *strClientMail;
@property(nonatomic, retain) NSString *strClientSkype;
@property(nonatomic, retain) NSString *strClientPhone;
@property(nonatomic, retain) NSString *strClientNotes;
@property(nonatomic, retain) NSString *strProjectName;
@property(nonatomic, retain) NSString *strTaskName;
@property(nonatomic, retain) NSDate   *dtStartTime;
@property(nonatomic, strong) NSDate   *dtStartDate;
@property(nonatomic, retain) NSDate   *dtEndDate;
@property(nonatomic, assign) NSTimeInterval      *numPlaningDuration;
@property(nonatomic, assign) double    *numRealDuration;
@property(nonatomic, assign) int      *numRate;
@property(nonatomic, retain) NSString *strColor;
@property(nonatomic, retain) NSString   *strIsChecked;

-(void)clear;
-(id)initWithEmptyFields;
-(id)initWithDictionary:(NSDictionary*)dictTaskData;
@end
