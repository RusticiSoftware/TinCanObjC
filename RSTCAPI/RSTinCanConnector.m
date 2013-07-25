//
//  RSTinCanConnector.m
//  RSTCAPI
//
//  Created by Brian Rogers on 2/28/13.
/*
 Copyright 2013 Rustici Software
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RSTinCanConnector.h"


@interface RSTinCanConnector()
{
    NSMutableArray *_recordStore;
    
}

@end

@implementation RSTinCanConnector

- (id) initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        _recordStore = [options valueForKey:@"recordStore"];        
    }
    return self;
}

/**
 @method prepareStatement
 @param {Object|TinCan.Statement} Base statement properties or
 pre-created TinCan.Statement instance
 @return {TinCan.Statement}
 */
- (void) prepareStatement:(TCStatement *)statementToPrepare withCompletionBlock:(void(^)(TCStatement *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TCError *error = [[TCError alloc] initWithMessage:@"Not Implemented"];
        errorBlock(error);
    });
}

/**
 Calls saveStatement on each configured LRS, provide callback to make it asynchronous
 
 @method sendStatement
 @param {TinCan.Statement|Object} statement Send statement to LRS
 @param {Function} [callback] Callback function to execute on completion
 */
- (void) sendStatement:(TCStatement *)statementToSend withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs saveStatement:statementToSend withOptions:nil
     withCompletionBlock:^(){
         dispatch_async(dispatch_get_main_queue(), ^{
             completionBlock();
         });
     }
      withErrorBlock:^(TCError *error){
          dispatch_async(dispatch_get_main_queue(), ^{
              errorBlock(error);
          });
      }];
}

/**
 Calls retrieveStatement on each configured LRS until it gets a result, provide callback to make it asynchronous
 
 @method getStatement
 @param {String} statement Statement ID to get
 @param {Function} [callback] Callback function to execute on completion
 @return {TinCan.Statement} Retrieved statement from LRS
 
 TODO: make TinCan track statements it has seen in a local cache to be returned easily
 */
- (void) getStatementWithId:(NSString *)statementId withOptions:(NSDictionary *)options withCompletionBlock:(void(^)(TCStatement *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs retrieveStatementWithId:statementId withOptions:options
        withCompletionBlock:^(TCStatement *statement){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(statement);
            });
        }
         withErrorBlock:^(TCError *error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 errorBlock(error);
             });
         }];
}

/**
 Calls saveStatements with list of prepared statements
 
 @method sendStatements
 @param {Array} Array of statements to send
 @param {Function} Callback function to execute on completion
 */
- (void) sendStatements:(TCStatementCollection *)statementArray withCompletionBlock:(void(^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs saveStatements:statementArray withOptions:nil
    withCompletionBlock:^(){
       dispatch_async(dispatch_get_main_queue(), ^{
           completionBlock();
       });
    }
    withErrorBlock:^(TCError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(error);
        });
    }];
}

/**
 @method getStatements
 @param {Object} [cfg] Configuration for request
 @param {Boolean} [cfg.sendActor] Include default actor in query params
 @param {Boolean} [cfg.sendActivity] Include default activity in query params
 @param {Object} [cfg.params] Parameters used to filter
 
 @param {Function} [cfg.callback] Function to run at completion
 
 TODO: support multiple LRSs and flag to use single
 */
- (void) getStatementsWithOptions:(TCQueryOptions *)options withCompletionBlock:(void(^)(NSArray *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs queryStatementsWithOptions:options
        withCompletionBlock:^(NSArray *statementArray){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(statementArray);
            });
        }
        withErrorBlock:^(TCError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
    }];
    

}

/**
 @method getState
 @param {String} key Key to retrieve from the state
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.agent] Agent used in query,
 defaults to 'actor' property if empty
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Object} [cfg.registration] Registration used in query,
 defaults to 'registration' property if empty
 @param {Function} [cfg.callback] Function to run with state
 */
- (void) getStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void(^)(NSDictionary *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs retrieveStateWithStateId:stateId withActivityId:activityId withAgent:agent withRegistration:registration withOptions:options
        withCompletionBlock:^(NSDictionary *state)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(state);
            });
        }
         withErrorBlock:^(TCError *error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 errorBlock(error);
             });
         }];
}

/**
 @method setState
 @param {String} key Key to store into the state
 @param {String|Object} val Value to store into the state, objects will be stringified to JSON
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.agent] Agent used in query,
 defaults to 'actor' property if empty
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Object} [cfg.registration] Registration used in query,
 defaults to 'registration' property if empty
 @param {Function} [cfg.callback] Function to run with state
 */
- (void) setStateWithValue:(NSDictionary *)value withStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void(^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs saveStateWithValue:value withStateId:stateId withActivityId:(NSString *)activityId withAgent:agent withRegistration:registration withLastSHA1:nil withOptions:options 
                withCompletionBlock:^(){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock();
                    });
                }
                 withErrorBlock:^(TCError *error){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         errorBlock(error);
                     });
                 }];
}

/**
 @method deleteState
 @param {String|null} key Key to remove from the state, or null to clear all
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.agent] Agent used in query,
 defaults to 'actor' property if empty
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Object} [cfg.registration] Registration used in query,
 defaults to 'registration' property if empty
 @param {Function} [cfg.callback] Function to run with state
 */
- (void) deleteStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void(^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCLRS *lrs = [[TCLRS alloc] initWithOptions:[_recordStore objectAtIndex:0]];
    
    [lrs dropStateWithStateId:stateId withActivityId:activityId withAgent:agent withRegistration:registration withOptions:options
              withCompletionBlock:^()
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completionBlock();
                         });
                     }
                   withErrorBlock:^(TCError *error){
                       dispatch_async(dispatch_get_main_queue(), ^{
                           errorBlock(error);
                       });
                   }];
}

/**
 @method getActivityProfile
 @param {String} key Key to retrieve from the profile
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Function} [cfg.callback] Function to run with activity profile
 */
- (void) getActivityProfile:(NSString *)key withOptions:(NSDictionary *)options withCompletionBlock:(void(^)(NSDictionary *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TCError *error = [[TCError alloc] initWithMessage:@"Not Implemented"];
        errorBlock(error);
    });
}

/**
 @method setActivityProfile
 @param {String} key Key to store into the activity profile
 @param {String|Object} val Value to store into the activity profile, objects will be stringified to JSON
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Function} [cfg.callback] Function to run with activity profile
 */
- (void) setActivityProfile:(NSString *)key withValue:(NSDictionary *)value withOptions:(NSDictionary *)options withCompletionBlock:(void(^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TCError *error = [[TCError alloc] initWithMessage:@"Not Implemented"];
        errorBlock(error);
    });
}

/**
 @method deleteActivityProfile
 @param {String|null} key Key to remove from the activity profile, or null to clear all
 @param {Object} [cfg] Configuration for request
 @param {Object} [cfg.activity] Activity used in query,
 defaults to 'activity' property if empty
 @param {Function} [cfg.callback] Function to run with activity profile
 */
- (void) deleteActivityProfile:(NSString *)key withOptions:(NSDictionary *)options withCompletionBlock:(void(^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TCError *error = [[TCError alloc] initWithMessage:@"Not Implemented"];
        errorBlock(error);
    });
}


@end










