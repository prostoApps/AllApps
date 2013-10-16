//
//  TTItem.m
//  TimeTracker
//
//  Created by ProstoApps* on 5/24/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTItem.h"

NSString *const STR_ALL_CLIENTS  = @"allClients";
NSString *const STR_ALL_PROJECTS = @"allProjects";
NSString *const STR_ALL_TASKS    = @"allTasks";


NSString *const STR_CLIENT_NAME  = @"clientName";
NSString *const STR_CLIENT_SKYPE = @"clientSkype";
NSString *const STR_CLIENT_PHONE = @"clientPhone";
NSString *const STR_CLIENT_MAIL  = @"clientMail";
NSString *const STR_CLIENT_NOTES = @"clientNotes";
NSString *const STR_PROJECT_NAME = @"projectName";
NSString *const STR_TASK_NAME    = @"taskName";
NSString *const STR_TASK_COLOR   = @"taskColor";
NSString *const STR_TASK_CHECK   = @"isCheck";
NSString *const STR_START_DATE   = @"startDate";
NSString *const STR_END_DATE     = @"endDate";

NSString *const STR_COLOR_RED    = @"ff0000";
NSString *const STR_COLOR_GREEN  = @"00ff00";
NSString *const STR_COLOR_BLUE   = @"0000ff";


@implementation TTItem

@synthesize   strClientName, strClientMail, strClientNotes,strClientPhone,strClientSkype;
@synthesize   strProjectName,strTaskName,dtStartDate,dtStartTime,dtEndDate;
@synthesize   numPlaningDuration,numRealDuration,numRate,strColor,strCheck;

-(void)clear
{
    strClientName=nil;
    strClientMail=nil;
    strClientNotes=nil;
    strClientPhone=nil;
    strClientSkype=nil;
    
    strProjectName=nil;
    strTaskName=nil;
    strCheck=nil;
    strColor=nil;
    dtStartDate=nil;
    dtStartTime=nil;
    dtEndDate=nil;
    numPlaningDuration=nil;
    numRate=nil;
    numRealDuration=nil;
}

@end
