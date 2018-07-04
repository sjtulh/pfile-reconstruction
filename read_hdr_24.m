% Read the header of a P file (version 24).
% liuhang, 2018/6/30

% clear all;
% Pfile = 'F:\sd\mri\pfile reconstruction\data\version 24\dicom_data\breast_coil\P50176.7';
% fid=fopen(Pfile,'r', 'ieee-le');
% hdr = read_hdr_24(fid);

function hdr = read_hdr_24(fid)
fseek(fid, 1468, 'bof');
hdr.size = fread(fid, 1, 'int32');		% rdb_hdr_off_data

fseek(fid, 0, 'bof');
hdr.version = fread(fid, 1, 'float');
fseek(fid, 12, 'cof');
hdr.scan_date = deblank(fread(fid, [1, 10], '*char'));
DateNum= datevec(hdr.scan_date, 'mm/dd/yyyy');
DateNum(1)= DateNum(1)+ 1900;
hdr.scan_date = datestr(DateNum, 'mm/dd/yyyy');
clear DateNum;
hdr.scan_time = deblank( fread(fid, [1, 8], '*char'));
fseek(fid, 30, 'cof');
hdr.npasses = fread(fid, 1, 'int16');
fseek(fid, 2, 'cof');
hdr.nslices = fread(fid, 1, 'uint16');
hdr.nechoes = fread(fid, 1, 'int16');
fseek(fid, 2, 'cof');
hdr.nframes = fread(fid, 1, 'int16');
fseek(fid, 4, 'cof');
hdr.frame_size = fread(fid, 1, 'uint16');
hdr.point_size = fread(fid, 1, 'int16');
fseek(fid, 18, 'cof');
hdr.acq_x_res = fread(fid, 1, 'uint16');
hdr.acq_y_res = fread(fid, 1, 'int16');
hdr.recon_x_res = fread(fid, 1, 'int16');
hdr.recon_y_res = fread(fid, 1, 'int16');
hdr.im_size = fread(fid, 1, 'int16');
hdr.recon_z_res = fread(fid, 1, 'int32');
fseek(fid, 84, 'cof');
hdr.start_rcv = fread(fid, 1, 'int16');
hdr.stop_rcv = fread(fid, 1, 'int16');
fseek(fid, 1440, 'cof');
hdr.bandwidth = fread(fid, 1, 'float');
hdr.data_size = fread(fid, 1, 'uint32');
hdr.ssp_save = fread(fid, 1, 'uint32');  
hdr.uda_save = fread(fid, 1, 'uint32');
fseek(fid, 139692, 'cof');
hdr.aps_frequency = fread(fid, 1, 'uint32')/1e7;
fseek(fid, 2036, 'cof');
hdr.magnet_strength = fread(fid, 1, 'int32')/1e4;
hdr.patient_weight = fread(fid, 1, 'int32')/1e3;
fseek(fid, 116, 'cof');
hdr.exam_number = fread(fid, 1, 'uint16');
fseek(fid, 18, 'cof');
hdr.patient_age = fread(fid, 1, 'int16');
fseek(fid, 2, 'cof');
hdr.patient_sex = fread(fid, 1, 'int16');
fseek(fid, 595, 'cof');
hdr.exam_type = deblank( fread(fid, [1, 3], '*char'));
hdr.system_id = deblank( fread(fid, [1, 9], '*char'));
fseek(fid, 22, 'cof');
hdr.hospital_name = deblank( fread(fid, [1, 33], '*char'));
fseek(fid, 24, 'cof');
hdr.service_id = deblank( fread(fid, [1, 16], '*char'));
fseek(fid, 100, 'cof');
hdr.patient_name = deblank( fread(fid, [1, 65], '*char'));
hdr.patient_id = deblank( fread(fid, [1, 65], '*char'));
fseek(fid, 578, 'cof');
hdr.start_location = fread(fid, 1, 'float');
hdr.end_location = fread(fid, 1, 'float');
fseek(fid, 562, 'cof');
hdr.series_number = fread(fid, 1, 'int16');
fseek(fid, 138, 'cof');
hdr.series_description = deblank( fread(fid, [1, 65], '*char'));
fseek(fid, 21, 'cof');
hdr.protocol = deblank( fread(fid, [1, 25], '*char'));
hdr.start_ras = fread(fid, 1, 'char');
hdr.end_ras = fread(fid, 1, 'char');
fseek(fid, 1769, 'cof');
hdr.fov_fr = fread(fid, 1, 'float')/10;
hdr.fov_ph = fread(fid, 1, 'float')/10;
hdr.scan_duration = fread(fid, 1, 'float');
hdr.thickness = fread(fid, 1, 'float')/10;
% hdr.scanspacing = fread(fid, 1, 'float');
% scanspacing找不到
fseek(fid, 360, 'cof');
hdr.N_hor = fread(fid, 1, 'float');   % Number of pixels horizontally
hdr.N_ver = fread(fid, 1, 'float');   % Number of pixels vertically
hdr.x_size = fread(fid, 1, 'float');
hdr.y_size = fread(fid, 1, 'float');
hdr.r_center = fread(fid, 1, 'float');
hdr.a_center = fread(fid, 1, 'float');
hdr.s_center = fread(fid, 1, 'float');
hdr.r_norm = fread(fid, 1, 'float');
hdr.a_norm = fread(fid, 1, 'float');
hdr.s_norm = fread(fid, 1, 'float');
hdr.x_tl = fread(fid, 1, 'float');
hdr.y_tl = fread(fid, 1, 'float');
hdr.z_tl = fread(fid, 1, 'float');
hdr.x_tr = fread(fid, 1, 'float');
hdr.y_tr = fread(fid, 1, 'float');
hdr.z_tr = fread(fid, 1, 'float');
hdr.x_br = fread(fid, 1, 'float');
hdr.y_br = fread(fid, 1, 'float');
hdr.z_br = fread(fid, 1, 'float');
fseek(fid, 300, 'cof');
hdr.tr = fread(fid, 1, 'int32')/1e3;
hdr.ti = fread(fid, 1, 'int32')/1e3;
hdr.te = fread(fid, 1, 'int32')/1e3;
fseek(fid, 300, 'cof');
hdr.matx = fread(fid, 1, 'int16');
hdr.maty = fread(fid, 1, 'int16');
fseek(fid, 128, 'cof');
hdr.frequency_direction = fread(fid, 1, 'int16');
fseek(fid, 130, 'cof');
hdr.psd_name = deblank(fread(fid, [1, 33], '*char'));   %最后几个字符乱码
fseek(fid, 84, 'cof');
hdr.coil_name = deblank(fread(fid, [1, 17], '*char'));
fseek(fid, 115, 'cof');
hdr.long_coil_name = deblank(fread(fid, [1, 24], '*char'));
end