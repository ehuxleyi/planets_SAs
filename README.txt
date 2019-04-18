To run a sensitivity analysis follow these steps:

1. use WinRAR, 7-zip or similar to extract the contents of "planets_SAs_M.zip" 
    to a directory

2. start MATLAB

3. in MATLAB, change the directory to where you extracted the files to
   and then change to the subdirectory for the specific sensitivity analysis

4. enter the command "ts_master" in MATLAB's command window

5. when the tasks have finished running, type "ts_retriever" to fetch the 
    results then "ts_analyser" to analyse them


New users should run both the default serial and parallel versions before 
running these model variants.

Parameter values and settings can be edited in the file 'initialise.m'; the values of 
'nplanets' and 'nreruns' control how long a sensitivity analysis takes to complete. 

Sensitivity analyses should run correctly in Matlab R2014a and later versions. 
Statisitics, Wavelets, Parallel Computing and MATLAB Distributed Computing 
Server (MDCS) toolboxes must be installed. To run large simulations efficiently, 
it may be necessary to alter cluster properties such as 'walltime' and 'number 
of nodes' in MATLAB's Cluster Profile Manager.

You are free to use, modify and share the code in this directory according 
to the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 License
(https://creativecommons.org/licenses/by-nc-sa/4.0/)