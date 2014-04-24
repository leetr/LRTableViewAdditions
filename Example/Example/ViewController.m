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
    self.numbers = [NSMutableArray new];
    [self.numbers addObjectsFromArray:@[@"one", @"two", @"three"]];
    
    self.objects = [NSMutableArray new];
    [self.objects addObject:[Car carWithMake:@"audi" model:@"A5"]];
    [self.objects addObject:[Car carWithMake:@"audi" model:@"tt"]];
    [self.objects addObject:[Car carWithMake:@"vw" model:@"bora"]];
    [self.objects addObject:[Car carWithMake:@"bmw" model:@"328i"]];
}

- (void)setupTableViewModel
{
    [self addSectionWithCellsFromStoryboard];
    [self addSectionWithCellsFromNib];
}

- (void)addSectionWithCellsFromStoryboard
{
    LRTableViewPart *part = [LRTableViewPart partWithCellIdentifier:@"Identifier1"];
    part.cellHeight = 100;
    part.cellBindings = @{@"textLabel1.text" : @"[object]", @"textLabel2.text" : @"[object]"};
    [part observeObject:self forKeyPath:@"numbers"];
    
    LRTableViewSection *section = [LRTableViewSection sectionWithParts:@[part]];
    section.headerTitle = @"Cells loaded from storyboard";
    
    [self.tableViewModel addSection:section];
}

- (void)addSectionWithCellsFromNib
{
    LRTableViewPart *part = [LRTableViewPart partWithCellIdentifier:@"NibCellIdentifier" nibName:@"NibCell"];
    part.cellHeight = 60;
    part.cellBindings = @{@"textLabel1.text" : @"make", @"textLabel2.text" : @"model"};
    [part observeObject:self forKeyPath:@"objects"];
    
    LRTableViewSection *section = [LRTableViewSection sectionWithParts:@[part]];
    section.headerTitle = @"Cells loaded from nib";
    
    [self.tableViewModel addSection:section];
}

@end
