---
layout: default
date: 2016-09-02 12:00
title: "A paper in short: Control-Flow Integrity"
tag: Security
---

[Control-Flow Integrity](http://dl.acm.org/citation.cfm?id=1102165) - Abadi et al. 

## Motivation

Most of the attacks that *do* something malicious change the behavior of a target program. I've got to emphasize, we are not talking here about hiding confidential information but rather about protecting from taking control over the machine. In this scenario, if we can detect the change in the program's execution flow we can detect the attack. 

## Idea

Find out the *correct* program's behavior off-line and under safe conditions, and afterwards check that program follows it. More technically, we first create a control flow graph (CFG) and then add run-time checks that enforce it. This way, we protect from control-flow hijacking and also from some hardware faults.

## Implementation

The CFG is created from an application's binary and thus re-compilation is not required.

The run-time checks are added by binary instrumentation, i.e. directly in the assembly code. The instrumentation modifies all *call* and *ret* (return) instructions, as well as all their possible destinations (based on CFG). As a result, each destination gets a unique value that is checked before each call and return. If the program flow is changed, the new destination will have a different value and the check will fail. 

## Performance

The authors claim 16% slowdown on average, but this number seems a bit suspicious to me: firstly, because they used SPEC benchmark suite but tested only a subset of applications from it; secondly, because they  did not instrument dynamic libraries thus having a part of the application unprotected.