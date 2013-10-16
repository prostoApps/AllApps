//
//  TTAppDataManager.m
//  TimeTracker
//
//  Created by ProstoApps* on 6/28/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDataManager.h"

@implementation TTAppDataManager


NSString *const STR_SORT_PARAMETER_TASK_NAME         = @"name";
NSString *const STR_SORT_PARAMETER_CLIENT_NAME       = @"clientName";
NSString *const STR_SORT_PARAMETER_PROJECT_NAME      = @"projectName";
NSString *const STR_SORT_PARAMETER_DATE              = @"date";
NSString *const STR_SORT_PARAMETER_COLOR             = @"color";
NSString *const STR_SORT_PARAMETER_TASK_COMPLETED    = @"taskCompleted";
NSString *const STR_SORT_PARAMETER_TASK_DURATION     = @"taskDuration";

static TTLocalDataManager *localDataManager;
//@synthesize localDataManager;

@synthesize segmentIndexNewProject;
@synthesize dictNewProjectIndexPaths;

+ (TTAppDataManager *)sharedAppDataManager
{
    static TTAppDataManager *sharedAppDataManager;

//    static TTAppDataManager *iCloudDataManager;
    
    @synchronized(self)
    {
        if (!sharedAppDataManager)
        {
            sharedAppDataManager = [[TTAppDataManager alloc] init];
//            localDataManager = [[TTLocalDataManager alloc] init];
            [sharedAppDataManager initManagers];
        }
        return sharedAppDataManager;
    }
}

-(void)initManagers
{
    localDataManager = [[TTLocalDataManager alloc] init];
    [localDataManager readLocalData];
//    [localDataManager initTestData];
}

-(NSDictionary*)readDataFromFile:(NSString*)pathToFile
{
    NSDictionary *dictDataFromFile = [NSDictionary dictionaryWithContentsOfFile:pathToFile];
    NSLog(@"AppDataManager::readDataFromFile: %@",dictDataFromFile);
    return dictDataFromFile;
}

//Get Path to DOCUMENTS in app root;
-(NSString*)getDocumentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSString*)getProjectsFilePath
{
    NSString * test =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
}
-(void)loadNewProjectFormData{
    // загружаем стили ячеек для формы
    if (dictNewProjectFormData.count == 0) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
        dictNewProjectFormData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        //создаем пустые дикшионари для Индекс значений со структурой (Task,Project,Client)
        dictNewProjectIndexPaths = [[NSMutableDictionary alloc] init];
        for(id key in [dictNewProjectFormData allKeys]){
            [dictNewProjectIndexPaths setObject:[[NSMutableDictionary alloc] init] forKey:key];
        }
    }
}

-(NSObject*)getNewProjectFormDataValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath{
    return [[[[[dictNewProjectFormData objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
               objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS] objectAtIndex:[indexPath row]] objectForKey:value];
}

-(NSArray*)getNewProjectFormData{
    
    return [dictNewProjectFormData objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]];
    
}
-(void)saveNewProjectFormDataValue:(NSObject*)object byIndexPath:(NSIndexPath*)indexPath{
    
    [[[[[dictNewProjectFormData objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
        objectAtIndex:[indexPath section]]objectForKey:STR_NEW_PROJECT_CELLS]
            objectAtIndex:[indexPath row]] setObject:object forKey:STR_NEW_PROJECT_VALUE];
    
}
-(void) clearNewProjectFormData{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    NSMutableDictionary * clearDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [dictNewProjectFormData setObject:[clearDictionary objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
                               forKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]];
}

//Save Item to Device
-(BOOL)saveTTItem
{
    BOOL * bReadyToWriteData = NO;
    TTItem * item = [[TTItem alloc] init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    item.strClientName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                               byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT]]];
    
    //Если выбрана категория "создать таск", сохраняем таск с проектом и клиентом
    if ([[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_TASK])
    {

        item.strTaskName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                                 byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_NAME]]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        
        item.strColor = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_COLOR]]];
        
        
        item.dtStartDate = [self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_START_DATE]];
        item.dtEndDate = [self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_END_DATE]];
        
        dictData = [self serializeTaskData:item];
        bReadyToWriteData = [localDataManager saveItemData:dictData];
        
    }    //Если выбрана категория "создать проект", сохраняем только проект с клиентом
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        dictData = [self serializeProjectData:item];
        bReadyToWriteData = [localDataManager saveProjectData:dictData];
    }    //Если выбрана категория "создать проект", сохраняем только клиента
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        item.strClientSkype = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_SKYPE]]];
     
        item.strClientPhone = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_PHONE]]];
     
        item.strClientMail = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_MAIL]]];
     
        item.strClientNotes = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_NOTE]]];
        dictData = [self serializeClientData:item];
        bReadyToWriteData = [localDataManager saveClientData:dictData];
    }
    
    if (bReadyToWriteData == YES)
    {
        [localDataManager writeData:[localDataManager dictLocalData]
                             toFile:[self getProjectsFilePath] ];
        return YES;
    }
    return NO;
}

