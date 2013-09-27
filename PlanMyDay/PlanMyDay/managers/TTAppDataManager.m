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

@synthesize ipNewProjectSelectProperty;
@synthesize nameNewProject;
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
      //
}
-(NSObject*)getNewProjectFormDataValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath{
    return [[[[[dictNewProjectFormData objectForKey:nameNewProject] objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS] objectAtIndex:[indexPath row]] objectForKey:value];
}

-(NSArray*)getNewProjectFormData{
    
    return [dictNewProjectFormData objectForKey:nameNewProject];
    
}
-(void)saveNewProjectFormDataValue:(NSObject*)object byIndexPath:(NSIndexPath*)indexPath{
    
    [[[[[dictNewProjectFormData objectForKey:nameNewProject] objectAtIndex:[indexPath section]]objectForKey:STR_NEW_PROJECT_CELLS]
            objectAtIndex:[indexPath row]] setObject:object forKey:STR_NEW_PROJECT_VALUE];
    
}
-(void) clearNewProjectFormData{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    NSDictionary * clearDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [dictNewProjectFormData setObject:[clearDictionary objectForKey:nameNewProject] forKey:nameNewProject];
}

//Save Item to Device
-(void)saveTTItem
{
    TTItem * item = [[TTItem alloc] init];
    if ([nameNewProject isEqualToString:STR_NEW_PROJECT_TASK])
    {

        item.strTaskName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE byIndexPath:[[dictNewProjectIndexPaths objectForKey:nameNewProject] objectForKey:STR_NEW_PROJECT_NAME]]];
        item.strProjectName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE byIndexPath:[[dictNewProjectIndexPaths objectForKey:nameNewProject] objectForKey:STR_NEW_PROJECT_PROJECT]]];
        item.strClientName = [NSString stringWithFormat:@"%@",[self getNewProjectFormDataValue:STR_NEW_PROJECT_VALUE byIndexPath:[[dictNewProjectIndexPaths objectForKey:nameNewProject] objectForKey:STR_NEW_PROJECT_CLIENT]]];
 
        
    }
    else if( [nameNewProject isEqualToString:STR_NEW_PROJECT_PROJECT])
    {
        
    }
    else if( [nameNewProject isEqualToString:STR_NEW_PROJECT_CLIENT])
    {
        
    }
    
   
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
   // [item setItemData:data];
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
- (UIButton*)makeButtonStyled:(UIButton*)button{
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    return button;
}


@end
