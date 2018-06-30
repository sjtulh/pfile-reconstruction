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