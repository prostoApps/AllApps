

#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView


@synthesize titleLabel=_titleLabel, disclosureButton=_disclosureButton, delegate=_delegate, section=_section;
@synthesize sectionHeaderBack;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:self options:nil];
        self = [nibbArray objectAtIndex:0];
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self.disclosureButton addGestureRecognizer:tapGesture];
        
        _delegate = delegate;
        _section = sectionNumber;
        self.userInteractionEnabled = YES;
        
        self.sectionHeaderBack.layer.borderColor = [TTTools colorWithHexString:@"#a8adb3"].CGColor;
        self.sectionHeaderBack.layer.borderWidth = 1.0f;
        
        self.titleLabel.text = title;
        [self.disclosureButton setImage:[UIImage imageNamed:@"icon-statistic_disclosure2.png"] forState:UIControlStateNormal];
        [self.disclosureButton setImage:[UIImage imageNamed:@"icon-statistic_disclosure.png"] forState:UIControlStateSelected];
        
        
        
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}




@end