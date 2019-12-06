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

f = figure();
hold on
plot(t, x, 'LineWidth', 1.5)
plot(t, y, 'LineWidth', 1.5)
plot(t, z, 'LineWidth', 1.5)
xline(t_failure, '--')
xlabel('Time (s)')
ylabel('Position (m)')
legend('x', 'y', 'z')
xlim([0, t(end)])
ylim([-5, 10])
