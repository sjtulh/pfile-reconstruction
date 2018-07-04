% Read the header of a P file.
%
% [hdr] = read_hdr_14(Pfile)
% Pfile		Name of the Pfile to read
% hdr		Structure containing header information.
% Copyrights Bruno Madore, Harvard Medical School
% Written in Fall 2000. 
% Summer 2006:	Update to version 12.0 by Bruno Madore
% 08/02/2006:   Update to version 14.3 by Renxin Chu 

%meic function [hdr] = read_hdr_14(Pfile)
function [hdr] = read_hdr_14(fid)

% Figure out the version number
%meic -->
%endian = 'l';	% Starting with Excite 2 (11.0), the host is a PC
%fid = fopen(Pfile, 'r', endian);
%<-- meic
fseek(fid, 0, 'bof');
hdr.version = fread(fid, 1, 'float'); % version of epic software;
if floor(hdr.version) == 14 | floor(hdr.version) == 15 | floor(hdr.version) == 24
    % for ver24, only size, N_hor and N_ver are corrected by chens
  % Excite 14 (modification 3?)
else
  error(['Error: wrong version number ' num2str(hdr.version) ...
  ', in read_hdr_*.m']);
end

% From rdbm.h, first get the offsets to the various header sections.
fseek(fid, 1468, 'bof');
hdr.size = fread(fid, 1, 'integer*4');		% rdb_hdr_off_data
fseek(fid, 1496, 'bof');
hdr.exam_off = fread(fid, 1, 'integer*4');	% rdb_hdr_off_exam
fseek(fid, 1500, 'bof');
hdr.series_off = fread(fid, 1, 'integer*4');	% rdb_hdr_off_series
fseek(fid, 1504, 'bof');
hdr.mrdata_off = fread(fid, 1, 'integer*4');	% rdb_hdr_off_image
fseek(fid, 200, 'bof');
hdr.start_rcv = fread(fid, 1, 'integer*2');	% Number for first coil of the array
fseek(fid, 202, 'bof');
hdr.stop_rcv = fread(fid, 1, 'integer*2');	% Number for last coil of the array

% From imagedb.h, exam section
fseek(fid, hdr.exam_off+208, 'bof');
hdr.B0 = fread(fid, 1, 'integer*4')/1e4;	% Field strength (T)
fseek(fid, hdr.exam_off+272, 'bof');
hdr.ex_no = fread(fid, 1, 'integer*2');		% ex_no, exam number

% From imagedb.h, series section
fseek(fid, hdr.series_off+382, 'bof');
hdr.se_no = fread(fid, 1, 'integer*2');		% se_no, series number
fseek(fid, hdr.series_off+72, 'bof');
hdr.loc0 = fread(fid, 1, 'float');		% start_loc
fseek(fid, hdr.series_off+617, 'bof');
hdr.ras0 = fread(fid, 1, 'char');		% start_ras
fseek(fid, hdr.series_off+248, 'bof');
hdr.p_pos = fread(fid, 1, 'integer*4');		% Patient position
fseek(fid, hdr.series_off+252, 'bof');
hdr.p_entry = fread(fid, 1, 'integer*4');	% Patient entry

