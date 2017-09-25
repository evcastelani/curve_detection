# Algorithm for Curve Detection (ACD-Package)

This package is devoted for detection of shape in binarized images. 
We highlight that this package is BETA QUALITY, just for academic purposes.

All implementations were made using [Julia Language](https://julialang.org) and in 
this  stage the code can be very rough. There is three algorithms implemented: 
* one based on Gauss-Newton Method
* the HT for circle detection
* a new hybrid algorithm based on Gauss-Newton and HT.

For test all algorithm you need

* Install Julia Language
* Install some dependencies

For install all dependencies just type in Julia REPL:

 * ```Pkg.add("Images")```
 * ```Pkg.add("Colors")```
 * ```Pkg.add("FixedPointNumbers")```
 * ```Pkg.add("ImageView")```

 After that, you need to include the setup file. For this, just type 
 ```include("setup_tests.jl")```.

 In order to run some problem type something like: 
 
 ```run_prob("datafile-50-300-30-10","HT",20,true,false)```, for artificial problems or

 ```run_prob("moedas","HT",20,true,true)```, for real problems. Change ```HT``` by ```GN``` or ```HTGN``` in order to test other methods.

 All images (real or artificial) are in ```/real_examples``` folder or ```/synthetic_example``` folder.

 The folder ```/scripts``` contain some tests in artificial instances. 

 This implementation was made by:

 - Emerson Vitor Castelani
 - Wesley V. I. Shirabayashi
 - Jair da Silva
 - Eduardo Neves 
