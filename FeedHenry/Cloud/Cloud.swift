/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import AeroGearHttp

//public typealias CompletionBlock = (AnyObject?, NSError?) -> Void
public typealias InnerCompletionBlock = (() throws -> [String: AnyObject]?) -> Void

/*
This class provides static methods to initialize the library and create new
instances of all the API request objects.
*/
public class FH {
    var props: CloudProps?
    /** 
     Initialize the library.
     
     This must be called before any other API methods can be called. The
     initialization process runs asynchronously so that it won't block the main UI
     thread.
     
     You need to make sure it is successful before calling any other API methods. The
     best way to do it is using the success block.
     
     void (^success)(FHResponse *)=^(FHResponse * res){
     //init succeeded, do stuff here
     };
     
     void (^failure)(id)=^(FHResponse * res){
     NSLog(@"FH init failed. Response = %@", res.rawResponse);
     };
     
     [FH initWithSuccess:success AndFailure:failure];
     
     @param sucornil Block to be called if init is successful. It could be nil.
     @param failornil Block to be called if init is failed. It could be nil.
     */
    public class func setup(completionHandler: (InnerCompletionBlock)) -> Void {
        // TODO register for Reachability
        // TODO check if online otherwise send error
        // TODO read properties file, get  host
        let http = Http(baseURL: "https://aerogear.feedhenry.com")//"https://redhat-demos-t.sandbox.feedhenry.com")
        let config = FeedHenryConfig()
        let defaultParameters: [String: AnyObject]? = config.params
        // TODO set headers with appkey: is it needed??
        http.POST("/box/srv/1.1/app/init", parameters: defaultParameters, credential: nil, completionHandler: {(response: AnyObject?, error: NSError?) -> Void in
            if let error = error {
                completionHandler({throw error})
            } else {
                // using JsonResponseSerializer
                let resp = response as? [String: AnyObject]
                // TODO save cloudProps
                completionHandler({return resp})
            }
        })
    }
    
    public class func performCloud(path: String, completionHandler: InnerCompletionBlock) {
        
    }
}