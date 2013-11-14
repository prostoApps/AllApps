//
//  TTLocalDataManager.m
//  TimeTracker
//
//  Created by ProstoApps* on 5/25/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTLocalDataManager.h"

@implementation TTLocalDataManager
{

}

@synthesize dictLocalData,arrAllTasks,arrAllClients,arrAllProjects;

-(id)init
{
    if (!self)
    {
        self = [[TTLocalDataManager alloc] init];
    }
    if (!arrAllTasks)
    {
        arrAllTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSDictionary*)readLocalData
{
    [TTAppDataManager sharedAppDataManager];

    dictLocalData = [[NSMutableDictionary alloc]
                     initWithDictionary:[[TTAppDataManager sharedAppDataManager]
                                        readDataFromFile:[[TTAppDataManager sharedAppDataManager] getProjectsFilePath]]];

    return dictLocalData;
}

-(void)writeData:(NSDictionary*)data toFile:(NSString*)path
{
    [data writeToFile:path atomically:YES];
}



-(BOOL)saveClientData:(NSMutableDictionary*)itemData
{
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if([[itemData objectForKey:STR_CLIENT_NAME] isEqual: [dictClientData objectForKey:STR_CLIENT_NAME]])
            {
                //show alert of duplicate tasks
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Client name" message:@"Sorry! You already have Client with the same name."
                                                               delegate:self cancelButtonTitle:@"Rename" otherButtonTitles:nil];
                [alert show];
                return NO;
            }//end of if
        }
    }
    
    [itemData setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:STR_ALL_PROJECTS];

    [dictLocalData  setObject:[[NSMutableArray alloc] init] forKey:STR_ALL_CLIENTS];


    if (![dictLocalData objectForKey:STR_ALL_CLIENTS])
    {
        [dictLocalData setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:STR_ALL_CLIENTS];
    }
    

    [[dictLocalData objectForKey:STR_ALL_CLIENTS] addObject:itemData];
    
    return YES;
}

-(BOOL)saveProjectData:(NSMutableDictionary*)itemData
{
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if([[itemData objectForKey:STR_CLIENT_NAME] isEqual: [dictClientData objectForKey:STR_CLIENT_NAME]])
            {
                //если у клиента есть проекты, проходим по каждому из них, если нет - добавляем новый
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if([[itemData objectForKey:STR_PROJECT_NAME] isEqual: [dictProjectData objectForKey:STR_PROJECT_NAME]])
                        {

                            //show alert of duplicate tasks
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Client name" message:@"Sorry! You already have Client with the same name."
                                                               delegate:self cancelButtonTitle:@"Rename" otherButtonTitles:nil];
                            [alert show];
                            return NO;
                        }
                    }
                }
                else
                {
                    //createProject
                    NSMutableDictionary *tmpPoject = [[NSMutableDictionary alloc]  initWithObjectsAndKeys:
                                                      [itemData objectForKey:STR_CLIENT_NAME], STR_CLIENT_NAME,
                                                      [itemData objectForKey:STR_PROJECT_NAME], STR_PROJECT_NAME,
                                                      [[NSMutableArray alloc] init], STR_ALL_TASKS,
                                                      nil ];

                    if (![dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        [dictClientData setObject:[[NSMutableDictionary alloc] initWithDictionary:tmpPoject copyItems:YES] forKey:STR_ALL_PROJECTS];
                    }
                    else
                    {
                        [dictClientData setObject:[[NSMutableArray alloc] initWithObjects: tmpPoject,nil ] forKey:STR_ALL_PROJECTS];
                    }

                    return YES;
                }
                //createProject
                NSMutableDictionary *tmpPoject = [[NSMutableDictionary alloc]  initWithObjectsAndKeys:
                                                  [itemData objectForKey:STR_CLIENT_NAME], STR_CLIENT_NAME,
                                                  [itemData objectForKey:STR_PROJECT_NAME], STR_PROJECT_NAME,
                                                  [[NSMutableArray alloc] init], STR_ALL_TASKS,
                                                  nil ];
                
                if (![dictClientData objectForKey:STR_ALL_PROJECTS])
                {
                    [dictClientData setObject:[[NSMutableDictionary alloc] init] forKey:STR_ALL_PROJECTS];
                }
                
                [[dictClientData objectForKey:STR_ALL_PROJECTS] addObject:tmpPoject];
                return YES;
            }//end of if
        }
    }
    //createProject
    NSMutableDictionary *tmpPoject = [[NSMutableDictionary alloc]  initWithObjectsAndKeys:
                                      [itemData objectForKey:STR_CLIENT_NAME], STR_CLIENT_NAME,
                                      [itemData objectForKey:STR_PROJECT_NAME], STR_PROJECT_NAME,
                                      nil ];
    
    NSMutableDictionary *tmpClient = [self createClientWithProjects:[[NSMutableArray alloc] initWithObjects:tmpPoject, nil]];
    
    //add new project to client projects
    [[[dictLocalData objectForKey:STR_ALL_CLIENTS] objectForKey:STR_ALL_CLIENTS] addObject:tmpClient];
    return YES;
}


