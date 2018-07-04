function [hdr, raw_data] = read_mPfile(pfile, chp)
% var = 'F:\sd\mri\pfile reconstruction\data\version 24\dicom_data\breast_coil\P49664.7';
% var = 'F:\sd\mri\pfile reconstruction\data\version 24\dicom_data\breast_coil\P*****.7';
chp = 0;
if isempty(strfind(pfile, '*')) == 1
    [hdr, raw_data] = read_sglPfile(pfile, chp);
else
    filelist=dir(pfile);
    whereP=strfind(pfile,'P');
    for i = 1 : length(filelist)
        ipfile = [var(1:whereP(end)-1) filelist(i).name];
        [hdr, raw_data_temp] = read_sglPfile(ipfile, chp);
        raw_data(:,:,:,:,i) = raw_data_temp(:,:,:,:);
    end
end