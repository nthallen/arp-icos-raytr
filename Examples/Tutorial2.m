%% Tutorial2: ICOS_sr_search
% ICOS_search was the first module created to explore and compare
% different configurations at a higher level. It was created before
% the development of the skew and divergence model, and was originally
% intended to look for viable configurations using off-the-shelf
% components within various physical constraints. It lacks the level
% of analysis that ICOS_sr_search has for what really constitutes a
%viable configuration. On the other hand, there are features of
% ICOS_search that are still useful, most notably the auto-focus
% utilities and the tie-in to in-depth analysis using ICOS_beam.
% These are actually used by ICOS_sr_search to provide the same
% capabilities.
%
rd = 0.08; % Define the target radius at the detector
th = 13; % Define the target angle from normal at the detector
L = 50; % Cavity length
mnc = sprintf('L%02d_rd%02d_th%.1f', L, floor(rd*100), th);
SR = ICOS_sr_search('mnc',mnc,'L',L,'B',0.4,'Rw1',0.2, 'rd', rd, 'th', th);
SR.enumerate;
%% These two methods calculate the design and build tolerances
% The design tolerance specifies how much the cavity length might need
% to be changed to accomodate errors in mirror radius of curvature
% allowed by the manufacturer's stated tolerance. Internally, we calculate
% a minimum (making the cell shorter) and maximum (making it longer). For
% the following analyses, we simply use the difference between those.
SR.design_tolerance;
% The build tolerance assumes we actually know the radius of curvature of
% the mirrors and calculates how much the cell length can vary and still
% remain in a non-overlapping pattern to avoid optical resonances.
SR.build_tolerance;
%% These tools offer different ways to visualize the set of solutions
% enumerated by the SR.enumerate method. You can use Matlab's Data Cursor
% tool to select individual points and see the relevant design parameters.
% You can also use Matlab's zoom features to zoom in on a particular area
% of interest. For example, you may need to zoom in vertically to examine
% points that are grouped close to one of the axes.
% If you deselect both the zoom and data cursor features, you can click and
% drag to select specific configurations. The selected points will then be
% drawn with a red circle around them. When you close the figure, the
% points you have selected will be remembered and carried forward to the
% next tool.
%
% The first view looks at build tolerance vs the length of the reinjection
% module (RLmin)
SR.explore_build_tolerance;
%% This view looks at build tolerance vs design tolerance.
% Hint: we're looking for relatively large values for build tolerance and
% relatively small values for design tolerance.
SR.explore_build_tolerance(2);
%% This view looks at build tolerance vs the ratio of radii of the beam
% spot patterns on the two ICOS mirrors. This is a way of assessing whether
% the pattern is more cylindrical or conical.
SR.explore_build_tolerance(3);
%% This view looks at the configurations plotted according to the radius
% of curvature of the two ICOS mirros.
SR.explore_build_tolerance(4);
%%
% SR.savefile writes the SR object out to a file based on the mnemonic
SR.savefile;
%%
% SR.focus runs the auto focus search for each of the configurations
% selected using explore_build_tolerance. The results for each
% configuration are written out to a separate .mat file prefixed with 'IS'
% (since these are ICOS_search objects). Each IS file includes
% specifications for multiple possible focusing configurations.
% If you are curious and don't mind having your computer tied up for
% a few minutes, you can change the 'focus_visible' option to 1 to see the
% focus configurations as they are identified.
SR.focus('focus_visible',0);
%%
% This will collect the names of all the IS_ files we just generated
pattern = ['IS_' mnc '*.mat'];
files = dir(pattern);
%%
% Now we can step through each file and select interesting focus
% configurations for further analysis. This is like
% explore_build_tolerance. The x-axis is the total length of the optical
% configuration. All of the differences in this view are due to the choice
% of focusing configuration. The y-axis indicates the relative position of
% the last focusing lens as a fraction of the distance from the previous
% optic to the detector. It makes sense to choose a configuration that
% gives you some range of motion in either direction, so something closer
% to 0.5 than to either 0 or 1.
for i=1:length(files)
  clear IS
  load(files(i).name);
  if exist('IS','var') && ~isempty(IS.res2)
    IS.explore_focus;
    IS.savefile;
  end
end
%%
% The final step is to run the full focusing analysis. This loop will
% analyze every configuration you selected, and each one takes several
% minutes. You can interrupt the process at any time by typing ctrl-C in
% the main Matlab command window.
% Status updates will be printed approximately every minute. The default
% analysis specified here uses 100 passes per configuration, and the number
% of passes is reported on each status update to give you a sense of how
% long the operation will take.
% As the analysis for each configuration is completed, four plots will be
% displayed showing both high resolution and detector resolution heat maps
% at the detector surface. The 'bad angle' plots depict power that reaches
% the plane of the detector but is rejected for exceeding the acceptance
% angle of the detector.
for i=1:length(files)
  clear IS
  load(files(i).name);
  if exist('IS','var') && ~isempty(IS.res2) && any([IS.res2.sel])
    fprintf(1,'Analyzing %s\n', IS.ISopt.mnc);
    IS.analyze;
    close all
  end
end