-(BOOL)saveItemData:(NSMutableDictionary*)itemData
{
   // [self initTestData ];
    
    BOOL *bIsNoEqualItems = NO;
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        bIsNoEqualItems = NO;
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if([[itemData objectForKey:STR_CLIENT_NAME] isEqual: [dictClientData objectForKey:STR_CLIENT_NAME]])
            {
                //если у клиента есть проекты, проходим по каждому из них, если нет - добавляем новый
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if([[itemData objectForKey:STR_PROJECT_NAME] isEqual: [dictProjectData objectForKey:STR_PROJECT_NAME]])
                        {
                            bIsNoEqualItems = NO;
                            //если в проекте есть таски, то проходим по каждой, если нету - создаем таск
                            if([[dictProjectData objectForKey:STR_ALL_TASKS] count] > 0)
                            {
                                //проходим по всем таскам проекта и проверяем совпадение имен
                                for (NSMutableDictionary *dictTaskData in [dictProjectData objectForKey:STR_ALL_TASKS])
                                {
                                    //check if tasks are duplicated
                                    //если в проете есть такс с таким именем, выдаем алерт об ошибке, иначе сохраняем таск в проект
                                    if([[itemData objectForKey:STR_TASK_NAME] isEqual: [dictTaskData objectForKey:STR_TASK_NAME]])
                                    {
                                        //show alert of duplicate tasks
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong task name" message:@"You already have the task with the same name"
                                                                                       delegate:self cancelButtonTitle:@"Rename" otherButtonTitles:nil];
                                        [alert show];
                                        bIsNoEqualItems = NO;
                                        return NO;
                                    }
                                    else
                                    {
                                        bIsNoEqualItems = YES;
                                    }
                                }
                                
                                if (bIsNoEqualItems) {
                                    //Save the task to it's project
                                    
                                    if (![dictProjectData objectForKey:STR_ALL_TASKS])
                                    {
                                        [dictProjectData setObject:[[NSMutableDictionary alloc] init] forKey:STR_ALL_TASKS];
                                    }
                                    
//                                    [dictClientData setObject:[[NSMutableArray alloc] initWithObjects: tmpPoject,nil ] forKey:STR_ALL_PROJECTS];
                                    [[dictProjectData objectForKey:STR_ALL_TASKS] addObject:[itemData copy]];
                                    //TODO go to the tasks list
                                    return YES;
                                }
                            }
                            else
                            {
                                //Save the task to it's project
                                if (![dictProjectData objectForKey:STR_ALL_TASKS])
                                {
                                    [dictProjectData setObject:[[NSMutableDictionary alloc] init] forKey:STR_ALL_TASKS];
                                }
                                
                                
                                [dictProjectData setObject:[[NSMutableArray alloc] initWithObjects: [itemData copy],nil ] forKey:STR_ALL_TASKS];
                                //TODO go to the tasks list
                                return YES;
                            }
                        }
                        else
                        {
                            bIsNoEqualItems = YES;
                        }//end of if else                        
                    }//end of for
                    
                    if (bIsNoEqualItems) {
                        //копируем таск и создаем новый проект с этим таском.
                        //потом записываем проект клиенту
                        NSMutableDictionary *tmpTask = [itemData copy];
                        
                        //createProject
                        NSMutableDictionary *tmpPoject = [self createProjectWithTasks:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
                        
                        //add new project to client projects
                        [[dictClientData objectForKey:STR_ALL_PROJECTS] addObject:tmpPoject];
                        //TODO go to the tasks list
                        return YES;
                    }
                }
                else
                {
                    //копируем таск и создаем новый проект с этим таском.
                    //потом записываем проект клиенту
                    NSMutableDictionary *tmpTask = [itemData copy];
                    
                    //createProject
                    NSMutableDictionary *tmpPoject = [self createProjectWithTasks:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
                    
                    //add new project to client projects
                    [[dictClientData objectForKey:STR_ALL_PROJECTS] addObject:tmpPoject];
                    
                    //TODO go to the tasks list
                    return YES;
                }
                
            }//end of if
            else
            {
                bIsNoEqualItems = YES;
            }
            
        }//end of for
        if (bIsNoEqualItems) {
            //копируем таск и создаем новый проект с этим таском.
            //потом записываем проект клиенту
            NSMutableDictionary *tmpTask = [itemData copy];
            
            //createProject
            NSMutableDictionary *tmpPoject = [self createProjectWithTasks:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
            
            NSMutableDictionary *tmpClient = [self createClientWithProjects:[[NSMutableArray alloc] initWithObjects:tmpPoject, nil]];
            //add new project to client projects
            [[dictLocalData objectForKey:STR_ALL_CLIENTS] addObject:tmpClient];
            //TODO go to the tasks list
            return YES;
        }

    }//end of if
    else
    {
        //копируем таск и создаем новый проект с этим таском.
        //потом записываем проект клиенту
        NSMutableDictionary *tmpTask = [itemData copy];
        
        //createProject
        NSMutableDictionary *tmpPoject = [self createProjectWithTasks:[[NSMutableArray alloc] initWithObjects:tmpTask, nil]];
        
        NSMutableDictionary *tmpClient = [self createClientWithProjects:[[NSMutableArray alloc] initWithObjects:tmpPoject, nil]];
        //add new project to client projects
        [[dictLocalData objectForKey:STR_ALL_CLIENTS] addObject:tmpClient];
        //TODO go to the tasks list
        return YES;

    }
}

