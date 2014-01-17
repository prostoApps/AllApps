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
    NSMutableDictionary * dictTableFieldsOption;
    
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

@property (nonatomic,readwrite) NSMutableDictionary * dictOfTableFieldIndexPaths;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;


// Table Fields Option methods
-(void)loadTableFieldsOptionsForView:(NSString*)strView;
-(NSArray*) getTableFieldsOptionsByCategory:(NSString*)category;
-(void) clearTableFieldsOptionsByCategory:(NSString*)category;
-(NSIndexPath*)getTableFieldsOptionIndexPathByValue:(NSString*)value onCategory:(NSString*)category;
-(NSObject*)getTableFieldsOptionValueByIndexPath:(NSIndexPath*)indexPath onCategory:(NSString*)category;
-(void)saveTableFieldsOptionValue:(NSObject*)value byIndexPath:(NSIndexPath*)indexPath onCategory:(NSString*)category;


-(void)updateNewTaskFormFieldsWithData:(TTItem*) dictTaskData onCategory:(NSString*)category;

-(NSMutableDictionary*)readDataFromFile:(NSString*)pathToFile;
-(BOOL)editTTItem:(NSMutableDictionary*)dictOldTaskData onCategory:(NSString*)category;
-(BOOL)saveTTItemOnCategory:(NSString*)category;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;



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
