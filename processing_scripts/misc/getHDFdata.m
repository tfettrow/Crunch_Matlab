function Data = getHDFdata (fileName)

sensors     = h5info(fileName, '/Sensors');
processed   = h5info(fileName, '/Processed');
nDevices    = length(sensors.Groups);

Devices(nDevices)   = struct('x',[],'dateNumbers',[],'label',[]);

for i = 1:nDevices
    label = h5readatt(fileName, [sensors.Groups(i).Name '/Configuration'], 'Label 0');    
    a = h5read(fileName, [sensors.Groups(i).Name '/Accelerometer'])';
    g = h5read(fileName, [sensors.Groups(i).Name '/Gyroscope'])';
    m = h5read(fileName, [sensors.Groups(i).Name '/Magnetometer'])';
    q = h5read(fileName, [processed.Groups(i).Name '/Orientation'])';
    dn = h5read(fileName, [sensors.Groups(i).Name '/Time']).';
    
    Devices(i).x            = [a g m];
    Devices(i).q            = q;
    tOffset                 = -7*60; 
    Devices(i).dateNumbers  = double(dn).'/(24*3600*1e6) + datenum(1970,1,1)+ tOffset/(24*60);
    Devices(i).label        = label;
end

Data.Devices  = Devices;