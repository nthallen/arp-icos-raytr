%%
P = ICOS_Model6.props;
P.visible = 1;
PM = ICOS_Model6(P);
%%
P = ICOS_Model6.props;
P.visible = 1;
P.R1 = 75;
P.r1 = 1.5*2.54;
P.R2 = 75;
P.r2 = 2.7874*2.54/2;
P.HRC = 47.9757;
P.herriott_spacing = 10;
P.Hr = 4.2349*2.54/2;
P.y0 = 2;
PM = ICOS_Model6(P);
%%
P.injection_scale = 0.5;
P.HR = 0;
P.visible = 0;
P.plot_endpoints = 3;
%%
dy = .06;
dz = .035;
delta = .01;
%% Run this a few times
PM = ICOS_Model6(P,'dy',dy + delta * linspace(-1,1,11),'dz',dz + delta *linspace(-1,1,11));
[dy,dz] = PM.identify_minimum('eccentricity');
delta = delta/5;
PM.clean_results;
PM.plot_results('eccentricity'); shg;
%%
P.dy = dy;
P.dz = dz;
P.injection_scale = 1;
P.visible = 1;
PM = ICOS_Model6(P);
%%
P.HR = 0.98;
P.stop_ICOS = 1;
P.plot_endpoints = 2;
P.visible = 0;
PM = ICOS_Model6(P,'herriott_spacing',linspace(8,25,31));
%%
hs = PM.identify_minimum('eccentricity');
delta = 1;
%% Run this a couple times
PM = ICOS_Model6(P,'herriott_spacing',hs + delta * linspace(-1,1,21));
hs = PM.identify_minimum('eccentricity');
PM.clean_results;
PM.plot_results('eccentricity'); shg;
delta = delta/5;
%%
P.herriott_spacing = hs;
P.stop_ICOS = 0;
P.visible = 1;
PM = ICOS_Model6(P);
%%
P.max_rays = 3000;
P.ICOS_passes_per_injection = 60;
PM = ICOS_Model6(P);