#pragma mark - Edit Task with new Data
-(NSMutableDictionary*) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData
{
    NSMutableDictionary * dictTaskToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictTaskToEdit copyItems:YES];
    
    for(NSString* key in [dictNewData allKeys])
    {
        if([dictTaskToReturn objectForKey:key] != [dictNewData objectForKey:key] )
        {
            [dictTaskToReturn setObject:[dictNewData objectForKey:key] forKey:key];
        }
    }
    return dictTaskToReturn;
}

#pragma mark - Clear Task
-(NSMutableDictionary*) clearTask:(NSMutableDictionary*) dictTaskToClear
{
    NSMutableDictionary * dictTaskToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictTaskToClear copyItems:YES];
    
    for(NSString* key in [dictTaskToReturn allKeys])
    {
        [dictTaskToReturn setObject:nil forKey:key];
    }
    return dictTaskToReturn;
}

#pragma mark - Remove Task Section
-(BOOL) removeTask:(NSMutableDictionary*) dictTaskToRemove
{
    return [localDataManager removeTask:dictTaskToRemove];
}

//remove project
-(BOOL) removeProject:(NSMutableDictionary*) dictProjectToRemove
{
    return [localDataManager removeProject:dictProjectToRemove];
}

-(BOOL) removeClient:(NSMutableDictionary*) dictClientToRemove
{
    return [localDataManager removeClient:dictClientToRemove];
}

#pragma mark - Remove All Tasks
-(BOOL) removeAllTask:(NSMutableDictionary*) dictTaskToRemove
{
    return [localDataManager removeAllTasks];
}


#pragma mark - Serialize Task Data
-(NSMutableDictionary*)serializeClientData:(TTItem*)item
{
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init ];
    if (item.strClientName != nil)
    {
        [dictData setObject:item.strClientName forKey:STR_CLIENT_NAME];
    }
    if (item.strClientName != nil)
    {
        [dictData setObject:item.strClientMail forKey:STR_CLIENT_MAIL];
    }
    if (item.strClientName != nil)
    {
        [dictData setObject:item.strClientSkype forKey:STR_CLIENT_SKYPE];
    }
    if (item.strClientName != nil)
    {
        [dictData setObject:item.strClientPhone forKey:STR_CLIENT_PHONE];
    }
    if (item.strClientName != nil)
    {
        [dictData setObject:item.strClientNotes forKey:STR_CLIENT_NOTES];
    }

    return dictData;
}

-(NSMutableDictionary*)serializeProjectData:(TTItem*)item
{
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     item.strClientName,  STR_CLIENT_NAME,
                                     item.strProjectName, STR_PROJECT_NAME,
                                     item.strTaskName,    STR_TASK_NAME,
                                     item.strColor,       STR_TASK_COLOR,
                                     item.strClientMail,  STR_CLIENT_MAIL,
                                     item.strClientSkype, STR_CLIENT_SKYPE,
                                     item.strClientPhone, STR_CLIENT_PHONE,
                                     item.strClientNotes, STR_CLIENT_NOTES,
                                     // item.strCheck,      STR_TASK_CHECK,
                                     // item.dtStartDate,   STR_START_DATE,
                                     // item.dtEndDate,     STR_END_DATE,
                                     nil];
    
    return dictData;
}

