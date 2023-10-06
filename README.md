# ATT: A Novel Recursive Least-Squares Adaptive Method For Streaming Tensor-Train Decomposition With Incomplete Observations

Tensor tracking which is referred to as the online (adaptive) decomposition of streaming tensors has recently gained much attention in the signal processing community due to the
fact that many modern applications generate a huge number of multidimensional data streams over time. In this paper, we propose an effective tensor tracking method via tensor-train
format for decomposing high-order incomplete streaming tensors. On the arrival of new data, the proposed algorithm minimizes a weighted least-squares objective function accounting for both
missing values and time-variation constraints on the underlying tensor-train cores, thanks to the recursive least-squares technique and the block coordinate descent framework. Our algorithm is
fully capable of tensor tracking from noisy, incomplete, and high-dimensional observations in both static and time-varying environments. Its tracking ability is validated with several experiments
on both synthetic and real data.

![tt](https://user-images.githubusercontent.com/26319211/175497122-8f6900e5-740f-4231-97a3-4556114188e7.PNG)


## Dependencies 
+ Our MATLAB code requires the [Tensor Toolbox](http://www.tensortoolbox.org/).
+ MATLAB 2019a or newer.

## Demo
+ Run demo_xyz.m for synthetic data.

## State-of-the-art algorithms for comparison
+ TeCPSGD: “[*Subspace learning and imputation for streaming big data matrices and tensors*](https://ieeexplore.ieee.org/document/7072498)”. **IEEE Trans. Signal Process.**, 2015.
+ TT-FOA:  “[*Adaptive Algorithms for Tracking Tensor-Train Decomposition of Streaming Tensors*](https://ieeexplore.ieee.org/document/9287780)”. **Proc. 28th EUSIPCO,** 2020.
+ ACP & ATD:  “[*Tracking Online Low-Rank Approximations of Higher-Order Incomplete Streaming Tensors*](https://www.cell.com/patterns/fulltext/S2666-3899(23)00104-6)”. **Patterns**, 2023.

## Some Experimental Results

+ Noisy data

![effect_noise](https://user-images.githubusercontent.com/26319211/175498006-a9163a09-109e-4a22-97a7-4f4cee2e0c33.PNG)

+ Missing data

![Effect_missing](https://user-images.githubusercontent.com/26319211/175498143-2b895bb9-cd76-47ce-8e93-f18f04ed7b30.PNG)


## Reference

If you use this code, please cite the following paper.

[1] **L.T. Thanh**, K. Abed-Meraim, N. L. Trung and A. Hafiane. “[*A Novel Recursive Least-Squares Adaptive Method For Streaming Tensor-Train Decomposition With Incomplete Observations*](https://www.sciencedirect.com/journal/signal-processing/articles-in-press)”. **Signal Process.**, 2023. [[PDF]](https://thanhtbt.github.io/files/2023_SP_ATT.pdf).
