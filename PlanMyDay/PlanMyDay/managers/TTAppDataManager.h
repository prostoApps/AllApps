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
#import "TTApplicationManager.h"

@interface TTAppDataManager : NSObject
{
//    TTLocalDataManager *myLocalDataManager;
//    TTLocalDataManager *localDataManager;
    NSMutableDictionary * dictNewProjectFormData;
   
    
}

//@property (nonatomic, retain) TTLocalDataManager *localDataManager;
@property (nonatomic,copy) NSIndexPath * indexPathNewProject;
@property (nonatomic,copy) NSString * nameNewProject;
@property (nonatomic,readwrite) int segmentIndexNewProject;
@property (nonatomic,readwrite) NSMutableDictionary * dictNewProjectIndexPaths;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;
-(NSArray*) getNewProjectFormData;
-(NSObject*)getNewProjectFormDataValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath;

-(NSDictionary*)readDataFromFile:(NSString*)pathToFile;

-(void)saveTTItem;
-(void)saveNewProjectFormDataValue:(NSObject*)value onSection:(NSInteger)section onRow:(NSInteger)row;

-(void)loadNewProjectFormData;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (TTAppDataManager *)sharedAppDataManager;
@end
