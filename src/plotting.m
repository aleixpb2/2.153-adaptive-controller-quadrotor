% Data handling
close all;

n_data = size(out.X.signals.values,3);
t     = out.X.time;
x     = out.X.signals.values(1,1,:); x = reshape(x,n_data,1);
y     = out.X.signals.values(2,1,:); y = reshape(y,n_data,1);
z     = out.X.signals.values(3,1,:); z = reshape(z,n_data,1);
roll  = out.X.signals.values(4,1,:); roll = reshape(roll,n_data,1);
pitch = out.X.signals.values(5,1,:); pitch = reshape(pitch,n_data,1);
yaw   = out.X.signals.values(6,1,:); yaw = reshape(yaw,n_data,1);
roll  = rad2deg(roll);
pitch  = rad2deg(pitch);
yaw  = rad2deg(yaw);

r_x   = out.r.signals.values(:,1);
r_y   = out.r.signals.values(:,2);
r_z   = out.r.signals.values(:,3);
r_psi = out.r.signals.values(:,4);

%% Position
f = figure();
hold on
plot(t, x, 'LineWidth', 1.5)
plot(t, y, 'LineWidth', 1.5)
plot(t, z, 'LineWidth', 1.5)
plot(t, r_x ,'-.', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1)
plot(t, r_y ,'-.', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1)
plot(t, r_z ,'-.', 'Color', [0.9290, 0.6940, 0.125], 'LineWidth', 1)
xline(t_failure, '--')
xlabel('Time (s)')
ylabel('Position (m)')
legend('x', 'y', 'z', 'Location', 'northwest')
xlim([0, t(end)])
ylim([-1, 7])

%% Orientation
f = figure();
hold on
plot(t, roll, 'LineWidth', 1.5)
plot(t, pitch, 'LineWidth', 1.5)
plot(t, yaw, 'LineWidth', 1.5)
plot(t, r_psi ,'-.', 'Color', [0.9290, 0.6940, 0.125], 'LineWidth', 1)
xline(t_failure, '--')
xlabel('Time (s)')
ylabel('Orientation (deg)')
legend('\phi (roll)', '\theta (pitch)', '\psi (yaw)', 'Location', 'north')
xlim([0, t(end)])
ylim([-7, 7])

%% Save to Excel
saveToExcel(t,x, y, z, roll, pitch, yaw)
