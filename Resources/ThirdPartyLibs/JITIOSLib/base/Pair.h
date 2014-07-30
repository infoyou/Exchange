//----------------------------------------------------------------------------//
// Pair.h
// Created by Xie Chenghao On 2012-05-28
#import <Foundation/Foundation.h>

//------------------------------------------------------------------------------
/* Pair data structure */

@interface Pair : NSObject {
@public
    id mCar, mCdr;
}

@property (nonatomic,retain) id car;
@property (nonatomic,retain) id cdr;

+ (Pair *) cons:(id) x and:(id) y;
+ (Pair *) consInt:(int) x and:(id) y;
+ (Pair *) consInt:(int) x andInt:(int) y;
+ (Pair *) consBool:(BOOL) x and:(id) y;
+ (Pair *) list:(id) object, ...;
+ (Pair *) listWithSize:(int) size;
+ (Pair *) listFromArray: (NSArray *) array;

/* Make a Pair object with car = x and cdr = y */
- (id) initWith:(id) x and:(id) y;

/* make a list with recursively conntected pairs
   Eg: Pair<object1 Pair<object2 ...Pair<objectn, nil>...>> */
- (id) initList:(id) object, ...;
- (id) initWithListSize:(int) size;

/* Return cdr object as a Pair object */
- (Pair *) rest;

/* Return YES if the cdr object is a Pair object */
- (BOOL) hasRest;

/* if car is an NSNumber object return its intValue */
- (int) carInt;

/* if cdr is an NSNumber object return its intValue */
- (int) cdrInt;

/* if cdr is an NSNumber object return its boolValue */
- (BOOL) carBool;

/* if cdr is an NSNumber object return its boolValue */
- (BOOL) cdrBool;

/** list operations */
/* Return the ith element of the list */
- (id) elem:(int) i;

/* Return the int value of the ith element of the list */
- (int) elemInt:(int) i;

/* Return the BOOL value of the ith element of the list */
- (BOOL) elemBool:(int) i;

/* Replace the ith element of the list with the given value object */
- (void) set:(int) i value:(id) value;

/* Replace the ith element of the list with the NSNumber object with given int
   vlaue*/
- (void) set:(int) i intValue:(int) value;

/* Replace the ith element of the list with the NSNumber object with given bool
   vlaue*/
- (void) set:(int) i boolValue:(BOOL) value;

/* Replace the ith element of the list with the jth element*/
- (void) set:(int) i withElem:(int) j;

/* Return list size*/
- (int) listSize;

/* Return YES if the car object is a kind of given class */
- (BOOL) hasCar:(Class) aClass;

/* Rrturn YES if the cdr object is a kind of given class */
- (BOOL) hasCdr:(Class) aClass;

/* Rrturn YES if the given argument object is a kindof Pair and the car and cdr
   object of the both objects are equal with each other */
- (BOOL) isEqual: (id) anObject;

- (NSString *) description;
@end

//----------------------------------END---------------------------------------//
