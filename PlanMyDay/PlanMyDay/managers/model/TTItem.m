//
//  TTItem.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 5/24/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTItem.h"

NSString *const STR_ALL_CLIENTS  = @"allClients";
NSString *const STR_ALL_PROJECTS = @"allProjects";
NSString *const STR_ALL_TASKS    = @"allTasks";


NSString *const STR_CLIENT_NAME  = @"clientName";
NSString *const STR_PROJECT_NAME = @"projectName";
NSString *const STR_TASK_NAME    = @"taskName";
NSString *const STR_TASK_COLOR   = @"taskColor";
NSString *const STR_TASK_CHECK   = @"isCheck";
NSString *const STR_START_DATE   = @"startDate";
NSString *const STR_END_DATE     = @"endDate";


@implementation TTItem

@synthesize   strClientName, strProjectName,strTaskName,dtStartDate,dtStartTime,dtEndDate;
@synthesize   numPlaningDuration,numRealDuration,numRate,strColor,strCheck;

-(void)clear
{
    strClientName=nil;
    strProjectName=nil;
    strTaskName=nil;
    strCheck=nil;
    dtStartDate=nil;
    dtStartTime=nil;
    dtEndDate=nil;
    numPlaningDuration=nil;
    numRate=nil;
    numRealDuration=nil;
}

@end
