//
//  TTSelectColorViewController.m
//  PlanMyDay
//
//  Created by Torasike on 30.09.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTSelectColorViewController.h"

#define COLOR_1 @"ff0000"
#define COLOR_2 @"00ff00"
#define COLOR_3 @"0000ff"


@interface TTSelectColorViewController ()
{
    NSIndexPath * indexCurrentColor;
}
@end

@implementation TTSelectColorViewController
@synthesize delegate;
@synthesize collectionViewOfColors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexCurrentColor = [[NSIndexPath alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //UIGestureRecognizer * tapGesture = [[UIGestureRecognizer alloc] initWithTarget:collectionViewOfColors action:@selector()]
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[delegate getColorData] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColorCell"];
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell"
                                                                            forIndexPath:indexPath];
    
    if ([cell viewWithTag:1]) {
        [[cell viewWithTag:1] removeFromSuperview];
        [[cell viewWithTag:2] removeFromSuperview];
    }
    NSString * cellColorString = [[[delegate getColorData] objectAtIndex:indexPath.item]objectForKey:STR_NEW_PROJECT_COLOR_COLOR];
    
    UIColor * cellColor = [TTTools colorWithHexString:cellColorString];
    
    UIColor *  cellBgColor = [UIColor clearColor];
    
    if ([delegate respondsToSelector:@selector(getSelectedFieldTableValue)]) {
        NSString * selectedColorString = [NSString stringWithFormat:@"%@",[[delegate getSelectedFieldTableOptions] objectForKey:STR_NEW_PROJECT_VALUE]];
        
        if ([cellColorString isEqualToString:selectedColorString]) {
            cellBgColor = cellColor;
            indexCurrentColor = indexPath;
        }
    }
   
    [cell addSubview:[self circleWithColor:cellColor backgroundColor:cellBgColor radius:45]];
    UILabel * lblColorName = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 90, 14)];
    
    lblColorName.text = [[[delegate getColorData] objectAtIndex:indexPath.item] objectForKey:STR_NEW_PROJECT_COLOR_NAME];
    lblColorName.textColor = [UIColor whiteColor];
    lblColorName.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_MEDIUM size:13.f];
    lblColorName.textAlignment = NSTextAlignmentCenter;
    lblColorName.tag = 2;
    [cell addSubview:lblColorName];
    

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//   [delegate saveSelectedFieldTableValue:[[[delegate getColorData] objectAtIndex:indexPath.item] objectForKey:STR_NEW_PROJECT_COLOR_COLOR]];
////    [collectionView reloadData];
//    UICollectionViewCell * oldCell = [collectionView cellForItemAtIndexPath:indexCurrentColor];
//    [oldCell viewWithTag:1].backgroundColor = [UIColor clearColor];
//    
//    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIColor * color = [UIColor colorWithCGColor:[cell viewWithTag:1].layer.borderColor];
//    [cell viewWithTag:1].backgroundColor = color;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [delegate saveSelectedFieldTableValue:[[[delegate getColorData] objectAtIndex:indexPath.item] objectForKey:STR_NEW_PROJECT_COLOR_COLOR]];
    [collectionView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(UIView *)circleWithColor:(UIColor *)color backgroundColor:(UIColor*)backColor radius:(int)radius {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)] ;
    circle.backgroundColor = backColor;
    circle.layer.borderColor = color.CGColor;
    circle.layer.borderWidth = 3.5f;
    circle.layer.cornerRadius = radius;
    circle.layer.masksToBounds = YES;
    circle.tag = 1;
    return circle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
