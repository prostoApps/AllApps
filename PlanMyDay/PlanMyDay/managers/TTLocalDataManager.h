//
//  TTLocalDataManager.h
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 5/25/13.
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

-(void)writeData:(NSMutableDictionary*) data toFile:(NSString*)path ;
-(NSMutableDictionary*)readLocalData;
-(void)saveItemData:(NSMutableDictionary*)itemData;

//-(NSDictionary*) serializeProjectData:(NSDictionary*)taskData;
-(NSMutableDictionary*)createProjectWithTasks:(NSMutableArray*) arrTasks;
-(NSMutableDictionary*)createClientWithProjects:(NSMutableArray*)arrProjects;
-(void)initTestData;
@end
