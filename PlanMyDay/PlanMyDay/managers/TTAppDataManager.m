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

@synthesize dictOfTableFieldIndexPaths;

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
    
    //load fileds options
    [self loadTableFieldsOptions];
//    [localDataManager initTestData];
}

-(NSMutableDictionary*)readDataFromFile:(NSString*)pathToFile
{
    NSMutableDictionary *dictDataFromFile = [NSMutableDictionary dictionaryWithContentsOfFile:pathToFile];
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
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
}
-(void)loadTableFieldsOptions{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    // загружаем опции ячеек для формы
    NSMutableDictionary * dictAddedFields = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ( dictTableFieldsOption.count == 0) {
        dictTableFieldsOption = [[NSMutableDictionary alloc] init];
    }
    if ( dictOfTableFieldIndexPaths.count == 0) {
        dictOfTableFieldIndexPaths = [[NSMutableDictionary alloc] init];
    }
    
    for (id key in [dictAddedFields allKeys]) {
        if ([dictTableFieldsOption objectForKey:key] == nil ) {
         
            [dictTableFieldsOption setObject:[dictAddedFields objectForKey:key] forKey:key];
            [dictOfTableFieldIndexPaths setObject:[[NSMutableDictionary alloc] init] forKey:key];
            int section = 0;
            for(NSDictionary * arrSection in [[dictAddedFields objectForKey:key] allObjects]){
                //  NSLog(@"%d",section);
                int row = 0;
                for(NSDictionary * arrRow in [[arrSection objectForKey:STR_NEW_PROJECT_CELLS] allObjects]){
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [[dictOfTableFieldIndexPaths objectForKey:key] setObject:indexPath forKey:[arrRow objectForKey:STR_NEW_PROJECT_NAME]];
                    row++;
                }
                section++;
            }
        }
    }
    
}

-(NSArray*)getTableFieldsOptionsByCategory:(NSString*)category{
    return [dictTableFieldsOption objectForKey:category];
}
-(void) clearTableFieldsOptionsByCategory:(NSString *)category{
    [dictTableFieldsOption removeObjectForKey:category];
    [dictOfTableFieldIndexPaths removeObjectForKey:category];
}
-(NSObject*)getTableFieldsOptionValueByIndexPath:(NSIndexPath *)indexPath onCategory:(NSString*)category; {
    return [[[[[dictTableFieldsOption objectForKey:category]
               objectAtIndex:[indexPath section]]objectForKey:STR_NEW_PROJECT_CELLS]
             objectAtIndex:[indexPath row]] objectForKey:STR_NEW_PROJECT_VALUE];
}

