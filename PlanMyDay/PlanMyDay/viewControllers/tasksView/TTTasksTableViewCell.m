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

@implementation TTTasksTableViewCell

@synthesize clientName;
@synthesize taskName;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
       NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"TTTasksTableViewCell" owner:self options:nil];
        self = [nibbArray objectAtIndex:0];
        
        // Setup a left swipe gesture recognizer
       
        UIPanGestureRecognizer* leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCell:)];
        [leftPanGestureRecognizer setMinimumNumberOfTouches:1];
        [leftPanGestureRecognizer setMaximumNumberOfTouches:1];
        [leftPanGestureRecognizer setCancelsTouchesInView:NO];
        [leftPanGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:leftPanGestureRecognizer];
        
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
    taskColor.backgroundColor = [self colorWithHexString:[data objectForKey:@"color"]];
    if ([[data objectForKey:@"dateStart"] isEqual:@"06.06.2006"])
    {
        // РАЗОБРАТЬСЯ
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        //[taskIcon setBounds:CGRectMake(0, -12, 22, 22)];
        CGRect taskIconFrame = taskIcon.frame;
        taskIconFrame.origin.y = 12;
        [taskIcon setFrame:taskIconFrame];
        
        [curentTaskTime setHidden:false];
        if ([data objectForKey:@"durationReal"] > [data objectForKey:@"durationPlan"])
        {
            [taskIcon setContentMode:UIViewContentModeCenter];
            isOvertime = true;
            curentTaskTime.textColor = [self colorWithHexString:@"fc3e39"];
            
            
        }
    }
    else
    {
        CGRect taskIconFrame = taskIcon.frame;
        taskIconFrame.origin.y = 12;
        [taskIcon setFrame:taskIconFrame];
    }
    /*
    if ([[data objectForKey:@"isCheck"] isEqual:@"true"])
    {
        isCheck = true;
    }
     */

}

