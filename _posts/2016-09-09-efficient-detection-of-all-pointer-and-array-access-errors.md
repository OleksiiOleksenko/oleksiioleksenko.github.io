---
title: "Notes on: Efficient detection of all pointer and array access errors"
date: 2016-09-09 12:00
layout: post
headerImage: false
tag:
- security
category: blog
author: me
---

[Efficient detection of all pointer and array access errors](http://dl.acm.org/citation.cfm?id=178446) - Austin et al.

A nicely written security paper, which, to my knowledge, was the first one to introduce fat pointers (a.k.a. safe pointers). 

## Motivation

Memory attacks always were and still are prevailing among applications written in low-level languages such as C and C++. A memory attack is a scenario in which an adversary gets access to the region of memory she is not allowed to. 

## Idea

We can prevent the adversary from doing a memory attack if we restrict her actions on a fine grained level. In particular, we can transform all pointers in a program to contain not only memory addresses, but also some additional metadata. It's enough to keep two main parameters: *pointer bounds* --- the lowest and the highest address of the memory region the pointer is allowed to use, and some information about the pointer lifetime so that we can detect if the pointer is used before the object was created or after it was deleted.

In a nutshell, the resulting program transformation looks as follows:

* when a pointer is created (e.g., on memory allocation or using operator '&'), it stores the objects' metadata;
* at object deallocation, its pointers are marked illegal; 
* all pointers operations (e.g., pointer arithmetic) are replaced with equivalent ones with metadata propagation;
* on each memory access, the referenced object is checked if it matches the pointer's metadata.


## Implementation

The transformation is performed on the source code level, i.e., the source code itself is changed (automatically, of course). I haven't found how they were doing it exactly and what tools were they using.

They do not mention it in the paper, but it will probably lead to incompatibility with external pre-compiled libraries, since the very notion of a pointer has changed. An application will work only if all re dependencies are re-compiled with this protection enabled. 

## Performance

The numbers are pretty bad, up to 540% slowdown. But that was the first attempt on full memory protection, so it doesn't really matter for this case. The goal was to provide security first. 