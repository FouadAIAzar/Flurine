function [eem_cor,correct,eem_filter] = cleanscan(eem)
%Syntax  [eem_cor, correct, eem_filter] = cleanscan(eem,tol,coeff,baseopt)
%
% Corrects an excitaion-emmision matrix flurometer scan (EEM) to remove 
% specific optical abberations (i.e. 1st-order Rayleigh Scatter, 2nd order 
% Rayleigh scatter (i.e. Overtones) and their associated Raman Scatter
% peaks). If the tolerance <1000 are specified in the correct matrix,
% fluorescence values in scatter regions (i.e. peaks emmision +/- tolerance
% in nm for each excitation wavelength) are excised and replaced by 
% interpolation of the surrounding data using a three-dimensional Delauny
% triangulation method. If tolerances >= 1000 are specified, values in the 
% corresponding portion of the EEM will be replaced with a constant value
% 'baseopt' (i.e. truncated).
% Tolernace values of 0 can be used to slecatively disable correction of
% the scatter peaks.
%
% Input arguments: 
%
%   'eem' is a matrix of EEM data, with excitation wavelengths in the first
%   row, emission wavelengths in the first column, and corresponding 
%   fluorescence intesity values for each ex/em wavelength combination. The
%   The top left cell is ignored but copied to the output matrix in case it
%   contains information. Note that single emission and single exciataion
%   scans are supported, but they mus be in 'eem' format as described (i.e.
%   must include the excutation or emission wavelength in the first row or
%   coloumn, resp.)                                                        
%   
%   'tol' is an n row by 2 coloumn matrix of correction tolernaces in nm. 
%   coloumns specify tolerances below (left col) and above (right col) the
%   peak emission at each excitation wavelength. Typical row assignments
%   are as follows:
%       row 1: primary Rayleigh scatter
%       row 2: primary Raman scatter
%       row 3: secondary Rayleigh scatter
%       row 4: secondary Raman scatter
%   Use tolerances >= 1000 to truncate corresponding portions of an EEM and
%   set truncated values to 'baseopt' (note: truncation overrides excising)
%   Typical example with truncation of emissions below excitation
%   wavelength:
%       [1000  12; …]
%       [16    16; … ]
%       [18    18; …]
%       [18    18; …]
%
%   'coeff' is a matrix of polynomial curve fir coefficients which describe
%   the excitation wavelenth-dependent emission wavelength for each scatter
%   peak. Coefficients must be in rows and ordered appropriately for the
%   'polyval' function (i.e. x^n,x^(n-1),… , constant). Row assignments
%   must match the tol matrix, but any power polynomial can be specified.
%   Typical example for a second-order polynomial matching tol above:
%       [ 0.0000 1.0000   0.0000]
%       [ 0.0060 0.8711  18.7770]
%       [ 0.0000 2.0000   0.0000]
%       [-0.0001 2.4085 -47.2965]
%   equivalent to : 0x^2 + 1x + 0, 0.0006x^2 + ... etc.
%   
%   'baseopt' specifies optional besline value to substitute for values in
%   truncated scan regions. Default value is 0
%
% Output parameters: 'eem_cor' corrected EEM; 'correct' correction matrix
% reflecting any chnages following validation; 'eem_filter' is the filter
% matrix used to correct 'eem' (i.e. a matrix of ones and zeros the same
% dimensions as 'eem_cor', with zeros representing values in scatter
% regions which were excised or truncated')

%%
% initialize variables for clean scan
% correction tolerance
correct = [12 12; 16 16 ; 18 18; 18 18];
% polynomial curve fit coefficients
parms = [0 1.0000 0; 0.0006 0.8711 18.770; 0 2.0000 0;...
    -0.0001 2.4085 -47.2965]; 
% baseline value
baseopt = 0;

%%
eem_cor = [] ;
eem_filter = [] ;

%if nargin >= 3  %check for minimum number of arguments
    
    if ~exist('baseopt') %assign default baseopt
        baseopt = 0;
    end
    
    if size(correct,2) < 2 %single coloumn format -replicate value
        correct = [correct correct];
    end
    
    cancel = 0;
    
    %validate input arguments
    [ex,em,fl,fl_id] = unwarpeem(eem);
    
    if isempty(fl) %validate data matrix
        cancel = 1;
        errormsg = 'EEM datamatrix is invalid';
    elseif size(parms,1) ~= size(correct,1) %validate polyfit parms
        cancel = 1;
        errormsg =...
           'Curve-fit coefficient matrix does not match correction matrix';
    end
    
    if cancel == 0 %proceed with analysis
        
       %from observed emmission matrix
       em_obs = repmat(em,1,length(ex));
        
       %initilize filter matrices 
       filt_excise = ones(size(em_obs));
       filt_trunc = zeros(size(em_obs));
       
       %loop through correction parameters for each peak
       for n = 1:size(correct,1)
           
           if correct(n,1)>0 | correct(n,2)>0 %test for no filter condition
               
             peaks = polyval(parms(n,:),ex); %get array of scatter peak 
                                             %emissions 
             
             %from appropriate filter matrices for emmisions below scatter 
             %peak 
             if correct(n,1) < 1000 %excise
                 em_below = (em_obs -...
                     repmat(peaks-correct(n,1),length(em),1)) <= 0;
             else % turncate
                 %creat logical index the same dimensions as em_sgolayfilt
                 %(obs, with vals below the scatter peak lowvr limit = 1, 
                 %update turncation filter
                 em_below = (em_obs - repmat(peaks, length(em),1)) <= 0;
                 filt_trunc(em_below) = 1;
             end
             
             %from appropriate filter matrices for emissions above scatter
             %peak
             
             if correct(n,2) < 1000 %excise
                 em_above = (em_obs -...
                     repmat(peaks+correct(n,2),length(em),1)) >= 0;
                
             else %turncate
                 %create logical index the same dimensions as em_obs, with
                 %vals above the scatter peak lower limit = 1, update
                 %turncation filter
                 em_above=(em_obs-repmat(peaks,length(em),1))>=0;
                 filt_trunc(em_above) = 1;
             end
              %update excise filter matrix using combination of logical
              %indices (excise region = 0)
              filt_excise = filt_excise .* (em_below + em_above);
           end
       end
       
       %substitute 'baseopt' for truncated values
       fl(filt_trunc == 1) = baseopt;
       
       %update master filter to account for truncations
       filt_excise(filt_trunc == 1) = 1;
       
       %get index of excised values
       I_excise = find(filt_excise == 0);
       
       %excise values and grid data to reconstitute EEM is necessary
       if ~isempty(I_excise)
           
           %replace zeros with NaN
           fl(I_excise) = NaN;
           
           %for matched ex, em, fl vectors
           em_vec = reshape(em*ones(1,length(ex)), length(em)*length(ex),1);
           ex_vec = reshape(ones(length(em),1)*ex,length(em)*length(ex),1);
           fl_vec = reshape(fl,length(em)*length(ex),1);
           
           %get index of valid data points
           I_valid = find(~isnan(fl_vec));
           
           %interpolate using 2D or 3D algorithm as appropriate
           if size(fl,2) > 1
               
               if size(fl,1) > 1 %EEM matrix
                   %grid valid data points to form new EEM
                   fl = griddata(ex_vec(I_valid),...
                       em_vec(I_valid),fl_vec(I_valid),ex,em);
               else %excitation scan
                   %interpolate single ex scan
                   fl = interp1(ex_vec(I_valid),...
                       fl_vec(I_valid),ex,'spline');
               end
               
           else %emission scan 
               %interpolate single em scan
               fl = interpl(em_vec(I_valid),fl_vec(I_valid),em,'spline');
           end
           
           
           %zero out any nulls or negative or near zero values
           fl = noneng(fl);
       end
       
       %assemble output EEM
       eem_cor = wrap(ex,em,fl,fl_id);
       
       %assemble total correction filter in EEM form
       filt_excise = filt_excise .* (filt_trunc < 1);
       eem_filter = wrap(ex,em,filt_excise);
       
    end
    
%else
    
%    errormsg = 'Too few arguemtns for function';
%    cancel = 1;
    
%end

if cancel == 1
    clc
    disp(' '); disp(' ')
    disp(errormsg)
    disp(' '); disp (' ')
end








