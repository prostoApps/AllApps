
#import <Foundation/Foundation.h>
#import "SectionHeaderView.h"

@interface Section : NSObject 
@property (nonatomic, strong) SectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) NSString *sectionHeader;
@property (nonatomic, strong) NSMutableArray *sectionRows;
@property (nonatomic) BOOL open;

@end
