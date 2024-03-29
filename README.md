# <img src="/figs/logo.png" alt="logo" width="400"/> 
**[Bryce M. Henson](https://github.com/brycehenson)**  
Matlab code for fast masking/selection of ordered vectors based on binary search.  
**Status:** This Code **is ready for use in other projects**. Testing is implemented and passing.  

[![View fast_sorted_mask on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/71222-fast_sorted_mask)
[![Build Status](https://img.shields.io/static/v1.svg?label=CSL&message=software%20against%20climate%20change&color=green?style=flat&logo=github)](https://img.shields.io/static/v1.svg?label=CSL&message=software%20against%20climate%20change&color=green?style=flat&logo=github)


Selecting the elements of a vector that lie between some limits (herein *masking*, sometimes known as 'gating') is a widely used analytical tool (eg. particle physics) commonly employed in the analysis routines of the He* BEC group ([@spicydonkey](https://github.com/spicydonkey/hebec_essentials),[@GroundhogState](https://github.com/GroundhogState)). 

The common approach to masking data involves comparing each element (n) to the upper and lower limit (herein *Brute compare*) has complexity O(n). The novel contribution of this code is a demonstration of a relatively simple approach that uses a binary search algorithm ( O(log(n)) ) on an ordered vector to achieve superior performance in two use cases. 
1. Data that is already sorted ( O(log(n)) cf. brute O(n) ).
2. When there is a requirement to repeatedly (m times) mask the same data such that the inial cost of the sort is offset by the increased speed of the mask operation. (O(n·log(n)+m·log(n)) cf. O(n·m) )  
Note that if m is small and you check that the data is ordered (eg issorted(data)) you have probably lost most of any potential speedup already.

There are two things that the user may want from this masking operation:
1. Returning the number of data points(or counts) in this mask (herein *return mask count*).
   * This is where the search based algorithm really shines compared to the brute mask (as it just subtracts the upper and lower index while the brute compare must count up the logical vector, see details).
2. Return the values of the data that makes it through this mask. (herein *retun mask values*)
   * This has a smaller speedup because copying a subset of a vector (even a contiguous block) is a substantially slower than the search.

The code here demonstrates the algorithm for both types (counting and subset) in native matlab and provides a number of tests in order to compare the performance.
For taking small slices of large (>1e6 elements) sorted vectors, a speedup of 1000x is demonstrated.

| ![A comparison of various masking approaches](/figs/fig1.png "Fig1") | 
|:--:| 
 **Figure1**- Comparison of the brute mask to the fast_sorted_mask on an i7-7700 @ 4.00GHz . The brute mask for sorted and unsorted data gives comparable performance at large n, however at intermediate n \~10^2.1 the sorted date version is slightly faster which is somewhat puzzling. The fast_sorted_mask execution time (for a presorted vector) is superior at all values of n>10^2.1, however when the sort time is induced is slower than the brute mask. If however the execution time includes the sort then for m=1e2 masking operations (and scaled) then superior performance is obtained.  |


| ![A comparison of various masking approaches](/figs/fig2.png "Fig2") | 
|:--:| 
| **Figure2**-**Retuning Counts** **(a)** (Top left)The Relative execution time of the algorithm run on sorted data (of length n) compared to a simple brute compare approach.**(b)** (Top right) The Relative execution time of sorting data and then running the algorithm m times compared to the a simple brute compare approach (that does not requires sorted data) for the same m executions.**(c)**(Bottom left) the number of repeated uses (m) that are required in order to offest the inital sort time and produce the same execution time as the brute compare. **(d)**(Bottom right) as in **(b)** with varied m and fixed n.  |


| ![A comparison of various masking approaches](/figs/fig3.png "Fig3") | 
|:--:| 
| **Figure2**-**Retuning Values** **(a)** (Top left)The Relative execution time of the algorithm run on sorted data (of length n) compared to a simple brute compare approach.**(b)** (Top right) The Relative execution time of sorting data and then running the algorithm m times compared to the a simple brute compare approach (that does not requires sorted data) for the same m executions.**(c)**(Bottom left) the number of repeated uses (m) that are required in order to offest the inital sort time and produce the same execution time as the brute compare. **(d)**(Bottom right) as in **(b)** with varied m and fixed n.  |

## Usage Examples
The brute compare implementation is very easy by using a logical mask vector:
```
mask=data>lower_lim & data<upper_lim 
```
(If you are not familaiar with Logical indexing [read more here](https://blogs.mathworks.com/loren/2013/02/20/logical-indexing-multiple-conditions/)  )
the number of counts (integer) may be extracted as
```
num_mask=sum(mask)
```
or the subset of data points (vector)
```
subset_mask=data(mask)
```
The equivelent (but faster) operation using fast_sorted_mask on ordered data is:
```
mask_idx=fast_sorted_mask(data,lower_lim,upper_lim);
num_mask=mask_idx(2)-mask_idx(1)+1;
subset_mask=data(mask_idx(1):mask_idx(2)); 
```
**WARNING: the data vector MUST be sorted. See figures above for when it is still advantagous to sort unordered data and then use this approach.**

## Also See
[fast_search_based_histogram](https://github.com/brycehenson/fast_search_based_histogram) where I apply similar principles to dramaticaly speed up histograming (in certian cases). 

## Future work
contributors welcome! Drop me an [email](mailto:bryce.m.henson+github.fast_sorted_maske@gmail.com?subject=I%20would%20Like%20to%20Contribute[github][fast_sorted_mask]) .
- figure out what the bump in the relative time is at n=10^7.05 
- Compile to C
  - attempts have not shown any improvement.
- Fast nd histogram to replace [histcn](https://au.mathworks.com/matlabcentral/fileexchange/23897-n-dimensional-histogram?focused=5198474&tab=function) & [ndhistc](https://au.mathworks.com/matlabcentral/fileexchange/3957-ndhistc)
- [x] add to fileexchange
- [x] Fast 1d histogram based on this approach
- [x] consolidate test scripts
- [x] check what the function does to counts that equal the bin edge
  
## Contributions
This project would not have been possible without the open source tools that it is based on.
- **Benjamin Bernard** Binary search modified from fileexchange project [binary-search-for-closest-value-in-an-array](https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array)
- ***Denis Gilbert***    [M-file Header Template](https://au.mathworks.com/matlabcentral/fileexchange/4908-m-file-header-template)
- ***Daniel Eaton***     ["Smart"/Silent Figure](https://au.mathworks.com/matlabcentral/fileexchange/8919-smart-silent-figure)
