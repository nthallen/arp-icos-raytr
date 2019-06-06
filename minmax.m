function lims = minmax(A)
% lims = minmax(A)
% Similar to bounds(), but returns a 1x2 vector instead of 2 separate
% arguments
% 6/6/2019: Added as replacement for minmax which disappeared
[S,L] = bounds(A);
lims = [S,L];
