function [u1,u2] = toggleinput3(t,i)
        if t(i)<=50
            u1 = 0;
            u2 = 0;
        elseif 50< t(i) && t(i) <75
            u1 = 1;
            u2 = 0;
        elseif 75<=t(i) && t(i) <150
            u1 = 0;
            u2 = 0;
        elseif 150<=t(i) && t(i) <=175
            u1 = 0;
            u2 = 1;
%         elseif t(i)>=175
%             u1 = 0;
%             u2 = 0;
        elseif t(i)>175 && t(i)<=250
            u1 = 0;
            u2 = 0;
        elseif 250<t(i) && t(i)<275
            u1 = 1;
            u2 = 0;
        elseif 275<=t(i) 
%             && t(i)<350
                u1=0;
                u2=0;
%         elseif 350<=t(i) && t(i)<= 375
%                 u1=1;
%                 u2=0;
%         elseif t(i)>375
%                 u1=0;
%                 u2=0;              
        end
%   u1 = u1;
%   u2= u2;
end