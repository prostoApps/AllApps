//
//  TTTasksTableViewCell.m
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//
#define CHECK_MOVE_DISTANSE 60
#define DELETE_MOVE_DISTANSE 160
#define NOACTION_MOVE_DISTANSE 40

#import "TTTasksTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TTTasksTableViewCell
{
    CABasicAnimation * _taskAnimation;
    
    CGPoint _startPositionCheck;
    CGPoint _startPositionContent;
    CGPoint _endPositionCheck;
    CGPoint _endPositionContent;
}

@synthesize clientName;
@synthesize taskName;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //add test changes! 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
       NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"TTTasksTableViewCell" owner:self options:nil];
        self = [nibbArray objectAtIndex:0];
        
        // set positions
        _startPositionCheck = CGPointMake(taskCheckBackground.center.x, taskCheckBackground.center.y);
        _startPositionContent = CGPointMake(taskContentView.center.x, taskContentView.center.y);
        _endPositionCheck = CGPointMake(taskCheckBackground.center.x, taskCheckBackground.center.y);
        _endPositionContent = CGPointMake(taskContentView.center.x - (taskContentView.frame.size.width+40), taskContentView.center.y);
        
        // add icon
        CGRect taskIconFrame = CGRectMake(18, 25, 22, 22);
        //taskIcon = [[UIImageView alloc] initWithFrame:taskIconFrame];
        taskIcon = [[UIButton alloc] initWithFrame:taskIconFrame];
        [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-default.png"] forState:UIControlStateNormal];
        [taskIcon setClipsToBounds:YES];
        [taskIcon addTarget:self action:@selector(iconTaskWasTaped) forControlEvents:UIControlEventTouchUpInside];
        [taskContentView addSubview:taskIcon];
        isCheck = false;
        
        // Setup a left swipe gesture recognizer
       
        UIPanGestureRecognizer* leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCell:)];
        [leftPanGestureRecognizer setMinimumNumberOfTouches:1];
        [leftPanGestureRecognizer setMaximumNumberOfTouches:1];
        [leftPanGestureRecognizer setCancelsTouchesInView:NO];
        [leftPanGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:leftPanGestureRecognizer];

        
        _taskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        _taskAnimation.delegate = self;
        _taskAnimation.duration = 0.2f;
        _taskAnimation.fillMode = kCAFillModeForwards;
        _taskAnimation.removedOnCompletion = NO;
    }
    return self;
}

//Событие по клику на иконку
-(void)iconTaskWasTaped{
    if (!isCheck){
        [self.delegate iconTaskWasTaped:self];
    }
    
}


// Включаем тольго горизонтальные перетаскивания



- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
   if ([panGestureRecognizer class ] != [UILongPressGestureRecognizer class])
    {
        CGPoint location = [panGestureRecognizer translationInView:self.contentView];
//        NSLog(@"location.x:%f,location.y:%f",fabs(location.x),fabs(location.y));
        return fabs(location.x) >= fabs(location.y) ;
    }
    
    return NO;
    
}

 //поддержа других gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; //otherGestureRecognizer is your custom pan gesture
}

// заполненеие ячейки данными
-(void)setTableCellData:(NSDictionary*)data
{
    clientName.text = [NSString stringWithFormat:@"%@ — %@",[data objectForKey:@"clientName"],[data objectForKey:@"projectName"]];
    taskName.text = [data objectForKey:@"taskName"];
    taskColor.backgroundColor = [TTTools colorWithHexString:[data objectForKey:@"taskColor"]];
    
    if ([[data objectForKey:@"dateStart"] isEqual:@"06.06.2006"])
    {
        CGRect taskIconFrame = taskIcon.frame;
        taskIconFrame.origin.y = 12;
        [taskIcon setFrame:taskIconFrame];
        
        [curentTaskTime setHidden:false];
        if ([[data objectForKey:@"durationReal"] integerValue] > [[data objectForKey:@"durationPlan"] integerValue])
        {
            [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-overtime.png"] forState:UIControlStateNormal];
            isOvertime = true;
            curentTaskTime.textColor = [TTTools colorWithHexString:@"fc3e39"];
        }
    }
    
    
    if ([[data objectForKey:@"isCheck"] isEqual:@"1"])
    {
        [self setTaskChaked];
    }
    else
    {
         [self setTaskUnChaked];
    }
}
-(NSDictionary*)getTableCellData{
    NSArray *names = [clientName.text componentsSeparatedByString:@" — "];
    
    NSDictionary * getData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%hhd",isCheck] , @"isCheck",
                              [names objectAtIndex:0], @"clientName",
                              [names objectAtIndex:1], @"projectName",
                              taskName.text          , @"taskName",
                              
                              
                              nil];

    return getData;
    
}

