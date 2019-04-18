% This script initialises lots of global and local variables and does other
% things that are needed before getting started
%--------------------------------------------------------------------------

% close all windows, clear all memory  
clear all; close all; clc;

% define various constants and parameters used
set_constants;

task_planets = double(zeros([ntasks ntaskruns])); % list of planets for each task
task_runs    = double(zeros([ntasks ntaskruns])); % list of runs for each task

% if necessary, create the directory in which to store all of the results
if ~exist('results', 'dir')
    mkdir('results');
end;
sname = sprintf('results/%s', savename);
if ~exist(sname, 'dir')
    mkdir(sname);
end;

