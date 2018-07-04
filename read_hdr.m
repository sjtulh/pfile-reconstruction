function hdr = read_hdr(fid)
fseek(fid, 0, 'bof');
hdr.version = fread(fid, 1, 'float');
if floor(hdr.version) == 14 || floor(hdr.version) == 15
    hdr = read_hdr_14(fid);
elseif floor(hdr.version) == 24
    hdr = read_hdr_24(fid);
else
    error(['Error: wrong version number ',num2str(hdr.version)]);
end

% Some of the values read in the header may require corrections
% hdr.nph = max([hdr.time hdr.cphase]);
% if hdr.nph == 0				% Not defined (=0) when just 1 phase
%    hdr.nph = 1;	
% end
% if hdr.nph == 0				% Not defined (=0) when just 1 phase
%    hdr.nph = 1;	
% end
if hdr.ncoils == 0
   hdr.ncoils =1;
end
if hdr.nechoes == 0
   hdr.nechoes = 1;
end
if hdr.nslices == 0			% If not defined, should presumably be 1
   hdr.nslices = 1;	
end
if hdr.fov_ph == 0			% Not set, which means same as freq
   hdr.fov_ph = hdr.fov_fr;
else
   if hdr.fov_fr ~= hdr.fov_ph		% Asymetric FOV,
      hdr.N_ver = hdr.N_ver * ...	% N_ver needs correction
      hdr.fov_ph/hdr.fov_fr;
   end
end
hdr.ncoils = hdr.stop_rcv - hdr.start_rcv + 1;		% Number of coils in array
hdr.scale = hdr.N_hor * hdr.N_ver;	% FFT scaling factor