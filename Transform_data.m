%% Script para transformar datos_long.csv al formato data_all_seb.mat

clear all;

% 1. Cargar datos desde CSV
datos_long = readtable('C:\Users\yangy\Documents\MATLAB\Wepsilon\datos_long.csv');

% 2. Obtener información de la estructura de los datos
unique_subs = unique(datos_long.sub);
num_subs = length(unique_subs);
num_trials = max(datos_long.trial);

fprintf('\nNúmero de sujetos: %d\n', num_subs); % 101
fprintf('Número de trials: %d\n', num_trials); % 48


% 3. Inicializar matrices para el formato wide
% Crear matrices de trials x sujetos (igual que data_all_seb.mat)
data.chosen = zeros(num_trials, num_subs);
data.effort = zeros(num_trials, num_subs);
data.reward = zeros(num_trials, num_subs);
data.agent = zeros(num_trials, num_subs);

% 4. Llenar las matrices transformando de long a wide
for i = 1:height(datos_long)
    sub_id = datos_long.sub(i);
    trial_num = datos_long.trial(i);
    
    % Encontrar el índice del sujeto en el array de sujetos únicos
    sub_idx = find(unique_subs == sub_id);
    
    % Asignar valores a las matrices
    % Nota: decision en el CSV corresponde a chosen en el .mat
    data.chosen(trial_num, sub_idx) = datos_long.decision(i);
    data.effort(trial_num, sub_idx) = datos_long.effort(i);
    data.reward(trial_num, sub_idx) = datos_long.reward(i);
    data.agent(trial_num, sub_idx) = datos_long.agent(i);
end

% Mostrar estadísticas básicas
fprintf('Proporción de trabajar: %.2f%%\n', sum(data.chosen(:)==1)/numel(data.chosen)*100);

% 6. Guardar el archivo .mat en el mismo formato que data_all_seb.mat
save(datos_long_transformed.mat, 'data');


fprintf('  load datos_long_transformed.mat;\n');



%% 7. Guardar también información adicional (opcional)
% Si quieres mantener información extra del CSV original
data_extra.subject_ids = unique_subs;  % IDs originales de los sujetos
data_extra.num_subjects = num_subs;
data_extra.num_trials = num_trials;

% Si hay columnas adicionales que quieras guardar (success, grupo)
if ismember('success', datos_long.Properties.VariableNames)
    data_extra.success = zeros(num_trials, num_subs);
    for i = 1:height(datos_long)
        sub_idx = find(unique_subs == datos_long.sub(i));
        trial_num = datos_long.trial(i);
        data_extra.success(trial_num, sub_idx) = datos_long.success(i);
    end
end

if ismember('grupo', datos_long.Properties.VariableNames)
    % El grupo es constante por sujeto, guardar como vector
    data_extra.grupo = zeros(1, num_subs);
    for sub_idx = 1:num_subs
        sub_id = unique_subs(sub_idx);
        data_extra.grupo(sub_idx) = datos_long.grupo(find(datos_long.sub == sub_id, 1));
    end
end

save('datos_long_transformed_with_extras.mat', 'data', 'data_extra');
fprintf('Archivo con información extra guardado como: datos_long_transformed_with_extras.mat\n');