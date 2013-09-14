//
//  TTAppDataManager.h
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/28/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTItem.h"
#import "TTLocalDataManager.h"

@interface TTAppDataManager : NSObject
{
//    TTLocalDataManager *myLocalDataManager;
//    TTLocalDataManager *localDataManager;
}

//@property (nonatomic, retain) TTLocalDataManager *localDataManager;
@property (nonatomic,retain) NSDictionary * addNewTaskData;
@property (nonatomic,retain) NSDictionary * addNewProjectData;
@property (nonatomic,retain) NSDictionary * addNewClientData;
@property (nonatomic,copy) NSString * selectProperty;
@property (nonatomic,copy) NSString * addNewStr;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;
-(NSDictionary*)readDataFromFile:(NSString*)pathToFile;
-(void)saveTTItem:(TTItem*)item;

-(NSMutableArray*)getAllTasks;

+ (TTAppDataManager *)sharedAppDataManager;
@end
