function videoNewBackground(stableVideoPath, maskPath, outPath, mattingPicture, params, textGUI)

warning off
        
% Read input video, create output video
InputVid = VideoReader(stableVideoPath);
InputMaskVid = VideoReader(maskPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
OutputVid = VideoWriter(outPath);
OutputVid.FrameRate = InputVid.FrameRate;
open(OutputVid);

img3 = imread(mattingPicture);
img3 = imresize(img3, [InputVid.Height InputVid.Width]);
img3 = double(img3);


countCaca = 1;



while hasFrame(InputVid)
    
    textToDisp = sprintf('Processing frame %s out of %s', num2str(countCaca), num2str(numFrames));
    set(textGUI, 'String', textToDisp);
    
    if countCaca == 57
        grgrrr=9;
    end
    
    disp(countCaca)
    countCaca = countCaca + 1;
    
    img1 = readFrame(InputVid);
    imgForTri = rgb2gray(readFrame(InputMaskVid));
    imgForTri(imgForTri>50) = 255;
    imgForTri(imgForTri<50) = 0;
    img2 = triMapImage(imgForTri);
    
    if ~isequal(imgForTri,img2)
        threshFG = 255.0*.95;
        threshBG = 255.0*.05;
        iterCount = 10;
        deltaValue = .0001;
        
        img1_r = size(img1, 1);
        img1_c = size(img1, 2);
        channel_sz = img1_r * img1_c;
        f_ind = find(img2 >= threshFG); f_ind = [f_ind; f_ind+channel_sz; f_ind+channel_sz*2];
        b_ind = find(img2 <= threshBG); b_ind = [b_ind; b_ind+channel_sz; b_ind+channel_sz*2];
        u_ind = find(img2 < threshFG & img2 > threshBG);  u_ind = [u_ind; u_ind+channel_sz; u_ind+channel_sz*2];
        fg = double(img1); fg(b_ind) = 0; fg(u_ind) = 0;
        bg = double(img1); bg(f_ind) = 0; bg(u_ind) = 0;
        un = double(img1); un(f_ind) = 0; un(b_ind) = 0;
        
        barF = [0 0 0];
        barBValue = [0 0 0];
        for i=1:3
            f = fg(:,:,i);
            b = bg(:,:,i);
            barF(i) = mean(f(find(f)));
            barBValue(i) = mean(b(find(b)));
        end
        
        temporalF(:,:,1) = fg(:,:,1) - barF(1);
        temporalF(:,:,2) = fg(:,:,2) - barF(2);
        temporalF(:,:,3) = fg(:,:,3) - barF(3);
        sumFValue = [0 0 0; 0 0 0; 0 0 0];
        count = 0;
        for c=1:size(temporalF, 2)
            for r=1:size(temporalF, 1)
                pixelFValue = temporalF(r,c, :);
                pixelFValue = reshape(pixelFValue,3,1);
                if(any(fg(r,c,:)))
                    sumFValue = sumFValue + (pixelFValue * pixelFValue');
                    count = count + 1;
                end
            end
        end
        f_co = sumFValue / count;
        
        %Cov of B
        temporalB(:,:,1) = bg(:,:,1) - barBValue(1);
        temporalB(:,:,2) = bg(:,:,2) - barBValue(2);
        temporalB(:,:,3) = bg(:,:,3) - barBValue(3);
        sumBValue = [0 0 0; 0 0 0; 0 0 0];
        count = 0;
        for c=1:size(temporalB, 2)
            for r=1:size(temporalB, 1)
                pixelBValue = temporalB(r,c, :);
                pixelBValue = reshape(pixelBValue,3,1);
                if(any(bg(r,c,:)))
                    sumBValue = sumBValue + (pixelBValue * pixelBValue');
                    count = count + 1;
                end
            end
        end
        b_co = sumBValue / count;
        
        
        alpha_un = double(img2)/255.0;
        F_un = un;
        B_un = un;
        for c=1:img1_c
            for r=1:img1_r
                if(~any(un(r,c,:)))
                    continue
                end
                
                un_c = reshape(un(r,c,:), 3,1);
                alpha = 0;
                count = 0;
                try
                    alpha = alpha + alpha_un(r-1, c);
                    count = count + 1;
                end
                try
                    alpha = alpha + alpha_un(r+1, c);
                    count = count + 1;
                end
                try
                    alpha = alpha + alpha_un(r, c-1);
                    count = count + 1;
                end
                try
                    alpha = alpha + alpha_un(r, c+1);
                    count = count + 1;
                end
                alpha = alpha / count;
                for k=1:iterCount
                    alpha_prev = alpha;
                    [F B] = FBSOLVER(f_co, b_co, barF, barBValue, un_c, alpha);
                    alpha = dot((un_c - B), (F - B)) / norm(F-B).^2;
                    if(abs(alpha -alpha_prev) <= deltaValue)
                        break;
                    end
                end
                alpha_un(r,c) = alpha;
                F_un(r,c,:) = F;
                B_un(r,c,:) = B;
            end
        end
        
        f_ind = find(img2 >= threshFG);
        b_ind = find(img2 <= threshBG);
        u_ind = find(img2 > threshBG & img2 < threshFG);
        alpha_un(b_ind) = 0; alpha_un(f_ind) = 1;

        
        %Read in image to compose
        img3 = imresize(img3, [size(img1, 1) size(img1, 2)]);
        img3 = double(img3);
        img1 = double(img1);
        
        img_final = img3;
        img_final(:,:,1) = F_un(:,:,1).*alpha_un(:,:) + img3(:,:,1).*(1 - alpha_un(:,:));
        img_final(:,:,2) = F_un(:,:,2).*alpha_un(:,:) + img3(:,:,2).*(1 - alpha_un(:,:));
        img_final(:,:,3) = F_un(:,:,3).*alpha_un(:,:) + img3(:,:,3).*(1 - alpha_un(:,:));
        
        img_final(f_ind) = img1(f_ind);
        img_final(f_ind+channel_sz) = img1(f_ind+channel_sz);
        img_final(f_ind+channel_sz*2) = img1(f_ind+channel_sz*2);
        
        writeVideo(OutputVid,uint8(img_final));
    else
        writeVideo(OutputVid,uint8(img3));
    end
    
end