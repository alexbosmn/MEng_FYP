function [u1,u2] = toggleinput(t,i)
        if t(i)<=50
            u1 = 0;
            u2 = 0;
        elseif 50< t(i) && t(i) <75
            u1 = 1;
            u2 = 0;
        elseif 75<=t(i) && t(i) <150
            u1 = 0;
            u2 = 0;
        elseif 150<=t(i) && t(i) <175
            u1 = 0;
            u2 = 1;
        elseif t(i)>=175
            u1 = 0;
            u2 = 0;
        end
  u1 = u1;
  u2= u2;
end