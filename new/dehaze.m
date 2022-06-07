%% 鲁棒性测试——实时去雾算法
function out_img=dehaze(Img)
    % 归一化到[0,1]
    Img = double(Img)/255.0;  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    % 第二步: 求取I的三个通道的最小值矩阵M
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M = min(Img,[],3);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 第三步: 对M进行均值滤波，得到Mave(x)  
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
    % 第四步: 求取M(x)中所有元素的均值Mav 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    [height, width] = size(M_average);  
    M_average_value = sum(sum(M_average)) / (height * width);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 第五步: 利用M_average求出环境光度 L 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % delta值越大，去雾后的图像越暗，去雾效果越好
    % delta值越小，去雾后的图像越白，去雾效果越差  
    delta = 2.0;    
    L = min ( min( delta*M_average_value,0.9)*M_average, M);  

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 第六步: 利用M_average和I，求出全局大气光 A
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    Matrix = [1;...
              1;...
              1];
    A = 0.5 * ( max( max( max(Img, [], 3) ) ) + max( max(M_average) ) )*Matrix;  


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 第七步: 利用A、L和I求出去雾图
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [height, width, dimention] = size(Img);  
    I_defog = zeros(height,width,dimention);  
    for i = 1:dimention  
        I_defog(:,:,i) = (Img(:,:,i) - L) ./ (1 - L./A(i));  
    end  
    
   out_img=uint8(I_defog*255.0);
     
end
    

