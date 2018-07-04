function [hdr, raw_data] = read_sglPfile(Pfile, chp)
fid = fopen(Pfile,'r', 'ieee-le');
hdr = read_hdr(fid);

k_size = 2 * hdr.N_hor * hdr.N_ver;  % '2' for real and imaginary
                                     % # of data in unit of INT16 (INT32 if EDR on)
baseline = 2 * hdr.N_hor;            % '2' for real and imaginary
temp = zeros(2, hdr.N_hor * hdr.N_ver);
real_part = zeros(hdr.N_hor, hdr.N_ver); 
imag_part = zeros(hdr.N_hor, hdr.N_ver); 
fseek(fid, hdr.size, 'bof'); % skip header

for icoil = 1:hdr.ncoils
    for iecho = 1: hdr.nechoes
        for islice = 1:hdr.nslices
            if hdr.point_size == 4
                fseek(fid, baseline*4, 'cof'); % 4 For long integer
                [buf, count] = fread(fid, k_size, 'int32');
            else
                fseek(fid, baseline*2, 'cof'); % 2 For short integer
                [buf, count] = fread(fid, k_size, 'int16');
            end    
            if count ~= k_size
                error(['Only ' num2str(count) ' of ' num2str(k_size) ...
                    ' bytes were read for coil #' num2str(icoil) ', slice #' num2str(isl)]);
            end
            temp(:) = buf(:);
            real_part(:) = temp(1,:);
            imag_part(:) = temp(2,:);
            raw_data(:,:,islice,icoil,iecho) = (real_part' + 1i*imag_part');
        end
    end
end
raw_data = squeeze(raw_data);
fclose(fid);

if chp==1
    modulation = (-1).^(1:N_ver)';
    raw_data = raw_data .* repmat(modulation, [1 N_hor nslices ncoils nph necho]);
end

end