-(NSMutableDictionary*)createProjectWithTasks:(NSMutableArray*) arrTasks
{
    NSMutableDictionary *tmpPoject = [[NSMutableDictionary alloc]  initWithObjectsAndKeys:
                                      [[arrTasks objectAtIndex:0] objectForKey:STR_CLIENT_NAME], STR_CLIENT_NAME,
                                      [[arrTasks objectAtIndex:0] objectForKey:STR_PROJECT_NAME], STR_PROJECT_NAME,
                                      [arrTasks copy],STR_ALL_TASKS,nil ];

    return tmpPoject;
}

-(NSMutableDictionary*)createClientWithProjects:(NSMutableArray*)arrProjects
{
    NSDictionary *tmpClient = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            [[arrProjects objectAtIndex:0] objectForKey:STR_CLIENT_NAME], STR_CLIENT_NAME,
                            arrProjects, STR_ALL_PROJECTS, nil];
    return tmpClient;
}

#pragma mark - Get All Section
-(NSMutableArray*)getAllTasks
{
  //  [self initTestData];
   
    if (arrAllTasks.count > 0) {
        [arrAllTasks removeAllObjects];
    }

    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
     
            //если у клиента есть проекты, проходим по каждому из них
            if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
            {
                //проходим по всем проектам клиента и проверяем на совпадение имени
                //если у клиента существует проект с таким же именем, то заходим в него
                for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                {
                    //если в проекте есть таски, то проходим по каждой
                    if([[dictProjectData objectForKey:STR_ALL_TASKS] count] > 0)
                    {
                        //проходим по всем таскам проекта и добавляем и в массив всех тасков
                        for (NSMutableDictionary *dictTaskData in [dictProjectData objectForKey:STR_ALL_TASKS])
                        {
                            [arrAllTasks addObject:[dictTaskData copy]];
                        }
                    }//end if
                }//end for
            }//end if
        }//end for
    }//end if
    else
    {
//        [self initTestData];
    }
    
    return arrAllTasks;
}

