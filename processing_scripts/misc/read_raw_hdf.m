   % load recording
Opal = getHDFdata('20210831-135504_Walk.h5'); % change path and file name
%  
% % read labels
OpalsL={Opal.Devices(1).label; Opal.Devices(2).label; Opal.Devices(3).label; Opal.Devices(4).label; Opal.Devices(5).label};
%  
% % find sensor ID
Lumbar=strmatch(['Lumbar'],OpalsL);
% Sternum=strmatch(['Sternum'],OpalsL);
% RFoot=strmatch(['Right Foot'],OpalsL);
% LFoot=strmatch(['Left Foot'],OpalsL);
% RArm=strmatch(['Right Wrist'],OpalsL);
% LArm=strmatch(['Left Wrist'],OpalsL);
%  
%  
raw.Lumbar=[Opal.Devices(Lumbar).x(:,1:3)/9.81 Opal.Devices(Lumbar).x(:,4:6)*180/pi];
% raw.Sternum=[Opal.Devices(Sternum).x(:,1:3)/9.81 Opal.Devices(Sternum).x(:,4:6)*180/pi];
% raw.RFoot=[Opal.Devices(RFoot).x(:,1:3)/9.81 Opal.Devices(RFoot).x(:,4:6)*180/pi];
% raw.LFoot=[Opal.Devices(LFoot).x(:,1:3)/9.81 Opal.Devices(LFoot).x(:,4:6)*180/pi];
% raw.RArm=[Opal.Devices(RArm).x(:,1:3)/9.81 Opal.Devices(RArm).x(:,4:6)*180/pi];
% raw.LArm=[Opal.Devices(LArm).x(:,1:3)/9.81 Opal.Devices(LArm).x(:,4:6)*180/pi];

estimated_time = 0:1/128:length(raw.Lumbar/128);

figure; hold on;
plot(estimated_time, raw.Lumbar(:,1));
plot(estimated_time, raw.Lumbar(:,2));
plot(estimated_time, raw.Lumbar(:,3));
plot(estimated_time, raw.Lumbar(:,4));
plot(estimated_time, raw.Lumbar(:,5));
plot(estimated_time, raw.Lumbar(:,6));

