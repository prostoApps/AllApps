//
//  TTLocalDataManager.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 5/25/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTLocalDataManager.h"

@implementation TTLocalDataManager
{

}

@synthesize dictLocalData,arrAllTasks;

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

-(void)saveItemData:(NSMutableDictionary*)itemData
{
   // [self initTestData ];
    
    BOOL *bIsNoEqualItems = NO;
        
    //если у клиента есть проекты, проходим по каждому из них, если нет - добавляем новый
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
                                        return;
                                    }
                                    else
                                    {
                                        bIsNoEqualItems = YES;
                                    }
                                }
                                
                                if (bIsNoEqualItems) {
                                    //Save the task to it's project
                                    [[dictProjectData objectForKey:STR_ALL_TASKS] addObject:[itemData copy]];
                                    //TODO go to the tasks list
                                    return;
                                }
                            }
                            else
                            {
                                //Save the task to it's project
                                [[dictProjectData objectForKey:STR_ALL_TASKS] addObject:[itemData copy]];
                                //TODO go to the tasks list
                                break;
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
                        return;
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
                    return;
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
            return;
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
        return;

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
        [self initTestData];
    }
    
    return arrAllTasks;
}

@end
