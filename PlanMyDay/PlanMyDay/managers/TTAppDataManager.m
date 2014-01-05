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
@synthesize arraySettingsFields;
@synthesize arrayFilterFields;

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
    NSString * test =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
}
-(void)loadNewProjectFields{
    // загружаем стили ячеек для формы
    if (dictNewProjectFields.count == 0) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
        dictNewProjectFields = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        //создаем пустые дикшионари для Индекс значений со структурой (Task,Project,Client)
        dictNewProjectIndexPaths = [[NSMutableDictionary alloc] init];
        for(id key in [dictNewProjectFields allKeys]){
            [dictNewProjectIndexPaths setObject:[[NSMutableDictionary alloc] init] forKey:key];
            int section = 0;
            for(NSDictionary * arrSection in [[dictNewProjectFields objectForKey:key] allObjects]){
              //  NSLog(@"%d",section);
                int row = 0;
                for(NSDictionary * arrRow in [[arrSection objectForKey:STR_NEW_PROJECT_CELLS] allObjects]){
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [[dictNewProjectIndexPaths objectForKey:key] setObject:indexPath forKey:[arrRow objectForKey:STR_NEW_PROJECT_NAME]];
                    row++;
                }
                section++;
                
            
            }
            
        }
        
    }
}
-(void)loadSettingsFields{
    // загружаем стили ячеек для формы
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListSettingsView" ofType:@"plist"];
        self.arraySettingsFields = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}
-(void)loadFilterFields{
    // загружаем стили ячеек для формы
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListFilterView" ofType:@"plist"];
        self.arrayFilterFields = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

}
-(NSArray*)getNewProjectFields{
    return [dictNewProjectFields objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]];
}

-(NSArray*)updateNewTaskFormFieldsWithData:(TTItem*) item
{
    NSMutableArray * arrToReturn = [[NSMutableArray alloc] initWithArray:[dictNewProjectFields objectForKey:STR_NEW_PROJECT_TASK]];
    //set task fields (section 1)
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",item.strTaskName]);
//    NSLog(@"%@",[[[arrToReturn objectAtIndex:0] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:0 ] );
    
    [[[[arrToReturn objectAtIndex:0] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:0 ] setObject:
     [NSString stringWithFormat:@"%@",item.strTaskName] forKey:STR_NEW_PROJECT_VALUE];
    
    [[[[arrToReturn objectAtIndex:0] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:1 ] setObject:
     [NSString stringWithFormat:@"%@",item.strProjectName] forKey:STR_NEW_PROJECT_VALUE];
    
    [[[[arrToReturn objectAtIndex:0] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:2 ] setObject:
     [NSString stringWithFormat:@"%@",item.strClientName] forKey:STR_NEW_PROJECT_VALUE];
    
    [[[[arrToReturn objectAtIndex:0] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:3 ] setObject:
     [NSString stringWithFormat:@"%@",item.strColor] forKey:STR_NEW_PROJECT_VALUE];

    //set task date (section 2)
    [[[[arrToReturn objectAtIndex:1] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:0 ] setObject:
     item.dtStartDate forKey:STR_NEW_PROJECT_VALUE];
    
    [[[[arrToReturn objectAtIndex:1] objectForKey:STR_NEW_PROJECT_CELLS]objectAtIndex:1 ] setObject:
     item.dtEndDate forKey:STR_NEW_PROJECT_VALUE];
    
    return arrToReturn;
}

-(NSMutableArray*)getFilterFields{
    return arrayFilterFields;
}

-(NSObject*)getNewProjectFieldsValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath{
    return [[[[[dictNewProjectFields objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
               objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS] objectAtIndex:[indexPath row]] objectForKey:value];
}

-(void)saveNewProjectFieldsValue:(NSObject*)object byIndexPath:(NSIndexPath*)indexPath{
    
    [[[[[dictNewProjectFields objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
        objectAtIndex:[indexPath section]]objectForKey:STR_NEW_PROJECT_CELLS]
            objectAtIndex:[indexPath row]] setObject:object forKey:STR_NEW_PROJECT_VALUE];
    
}
-(void) clearNewProjectFields{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    NSMutableDictionary * clearDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [dictNewProjectFields setObject:[clearDictionary objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]]
                               forKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]];
}

//TODO REFACTOR: MOVE SAME PARTS IN IF CASES TO SEPARATE METHODS:::
//Edit Item and save it to Device
-(BOOL)editTTItem:(NSMutableDictionary*) dictOldTaskData
{
    BOOL * bReadyToWriteData = NO;
    TTItem * item = [[TTItem alloc] init];
    
    NSMutableDictionary *dictUpdatedTaskData = [[NSMutableDictionary alloc] init];
    
    item.strClientName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                             byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT]]];
    
    //Если выбрана категория "редактировать таск", сохраняем таск с проектом и клиентом
    if ([[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_TASK])
    {
        
        item.strTaskName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                               byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_NAME]]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                  byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        
        item.strColor = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                            byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_COLOR]]];
//        [NSDate da]
        
        item.dtStartDate = [self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_START_DATE]];
        item.dtEndDate = [self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                            byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_END_DATE]];
        
        dictUpdatedTaskData = [self serializeTaskData:item];
        
    }    //Если выбрана категория "редактировать проект", сохраняем только проект с клиентом
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                  byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        dictUpdatedTaskData = [self serializeProjectData:item];

    }    //Если выбрана категория "редактировать проект", сохраняем только клиента
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        item.strClientSkype = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                  byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_SKYPE]]];
        
        item.strClientPhone = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                  byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_PHONE]]];
        
        item.strClientMail = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                 byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_MAIL]]];
        
        item.strClientNotes = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                  byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_NOTE]]];
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
-(BOOL)saveTTItem
{
    BOOL * bReadyToWriteData = NO;
    TTItem * item = [[TTItem alloc] init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    item.strClientName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                               byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT]]];
    
    //Если выбрана категория "создать таск", сохраняем таск с проектом и клиентом
    if ([[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_TASK])
    {

        item.strTaskName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                 byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_NAME]]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        
        item.strColor = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_COLOR]]];
        
        
        item.dtStartDate = [self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_START_DATE]];
        item.dtEndDate = [self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_END_DATE]];
//        [item setNumPlaningDuration:[item.dtStartDate timeIntervalSinceDate:item.dtEndDate]];
        
        dictData = [[NSMutableDictionary alloc] initWithDictionary:[self serializeTaskData:item] copyItems:YES];
        bReadyToWriteData = [localDataManager saveItemData:dictData];
        
    }    //Если выбрана категория "создать проект", сохраняем только проект с клиентом
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        
        dictData = [self serializeProjectData:item];
        bReadyToWriteData = [localDataManager saveProjectData:dictData];
    }    //Если выбрана категория "создать проект", сохраняем только клиента
    else if( [[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        item.strClientSkype = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                              byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_SKYPE]]];
     
        item.strClientPhone = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_PHONE]]];
     
        item.strClientMail = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
                                                                                    byIndexPath:[[dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] objectForKey:STR_NEW_PROJECT_CLIENT_MAIL]]];
     
        item.strClientNotes = [NSString stringWithFormat:@"%@",[self getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE
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
