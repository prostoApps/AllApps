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
NSString *const STR_DURATION     = @"duration";
NSString *const STR_THIS_TASK_IS_CHECKED = @"isChecked";

NSString *const STR_ARC          = @"arc";

NSString *const STR_COLOR_CARROT     = @"fd9426";
NSString *const STR_COLOR_CUCUMBER   = @"53d769";
NSString *const STR_COLOR_PLUM       = @"1c7efb";
NSString *const STR_COLOR_STRAWBERRY = @"fc3e39";

/*Carrot fd9426
Cucumber 53d769
Plum 1c7efb
Strawberry fc3e39
*/
@implementation TTItem

@synthesize   strClientName, strClientMail, strClientNotes,strClientPhone,strClientSkype;
@synthesize   strProjectName,strTaskName,dtStartDate,dtStartTime,dtEndDate;
@synthesize   numPlaningDuration,numRealDuration,numRate,strColor;
@synthesize   strIsChecked;

-(id)initWithEmptyFields
{
        self = [super init];
        if(self) {
            strTaskName = @"";
            strProjectName = @"";
            strClientName = @"";
            strColor = @"";
            numRealDuration = 0;
            numPlaningDuration = 0;
            strIsChecked = 0;
        }
        return(self);
}

-(void)clear
{
    strClientName=nil;
    strClientMail=nil;
    strClientNotes=nil;
    strClientPhone=nil;
    strClientSkype=nil;
    
    strProjectName=nil;
    strTaskName=nil;
    strIsChecked=nil;
    strColor=nil;
    dtStartDate=nil;
    dtStartTime=nil;
    dtEndDate=nil;
    numPlaningDuration=nil;
    numRate=nil;
    numRealDuration=nil;
}

@end
