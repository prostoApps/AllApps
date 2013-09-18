//
//  TTAppDataManager.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/28/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDataManager.h"

@implementation TTAppDataManager

static TTLocalDataManager *localDataManager;
//@synthesize localDataManager;
@synthesize addTTItemData;

@synthesize selectPropertyIndexPath;
@synthesize addNewStr;

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
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
}
-(void)loadTTItemFormData{
    // загружаем стили ячеек для формы
    if (addTTItemDataDictionary.count == 0) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
        addTTItemDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

    }
      //
}
-(NSObject*)getValueFormData:(NSString*)value ByIndexPath:(NSIndexPath*)indexPath{
    return [[[[[addTTItemDataDictionary objectForKey:addNewStr] objectAtIndex:[indexPath section]] objectForKey:@"cells"] objectAtIndex:[indexPath row]] objectForKey:value];
}

-(NSArray*)getAddTTItemFormData{
    
    return [addTTItemDataDictionary objectForKey:addNewStr];
    
}
-(void)saveTTItemAddDataValue:(NSObject*)object valueSection:(NSInteger)section valueRow:(NSInteger)row{
    
    [[[[[addTTItemDataDictionary objectForKey:addNewStr] objectAtIndex:section] objectForKey:@"cells"] objectAtIndex:row] setObject:object forKey:@"value"];
    
}
//Save Item to Device
-(void)saveTTItem:(TTItem*)item
{
    [localDataManager saveItemData:[self serializeData:item]];
    [localDataManager writeData:[localDataManager dictLocalData]
                         toFile:[self getProjectsFilePath] ];
    //    [localDataManager]
}

-(NSMutableDictionary*)serializeData:(TTItem*)item
{
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              item.strClientName, STR_CLIENT_NAME,
                              item.strProjectName,STR_PROJECT_NAME,
                              item.strTaskName,   STR_TASK_NAME,
                              item.strCheck,      STR_TASK_CHECK,
                              item.dtStartDate,   STR_START_DATE,
                              item.dtEndDate,     STR_END_DATE,
                              nil];
    
    return dictData;
}

-(TTItem*)deserializeData:(NSDictionary*)data
{
    TTItem *item;
    return item;
}

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


@end
