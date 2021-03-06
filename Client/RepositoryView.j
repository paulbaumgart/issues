
@import <AppKit/CPView.j>

@implementation RepositoryView : CPView
{
    @outlet CPImageView lockView;
    @outlet CPTextField nameField;
    @outlet CPTextField openIssuesBadge;

            int         unreadCount;
}

- (void)awakeFromCib
{
    [nameField setLineBreakMode:CPLineBreakByTruncatingTail];
    [nameField setFont:[CPFont boldSystemFontOfSize:11.0]];
    [nameField setVerticalAlignment:CPCenterVerticalTextAlignment];
    [self unsetThemeState:CPThemeStateSelectedDataView];

    [nameField setValue:[CPColor colorWithCalibratedRed:71/255 green:90/255 blue:102/255 alpha:1]           forThemeAttribute:"text-color"         inState:CPThemeStateTableDataView];
    [nameField setValue:[CPColor colorWithCalibratedWhite:1 alpha:1]           forThemeAttribute:"text-shadow-color"  inState:CPThemeStateTableDataView];
    [nameField setValue:CGSizeMake(0,1)                                        forThemeAttribute:"text-shadow-offset" inState:CPThemeStateTableDataView];

    [nameField setValue:[CPColor colorWithCalibratedWhite:1 alpha:1.0]         forThemeAttribute:"text-color"         inState:CPThemeStateTableDataView | CPThemeStateSelectedTableDataView];
    [nameField setValue:[CPColor colorWithCalibratedWhite:0 alpha:0.5]           forThemeAttribute:"text-shadow-color"  inState:CPThemeStateTableDataView | CPThemeStateSelectedTableDataView];
    [nameField setValue:CGSizeMake(0,-1)                                       forThemeAttribute:"text-shadow-offset" inState:CPThemeStateTableDataView | CPThemeStateSelectedTableDataView];

    [nameField setValue:[CPFont boldSystemFontOfSize:12.0]                     forThemeAttribute:"font"               inState:CPThemeStateTableDataView | CPThemeStateGroupRow];
    [nameField setValue:[CPColor colorWithCalibratedWhite:125 / 255 alpha:1.0] forThemeAttribute:"text-color"         inState:CPThemeStateTableDataView | CPThemeStateGroupRow];
    [nameField setValue:[CPColor colorWithCalibratedWhite:1 alpha:1]           forThemeAttribute:"text-shadow-color"  inState:CPThemeStateTableDataView | CPThemeStateGroupRow];
    [nameField setValue:CGSizeMake(0,1)                                        forThemeAttribute:"text-shadow-offset" inState:CPThemeStateTableDataView | CPThemeStateGroupRow];
    [nameField setValue:CGInsetMake(1.0, 0.0, 0.0, 2.0)                        forThemeAttribute:"content-inset"      inState:CPThemeStateTableDataView | CPThemeStateGroupRow];
}

- (int)widthOfBadge
{
    if (!unreadCount)
        return 0;

    var value = unreadCount + "";
    var size = [value sizeWithFont:[CPFont boldSystemFontOfSize:11]].width + 15;

    return size;
}

- (void)setObjectValue:(Object)anObject
{
    [nameField setStringValue:anObject.identifier];
    unreadCount = anObject.openIssues ? anObject.openIssues.length : anObject.open_issues;
    [lockView setHidden:!anObject["private"]];
}

- (void)setThemeState:(CPThemeState)aState
{
    [super setThemeState:aState];
    [nameField setThemeState:aState];
       
}

- (void)unsetThemeState:(CPThemeState)aState
{
    [super unsetThemeState:aState];
    [nameField unsetThemeState:aState];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    var width = CGRectGetWidth([self frame]),
        maxWidth = width - CGRectGetMinX([nameField frame]) - [self widthOfBadge] - ([lockView isHidden] ? 0 : 16);

    [nameField sizeToFit];

    var fitWidth = CGRectGetMaxX([nameField frame]),
        nameFrameSize = CGSizeMake((fitWidth > maxWidth ? maxWidth : fitWidth) - 6, 26),
        lockOrigin = CGPointMake((fitWidth > maxWidth ? maxWidth : fitWidth) + 2, 0);


    [nameField setFrameSize:nameFrameSize];
    [lockView setFrameOrigin:lockOrigin];        
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    lockView = [aCoder decodeObjectForKey:"lockView"];
    nameField = [aCoder decodeObjectForKey:"nameField"];
    unreadCount = [aCoder decodeObjectForKey:"open"];
    [self setNeedsLayout];
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:lockView forKey:"lockView"];
    [aCoder encodeObject:nameField forKey:"nameField"];
    [aCoder encodeInt:unreadCount forKey:"open"];
}

@end
