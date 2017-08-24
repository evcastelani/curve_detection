# Algorithm for Curve Detection

This package is devoted for detection of shape in binarized images. 

All implementations were made using [Julia Language](www.julialang.org). In this stage we put for testing just a rough implementation of HT. 

For test all algorithm you need

* Install Julia Language
* Install some dependencies

For install all dependencies just type in Julia REPL:
 "Pkg.add("Images")"
 "Pkg.add("Colors")" 
 "Pkg.add("FixedPointNumbers")"
 "Pkg.add("ImageView")"

 After that, you need to include the setup file. For this, just type 
 "include("setup_tests.jl")".

 In order to run some problem type something like: 
 "run_prob("datafile-50-300-30-10","HT",20,true,false)", for artificial problems or
 "run_prob("moedas","HT",20,true,true)", for real problems.

 All images (real or artificial) are in /real_examples folder or /synthetic_example folder.

 This implementation was made by:

 - Emerson Vitor Castelani
 - Wesley V. I. Shirabayashi
 - Jair da Silva
 - Eduardo Neves 
