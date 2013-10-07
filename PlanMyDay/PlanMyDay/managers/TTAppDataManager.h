//
//  TTAppDataManager.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/28/13.
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

extern NSString *const STR_SORT_PARAMETER_TASK_NAME;
extern NSString *const STR_SORT_PARAMETER_CLIENT_NAME;
extern NSString *const STR_SORT_PARAMETER_PROJECT_NAME;
extern NSString *const STR_END_DATE;
extern NSString *const STR_SORT_PARAMETER_COLOR;
extern NSString *const STR_SORT_PARAMETER_TASK_COMPLETED;
extern NSString *const STR_SORT_PARAMETER_TASK_DURATION;


//@property (nonatomic, retain) TTLocalDataManager *localDataManager;

@property (nonatomic,readwrite) int segmentIndexNewProject;
@property (nonatomic,readwrite) NSMutableDictionary * dictNewProjectIndexPaths;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;
-(NSArray*) getNewProjectFormData;
-(NSObject*)getNewProjectFormDataValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath;

-(NSDictionary*)readDataFromFile:(NSString*)pathToFile;

-(BOOL)saveTTItem;
-(void)saveNewProjectFormDataValue:(NSObject*)value byIndexPath:(NSIndexPath*)indexPath;
-(void)loadNewProjectFormData;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;

-(void) clearNewProjectFormData;
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;
- (UIButton*)makeButtonStyled:(UIButton *)button;
- (NSString *)convertDate:(NSDate *)date withFormat:(NSString *)format;

+ (TTAppDataManager *)sharedAppDataManager;

+(NSMutableArray*)sortTasks:(NSMutableArray*)arrTasksToSort byParameter:(NSString*)strSortParameter withValue:(NSString*) strSortParameterValue;

-(NSMutableDictionary*) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData;
-(NSMutableDictionary*) clearTask:(NSMutableDictionary*) dictTaskToClear;
-(BOOL) removeTask:(NSMutableDictionary*) dictTaskToRemove;
-(BOOL) removeProject:(NSMutableDictionary*) dictProjectToRemove;
-(BOOL) removeClient:(NSMutableDictionary*) dictClientToRemove;
-(BOOL) removeAllTask:(NSMutableDictionary*) dictTaskToRemove;

-(NSMutableDictionary*)serializeClientData:(TTItem*)item;
-(NSMutableDictionary*)serializeProjectData:(TTItem*)item;
-(NSMutableDictionary*)serializeTaskData:(TTItem*)item;

-(TTItem*)deserializeData:(NSDictionary*)data;
@end