-(NSIndexPath*)getTableFieldsOptionIndexPathByValue:(NSString*)value onCategory:(NSString *)category{
    
    return [[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:value];

}

-(void)saveTableFieldsOptionValue:(NSObject*)object byIndexPath:(NSIndexPath*)indexPath onCategory:(NSString *)category{
    
    [[[[[dictTableFieldsOption objectForKey:category]
        objectAtIndex:[indexPath section]]objectForKey:STR_NEW_PROJECT_CELLS]
            objectAtIndex:[indexPath row]] setObject:object forKey:STR_NEW_PROJECT_VALUE];
    
}


-(void)updateNewTaskFormFieldsWithData:(TTItem*) item onCategory:(NSString *)category
{
    
    
    [self saveTableFieldsOptionValue:item.strTaskName
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_TASK onCategory:category]
                          onCategory:category];
    [self saveTableFieldsOptionValue:item.strProjectName
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_PROJECT onCategory:category]
                          onCategory:category];
    [self saveTableFieldsOptionValue:item.strClientName
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_CLIENT onCategory:category]
                          onCategory:category];
    [self saveTableFieldsOptionValue:item.strColor
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_COLOR onCategory:category]
                          onCategory:category];
    [self saveTableFieldsOptionValue:item.dtStartDate
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_START_DATE onCategory:category]
                          onCategory:category];
    [self saveTableFieldsOptionValue:item.dtEndDate
                         byIndexPath:[self getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_END_DATE onCategory:category]
                          onCategory:category];
}
//Edit Item and save it to Device
-(BOOL)editTTItem:(NSMutableDictionary*) dictOldTaskData onCategory:(NSString *)category
{
    BOOL * bReadyToWriteData = NO;
    TTItem * item = [[TTItem alloc] init];
    
    NSMutableDictionary *dictUpdatedTaskData = [[NSMutableDictionary alloc] init];
    
    item.strClientName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT] onCategory:category]];
    
    //Если выбрана категория "редактировать таск", сохраняем таск с проектом и клиентом
    if ([category isEqualToString:STR_NEW_PROJECT_TASK])
    {
        item.strTaskName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_NAME] onCategory:category]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_PROJECT] onCategory:category]];
        item.strColor = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_COLOR] onCategory:category]];
        item.dtStartDate = [self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_START_DATE] onCategory:category];
        item.dtEndDate =[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_END_DATE] onCategory:category];
        dictUpdatedTaskData = [self serializeTaskData:item];
        
    }    //Если выбрана категория "редактировать проект", сохраняем только проект с клиентом
    else if( [category isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_PROJECT] onCategory:category]];
        dictUpdatedTaskData = [self serializeProjectData:item];
    }    //Если выбрана категория "редактировать проект", сохраняем только клиента
    else if( [category isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        item.strClientSkype = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_SKYPE] onCategory:category]];
        item.strClientPhone = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_PHONE] onCategory:category]];
        item.strClientMail = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_MAIL] onCategory:category]];
        item.strClientNotes = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_NOTE] onCategory:category]];
        dictUpdatedTaskData = [self serializeClientData:item];

    }
        bReadyToWriteData = [self editTask:dictOldTaskData withNewData:dictUpdatedTaskData];
    
    if (bReadyToWriteData == YES)
    {
        [localDataManager writeData:[localDataManager dictLocalData]
                             toFile:[self getProjectsFilePath] ];
        return YES;
    }
    return NO;
}

//Save Item to Device
-(BOOL)saveTTItemOnCategory:(NSString *)category
{
    BOOL * bReadyToWriteData = NO;
    TTItem * item = [[TTItem alloc] init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    item.strClientName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT] onCategory:category]];
    
    //Если выбрана категория "создать таск", сохраняем таск с проектом и клиентом
    if ([category isEqualToString:STR_NEW_PROJECT_TASK])
    {

        item.strTaskName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_NAME] onCategory:category]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_PROJECT] onCategory:category]];
        item.strColor = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_COLOR] onCategory:category]];
        item.dtStartDate = [self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_START_DATE] onCategory:category];
        item.dtEndDate =[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_END_DATE] onCategory:category];
        
        dictData = [[NSMutableDictionary alloc] initWithDictionary:[self serializeTaskData:item] copyItems:YES];
        bReadyToWriteData = [localDataManager saveItemData:dictData];
        
    }    //Если выбрана категория "создать проект", сохраняем только проект с клиентом
    else if( [category isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_PROJECT] onCategory:category]];
        
        dictData = [self serializeProjectData:item];
        bReadyToWriteData = [localDataManager saveProjectData:dictData];
    }    //Если выбрана категория "создать проект", сохраняем только клиента
    else if( [category isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        item.strClientSkype = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_SKYPE] onCategory:category]];
        item.strClientPhone = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_PHONE] onCategory:category]];
        item.strClientMail = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_MAIL] onCategory:category]];
        item.strClientNotes = [NSString stringWithFormat:@"%@",[self getTableFieldsOptionValueByIndexPath:[[dictOfTableFieldIndexPaths objectForKey:category] objectForKey:STR_NEW_PROJECT_CLIENT_NOTE] onCategory:category]];
        
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
-(BOOL) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData
{
    NSMutableDictionary * dictTaskToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictTaskToEdit copyItems:YES];
    
    return [localDataManager editTask:dictTaskToEdit withNewData:dictNewData];
    
    for(NSString* key in [dictNewData allKeys])
    {
        if([dictTaskToReturn objectForKey:key] != [dictNewData objectForKey:key] )
        {
            [dictTaskToReturn setObject:[dictNewData objectForKey:key] forKey:key];
        }
    }
    return YES;
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
    if ([localDataManager removeTask:dictTaskToRemove])
    {
        [localDataManager writeData:[localDataManager dictLocalData]
                                 toFile:[self getProjectsFilePath] ];
        return YES;
    }
    return NO;
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
    if (item.strClientMail != nil)
    {
        [dictData setObject:item.strClientMail forKey:STR_CLIENT_MAIL];
    }
    if (item.strClientSkype != nil)
    {
        [dictData setObject:item.strClientSkype forKey:STR_CLIENT_SKYPE];
    }
    if (item.strClientPhone != nil)
    {
        [dictData setObject:item.strClientPhone forKey:STR_CLIENT_PHONE];
    }
    if (item.strClientNotes != nil)
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
                                     item.strIsChecked,   STR_THIS_TASK_IS_CHECKED,
