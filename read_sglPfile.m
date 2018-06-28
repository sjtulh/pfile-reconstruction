% Read the header and the data of a P file.
%
% [hdr, raw_data] = read_Pfile(Pfile);
% Pfile		Name (including path) of the P file
% hdr		Structure containing data from the header
% raw_data	K-space data

%meic function [hdr, raw_data] = read_Pfile(Pfile);
function [hdr, raw_data] = read_sglPfile(vers, chp, Pfile, N_sl, nph, necho)
if nargin == 5 && exist('necho','var')==0, necho = 1; end;
% Open the file
fid = fopen(Pfile, 'r', 'ieee-le'); %meic b -> l
% meic -->
if fid == -1
    error(['Can not open ' Pfile]);
end
%<-- meic 03-14-2009
% Read the header
if vers == 12
    [hdr] = read_hdr_12(fid);
    hdrs=read_gehdrP11(Pfile); 
else
    [hdr] = read_hdr_14(fid);
    hdrs=read_gehdrP11(Pfile); 
end
hdr.Pname = Pfile;

% Redefine locally some header parameters using only the field names
N_hor = hdr.N_hor;
N_ver = round(hdr.N_ver); % meic
%N_sl = hdr.N_sl;% meic 052209
%N_sl = hdrs.N_sl;% meic 05220
%N_sl =8;
ncoils = hdr.ncoils;
% nechoes = hdrs.nechoes;
%nph = hdr.nph;
%nph=1; % meic
%scale = hdr.scale;   
    
% Read the actual data
k_size = 2*N_hor*N_ver;  % '2' for real and imaginary
                         % # of data in unit of INT16 (INT32 if EDR on)
baseline = 2*N_hor;      % '2' for real and imaginary
temp = zeros(2, N_hor*N_ver);
real_part = zeros(N_hor, N_ver); 
imag_part = zeros(N_hor, N_ver); 
fseek(fid, hdr.size, 'bof'); % skip header


for icoil = 1:ncoils % icoil
    for iecho = 1: necho
    for isl = 1:N_sl % isl 
        for iph = 1:nph % iph
            if hdrs.point_size == 4
                fseek(fid, baseline*4, 'cof'); % 4 For long integer
                [buf, count] = fread(fid, k_size, 'integer*4');
            else
                fseek(fid, baseline*2, 'cof'); % 2 For short integer
                [buf, count] = fread(fid, k_size, 'integer*2');
            end
            if count ~= k_size
                error(['Only ' num2str(count) ' of ' num2str(k_size) ...
                    ' bytes were read for coil #' num2str(icoil) ', phase #' ...
                    num2str(iph) ', slice #' num2str(isl)]);
            end
            temp(:) = buf(:);
            real_part(:) = temp(1,:);
            imag_part(:) = temp(2,:);
            raw_data(:,:,isl,icoil,iph,iecho) = (real_part' + 1i*imag_part') ...
               ;  %Bruno did:  * scale
        end
    end
end  %meic% 
end
% Apply Nyquist modulation along freq.-enc. direction
% modulation = (-1).^(1:N_hor);
% raw_data = raw_data .* repmat(modulation, [N_ver 1 1 ncoils nph]);

fclose(fid);

% % Apply Nyquist modulation along freq.-enc. direction
% modulation = (-1).^(1:N_hor);
% raw_data = raw_data .* repmat(modulation, [N_ver 1 1 ncoils nph]);

% % Apply Nyquist modulation to undo RF chopping
if chp==1
    modulation = (-1).^(1:N_ver)';
%    for isl = 1:N_sl
        raw_data = raw_data .* repmat(modulation, [1 N_hor N_sl ncoils nph necho]);
%    end
end
%meic: apply a factor to correct large number data
%raw_data = raw_data / 65536;