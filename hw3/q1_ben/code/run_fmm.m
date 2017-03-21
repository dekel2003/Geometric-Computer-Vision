function [T] = run_fmm(F, src_points,t0, display)
T = fmm(F,src_points-1,t0,display);
