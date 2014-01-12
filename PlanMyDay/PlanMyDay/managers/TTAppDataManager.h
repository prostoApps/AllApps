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
    NSMutableDictionary * dictNewProjectFields;
    NSMutableArray * arrayFilterFields;
   
    
}

extern NSString *const STR_SORT_PARAMETER_TASK_NAME;
extern NSString *const STR_SORT_PARAMETER_CLIENT_NAME;
extern NSString *const STR_SORT_PARAMETER_PROJECT_NAME;
extern NSString *const STR_END_DATE;
extern NSString *const STR_SORT_PARAMETER_COLOR;
extern NSString *const STR_SORT_PARAMETER_TASK_COMPLETED;
extern NSString *const STR_SORT_PARAMETER_TASK_DURATION;


//@property (nonatomic, retain) TTLocalDataManager *localDataManager;
@property (nonatomic, retain) UIViewController *currentViewController;

@property (nonatomic,readwrite) NSMutableDictionary * dictNewProjectIndexPaths;
@property (nonatomic,readwrite) NSMutableArray * arraySettingsFields;
@property (nonatomic,readwrite) NSMutableArray * arrayFilterFields;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;
-(NSArray*) getNewProjectFieldsByCategory:(NSString*)category;
-(void)updateNewTaskFormFieldsWithData:(TTItem*) dictTaskData onCategory:(NSString*)category;
-(NSArray*) getFilterFields;
-(NSObject*)getNewProjectFieldsValue:(NSString*)value byIndexPath:(NSIndexPath*)indexPath onCategory:(NSString*)category;
-(NSIndexPath*)getNewProjectFieldsIndexPathByValue:(NSString*)value onCategory:(NSString*)category;
-(NSObject*)getNewProjectFieldsValueByIndexPath:(NSIndexPath*)indexPath onCategory:(NSString*)category;

-(NSMutableDictionary*)readDataFromFile:(NSString*)pathToFile;

-(BOOL)editTTItem:(NSMutableDictionary*)dictOldTaskData onCategory:(NSString*)category;;

-(BOOL)saveTTItemOnCategory:(NSString*)category;
-(void)saveNewProjectFieldsValue:(NSObject*)value byIndexPath:(NSIndexPath*)indexPath onCategory:(NSString*)category;
-(void)loadNewProjectFields;
-(void)loadSettingsFields;
-(void)loadFilterFields;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;

-(void) clearNewProjectFieldsonCategory:(NSString*)category;

+ (TTAppDataManager *)sharedAppDataManager;

+(NSMutableArray*)sortTasks:(NSMutableArray*)arrTasksToSort byParameter:(NSString*)strSortParameter withValue:(NSString*) strSortParameterValue;

-(BOOL) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData;
-(NSMutableDictionary*) clearTask:(NSMutableDictionary*) dictTaskToClear;
-(BOOL) removeTask:(NSMutableDictionary*) dictTaskToRemove;
-(BOOL) removeProject:(NSMutableDictionary*) dictProjectToRemove;
-(BOOL) removeClient:(NSMutableDictionary*) dictClientToRemove;
-(BOOL) removeAllTask:(NSMutableDictionary*) dictTaskToRemove;

-(NSMutableDictionary*)serializeClientData:(TTItem*)item;
-(NSMutableDictionary*)serializeProjectData:(TTItem*)item;
-(NSMutableDictionary*)serializeTaskData:(TTItem*)item;

-(NSArray*) getDataForStatistic;

-(void)updateData;

-(TTItem*)deserializeData:(NSDictionary*)data;
@end
