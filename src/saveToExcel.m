function saveToExcel(time_tot,x_tot, y_tot, z_tot,roll_tot, pitch_tot, yaw_tot)
%SAVETOEXCEL Saves data to Excel format to generate a video of the drone

T = table(time_tot,x_tot, y_tot, z_tot,roll_tot, pitch_tot, yaw_tot);
filename = 'droneSolution.xlsx';
writetable(T,filename,'Sheet',1);
