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
    NSMutableDictionary * addTTItemDataDictionary;
   
    
}

//@property (nonatomic, retain) TTLocalDataManager *localDataManager;
@property (nonatomic,retain) NSMutableDictionary * addTTItemData;

@property (nonatomic,copy) NSIndexPath * selectPropertyIndexPath;
@property (nonatomic,copy) NSString * titleNewProject;
@property (nonatomic,readwrite) int newProjectSegmentIndex;

-(NSString*)getDocumentsPath;
-(NSString*)getProjectsFilePath;
-(NSArray*)getAddTTItemFormData;
-(NSObject*)getValueFormData:(NSString*)value ByIndexPath:(NSIndexPath*)indexPath;

-(NSDictionary*)readDataFromFile:(NSString*)pathToFile;
-(void)saveTTItem:(TTItem*)item;
-(void)saveTTItemAddDataValue:(NSObject*)object valueSection:(NSInteger)section valueRow:(NSInteger)row;
-(void)loadTTItemFormData;

-(NSMutableArray*)getAllTasks;
-(NSMutableArray*)getAllProjects;
-(NSMutableArray*)getAllClients;
-(NSMutableArray*)getAllTasksForToday;
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (TTAppDataManager *)sharedAppDataManager;
@end