- (void)moveCell:(id)sender {
    UIPanGestureRecognizer *r = (UIPanGestureRecognizer*)sender;
    CGPoint translation = [r translationInView:self];
    CGRect taskCheckBackgroundFrame = taskCheckBackground.frame;
    CGRect taskContentViewFrame = taskContentView.frame;
 
        switch (r.state) {
            case UIGestureRecognizerStateBegan:
                //отключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:NO];
                break;
                
            case UIGestureRecognizerStateChanged:
                // отметить ячейчку
                if (translation.x >= 0 )
                {
                    NSLog(@"translation: %f",translation.x);
                    taskContentViewFrame.origin.x = DELETE_START_POSITION;
                    [taskContentView setFrame:taskContentViewFrame];
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
                            taskName.alpha = 1-((translation.x / CHECK_MOVE_DISTANSE)/2);
                            clientName.alpha = 1-((translation.x / CHECK_MOVE_DISTANSE)/2);
                            
                            taskIcon.alpha = 1-(translation.x / CHECK_MOVE_DISTANSE);
                        }
//                        else
//                        {
//                            
//                            [taskIcon setContentMode:UIViewContentModeBottom];
//
//                           taskName.alpha = ((translation.x / CHECK_MOVE_DISTANSE)/2)+0.5;
//                           clientName.alpha = ((translation.x / CHECK_MOVE_DISTANSE)/2)+0.5;
//                        }
                        

                    }
                    else
                    {
                        if (!isCheck)
                        {
                            [taskIcon setContentMode:UIViewContentModeBottom];
                            taskIcon.alpha = (translation.x / CHECK_MOVE_DISTANSE)-1;
                        }
//                        else
//                        {
//                            if (!isOvertime)
//                            {
//                                [taskIcon setContentMode:UIViewContentModeTop];
//                            }
//                            else
//                            {
//                                [taskIcon setContentMode:UIViewContentModeCenter];
//                            }
//                        }
                        
                    }
                    // двигаем бекграунд
                    if (!isCheck)
                    {
                        taskCheckBackgroundFrame.origin.x = translation.x + CHECK_START_POSITION;
                    }
//                    else
//                    {
//                        taskCheckBackground.hidden = false;
//                        taskCheckBackgroundFrame.origin.x = translation.x - UNCHECK_START_POSITION;
//                    }
                    [taskCheckBackground setFrame:taskCheckBackgroundFrame];
                     NSLog(@"taskFrame: %f",taskCheckBackgroundFrame.origin.x);
                }
                // удалить ячейку
                else
                {
                    if (!isCheck)
                    {
                        taskCheckBackgroundFrame.origin.x = CHECK_START_POSITION;
                    }
//                    else
//                    {
//                        taskCheckBackgroundFrame.origin.x = -UNCHECK_START_POSITION;
//                    }
                    //возвращаем на место чек,анчек бекграунд ячейки
                    [taskCheckBackground setFrame:taskCheckBackgroundFrame];
                    //двигаем ячейку
                    taskContentViewFrame.origin.x = translation.x;
                    [taskContentView setFrame:taskContentViewFrame];
                }
                break;
                
            case UIGestureRecognizerStateEnded:
                //подключаем скролл таблицы
                [self.delegate allowTTTasksTableViewScroll:YES];
                // включаем анимацию
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                [UIView setAnimationDelegate:self];
                // завершение чек\анчек задания когда отпустили палец
                if (translation.x >= 0 )
                {
                    //завершить действие
                        if (translation.x > CHECK_MOVE_DISTANSE)
                        {
                            // не выполненное задание
                            if (!isCheck)
                            {
                                taskCheckBackgroundFrame.origin.x = CHECK_END_POSITION;
                                [UIView setAnimationDidStopSelector:@selector(animationDidStopCheckingCell)];
                            }
                            // выполненное задание
//                            else
//                            {
//                                taskCheckBackgroundFrame.origin.x = CHECK_START_POSITION;
//                                [UIView setAnimationDidStopSelector:@selector(animationDidStopUnCheckingCell)];
//                            }
                        }
                    // вернуть  в исходное положение
                        else
                        {
                            // не выполненное задание
                            if (!isCheck)
                            {
                                taskCheckBackgroundFrame.origin.x = CHECK_START_POSITION;
                                [taskName setAlpha:1];
                                [clientName setAlpha:1];
                                [taskIcon setAlpha: 1];
                            }
                            //выполненное задание
//                            else
//                            {
//                                taskCheckBackgroundFrame.origin.x = -UNCHECK_START_POSITION;
//                                [taskName setAlpha:0.5];
//                                [clientName setAlpha:0.5];
//                                [taskIcon setAlpha: 1];
//                            }
                        }
                        [taskCheckBackground setFrame:taskCheckBackgroundFrame];
                        taskContentViewFrame.origin.x = DELETE_START_POSITION;
                        [taskContentView setFrame:taskContentViewFrame];
                }
                // завершение удаления ячейки
                else
                {
                    // удалить задание
                    if (translation.x < -DELETE_MOVE_DISTANSE)
                    {
                        taskContentViewFrame.origin.x = -DELETE_END_POSITION;
                        [UIView setAnimationDidStopSelector:@selector(animationDidStopDeletingCell)];
                    }
                    //вернуть в исходное положение
                    else
                    {
                        taskContentViewFrame.origin.x = DELETE_START_POSITION;
                        // и вернуть чек анчек в исходное
                        if (!isCheck)
                        {
                            taskCheckBackgroundFrame.origin.x = CHECK_START_POSITION;
                        }
//                        else
//                        {
//                            taskCheckBackgroundFrame.origin.x = -UNCHECK_START_POSITION; 
//                        }
                        [taskCheckBackground setFrame:taskCheckBackgroundFrame];
                    }
                    [taskContentView setFrame:taskContentViewFrame];
                }
                break;
                
            case UIGestureRecognizerStateFailed:
                break;
            default:
                break;
        }
}

-(void)animationDidStopDeletingCell{
    [self.delegate deleteCellFromTTTasksTableView:self];
}
// метод финиш Чек 
-(void)animationDidStopCheckingCell{
    [taskName setAlpha:0.5];
    [clientName setAlpha:0.5];
    [taskIcon setAlpha: 1];
    [taskIcon setContentMode:UIViewContentModeBottom];
    
    CGRect taskIconFrame = taskIcon.frame;
    taskIconFrame.origin.y = 25;
    [taskIcon setFrame:taskIconFrame];
    [curentTaskTime setHidden:true];
    
    CGRect taskCheckBackgroundFrame = taskCheckBackground.frame;
    taskCheckBackgroundFrame.origin.x = -UNCHECK_START_POSITION;
    [taskCheckBackground setFrame:taskCheckBackgroundFrame];
    [taskCheckBackground setHidden:TRUE];
    
    isCheck = true;
}
// метод финиш анчек 
-(void)animationDidStopUnCheckingCell{
    [taskName setAlpha:1];
    [clientName setAlpha:1];
    [taskIcon setAlpha: 1];
    if (!isOvertime)
    {
        [taskIcon setContentMode:UIViewContentModeTop];
    }
    else
    {
        [taskIcon setContentMode:UIViewContentModeCenter];
    }
    isCheck = false;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
