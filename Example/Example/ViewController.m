#import "ViewController.h"
#import "Car.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self setupData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Example";
    
    [self setupTableViewModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilities

- (void)setupData
{
    self.actions = [NSMutableArray new];
    [self.actions addObjectsFromArray:@[@"add volvo", @"add audi"]];
    
    self.objects = [NSMutableArray new];
    
    [self.objects addObject:[Car carWithMake:@"vw" model:@"bora"]];
}

- (void)resetCars
{
    NSMutableArray *arr = [NSMutableArray new];
    
    [arr addObject:[Car carWithMake:@"volvo" model:@"s40"]];
    [arr addObject:[Car carWithMake:@"dodge" model:@"viper"]];
    
    self.objects = arr;
}

- (void)setupTableViewModel
{
    [self addSectionWithCellsFromStoryboard];
    [self addSectionWithCellsFromNib];
}

- (void)addSectionWithCellsFromStoryboard
{
    LRTableViewPart *part = [LRTableViewPart partWithCellIdentifier:@"Identifier1"];
    part.cellHeight = 60;
    part.cellBindings = @{@"textLabel1.text" : @"[object]", @"textLabel2.text" : @"[object]"};
    part.onCellSelected = ^(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow) {
        
        NSMutableArray *objects = [self mutableArrayValueForKey:@"objects"];
        
        if (partRow == 0) {
            
            [objects addObject:[Car carWithMake:@"volvo" model:@"s40"]];
        }
        else if (partRow == 1) {
            
            [objects addObject:[Car carWithMake:@"audi" model:@"tt"]];
        }
    };
    [part observeObject:self forKeyPath:@"actions"];
    
    
    LRTableViewSection *section = [LRTableViewSection sectionWithParts:@[part]];
    section.headerTitle = @"Cells loaded from storyboard";
    
    [self.tableViewModel addSection:section];
}

- (void)addSectionWithCellsFromNib
{
    LRTableViewPart *part = [LRTableViewPart partWithCellIdentifier:@"NibCellIdentifier" nibName:@"NibCell"];
    part.cellHeight = 60;
    
    // By default the row animation is set to UITableViewRowAnimationAutomatic
    // try uncommenting the following line to see the difference
//    part.rowAnimation = UITableViewRowAnimationFade;
    
    
    part.cellBindings = @{@"textLabel1.text" : @"make", @"textLabel2.text" : @"model"};
    
    //
    [part observeObject:self forKeyPath:@"objects"];
    
    // calling a setter instead of assigning a block directly, give us autocomplete for the block params
    [part setOnCellSelected:^(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow) {
        
        NSMutableArray *objects = [self mutableArrayValueForKey:@"objects"];
        
        if (objects.count > partRow) {
            
            [objects removeObjectAtIndex:partRow];
        }
    }];
    
    LRTableViewSection *section = [LRTableViewSection sectionWithParts:@[part]];
    section.headerTitle = @"Cells loaded from nib";
    
    
    section.hideHeaderWhenEmpty = YES;
    
    [self.tableViewModel addSection:section];
}

@end
