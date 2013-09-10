//
//  TTTasksTableViewCell.m
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//
#define CHECK_MOVE_DISTANSE 60
#define CHECK_START_POSITION 56
#define CHECK_END_POSITION 320
#define UNCHECK_START_POSITION 209
#define DELETE_MOVE_DISTANSE 130
#define DELETE_START_POSITION 0
#define DELETE_END_POSITION 360

#import "TTTasksTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TTTasksTableViewCell
{
    CABasicAnimation * _taskAnimation;
}

@synthesize clientName;
@synthesize taskName;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //add test changes! passwordtoGH!!!!!!!!13asd
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
       NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"TTTasksTableViewCell" owner:self options:nil];
        self = [nibbArray objectAtIndex:0];
        
        // add icon
        CGRect taskIconFrame = CGRectMake(18, 25, 22, 22);
        taskIcon = [[UIImageView alloc] initWithFrame:taskIconFrame];
        [taskIcon setImage:[UIImage imageNamed:@"task_icons.png"]];
        [taskIcon setContentMode:UIViewContentModeTop];
        [taskIcon setClipsToBounds:YES];
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
// Включаем тольго горизонтальные перетаскивания



- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
   if ([panGestureRecognizer class ] != [UILongPressGestureRecognizer class])
    {
        CGPoint location = [panGestureRecognizer translationInView:self.contentView];
        NSLog(@"location.x:%f,location.y:%f",fabs(location.x),fabs(location.y));
        return fabs(location.x) >= fabs(location.y) ;
    }
    
    return NO;
    
}



 //поддержа других gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; //otherGestureRecognizer is your custom pan gesture
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}
// заполненеие ячейки данными
-(void)setTableCellData:(NSDictionary*)data
{
    clientName.text = [NSString stringWithFormat:@"%@ — %@",[data objectForKey:@"clientName"],[data objectForKey:@"projectName"]];
    taskName.text = [data objectForKey:@"taskName"];
    taskColor.backgroundColor = [self colorWithHexString:[data objectForKey:@"taskColor"]];
    
    if ([[data objectForKey:@"dateStart"] isEqual:@"06.06.2006"])
    {
        CGRect taskIconFrame = taskIcon.frame;
        taskIconFrame.origin.y = 12;
        [taskIcon setFrame:taskIconFrame];
        
        [curentTaskTime setHidden:false];
        if ([[data objectForKey:@"durationReal"] integerValue] > [[data objectForKey:@"durationPlan"] integerValue])
        {
            [taskIcon setContentMode:UIViewContentModeCenter];
            isOvertime = true;
            curentTaskTime.textColor = [self colorWithHexString:@"fc3e39"];
        }
    }
    
    
    if ([[data objectForKey:@"isCheck"] isEqual:@"true"])
    {
        
        isCheck = true;
        [taskCheckBackground.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
        [taskCheckBackground.layer setPosition:CGPointMake(CHECK_END_POSITION, 0)];
        taskCheckBackground.hidden = true;
    }
    else
    {
        isCheck = false;
        [taskCheckBackground.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
        [taskCheckBackground.layer setPosition:CGPointMake(CHECK_START_POSITION, 0)];
        taskCheckBackground.hidden = false;
    }
    

}

- (void)moveCell:(id)sender {
    UIPanGestureRecognizer *r = (UIPanGestureRecognizer*)sender;
    CGPoint translation = [r translationInView:self];
//    CGRect taskCheckBackgroundFrame = taskCheckBackground.frame;
//    CGRect taskContentViewFrame = taskContentView.frame;
    
        switch (r.state) {
            case UIGestureRecognizerStateBegan:
                //отключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:NO];
                break;
    
            case UIGestureRecognizerStateChanged:
                // отметить ячейчку
                if (translation.x >= 0 )
                {
                    [taskContentView.layer setAnchorPoint:CGPointMake(0,0)];
                    [taskCheckBackground.layer setAnchorPoint:CGPointMake(0,0)];
                    [taskContentView.layer setPosition:CGPointMake(DELETE_START_POSITION, 0)];
                    
                    // двигаем иконку
                    if (translation.x < CHECK_MOVE_DISTANSE)
                    {
                        if (!isCheck)
                        {
                            if (!isOvertime)
                            {
                                [taskIcon setContentMode:UIViewContentModeTop];
                            }
                            else
                            {
                                [taskIcon setContentMode:UIViewContentModeCenter];
                            }
                            taskIcon.alpha = 1-(translation.x / CHECK_MOVE_DISTANSE);
                        }
                    }
                    else
                    {
                        if (!isCheck)
                        {
                            [taskIcon setContentMode:UIViewContentModeBottom];
                            taskIcon.alpha = (translation.x / CHECK_MOVE_DISTANSE)-1;
                        }
                    }
                    // двигаем бекграунд
                    if (!isCheck)
                    {
                        [taskCheckBackground.layer setPosition:CGPointMake(translation.x +CHECK_START_POSITION, 0)];
                    }
                }
                // удалить ячейку
                else
                {
                    [taskContentView.layer setAnchorPoint:CGPointMake(0,0)];
                    [taskCheckBackground.layer setAnchorPoint:CGPointMake(0,0)];
                    if (!isCheck)
                    {
                       [taskCheckBackground.layer setPosition:CGPointMake(CHECK_START_POSITION, 0)];
                        
                    }
                    //двигаем ячейку
                    [taskContentView.layer setPosition:CGPointMake(translation.x, 0)];
                }
                break;
            case UIGestureRecognizerStateEnded:
                //подключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:YES];
                // включаем анимацию

                // завершение чек\анчек задания когда отпустили палец
                if (translation.x >= 0 )
                {
                   
                    //завершить действие
                        if (translation.x > CHECK_MOVE_DISTANSE)
                        {
                            // не выполненное задание
                            if (!isCheck)
                            {
                              //  [taskCheckBackground.layer setPosition:CGPointMake(CHECK_END_POSITION, self.frame.origin.y)];
                                _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                                _taskAnimation.toValue = [NSNumber numberWithFloat:taskCheckBackground.frame.size.width - translation.x];
                               [_taskAnimation setValue:@"CheckTask" forKey:@"taskCellAnimation"];
                            }
                        }
                    // вернуть  в исходное положение
                        else
                        {
                            // не выполненное задание
                            if (!isCheck)
                            {
                                [taskIcon setAlpha: 1];
                                // точки анимации
                                _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                                _taskAnimation.toValue = [NSNumber numberWithFloat:-translation.x];
                                [_taskAnimation setValue:@"DontCheckTask" forKey:@"taskCellAnimation"];
                            }
                        }
                    
                    [taskCheckBackground.layer addAnimation:_taskAnimation forKey:nil];
                }
                // завершение удаления ячейки
                else
                {
                    // удалить задание
                    if (translation.x < -DELETE_MOVE_DISTANSE)
                    {
                        _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                        _taskAnimation.toValue = [NSNumber numberWithFloat:-taskContentView.frame.size.width-translation.x];
                        [_taskAnimation setValue:@"DeleteTask" forKey:@"taskCellAnimation"];
                    }
                    //вернуть в исходное положение
                    else
                    {
                        _taskAnimation.fromValue = [NSNumber numberWithFloat:0];
                        _taskAnimation.toValue = [NSNumber numberWithFloat:-translation.x];
                        [_taskAnimation setValue:@"DontDeleteTask" forKey:@"taskCellAnimation"];
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
        [taskCheckBackground.layer setPosition:CGPointMake(CHECK_START_POSITION,0)];
        
    }
    
    if ([animationName isEqualToString:@"CheckTask"]) {
        [taskName setAlpha:0.5];
        [clientName setAlpha:0.5];
        [taskIcon setAlpha: 1];
        [taskIcon setContentMode:UIViewContentModeBottom];
        
        CGRect taskIconFrame = taskIcon.frame;
        taskIconFrame.origin.y = 25;
        [taskIcon setFrame:taskIconFrame];
        [curentTaskTime setHidden:true];
        
        [taskCheckBackground.layer setPosition:CGPointMake(-UNCHECK_START_POSITION,0)];
        [taskCheckBackground setHidden:TRUE];
        
        isCheck = true;
    }
    // не удалять задание
    if ([animationName isEqualToString:@"DontDeleteTask"]) {
        [taskContentView.layer setPosition:CGPointMake(DELETE_START_POSITION,0)];
     }
    // удалить задание
    if ([animationName isEqualToString:@"DeleteTask"]) {
        [taskContentView.layer setPosition:CGPointMake(DELETE_END_POSITION,0)];
        [self.delegate deleteCellFromTTTasksTableView:self];

    }
    
    [taskCheckBackground.layer removeAllAnimations];
    [taskContentView.layer removeAllAnimations];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
