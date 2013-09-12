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
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:item.strClientName, STR_CLIENT_NAME,
                              item.strProjectName,STR_PROJECT_NAME,
                              item.strTaskName,   STR_TASK_NAME,
                              item.strCheck,   STR_TASK_CHECK,
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

@end