% From imagedb.h, image section
fseek(fid, hdr.mrdata_off+64, 'bof');
hdr.fov_fr = fread(fid, 1, 'float')/10;	% FOV in freq.-enc. dir. in cm
fseek(fid, hdr.mrdata_off+68, 'bof');
hdr.fov_ph = fread(fid, 1, 'float')/10; % FOV in ph.-enc. dir. in cm
hdr.sctime = fread(fid, 1, 'float');
%fseek(fid, hdr.mrdata_off+76, 'bof');
hdr.slthick = fread(fid, 1, 'float')/10; % slthick
fseek(fid, hdr.mrdata_off+80, 'bof');
hdr.scanspacing = fread(fid, 1, 'float')/10; % scanspacing
fseek(fid, hdr.mrdata_off+116, 'bof');
hdr.user0 = fread(fid, 1, 'float');	% opuser0 variable
fseek(fid, hdr.mrdata_off+172, 'bof');
hdr.user14 = fread(fid, 1, 'float');	% opuser14 variable
fseek(fid, hdr.mrdata_off+340, 'bof');
hdr.user39 = fread(fid, 1, 'float');	% user39
fseek(fid, hdr.mrdata_off+440, 'bof');
hdr.N_hor = fread(fid, 1, 'float');	% Number of pixels horizontally, dim_X(freq)
hdr.N_ver = fread(fid, 1, 'float');	% Number of pixels vertically, dim_Y(phase)
fseek(fid, hdr.mrdata_off+480, 'bof');
hdr.x_tl = fread(fid, 1, 'float')/10;	% x coord. of top left corner (cm, tlhc_R)
fseek(fid, hdr.mrdata_off+484, 'bof');
hdr.y_tl = fread(fid, 1, 'float')/10;	% y coord. (cm, tlhc_A)
fseek(fid, hdr.mrdata_off+488, 'bof');
hdr.z_tl = fread(fid, 1, 'float')/10;	% z coord. (cm, tlhc_S)
fseek(fid, hdr.mrdata_off+492, 'bof');
hdr.x_tr = fread(fid, 1, 'float')/10;	% Coord. for top right corner (cm, trhc_R)
fseek(fid, hdr.mrdata_off+496, 'bof');
hdr.y_tr = fread(fid, 1, 'float')/10;	% y coord. (cm, trhc_A)
fseek(fid, hdr.mrdata_off+500, 'bof');
hdr.z_tr = fread(fid, 1, 'float')/10;	% z coord. (cm, trhc_S)
fseek(fid, hdr.mrdata_off+504, 'bof');
hdr.x_br = fread(fid, 1, 'float')/10;	% Bottom right corner (cm, brhc_R)
fseek(fid, hdr.mrdata_off+508, 'bof');
hdr.y_br = fread(fid, 1, 'float')/10;	% y coord. (cm, brhc_A)
fseek(fid, hdr.mrdata_off+512, 'bof');
hdr.z_br = fread(fid, 1, 'float')/10;	% z coord. (cm, brhc_S)
fseek(fid, hdr.mrdata_off+704, 'bof');
%format long hdr.stamp
%hdr.stamp = fread(fid, 1, 'integer*4');	% Time stamp
fseek(fid, hdr.mrdata_off+712, 'bof');
hdr.TR = fread(fid, 1, 'integer*4');	% Repetition time (us, tr)
fseek(fid, hdr.mrdata_off+720, 'bof');
hdr.TE = fread(fid, 1, 'integer*4');	% Echo time (us, te)
fseek(fid, hdr.mrdata_off+824, 'bof');
hdr.time = fread(fid, 1, 'integer*4');	% Number of phases (i.e. time frames, fphase)
fseek(fid, hdr.mrdata_off+1020, 'bof');
hdr.matx = fread(fid, 1, 'integer*2');	% Image matrix size - X, imatrix_X
fseek(fid, hdr.mrdata_off+1022, 'bof');
hdr.maty = fread(fid, 1, 'integer*2');	% Image matrix size - Y, imatrix_Y
fseek(fid, hdr.mrdata_off+1070, 'bof');
%% Riad found 720 for cphase
hdr.cphase = fread(fid, 1, 'integer*2');% Number of cardiac phases
fseek(fid, hdr.mrdata_off+1100, 'bof');
hdr.nslices = fread(fid, 1, 'integer*2');	% Number of slices (slquant)
hdr.nechoes = fread(fid, 1, 'int16');
fseek(fid, hdr.mrdata_off+1114, 'bof');
hdr.point_size = fread(fid, 1, 'int16');  % rhptsize 2 - 4 
fseek(fid, hdr.mrdata_off+1178, 'bof');
hdr.vps = fread(fid, 1, 'integer*2');	% Number of views per segment (viewsperseg)
fseek(fid, hdr.mrdata_off+1272, 'bof');
hdr.psdname = fread(fid, 33, 'char');	% Pulse sequence name (psdname)
fseek(fid, hdr.mrdata_off+1384, 'bof');
hdr.loc_ras = fread(fid, 1, 'char');	% RAS letter of image location
fseek(fid, hdr.mrdata_off+1389, 'bof');
hdr.coil_name = fread(fid, 17, 'char');	% Coil name

% Find strings from corresponding number arrays
%hdr.psdname = char(hdr.psdname)';
hdr.loc_ras = char(hdr.loc_ras)';
hdr.coil_name = char(hdr.coil_name)';
hdr.ras0 = char(hdr.ras0)';