[![Build Status](https://travis-ci.org/plexteq/PQSsbJNIBridge.svg?branch=master)](https://travis-ci.org/plexteq/PQSsbJNIBridge)

## Synopsis

This project contains native OSX code and Java JNI bridge to it in order to implement Security scoped bookmarks for your Java application that needs to function in Apple's sandbox environment. 

Bookmarking mechanism is needed when resource accessed by user intent needs to be accessed after application restarts without explicit user action (by default this is prohibited by OSX and could be handled only by using bookmarking mechanism).

See more details regarding Apple OSX Sandbox environment here: https://developer.apple.com/library/content/documentation/Security/Conceptual/AppSandboxDesignGuide/AppSandboxInDepth/AppSandboxInDepth.html

## Usage

* Run native-osx/SecurityScopedBookmarkLibrary/build.sh on your OSX machine with XCode. This will produce .dylib shared library which is already JNI compatible.
* In Java code in static initializer call ```System.load("/path/to/libSecurityScopedBookmarkLibrary.dylib");```

## API Reference

See SecurityScopedBookMarks.java for API available.

Examples:

Create a bookmark for a random file (done only first time resource is accessed).
After bookmark is created it should be persisted within the application in order to survive application restart.

```java
String bookmark = SecurityScopedBookmarks.createBookmarkImpl("/path/to/file");
```

Request access to a bookmarked resource (after application restart). Could be called multiple times in a row.

```java
SecurityScopedBookmarks.startResourceAccessingImpl("previously persisted bookmark");
```

Stop accessing resource. Deallocates bookmark removing it from integnal OSX bookmark registry.
SecurityScopedBookmarks.startResourceAccessingImpl for this bookmark won't work on further allocations.

```java
SecurityScopedBookmarks.stopResourceAccessingImpl("previously persisted bookmark");
```


