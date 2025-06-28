clearvars

% time
T=2500; % timesteps
dt=0.01; % s

% spiral pitch/width? adjust so that the distance between successive
% arms of the spiral are 2*r_fov apart
v=47;
% angular rate
% adjust to make sure that it ends outside the last POA
omega=1.5;

% timesteps
t=0:dt:dt*T;

% make the spiral
x=v*t.*cos(omega*t);
y=v*t.*sin(omega*t);

figure(2); gcf; clf;
subplot(121);
plot(x,y);
hold on
viscircles([0,0],1080,'Color','yellow');
grid on
axis square

% axis([-10 10 -10 10])


% check the spiral
% pick waypoints approximately same distance from each other
xw=x(1:10:end);
yw=y(1:10:end);


subplot(122);
plot(x,y);
hold on;
plot(xw,yw, 'ko');
viscircles([0,0],1080,'Color','yellow');
axis square
grid on
% these points are arranged in order so track them in order
% move a fully actuated robot with through these waypoints at constant speed

xr=x(1);
yr=y(1);

wp=2; % first waypoint
k=1; % timestep initialize
sp=26; % speed -- this should be constant
dt=0.1; % timestep length, can be different from how the spiral was created
dist_t=3; % threshold distance at which waypoint is switched, keep it above sp*dt otherwise overshoot
while wp < numel(xw)
    
    % distance 
    de=sqrt((xw(wp)-xr(k))^2+(yw(wp)-yr(k))^2);
    if de < dist_t, wp=wp+1; end
    
    % velocity with constant speed
    v=[xw(wp)-xr(k); yw(wp)-yr(k)];
    v=v/norm(v)*sp; 

    % euler integration
    xr(k+1)=xr(k)+v(1)*dt;
    yr(k+1)=yr(k)+v(2)*dt;

    k=k+1;
    
    % check
    % figure(2); gcf;
    % subplot(122);
    % fh=plot(xr(k), yr(k), 'rd');
end

% %check
subplot(133);
sp=sqrt((diff(xr,1,2)/dt).^2+(diff(yr,1,2)/dt).^2);
plot((1:numel(xr)-1)*dt, sp);
ylabel('speed (m/s)');
xlabel('time(s)');