//                                      item.dtStartDate,   STR_START_DATE,
//                                      item.dtEndDate,     STR_END_DATE,
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
                                     item.dtStartDate,    STR_START_DATE,
                                     item.dtEndDate,      STR_END_DATE,
                                     item.strIsChecked,   STR_THIS_TASK_IS_CHECKED,
                                     nil];
    
    return dictData;
}


-(TTItem*)deserializeData:(NSDictionary*)data
{
    TTItem *item = [[TTItem alloc] init];

    item.strClientName  = [data objectForKey:STR_CLIENT_NAME];
    item.strProjectName = [data objectForKey:STR_PROJECT_NAME];
    item.strTaskName    = [data objectForKey:STR_TASK_NAME];
    item.dtStartDate    = [data objectForKey:STR_START_DATE];
    item.dtEndDate      = [data objectForKey:STR_END_DATE];
    item.strColor       = [data objectForKey:STR_TASK_COLOR];

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
            if ([dictTask objectForKey:STR_THIS_TASK_IS_CHECKED ] == strSortParameterValue)
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

-(NSArray*) getDataForStatistic
{
    NSMutableArray * arrToReturn = [[NSMutableArray alloc] init];
    NSArray *arrTasksToSort = [[NSArray alloc] initWithArray:[self getAllTasksForToday]];
    for (NSDictionary * tmpTask in arrTasksToSort)
    {
        if (arrToReturn.count == 0)
        {
            [arrToReturn addObject: [[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
        }
        else
        {
//            в arrToReturn лежат массивы с тасками. каждый массив содержит таски с одинаковым проектом и клиентом
//            проходим по всем массивам и по всем таскам, чтобы сравнить название проекта и клиента.
            for (NSMutableArray * tmpTasksFromSortedTasks in arrToReturn)
            {
                //тут цикл по массиву массивов
                for (NSDictionary *tmpTaskFromSortedTask in tmpTasksFromSortedTasks)
                {
                    //тут цикл по таскам массивов
                    if ([tmpTask objectForKey:STR_PROJECT_NAME] == [tmpTaskFromSortedTask objectForKey:STR_PROJECT_NAME])
                    {
                        //                   если проекты одинаковые, проверяем клиентов
                        if ([tmpTask objectForKey:STR_CLIENT_NAME] == [tmpTaskFromSortedTask objectForKey:STR_CLIENT_NAME])
                        {
                            //                    если клиенты одинаковые - добавляем новый таск в существующий массив
                            [tmpTasksFromSortedTasks addObject:tmpTask];
                        }
                        else
                        {
                            //                    если клиенты разные - создаем новый массив в arrToReturn и сохраняем туда таск
                            [arrToReturn addObject:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
                        }
                        
                    }
                    else
                    {
//                        если проекты разные, создаем новый массив "проект", сохраняем в него таск и добавляем этот массив в arrToReturn.
                        [arrToReturn addObject:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
                    }
                    //обрываем выполнение цикла по таскам внутри "проекта"(массив с тасками с одинаковым названием проекта и клиента).
//                    если первый таска не совпадает по имени - надо создавать новый "проект". если совпадает надо добавлять.
//                    не обязательно для этого перебирать все таски в "проекте"
                    break;
                }
            }
            
        }
        
        
    }
    
    return arrToReturn;
}

-(void)updateData
{
    
    NSLog(@"-(void!!!)updateData");
}
@end
