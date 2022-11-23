
%Obtención de puntos  x (Latitiud), y (Longitud)
x = puntos.Latitud;
y = puntos.Longitud;

longitud = size(x); % Tamaño de matriz

% plot(x, y); % Figrua pista

% Matriz de puntos x, y adelantados  +1
xMas = puntos.Latitud(2:longitud);
yMas = puntos.Longitud(2:longitud);

% Creación de matriz para guardar diferencia entre xMas - x, yMas - y
diffx = zeros(228, 1);
diffy = zeros(228, 1);

for i =1:1:longitud-1
    diffx(i) = xMas(i) - x(i); % Resta valor x+1 - x
    diffy(i) = yMas(i) - y(i); % Resta valor y+1 - y
end

% Correción valores para adecuar distancia 
diffxReal = diffx / 5713.20109420925 * 4318;   
diffyReal = diffy / 5713.20109420925 * 4318;    

% Vectores distancia
vecx = diffxReal * 111000;
vecy = diffyReal * 111000;

magnitudVec = (vecx.^2 + vecy.^2).^(1/2);

% Vectores unitarios

vecxUni = vecx ./ magnitudVec;
vecyUni = vecy ./ magnitudVec;

% Curvatura (K)

vecxUniMas = vecxUni(2:longitud-1);
vecyUniMas = vecyUni(2:longitud-1);

% Creación de matriz para guardar diferencia entre vecxUniMas - vecxUni, vecyUniMas - vecyUni
diffVecx = zeros(227, 1);
diffVecy = zeros(227, 1);

for i =1:1:longitud-2
    diffVecx(i) = vecxUniMas(i) - vecxUni(i); % Resta valor x+1 - x
    diffVecy(i) = vecyUniMas(i) - vecyUni(i); % Resta valor y+1 - y
end

% Curvatura (K) en x,y

curvaturaX = diffVecx ./ magnitudVec(1:longitud-2);
curvaturaY = diffVecy ./ magnitudVec(1:longitud-2);

magnitudCurvatura = (curvaturaX.^2 + curvaturaY.^2).^(1/2);

% Radio de curvatura

radioCurvatura = 1 ./ magnitudCurvatura;




