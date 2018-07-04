% RMSRECON  
% usage:    [result hdr raw_data] = rmsrecon(vers, chp, Pfile, N_sl, nph, necho, rms);
%                                                    rms=1: rms of coils

function [result,hdr,raw_data] = rmsrecon(Pfile, chp, rms)
%Pfile = ['/disk/meic/pfiles/011908/P04096.7'];
%[hdr, raw_data] = read_Pfile(Pfile); 
%addpath D:\Research\mei' matlab code'\
[hdr, raw_data] = read_mPfile(Pfile, chp);
result_temp = ifftshift(fft2(fftshift(raw_data, 2)), 2);
result = flipud(rot90(result_temp));   %调整方向

if rms == 1;
   result = squeeze(sqrt(sum(abs(result).^2,4))); 
   %im(result,111);colormap(gray);
end

% for isl=1:N_sl
%     im(squeeze(result(:,:,isl,:,:)), isl+100);colormap(gray);
% end
% 
%im = ifftshift(ifft(ifft(kspace,[],1),[],2),2);
% result_rms = squeeze(sqrt(sum(abs(result).^2,4)));
% figure;imagesc(result_rms(:,:,1));colormap(gray);
% title 'rms of all coils'
% ncoils = size(result,4);
% i =1;
% for icoil=1:1
%     for iph=1:1
%         for isl =1:1
%             %         hdl=cat(2,'h', num2str(i));
%             %figure;hdl=imagesc(abs(result(:,:,isl,icoil,iph))*2e1);colormap(gray);
%             %figure;hdl=imagesc(abs(raw_data(:,:,isl,iph)));colormap(gray);
%             %  ylim([80 110])
%             %         dt=datestr(now, 'mmddyy.HH:MM');
%             %         filename = cat(2,'~/im/053009/',dt,'-',num2str(i),'.jpg');
%             %         saveas(hdl, filename);
%             %         i = i + 1;
%         end
%     end
% end
%grid minor;
%title('Acquired Data (rms) of phase#1');

% figure;hdl=image(squeeze(result(:,:,8))*1e1);colormap(gray);
% 
% figure;hdl=image(squeeze(result(100,:,:))*1e1);colormap(gray);