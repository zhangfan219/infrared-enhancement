%% ³���Բ��ԡ���ʵʱȥ���㷨
function out_img=dehaze(Img)
    % ��һ����[0,1]
    Img = double(Img)/255.0;  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    % �ڶ���: ��ȡI������ͨ������Сֵ����M
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M = min(Img,[],3);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������: ��M���о�ֵ�˲����õ�Mave(x)  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [height,width] = size(Img);  
    mask = ceil(max(height, width) / 50);  
    if mod(mask, 2) == 0  
        mask = mask + 1;  
    end  
    f = fspecial('average', mask);  
    M_average = imfilter(M, f, 'symmetric');     

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ���Ĳ�: ��ȡM(x)������Ԫ�صľ�ֵMav 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    [height, width] = size(M_average);  
    M_average_value = sum(sum(M_average)) / (height * width);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ���岽: ����M_average���������� L 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % deltaֵԽ��ȥ����ͼ��Խ����ȥ��Ч��Խ��
    % deltaֵԽС��ȥ����ͼ��Խ�ף�ȥ��Ч��Խ��  
    delta = 2.0;    
    L = min ( min( delta*M_average_value,0.9)*M_average, M);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������: ����M_average��I�����ȫ�ִ����� A
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    Matrix = [1;...
              1;...
              1];
    A = 0.5 * ( max( max( max(Img, [], 3) ) ) + max( max(M_average) ) )*Matrix;  


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ���߲�: ����A��L��I���ȥ��ͼ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [height, width, dimention] = size(Img);  
    I_defog = zeros(height,width,dimention);  
    for i = 1:dimention  
        I_defog(:,:,i) = (Img(:,:,i) - L) ./ (1 - L./A(i));  
    end  
    
   out_img=uint8(I_defog*255.0);
     
end
    

