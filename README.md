# ATT: Streaming Tensor-Train Decomposition with Missing Data

Tensor tracking which is referred to as online (adaptive) decomposition of streaming tensors has recently gained much attention in the signal processing community due to the
fact that many modern applications generate a huge number of multidimensional data streams over time. In this paper, we propose an effective tensor tracking method via tensor-train
format for decomposing high-order incomplete streaming tensors. On the arrival of new data, the proposed algorithm minimizes a weighted least-squares objective function accounting for both
missing values and time-variation constraints on the underlying tensor-train cores, thanks to the recursive least-squares technique and the block coordinate descent framework. Our algorithm is
fully capable of tensor tracking from noisy, incomplete, and highdimensional observations in both static and time-varying environments. Its tracking ability is validated with several experiments
on both synthetic and real data.

![tt](https://user-images.githubusercontent.com/26319211/175497122-8f6900e5-740f-4231-97a3-4556114188e7.PNG)



## Dependencies 
+ Our MATLAB code requires the [Tensor Toolbox](http://www.tensortoolbox.org/) which is already attached to this repository.
+ MATLAB 2019a


## Demo
+ Run demo_xyz.m for synthetic data

## Some Results

+ Noisy data


![effect_noise](https://user-images.githubusercontent.com/26319211/175498006-a9163a09-109e-4a22-97a7-4f4cee2e0c33.PNG)

+ Missing data


![Effect_missing](https://user-images.githubusercontent.com/26319211/175498143-2b895bb9-cd76-47ce-8e93-f18f04ed7b30.PNG)


## Reference


This code is free and open source for research purposes. If you use this code, please acknowledge the following paper.

[1] L.T. Thanh, K. Abed-Meraim, N.L. Trung, A. Hafiance. "[*Streaming Tensor-Train Decomposition with Missing Data*](https://drive.google.com/file/d/1pmIGbtrTbG6axDhM-VrfrKqgaDWhMw-z/view?usp=sharing)". **TeckRxiv**, 2022. [[PDF](https://drive.google.com/file/d/1pmIGbtrTbG6axDhM-VrfrKqgaDWhMw-z/view?usp=sharing)].

