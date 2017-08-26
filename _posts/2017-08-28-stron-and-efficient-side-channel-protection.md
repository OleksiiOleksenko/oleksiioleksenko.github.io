---
layout: post
date: 2017-08-28 12:00
title: "A paper in short: Strong and Efficient Cache Side-Channel Protection using Hardware Transactional Memory"
tag: Security
comments: true
---

[Strong and Efficient Cache Side-Channel Protection using Hardware Transactional Memory](https://www.usenix.org/conference/usenixsecurity17/technical-sessions/presentation/gruss) - Gruss et al.

A paper presenting Cloak, a defense mechanism against cache side-channel attacks based on preloading and transactional memory.

# Idea

* User (i.e., an application developer) marks a piece of code as critical
* User states the working set of this piece of code 
* Cloak preloads the working set before executing the piece of code thus ensuring that all necessary data is in L1 cache (or LLC, depends on configuration)
* Cloak wraps the code in a TSX transaction
    * To be precise, it does not have to be a TSX transaction, any implementation of Transactional Memory will do
* If an adversary tries to launch a cache side-channel attack, it will cause cache misses and the transaction will be aborted

# Limitations

Although being a nice and rather efficient solution, this approach has several issues.

## Manual changes

On my opinion, the most important limitation of the paper is that it is not an automated solution.
Cloak protects user-defined parts of code on ad-hoc basis.
It implies that the side-channel leakage is already known or is anticipated in the given part of code.
Accordingly, Cloak can be applied to fix a known vulnerability in an application or to protect a small security-critical function.
It cannot, however, protect the whole application.
At least, not without considerable development effort and at cost of high performance overhead (judging from results of T-SGX, at least 60% and probably much higher).

## TSX

Cloak also suffers from certain limitations of TSX:

* Read set of the protected code must be smaller than the size of LLC and the write set - of L1. Otherwise, the code will experience cache misses and accordingly, false positives. 
    * We can partially overcome this limitation by splitting the code into smaller transactions, but it requires even more manual labor and prone to leaving out some of the leakage.
* The data structure tracking the read/write sets of a TSX transaction is not documented by Intel. Therefore, we cannot be completely sure that it detects all the cache misses, which might lead to false negatives.
* If the attacker is quick enough, a small amount leakage still remains. Fortunately, the necessary attack resolution is possible only with Flush+Reload attacks, which are relatively hard to mount (require shared memory).

