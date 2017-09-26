/**
 * Copyright (c) 2016, Plexteq
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks.h"

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    createBookmark
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_createBookmarkImpl
(JNIEnv *env, jclass class, jstring location)
{
    const char *nativeLocation = (*env)->GetStringUTFChars(env, location, 0);
    
    NSString *nsLocation = [NSString stringWithCString:nativeLocation encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file:///%@", nsLocation]];
    
    NSError* error;
    NSData* bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                               includingResourceValuesForKeys:nil
                                                relativeToURL:nil
                                                        error:&error];
    
    (*env)->ReleaseStringUTFChars(env, location, nativeLocation);
    
    // Returning base64 bookmark representation to the caller
    const char* stringifiedBookmark = [[bookmark base64EncodedStringWithOptions:0]
                                       cStringUsingEncoding:NSUTF8StringEncoding];
    
    return (*env)->NewStringUTF(env, stringifiedBookmark);
}

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    startResourceAccessing
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT jstring JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_startResourceAccessingImpl
(JNIEnv *env, jclass class, jstring bookmark)
{
    BOOL isStale;
    NSError* error;
    
    const char *nativeBookmark = (*env)->GetStringUTFChars(env, bookmark, 0);
    NSString *nsBookmark = [NSString stringWithCString:nativeBookmark encoding:NSUTF8StringEncoding];
    NSData *rawBookmark = [[NSData alloc] initWithBase64EncodedString:nsBookmark options:0];
    
    NSURL* accessResource = [NSURL URLByResolvingBookmarkData:rawBookmark
                                                  options:NSURLBookmarkResolutionWithSecurityScope
                                            relativeToURL:nil
                                      bookmarkDataIsStale:&isStale
                                                    error:&error];
    
    //TODO: handle bool of startAccessingSecurityScopedResource
    // and return that to the calling side
    [accessResource startAccessingSecurityScopedResource];
    
    (*env)->ReleaseStringUTFChars(env, bookmark, nativeBookmark);
    
    const char* securityScopedUrl = [[accessResource absoluteString] cStringUsingEncoding:NSUTF8StringEncoding];
    return (*env)->NewStringUTF(env, securityScopedUrl);
}

/*
 * Class:     com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks
 * Method:    stopResourceAccessing
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_plexteq_ssb_nativeimpl_SecurityScopedBookmarks_stopResourceAccessingImpl
(JNIEnv *env, jclass class, jstring bookmark)
{
    BOOL isStale;
    NSError* error;
    
    const char *nativeBookmark = (*env)->GetStringUTFChars(env, bookmark, 0);
    NSString *nsBookmark = [NSString stringWithCString:nativeBookmark encoding:NSUTF8StringEncoding];
    NSData *rawBookmark = [[NSData alloc] initWithBase64EncodedString:nsBookmark options:0];
    
    NSURL* accessResource = [NSURL URLByResolvingBookmarkData:rawBookmark
                                                      options:NSURLBookmarkResolutionWithSecurityScope
                                                relativeToURL:nil
                                          bookmarkDataIsStale:&isStale
                                                        error:&error];
    [accessResource stopAccessingSecurityScopedResource];
    
    (*env)->ReleaseStringUTFChars(env, bookmark, nativeBookmark);
}
