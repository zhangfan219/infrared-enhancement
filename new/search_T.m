function T=search_T(img)
[row,column]=size(img);
T=zeros(1,1);
T(1,1)=(max(img(:))+min(img(:)))/2;

for count=1:15
region_1=zeros(1,1);
region_2=zeros(1,1);
count_1=1;
count_2=1;
for i=1:row
    for j=1:column
        if img(i,j)<T
            region_1(1,count_1)=img(i,j);
            count_1=count_1+1;
        else 
            region_2(1,count_2)=img(i,j);
            count_2=count_2+1;
        end
    end
end
T(1,count)=(mean(region_1(:))+mean(region_2(:)))/2;
end           

end