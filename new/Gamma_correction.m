function out_Img=Gamma_correction(Img,gamma)
a=1;
[row,col]=size(Img);
Img=double(Img);
out_Img=abs((a*Img).^gamma);
maxm=max(out_Img(:));
minm=min(out_Img(:));
for j=1:row
	for k = 1:col
        out_Img(j,k)=(255*out_Img(j,k))/(maxm-minm);
	end
end
out_Img=uint8(out_Img);
end