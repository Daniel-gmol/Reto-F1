%% Obtener puntos

% Importación datos ( puntos  x (Latitiud), y (Longitud))
load('puntos.mat');


%Obtención de puntos  x (Latitiud), y (Longitud)
x = puntos.Latitud;
y = puntos.Longitud;

longitud = size(x); % Tamaño de matriz de LATITUD Y LONGITUD ans = 229

% Figrua pista
% plot(x, y); 

%% Vectores distancia

% Matriz puntos x, y. Adelantados una +1 posicón desde (2:longitud - 2:229)
xLatitudAdelantado = puntos.Latitud(2:longitud);
yLongitudAdelantado = puntos.Longitud(2:longitud);


% Creación de matriz para guardar diferencia entre xMas - x, yMas - y
matrizDiferenciasX = zeros(228, 1);
matriDiferenciasY = zeros(228, 1);


% Cálculo de diferencia entre puntos x, y
for i =1:1:longitud-1
    matrizDiferenciasX(i) = xLatitudAdelantado(i) - x(i); % Resta valor x+1 - x
    matriDiferenciasY(i) = yLongitudAdelantado(i) - y(i); % Resta valor y+1 - y
end


% Correción (x / 5713.2019420925 * 4318) valores para adecuar distancia 
% a Red Bull Ring 4.318 km 
diferenciaRealX = matrizDiferenciasX / 5713.20109420925 * 4318;   
diferenciaRealY = matriDiferenciasY / 5713.20109420925 * 4318;    


% Vectores distancia, (Cambio de longitud y latitud a METROS)
vectorDistanciaX = diferenciaRealX * 111000;
vectorDistanciaY = diferenciaRealY * 111000;

magnitudVectores = (vectorDistanciaX.^2 + vectorDistanciaY.^2).^(1/2); % Magnitud vector (Pitágoras)


%% Vectores Unitarios y Curvatura

% Vectores distancia unitarios (Dividir vectores / suMagnitud)
vectoresUnitariosX = vectorDistanciaX ./ magnitudVectores;
vectoresUnitariosY = vectorDistanciaY ./ magnitudVectores;


% Curvatura (K)

% Matriz vectores unitarios x, y. Y magnitud Vector REALES
% Adelantados una +1 posicón desde (2:longitud-1 - 2:228)
vectoresUnitarioAdelantadoX = vectoresUnitariosX(2:longitud-1);
vectoresUnitarioAdelantadoY = vectoresUnitariosY(2:longitud-1);
magnitudVectooresAdelantados = magnitudVectores(2:longitud-1);

% Creación de matriz para guardar diferencia entre vectores x,y Unitarios
% Y Magnitud del vectores reales
matrizDiferenciaVectoresX = zeros(227, 1);
matrizDiferenciaVectoresY = zeros(227, 1);
matrizDiferenciaMagnitudVectores = zeros(227, 1);


% Cálculo de diferencia y guardado en matriz
for i =1:1:longitud-2
    matrizDiferenciaVectoresX(i) = vectoresUnitarioAdelantadoX(i) - vectoresUnitariosX(i); 
    matrizDiferenciaVectoresY(i) = vectoresUnitarioAdelantadoY(i) - vectoresUnitariosY(i); 
    matrizDiferenciaMagnitudVectores(i) = magnitudVectooresAdelantados(i) - magnitudVectores(i); 
end


% Curvatura (K) en x,y
curvaturaX = matrizDiferenciaVectoresX ./ matrizDiferenciaMagnitudVectores;
curvaturaY = matrizDiferenciaVectoresY ./ matrizDiferenciaMagnitudVectores;

magnitudCurvatura = (curvaturaX.^2 + curvaturaY.^2).^(1/2); % Magnitud curvatura (Pitágoras)

radioCurvatura = 1 ./ magnitudCurvatura; % Radio de curvatura

%% Velocidades y distancias

% Velocidad promedio deun carro 182 km/h
% Conversión
velocidadPromedio = 350.2 / 3600 * 1000;  % m/s

% Tiempo
tiempo = magnitudVectores ./ velocidadPromedio;

% Componentes Velocidad instantane
velocidadInstantaneaX = vectoresUnitariosX .* velocidadPromedio; 
velocidadInstantaneaY = vectoresUnitariosY .* velocidadPromedio;

% Aceleración Instantanea
% Diferencia de velcoidades instantanes sobre el tiempo final

% Velocidades y Tiempo adelantados
tiempoAdelantado = tiempo(2:longitud-1);
velocidadInstantaneaAdelantadaX = velocidadInstantaneaX(2:longitud-1);
velocidadInstantaneaAdelantadaY = velocidadInstantaneaY(2:longitud-1);

% Creación de matriz para aceleraciones
aceleracionX = zeros(227, 1);
aceleracionY = zeros(227, 1);