- (void)moveCell:(id)sender {
    UIPanGestureRecognizer *r = (UIPanGestureRecognizer*)sender;
    CGPoint translation = [r translationInView:self];
    
        switch (r.state) {
            case UIGestureRecognizerStateBegan:
                //отключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:NO];
                break;
    
            case UIGestureRecognizerStateChanged:
                // отметить ячейчку
                if (translation.x >= 0)
                {
                    //если ячейка не отмечена
                    if (isCheck == false) {
                        //удаление на место
                        [taskContentView.layer setPosition:CGPointMake(_startPositionContent.x , _startPositionContent.y)];
                        // двигаем иконку
                        if (translation.x < CHECK_MOVE_DISTANSE)
                        {
                            if (!isOvertime)
                             {
                                 [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-default.png"] forState:UIControlStateNormal];
                             }
                             else
                                {
                                    [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-overtime.png"] forState:UIControlStateNormal];
                                }
                                taskIcon.alpha = 1-(translation.x / CHECK_MOVE_DISTANSE);
                        }
                        else
                        {
                            [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-check.png"] forState:UIControlStateNormal];
                            taskIcon.alpha = (translation.x / CHECK_MOVE_DISTANSE)-1;
                        }
                        // двигаем бекграунд
                        [taskCheckBackground.layer setPosition:CGPointMake(translation.x + _startPositionCheck.x, _startPositionCheck.y)];
                    }
                }
                // удалить ячейку
                else
                {
                    if (!isCheck)
                    {
                       [taskCheckBackground.layer setPosition:CGPointMake(_startPositionCheck.x, _startPositionCheck.y)];
                    }
                    
                    // икнока удалить задание
                    if (translation.x < -DELETE_MOVE_DISTANSE)
                    {
                        self.backgroundView.backgroundColor = [TTTools colorWithHexString:@"fa4030"];
                        [iconEditDel setImage:[UIImage imageNamed:@"icon-tasks-delete.png"]];
                    }
                    // икнока редактировать задание
                    else
                    {
                        self.backgroundView.backgroundColor = [TTTools colorWithHexString:@"ff6403"];
                       [iconEditDel setImage:[UIImage imageNamed:@"icon-tasks-edit.png"]];
                    }
    

                    //двигаем ячейку
                    [taskContentView.layer setPosition:CGPointMake(translation.x + _startPositionContent.x, _startPositionContent.y)];
                }
                break;
            case UIGestureRecognizerStateEnded:
                //подключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:YES];

                // завершение чек\анчек задания когда отпустили палец
                if (translation.x >= 0 )
                {
                    if (!isCheck)
                    {
                        //завершить действие
                        if (translation.x > CHECK_MOVE_DISTANSE)
                        {
                                _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                                _taskAnimation.toValue = [NSNumber numberWithFloat:taskCheckBackground.frame.size.width - translation.x];
                               [_taskAnimation setValue:@"CheckTask" forKey:@"taskCellAnimation"];
                        }
                        // вернуть  в исходное положение
                        else
                        {
                                [taskIcon setAlpha: 1];
                                _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                                _taskAnimation.toValue = [NSNumber numberWithFloat:- translation.x];
                                [_taskAnimation setValue:@"DontCheckTask" forKey:@"taskCellAnimation"];
                        }
                        [taskCheckBackground.layer addAnimation:_taskAnimation forKey:nil];
                    }
                }
                // завершение удаления ячейки
                else
                {
                    // удалить задание
                    if (translation.x < -DELETE_MOVE_DISTANSE)
                    {
                        _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                        _taskAnimation.toValue = [NSNumber numberWithFloat:-360 - translation.x];
                        [_taskAnimation setValue:@"DeleteTask" forKey:@"taskCellAnimation"];
                    }
                    //вернуть в исходное положение
                    else
                    {
                        _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                        _taskAnimation.toValue = [NSNumber numberWithFloat:-translation.x];
                        [_taskAnimation setValue:@"DontDeleteTask" forKey:@"taskCellAnimation"];
                        
                        if (translation.x < -NOACTION_MOVE_DISTANSE)
                        {
                           [self.delegate editCellFromTTTasksTableView:self];
                        }
                    }
                    [taskContentView.layer addAnimation:_taskAnimation forKey:nil];
                }
                [CATransaction commit];
                
                break;
                
            case UIGestureRecognizerStateFailed:
                break;
            default:
                break;
        }
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
   
    NSString * animationName = [theAnimation valueForKey:@"taskCellAnimation"];
    
    if ([animationName isEqualToString:@"DontCheckTask"]) {
        [self setTaskUnChaked];
    }
    
    if ([animationName isEqualToString:@"CheckTask"]) {
        [self setTaskChaked];
        [self.delegate checkCellFromTTTasksTableView:self];
    }
    // не удалять задание
    if ([animationName isEqualToString:@"DontDeleteTask"]) {
        [taskContentView.layer setPosition:CGPointMake(_startPositionContent.x,_startPositionContent.y)];
     }
    // удалить задание
    if ([animationName isEqualToString:@"DeleteTask"]) {
        [taskContentView.layer setPosition:CGPointMake(_endPositionContent.x,_endPositionContent.y)];
        [self.delegate deleteCellFromTTTasksTableView:self];

    }
    
    [taskCheckBackground.layer removeAllAnimations];
    [taskContentView.layer removeAllAnimations];
}

-(void)setTaskChaked{
    
    [taskName setAlpha:0.5];
    [clientName setAlpha:0.5];
    [taskIcon setAlpha: 1];
    [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-check.png"] forState:UIControlStateNormal];
   
    [taskIcon.layer setPosition:CGPointMake(18+taskIcon.frame.size.width/2, 25+taskIcon.frame.size.height/2)];
    [curentTaskTime setHidden:true];
    
    [taskCheckBackground.layer setPosition:CGPointMake(_endPositionCheck.x,_endPositionCheck.y)];
    [taskCheckBackground setHidden:TRUE];
    
    isCheck = true;
    
}

-(void)setTaskUnChaked{
    
    [taskName setAlpha:1];
    [clientName setAlpha:1];
    [taskIcon setAlpha: 1];
    [taskIcon setImage:[UIImage imageNamed:@"icon-tasks-default.png"] forState:UIControlStateNormal];
    
    [taskCheckBackground.layer setPosition:CGPointMake(_startPositionCheck.x,_startPositionCheck.y)];
    [taskCheckBackground setHidden:false];
    
    isCheck = false;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