-(NSMutableArray*)getAllTasksForToday
{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    arrAllTasks = [[NSMutableArray alloc] init];
    NSDate *dtDateToday = [NSDate date];
    //  [self initTestData];
    
    if (arrAllTasks.count > 0) {
        [arrAllTasks removeAllObjects];
    }
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            
            //если у клиента есть проекты, проходим по каждому из них
            if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
            {
                //проходим по всем проектам клиента и проверяем на совпадение имени
                //если у клиента существует проект с таким же именем, то заходим в него
                for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                {
                    //если в проекте есть таски, то проходим по каждой
                    if([[dictProjectData objectForKey:STR_ALL_TASKS] count] > 0)
                    {
                        //проходим по всем таскам проекта и добавляем и в массив всех тасков
                        for (NSMutableDictionary *dictTaskData in [dictProjectData objectForKey:STR_ALL_TASKS])
                        {
                            NSDateComponents *tmpComponents = [cal components:( NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[dictTaskData objectForKey:STR_START_DATE]];

                            //[NSDate timeIntervalSinceReferenceDate]
                            if(tmpComponents.day == components.day)
                                [arrAllTasks addObject:dictTaskData ];
                        }
                    }//end if
                }//end for
            }//end if
        }//end for
    }//end if
    else
    {
//        [self initTestData];
    }
    
    return arrAllTasks;
}

-(NSMutableArray*)getAllProjects
{
     arrAllProjects = [[NSMutableArray alloc] init];
    
    if (arrAllProjects.count > 0) {
        [arrAllProjects removeAllObjects];
    }
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате
            //если у клиента есть проекты, проходим по каждому из них
            if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
            {
                //проходим по всем проектам клиента
                for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                {
                    [arrAllProjects addObject:[dictProjectData copy]];
                }//end for
            }//end if
        }//end for
    }//end if
  
    return arrAllProjects;
}

-(NSMutableArray*)getAllClients
{
    arrAllClients = [[NSMutableArray alloc] init];
    
    if (arrAllClients.count > 0) {
        [arrAllClients removeAllObjects];
    }
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            [arrAllClients addObject:[dictClientData copy]];
        }//end for
    }//end if
    NSLog(@"%@",arrAllClients);
    return arrAllClients;
}

#pragma mark - Edit Section
-(BOOL) editTask:(NSMutableDictionary*) dictTaskToEdit withNewData:(NSMutableDictionary*) dictNewData
{
    NSMutableDictionary * dictTaskToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictTaskToEdit copyItems:YES];
 
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictTaskToEdit objectForKey:STR_CLIENT_NAME])
            {
                //если у клиента есть проекты, проходим по каждому из них
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if ([dictProjectData objectForKey:STR_PROJECT_NAME] == [dictTaskToEdit objectForKey:STR_PROJECT_NAME])
                        {
                            //если в проекте есть таски, то проходим по каждой
                            if([[dictProjectData objectForKey:STR_ALL_TASKS] count] > 0)
                            {
                                //проходим по всем таскам проекта и редактируем нужный
                                for (NSMutableDictionary *dictTaskData in [dictProjectData objectForKey:STR_ALL_TASKS])
                                {
                                    if ([dictTaskData objectForKey:STR_TASK_NAME] == [dictTaskToEdit objectForKey:STR_TASK_NAME])
                                    {
                                        for(NSString* key in [dictNewData allKeys])
                                        {
                                            if([dictTaskData objectForKey:key] != [dictNewData objectForKey:key] )
                                            {
                                                [dictTaskData setObject:[dictNewData objectForKey:key] forKey:key];
                                            }
                                        }
                                        return YES;
                                    }
                                }
                            }//end if
                        }
                    }//end for
                }//end if
            }
        }//end for
    }//end if
    
    return YES;
}