-(NSMutableDictionary*)serializeTaskData:(TTItem*)item
{
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     item.strClientName,  STR_CLIENT_NAME,
                                     item.strProjectName, STR_PROJECT_NAME,
                                     item.strTaskName,    STR_TASK_NAME,
                                     item.strColor,       STR_TASK_COLOR,
                                     item.dtStartDate,   STR_START_DATE,
                                     item.dtEndDate,     STR_END_DATE,
                                     // item.strCheck,      STR_TASK_CHECK,
                                     nil];
    
    return dictData;
}


-(TTItem*)deserializeData:(NSDictionary*)data
{
    TTItem *item;
   // [item setItemData:data];
    return item;
}

#pragma mark - Get Tasks by param
-(NSMutableArray*)getAllTasks
{
    NSMutableArray *arrAllTasks;
    arrAllTasks = [[NSMutableArray alloc] initWithArray:[localDataManager getAllTasks]];
    return arrAllTasks;
}

-(NSMutableArray*)getAllProjects
{
    NSMutableArray *arrAllProjects;
    arrAllProjects = [[NSMutableArray alloc] initWithArray:[localDataManager getAllProjects]];
    return arrAllProjects;
}

-(NSMutableArray*)getAllClients
{
    NSMutableArray *arrAllClients;
    arrAllClients = [[NSMutableArray alloc] initWithArray:[localDataManager getAllClients]];
    return arrAllClients;
}

-(NSMutableArray*)getAllTasksForToday
{
    NSMutableArray *arrAllTasks;
    arrAllTasks  = [[NSMutableArray alloc] initWithArray:[localDataManager getAllTasksForToday]];
    return arrAllTasks;
}

#pragma mark - Sort Tasks with parameter
+(NSMutableArray*)sortTasks:(NSMutableArray*)arrTasksToSort byParameter:(NSString*)strSortParameter withValue:(NSString*) strSortParameterValue
{
    if (!strSortParameterValue)
    {
        NSLog(@"NIL SORT PARAMETER VALUE");
        return nil;
    }
    
    NSMutableArray * arrTasksToReturnHolder = [[NSMutableArray alloc] init];

    if(strSortParameter == STR_SORT_PARAMETER_CLIENT_NAME)
    {
     //   [arrTasksToSort sor
    }
    else if(strSortParameter == STR_SORT_PARAMETER_CLIENT_NAME)
    {
        
    }
    else if(strSortParameter == STR_SORT_PARAMETER_PROJECT_NAME)
    {
        
    }
    else if(strSortParameter == STR_SORT_PARAMETER_TASK_COMPLETED)
    {
        for (NSMutableDictionary *dictTask in arrTasksToSort)
        {
            if ([dictTask objectForKey:STR_TASK_CHECK ] == strSortParameterValue)
            {
                [arrTasksToSort addObject:dictTask];
            }
        }
    }
    else if(strSortParameter == STR_SORT_PARAMETER_TASK_DURATION)
    {
        
    }
    else if(strSortParameter == STR_SORT_PARAMETER_COLOR)
    {
        for (NSMutableDictionary *dictTask in arrTasksToSort)
        {
            if ([dictTask objectForKey:STR_TASK_COLOR ] == strSortParameterValue)
            {
                [arrTasksToSort addObject:dictTask];
            }
        }
    }
    else if(strSortParameter == STR_SORT_PARAMETER_DATE)
    {
        
    }

    return arrTasksToReturnHolder;
}



- (UIColor *)colorWithHexString:(NSString *)stringToConvert
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
- (UIButton*)makeButtonStyled:(UIButton*)button{
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    return button;
}
- (NSString *)convertDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dt = [formatter stringFromDate:date];
    return dt;
}


@end
