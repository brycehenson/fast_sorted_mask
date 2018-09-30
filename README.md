# fast_sorted_mask
matlab code for fast masking of ordered vectors based on binary search
Selecting a subset of a vector that is between some limits (herein *masking*) is a widely used analytical tool. The common approach of comaring each element to the upper and lower limit  (herin *Brute compare*) has complexity O\~ n . The novel contribution of this code is a demonstration of a relatively simple approach that uses binary compare on an ordered vector to acceive superior performance in two cases. 
1. Data that is already sorted (O\~log(n) cf. brute O\~n).
2. When there is a requirement to repeatedly (m) mask the same data such that the the inial cost of the sort is offset by the increased speed of the operation. (O\~n·log(n)+m·log(n) )

The code here demosntrates the algorithm in native matlab and provides a number of tests in order to compare the performance.

| ![A comparison of various masking approaches](fig1.png "Fig1") | 
|:--:| 
 **Figure1**- Execution time for various methods.  |
 


| ![A comparison of various masking approaches](fig2.png "Fig2") | 
|:--:| 
| **Figure2**-**(a)** (Top left)The Relative execution time of the algorithm run on sorted data (of length n) compared to a simple brute compare approach.**(b)** (Top right) The Relative execution time of sorting data and then running the algorithm m times compared to the a simple brute compare approach (that does not requires sorted data) for the same m executions.**(c)**(Bottom left) the number of repeated uses (m) that are required in order to offest the inital sort time and produce the same execution time as the brute compare. **(d)**(Bottom right) as in **(b)** with varied m and fixed n.  |
