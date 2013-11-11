//
//  TTLocalDataManager.h
//  TimeTracker
//
//  Created by ProstoApps* on 5/25/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTItem.h"
#import "TTAppDataManager.h"

//
//@protocol TTDataManagerDelegate
//@optional
//- (BOOL)foo;
//@end

@interface TTLocalDataManager : NSObject
{
    NSMutableDictionary *dictLocalData;
//    id <TTDataManagerDelegate> delegate;
}

@property(nonatomic,retain) NSMutableDictionary *dictLocalData;
@property(nonatomic,retain) NSMutableArray      *arrAllTasks;
@property(nonatomic,retain) NSMutableArray      *arrAllProjects;
@property(nonatomic,retain) NSMutableArray      *arrAllClients;

-(void)writeData:(NSMutableDictionary*) data toFile:(NSString*)path ;
-(NSMutableDictionary*)readLocalData;
-(BOOL)saveItemData:(NSMutableDictionary*)itemData;
-(BOOL)saveProjectData:(NSMutableDictionary*)itemData;
-(BOOL)saveClientData:(NSMutableDictionary*)itemData;

//-(NSDictionary*) serializeProjectData:(NSDictionary*)taskData;
-(NSMutableDictionary*)createProjectWithTasks:(NSMutableArray*) arrTasks;
-(NSMutableDictionary*)createClientWithProjects:(NSMutableArray*)arrProjects;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;

-(void)initTestData;

-(BOOL) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData;
-(BOOL) editProject:(NSMutableDictionary*) dictProjectToEdit withNewData:(NSMutableDictionary*) dictNewData;
-(BOOL) editClient:(NSMutableDictionary*) dictClientToEdit withNewData:(NSMutableDictionary*) dictNewData;

-(BOOL) removeTask:(NSMutableDictionary*) dictTaskToRemove;
-(BOOL) removeProject:(NSMutableDictionary*) dictProjectToRemove;
-(BOOL) removeClient:(NSMutableDictionary*) dictClientToRemove;
-(BOOL) removeAllTasks;
@end
