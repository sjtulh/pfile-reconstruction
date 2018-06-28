%
% Read in a time series (multiple phases) of Pfiles
% usage:
% [hdr, raw_data] = read_mPfile(vers, chp, var, N_sl, nph)
% hdr: header of last Pfile
% data: array(Ny,Nx,nsl,ncoils,nphs)
% var: '~/pfiles/090507/P512***.7'
%

function [hdr, raw_data] = read_mPfile(vers, chp, var, N_sl, nph, necho)
if nargin == 5 && exist('necho','var')==0, necho = 1; end;
if isempty(strfind(var, '*')) == 1
    [hdr, raw_data] = read_sglPfile(vers, chp, var, N_sl, nph, necho);
else
    filelist=dir(var);
    whereP=strfind(var,'P');
    for i = 1 : nph
        Pfile = [var(1:whereP(end)-1) filelist(i).name];
        [hdr, raw_data_temp] = read_sglPfile(vers, chp, Pfile, N_sl, 1, necho);
        raw_data(:,:,:,:,i) = raw_data_temp(:,:,:,:);
    end
end
%size(raw_data)    
