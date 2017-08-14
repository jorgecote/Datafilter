%*************************************************************************%
%                       OUTLIERS DETECTION (univariate)                   %
%          Outliers Detection through 3-sigma rule, hampel identifier     %
%                       y hampel filter                                   %
%       hwin y t are parameters for hample filter only                    %
%*************************************************************************%
function [outliers medwind]=outlier_detection(dataset, method,hwin,t)

j=0;
L=0;
d1=0;
outliers=[];
switch(method)
    case 'sigmarule'
       u=mean(dataset);            %mean
       medwind=u;
       sigma=std(dataset,1);       %standard deviation
       du=dataset-u;               %point-mean distance
        for i=1:size(dataset,1)
            
            if(abs(du(i,:))>3*sigma)
                j=j+1;
                outliers(j,:)=i;
            end            
            
        end
        
    case 'MAD'
        x_=median(dataset);         %median
        medwind=x_;
        sigma_=mad(dataset,1);      %median absolut deviation
        dm=dataset-x_;              %point-median distance
        for i=1:size(dataset,1)
            if(abs(dm(i,:))>t*sigma_)
                j=j+1;
                outliers(j,:)=i;
            end    
        
        end
    case 'hampel'           %A systematic approach for soft sensor development
        medwind=0;
        if(mod(size(dataset,1),2*hwin)==0)      %    hwin
            x1=0;   x2=2*hwin;
            while(x2<=size(dataset,1))
            wind=dataset(x1+1:x2,:);
        x_=median(wind);                 %median
        sigma_=mad(wind,1);       %median absolut deviation        
        dm=wind-x_;                      %point-median distance
        
        for i=1:2*hwin
            if(abs(dm(i,:))>t*sigma_)
                j=j+1;
                outliers(j,:)=i+x1;
                medwind(j,:)=x_;
            end          
        end
        x1=x1+2*hwin;   x2=x2+2*hwin;
        
            end
        else
            error('Total de muestras debe ser divisible por tamaño de ventana');
        end

end


end