-(BOOL) editProject:(NSMutableDictionary*) dictProjectToEdit withNewData:(NSMutableDictionary*) dictNewData
{
    NSMutableDictionary * dictTaskToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictProjectToEdit copyItems:YES];
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictProjectToEdit objectForKey:STR_CLIENT_NAME])
            {
                //если у клиента есть проекты, проходим по каждому из них
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if ([dictProjectData objectForKey:STR_PROJECT_NAME] == [dictProjectToEdit objectForKey:STR_PROJECT_NAME])
                        {
                            for(NSString* key in [dictNewData allKeys])
                            {
                                if([dictTaskToReturn objectForKey:key] != [dictNewData objectForKey:key] )
                                {
                                    [dictTaskToReturn setObject:[dictNewData objectForKey:key] forKey:key];
                                }
                                return dictTaskToReturn;
                            }
                        }
                    }//end for
                }//end if
            }
        }//end for
    }//end if
    
    return nil;
}


-(BOOL) editClient:(NSMutableDictionary*) dictClientToEdit withNewData:(NSMutableDictionary*) dictNewData
{
    NSMutableDictionary * dictClientToReturn = [[NSMutableDictionary alloc] initWithDictionary:dictClientToEdit copyItems:YES];
    
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictClientToEdit objectForKey:STR_CLIENT_NAME])
            {
                for(NSString* key in [dictNewData allKeys])
                {
                    if([dictClientToEdit objectForKey:key] != [dictNewData objectForKey:key] )
                    {
                        [dictClientToReturn setObject:[dictNewData objectForKey:key] forKey:key];
                    }
                    return dictClientToReturn;
                }
            }
        }//end for
    }//end if
    
    return nil;
}

#pragma mark - Remove  Section
-(BOOL) removeTask:(NSMutableDictionary*) dictTaskToRemove
{
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictTaskToRemove objectForKey:STR_CLIENT_NAME])
            {
                //если у клиента есть проекты, проходим по каждому из них
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if ([dictProjectData objectForKey:STR_PROJECT_NAME] == [dictTaskToRemove objectForKey:STR_PROJECT_NAME])
                        {
                            //если в проекте есть таски, то проходим по каждой
                            if([[dictProjectData objectForKey:STR_ALL_TASKS] count] > 0)
                            {
                                //проходим по всем таскам проекта и редактируем нужный
                                for (NSMutableDictionary *dictTaskData in [dictProjectData objectForKey:STR_ALL_TASKS])
                                {
                                    if ([dictTaskData objectForKey:STR_TASK_NAME] == [dictTaskToRemove objectForKey:STR_TASK_NAME])
                                    {
                                        return YES;
                                    }
                                }
                            }//end if
                        }
                    }//end for
                }//end if
            }
        }//end for
    }//end if
    
    return NO;
}

-(BOOL) removeProject:(NSMutableDictionary*) dictProjectToRemove
{
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictProjectToRemove objectForKey:STR_CLIENT_NAME])
            {
                //если у клиента есть проекты, проходим по каждому из них
                if ([[dictClientData objectForKey:STR_ALL_PROJECTS] count] > 0)
                {
                    //проходим по всем проектам клиента и проверяем на совпадение имени
                    //если у клиента существует проект с таким же именем, то заходим в него
                    for (NSMutableDictionary *dictProjectData in [dictClientData objectForKey:STR_ALL_PROJECTS])
                    {
                        if ([dictProjectData objectForKey:STR_PROJECT_NAME] == [dictProjectToRemove objectForKey:STR_PROJECT_NAME])
                        {
                            return YES;
                        }
                    }//end for
                }//end if
            }
        }//end for
    }//end if
    
    return NO;
}

