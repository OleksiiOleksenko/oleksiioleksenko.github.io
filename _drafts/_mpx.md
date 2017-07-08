 Noob view on MPX?

Intro - motivate pointer protection
* common bug and vulnerability
    - why?
    - consequences
    - types
        + overflows

Short existing solutions - SW based.
    * existing - SW based - leads to high performance overheads
    * 2-3 sentences on each 

Our hope - MPX should improve performance and make it usable in production
However, no full scale data on how it performs

Disclaimer - try to discuss generic, but with examples for linux.

+ examples on assembly
+ 


 ...make use of the MPX feature. That involves tracking every pointer created by the program and the associated bounds; any time that a new pointer is created, it must be inserted into the bounds table for checking. Tracking of bounds must follow casts and pointer arithmetic; there is also a mechanism for "narrowing" a set of bounds when a pointer to an object within another object (a specific structure field, say) is created. The function-call interface is changed so that when a pointer is passed to a function, the appropriate bounds are passed with it. Pointers returned from functions also carry bounds information

MPX does is (should be) compatible with legacy software.

Idea - associate pointer with bounds (lower and upper) and check them on each access. I.e., it can be applied selectively to a subset of pointers in a program.

To that end, whenever a pointer is dereferenced, the appropriate instructions are generated to perform a bounds check first.

Adds bounds registers + instructions to operate on them. - see wiki

An out-of-bound memory reference causes a #BR exception.



Each memory reference is instrumented with checks of base pointer used for memory access against bounds associated with that pointer.
Bounds are computed by compiler analysis of data flow for used pointer.

## MPX in general

### Instruction set

* `bndmk` - create bounds for buf
* `bndcl` - check that memory access doesn't violate buf's low bound
* `bndcu` - check that memory access doesn't violate buf's upper bound
see  wiki

### How it works

* on creation - add to bounds table
* on change - modify bounds table
* on dereference - bndcl + bndcu
* on bound violation - see bound violation

+ link to mpx-protected libraries - potential vulnerability and issue in benchmarking

### Bound violation

When a bounds violation is detected, the processor will trap into the kernel. The kernel, in turn, will turn the trap into a SIGSEGV signal to be delivered to the application, similar to other types of memory access errors. Applications that look at the siginfo structure passed to the signal handler from the kernel will be able to recognize a bounds error by checking the si_code field for the new SEGV_BNDERR value. The offending address will be stored in si_addr, while the bounds in effect at the time of the trap will be stored in si_lower and si_upper. But most programs, of course, will not handle SIGSEGV at all and will simply crash in this situation.

If the application violates the bounds specified in the bounds registers,
a separate kind of #BR is raised which will deliver a signal with
information about the violation in the 'struct siginfo'.

## Kernel support (user space interface to MPX feature - linux specific):

prctl  options: - may not be in the kernel
* PR_MPX_INIT - sets up MPX checking and turns on the feature
* PR_MPX_RELEASE - cleans everything up

The system runtime will probably turn on MPX (PR_MPX_INIT) as part of application startup, before the application itself begins to run (does it?)



## Terminology

prctl- (operations on a process)

---

trap - In computing and operating systems, a trap, also known as an exception or a fault, is typically[NB 1][1] a type of synchronous interrupt typically caused by an exceptional condition (e.g., breakpoint, division by zero, invalid memory access). A trap usually results in a switch to kernel mode, wherein the operating system performs some action before returning control to the originating process. A trap in a system process is more serious than a trap in a user process, and in some systems is fatal. In some usages, the term trap refers specifically to an interrupt intended to initiate a context switch to a monitor program or debugger.[2]

---

SIGSEGV - invalid memory access (segmentation fault)

---

Bounds Table - A data structure used to store bounds for pointers stored in memory. Bounds table associate pointer and its location in memory with bounds of pointer.

---
