//----------------------------------------------------------------------------//
// Pair.m
// Created by Xie Chenghao On 2012-05-28
#import "Pair.h"

Pair *make_pair_va(va_list ls)
{
    id o = va_arg(ls, id);
    return o == nil ? nil : [Pair cons:o and:make_pair_va(ls)];
}

@implementation Pair

@synthesize car=mCar,cdr=mCdr;
 
//------------------------------------------------------------------------------
/* inits */

+ (Pair *) cons:(id) x and:(id) y
{
    return [[[Pair alloc] initWith:x and:y] autorelease];
}

+ (Pair *) consInt:(int) x and:(id) y
{
    return [Pair cons:[NSNumber numberWithInt:x] and:y];
}

+ (Pair *) consInt:(int) x andInt:(int) y
{
    return [Pair cons:[NSNumber numberWithInt:x] 
				  and:[NSNumber numberWithInt:y]];
}

+ (Pair *) consBool:(BOOL) x and:(id) y
{
    return [Pair cons:[NSNumber numberWithBool:x] and:y];
}

+ (Pair *) list:(id) object, ...
{
    Pair *p = nil;
    if(object) {
		va_list ap;
		va_start(ap, object);	
		p = make_pair_va(ap);
		va_end(ap);
    }
    return [Pair cons:object and:p]; 
}

+ (Pair *) listWithSize:(int) size
{
    return [[[Pair alloc] initWithListSize:size] autorelease];
}

+ (Pair *) listFromArray: (NSArray *) array
{
	int n = array.count;
	Pair *p = [Pair listWithSize:n];
	for(int i = 0; i < n; ++i) {
		[p set:i value:[array objectAtIndex:i]];
	}
	return p;
}

- (id) initWith:(id) x and:(id) y
{
    self = [super init];
    if(self) {
		self.car = x;
        self.cdr = y;
    }
    return self;
}

- (id) initList:(id) object, ...
{
    self = [super init];
    if(self) {
		Pair *p = nil;
		if(object) {
			va_list ap;
			va_start(ap, object);	
			p = make_pair_va(ap);
			va_end(ap);
		}
		self.car = object;
		self.cdr = p;
    }
    return self;
}

- (id) initWithListSize:(int) size
{
    assert(size > 0);
    self = [super init];
    if(self) {
		self.car = nil;
		self.cdr = (size == 1) ? nil : [Pair listWithSize:(size - 1)];
    }
    return self;
}

- (void) dealloc
{
    [mCar release];
    [mCdr release];
    [super dealloc];
}

//------------------------------------------------------------------------------
/** member access */

- (Pair *) rest
{
    return (Pair *) self.cdr;
}

- (BOOL) hasRest
{
    return [self hasCdr:[Pair class]];
}

- (int) carInt
{
    return [mCar intValue];
}

- (int) cdrInt
{
    return [mCdr intValue];
}

- (BOOL) carBool
{
    return [mCar boolValue];
}

- (BOOL) cdrBool
{
    return [mCdr boolValue];
}

//------------------------------------------------------------------------------
/** list operation */

- (int) listSize
{
    return [self hasRest ] ?  [(Pair *) self.cdr listSize] + 1 : 1;
}

- (id) elem:(int) i
{
    assert(i>=0);
    id r;
    if(i == 0)
		r = self.car;
    else if([self hasRest])
		r = [self.rest elem:(i-1)];
    else 
		[NSException raise:NSInvalidArgumentException
					format:@"Element index out of range of Pair list!"];
    return r;
}

- (int) elemInt:(int) i
{
    return [[self elem:i] intValue];
}

- (BOOL) elemBool:(int) i
{
    return [[self elem:i] boolValue];
}

- (void) set:(int) i value:(id) value
{
    assert(i>=0);
    if(i == 0) 
		self.car = value;
    else if([self hasRest])
		[self.rest set:(i-1) value:value];
    else
		[NSException raise:NSInvalidArgumentException
					format:@"Element index out of range of Pair list!"];
}

- (void) set:(int) i intValue:(int) value
{
    [self set:i value:[NSNumber numberWithInt:value]];
}

- (void) set:(int) i boolValue:(BOOL) value
{
    [self set:i value:[NSNumber numberWithBool:value]];
}

- (void) set:(int) i withElem:(int) j
{
    [self set:i value:[self elem:j]];
}

- (BOOL) hasCar:(Class) aClass
{
    return self.car != nil && [self.car isKindOfClass:aClass];
}

- (BOOL) hasCdr:(Class) aClass
{
    return self.cdr != nil && [self.cdr isKindOfClass:aClass];
}
//------------------------------------------------------------------------------
/** NSObject  */

- (BOOL) isEqual: (id) anObject
{
    if(![anObject isMemberOfClass:[Pair class]])
		return NO;

    Pair *p = (Pair *)anObject;
    return [self.car isEqual:p.car] && [self.cdr isEqual:p.cdr];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Pair<%@,%@>" ,self.car ,self.cdr];
}
@end

//----------------------------------END---------------------------------------//
