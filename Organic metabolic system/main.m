clear
clc
close all;


Xs_now=95.9;
Xp_now=0.83;
Xh_now=0.003;
Xr_now=0.0001;
Xo_now=0;
Xe_now=0;
dt=0.0001; %以年为单位
t_now=0;
Start_year=0;
End_year=2020;
record_start_year=1900;
record_interval=10;
k=1;
for i=1:ceil((End_year-Start_year)/dt)
    t_now=t_now+dt;
    Xs_last=Xs_now;
    Xp_last=Xp_now;
    Xh_last=Xh_now;
    Xr_last=Xr_now;
    Xo_last=Xo_now;
    Xe_last=Xe_now;
    
    
    dXp=(Xs_last-4.03*Xp_last)*dt;
    dXh=(0.48*Xp_last-17.87*Xh_last)*dt;
    dXr=(4.85*Xh_last-4.65*Xr_last)*dt;
    dXo=(2.55*Xp_last+6.12*Xh_last+1.95*Xr_last)*dt;
    dXe=(1.1*Xp_last+6.9*Xh_last+2.7*Xr_last)*dt;
    
    Xs_now=95.9*(1+0.635*sin(2*pi*t_now));
    Xp_now=Xp_last+dXp;
    Xh_now=Xh_last+dXh;
    Xr_now=Xr_last+dXr;
    Xo_now=Xo_last+dXo;
    Xe_now=Xe_last+dXe;
    
    if mod(i,record_interval/dt)==0
        Xs(1,k)=Xs_now;
        Xp(1,k)=Xp_now;
        Xh(1,k)=Xh_now;
        Xr(1,k)=Xr_now;
        Xo(1,k)=Xo_now;
        Xe(1,k)=Xe_now;
        k=k+1;
    end
end