-(BOOL) removeClient:(NSMutableDictionary*) dictClientToRemove
{
    if ([[dictLocalData objectForKey:STR_ALL_CLIENTS] count] > 0)
    {
        for (NSMutableDictionary *dictClientData in [dictLocalData objectForKey:STR_ALL_CLIENTS])
        {
            //проходим по всем проектам в локал дате и проверяем имена на повторение
            //если в локал дате существует клиент с таким же именем, то заходим в него
            if ([dictClientData objectForKey:STR_CLIENT_NAME] == [dictClientToRemove objectForKey:STR_CLIENT_NAME])
            {
                return YES;
            }
        }//end for
    }//end if
    
    return NO;
}

#pragma mark - Remove all  Tasks
-(BOOL)removeAllTasks
{
    dictLocalData = [[NSMutableDictionary alloc] init];
    return YES;
}

#pragma mark - Test Data Section
/*//////////////// TEST DATA AREA \\\\\\\\\\\\\\\\\\\\\\\\\\*/
-(void)initTestData
{
    //    CLIENT 1
    NSMutableDictionary *dictTask1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Павел", STR_CLIENT_NAME,
                                      @"Окна", STR_PROJECT_NAME,
                                      @"Правки", STR_TASK_NAME,
                                      @"fc3e39", STR_TASK_COLOR,
                                      nil];
    
    NSMutableDictionary *dictTask2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Павел", STR_CLIENT_NAME,
                                      @"Окна", STR_PROJECT_NAME,
                                      @"Окошко", STR_TASK_NAME,
                                      @"1c7efb", STR_TASK_COLOR,
                                      nil];
    
    NSMutableDictionary *dictTask3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Павел", STR_CLIENT_NAME,
                                      @"Страховая Компания", STR_PROJECT_NAME,
                                      @"Дизайн", STR_TASK_NAME,
                                      @"fd9426", STR_TASK_COLOR,
                                      @"1", STR_TASK_CHECK,
                                      nil];
    
    NSMutableDictionary *dictTask4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Павел", STR_CLIENT_NAME,
                                      @"Страховая Компания", STR_PROJECT_NAME,
                                      @"Верстка", STR_TASK_NAME,
                                      @"53d769", STR_TASK_COLOR,
                                      nil];
    
    
    //CLIENT 2
    
    NSMutableDictionary *dictTask5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Клиент", STR_CLIENT_NAME,
                                      @"Альтрон", STR_PROJECT_NAME,
                                      @"Главная страница", STR_TASK_NAME,
                                      @"fd9426", STR_TASK_COLOR,
                                      nil];
    
    NSMutableDictionary *dictTask6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Клиент", STR_CLIENT_NAME,
                                      @"Альтрон", STR_PROJECT_NAME,
                                      @"Контакты", STR_TASK_NAME,
                                      @"53d769", STR_TASK_COLOR,
                                      nil];
    
    NSMutableDictionary *dictTask7 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Клиент", STR_CLIENT_NAME,
                                      @"БВПЮ", STR_PROJECT_NAME,
                                      @"Календарик", STR_TASK_NAME,
                                      @"fc3e39", STR_TASK_COLOR,
                                      nil];
    
    NSMutableDictionary *dictTask8 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Клиент", STR_CLIENT_NAME,
                                      @"БВПЮ", STR_PROJECT_NAME,
                                      @"Логотип", STR_TASK_NAME,
                                      @"1c7efb", STR_TASK_COLOR,
                                      nil];
    
    //CLIENT 3
    
    NSMutableDictionary *dictTask9 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Алексей", STR_CLIENT_NAME,
                                      @"Bookzy", STR_PROJECT_NAME,
                                      @"Читалка", STR_TASK_NAME,
                                      @"1c7efb", STR_TASK_COLOR,
                                      @"1", STR_TASK_CHECK,
                                      nil];
    
    NSMutableDictionary *dictTask10 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Алексей", STR_CLIENT_NAME,
                                       @"Bookzy", STR_PROJECT_NAME,
                                       @"Главная страница", STR_TASK_NAME,
                                       @"1c7efb", STR_TASK_COLOR,
                                       nil];
    
    NSMutableDictionary *dictTask11 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Алексей", STR_CLIENT_NAME,
                                       @"DayPad", STR_PROJECT_NAME,
                                       @"Слайдер", STR_TASK_NAME,
                                       @"1c7efb", STR_TASK_COLOR,
                                       nil];
    
    NSMutableDictionary *dictTask12 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Алексей", STR_CLIENT_NAME,
                                       @"DayPad", STR_PROJECT_NAME,
                                       @"Картинки на слайдер", STR_TASK_NAME,
                                       @"1c7efb", STR_TASK_COLOR,
                                       nil];
    
    /////////////////////////
    
    NSMutableArray *arrTasks1 = [[NSMutableArray alloc] initWithObjects:dictTask1,dictTask2, nil];
    NSMutableArray *arrTasks2 = [[NSMutableArray alloc] initWithObjects:dictTask3,dictTask4, nil];
    
    NSMutableArray *arrTasks3 = [[NSMutableArray alloc] initWithObjects:dictTask5,dictTask6, nil];
    NSMutableArray *arrTasks4 = [[NSMutableArray alloc] initWithObjects:dictTask7,dictTask8, nil];
    
    NSMutableArray *arrTasks5 = [[NSMutableArray alloc] initWithObjects:dictTask9,dictTask10, nil];
    NSMutableArray *arrTasks6 = [[NSMutableArray alloc] initWithObjects:dictTask11,dictTask12, nil];
    
    NSMutableDictionary *dictProject1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project1Name", STR_PROJECT_NAME,
                                         @"client1Name", STR_CLIENT_NAME,
                                         arrTasks1, STR_ALL_TASKS, nil];
    NSMutableDictionary *dictProject2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project2Name", STR_PROJECT_NAME,
                                         @"client1Name", STR_CLIENT_NAME,
                                         arrTasks2, STR_ALL_TASKS, nil];
    
    NSMutableDictionary *dictProject3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project3Name", STR_PROJECT_NAME,
                                         @"client2Name", STR_CLIENT_NAME,
                                         arrTasks3, STR_ALL_TASKS, nil];
    NSMutableDictionary *dictProject4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project4Name", STR_PROJECT_NAME,
                                         @"client2Name", STR_CLIENT_NAME,
                                         arrTasks4, STR_ALL_TASKS, nil];
    
    NSMutableDictionary *dictProject5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project5Name", STR_PROJECT_NAME,
                                         @"client3Name", STR_CLIENT_NAME,
                                         arrTasks5, STR_ALL_TASKS, nil];
    NSMutableDictionary *dictProject6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"project6Name", STR_PROJECT_NAME,
                                         @"client3Name", STR_CLIENT_NAME,
                                         arrTasks6, STR_ALL_TASKS, nil];
    
    
    NSMutableArray *arrProjects1 = [[NSMutableArray alloc] initWithObjects:dictProject1,dictProject2, nil];
    NSMutableArray *arrProjects2 = [[NSMutableArray alloc] initWithObjects:dictProject3,dictProject4, nil];
    NSMutableArray *arrProjects3 = [[NSMutableArray alloc] initWithObjects:dictProject5,dictProject6, nil];
    
    NSMutableDictionary *dictClient1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"client1Name", STR_CLIENT_NAME,
                                        arrProjects1, STR_ALL_PROJECTS,
                                        nil];
    
    NSMutableDictionary *dictClient2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"client2Name", STR_CLIENT_NAME,
                                        arrProjects2, STR_ALL_PROJECTS,
                                        nil];
    
    NSMutableDictionary *dictClient3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"client3Name", STR_CLIENT_NAME,
                                        arrProjects3, STR_ALL_PROJECTS,
                                        nil];
    
    
    dictLocalData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [[NSMutableArray alloc] initWithObjects:dictClient1,dictClient2,dictClient3, nil], STR_ALL_CLIENTS
                     ,nil];
}

@end