% Cálculo de aceleraciones en X y en Y
for i = 1:longitud-2
    aceleracionX(i) = (velocidadInstantaneaAdelantadaX(i) - velocidadInstantaneaX(i)) ./ tiempoAdelantado(i);
    aceleracionY(i) = (velocidadInstantaneaAdelantadaY(i) - velocidadInstantaneaY(i)) ./ tiempoAdelantado(i);
end


% Magnitud aceleración
magnitudAceleracion = sqrt(aceleracionX.^2 + aceleracionY.^2);

%% Cálculo de fuerzas en X y en Y

% Fuerza en X y Fuerza en Y
masa = 798; % kg
fuerzaX = masa.*(aceleracionX);
fuerzaY = masa.*(aceleracionY);

% Fuerza de fricción máxima para que se mantenga en control el vehículo
fuerzaFriccionMaxima = 0.7 * 9.81 * masa;

fuerzaMagnitud=sqrt(fuerzaX.^2+fuerzaY.^2);
% Puntos en donde se puede superar la friccón
indices = find(fuerzaMagnitud >= fuerzaFriccionMaxima);

fuerzasSuperadas = fuerzaMagnitud(indices);

%% Gráfica de pista con distancias en METROS

%   Valor de inicio de (x, y) para la gráfica
valorInicialX = vectorDistanciaX(1) + vectorDistanciaX(2);
valorinicialY = vectorDistanciaY(1) + vectorDistanciaY(2);

% Creación de matrices para guardar suma de vectores en X y en Y
sumaVectorialX = zeros(229, 1);
sumaVectorialY = zeros(229, 1);

% Iniciacion de valores sumaVectorialX = [0, valorInicialX, ...] 
%                       sumaVectorialY = [0, valorInicialY, ...] 
sumaVectorialX(2,1) = valorInicialX;
sumaVectorialY(2,1) = valorinicialY;


for i = 3:longitud-1 % de 3 hasta 226
    sumaVectorialX(i) = valorInicialX + vectorDistanciaX(i);
    sumaVectorialY(i) = valorinicialY + vectorDistanciaY(i); 
    
    % Hacer valor inical de suma el valor actual
    valorInicialX = sumaVectorialX(i);
    valorinicialY = sumaVectorialY(i);
end

% Finalizar los valores en 0 apra regresar a inicio 
% sumaVectorialX = [..., 0] 
% sumaVectorialY = [..., 0] 
sumaVectorialX(229, 1) = 0;
umaVectorialY(229, 1) = 0;

plot(sumaVectorialX, sumaVectorialY);
hold on;


%% Distancias donde se sal

% ΔE = W
% ΔE = -Fd
% Ef - Ei = -Fd
% Ef su velocidad final será 0, entonces se elimina
% - Ei = - Fd
% Ei = Fd
% 1/2 * m * v^2 == Fd
% d =  (m * v^2)/ 2F

% Indices donde se sale de la pista
% indices = find(sqrt(fuerzaX.^2+fuerzaY.^2) >= fuerzaFriccionMaxima);

% velocidaddes donde se sale
velocidadesDondeSale = velocidadInstantaneaX(indices);

% Puntos donde se sale
puntoXDondeSale = sumaVectorialX(indices);
puntoYDondeSale = sumaVectorialY(indices);

%Calcular la distancia
distancia = (masa .* velocidadesDondeSale.^2) ./ (2 .* fuerzasSuperadas);


%% Animacion de trayectoria
% Animación trayectoria en pista

contador = 0;
for i=1:longitud-1
    plot(sumaVectorialX(i), sumaVectorialY(i), '.r');
    xlim([-1000 1000]);
    ylim([0 700]);
    hold on
    pause(0.1);
   
    
    if ismember(i, indices) == 1
        
        contador = contador + 1;
        
        xInicial = puntoXDondeSale(contador);
        yInicial = puntoYDondeSale(contador);
        
        xFinal = vectoresUnitariosX(i) * distancia(contador) + xInicial;
        yFinal = vectoresUnitariosY(i) * distancia(contador) + yInicial;
        
        
        pendiente = (yFinal - yInicial) / (xFinal - xInicial); % y = mx + b
        b = yInicial - pendiente * xInicial; 
        
        for z=xInicial:2:xFinal
            y = pendiente * z + b;
            plot(z, y, '.g');
            %pause(0.001);
        end
    end
    
end

%% 
figure(2)
plot(cumsum(magnitudVectores(1:end-1)), fuerzaMagnitud)
yline(fuerzaFriccionMaxima)
ylim([0,fuerzaFriccionMaxima*10])

%%
figure(3)
quiver(sumaVectorialX(2:end-1), sumaVectorialY(2:end-1), aceleracionX, aceleracionY)
hold on
plot(sumaVectorialX, sumaVectorialY, ".")
hold off
% Animación trayectoria fuera de la pista 
