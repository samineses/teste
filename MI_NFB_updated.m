%comentrio de saulo teste terminal windows
function varargout = MI_NFB_updated(varargin)
%MI_NFB_UPDATED MATLAB code file for MI_NFB_updated.fig
%      MI_NFB_UPDATED, by itself, creates a new MI_NFB_UPDATED or raises the existing
%      singleton*.
%
%      H = MI_NFB_UPDATED returns the handle to a new MI_NFB_UPDATED or the handle to
%      the existing singleton*.
%
%      MI_NFB_UPDATED('Property','Value',...) creates a new MI_NFB_UPDATED using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MI_NFB_updated_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MI_NFB_UPDATED('CALLBACK') and MI_NFB_UPDATED('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MI_NFB_UPDATED.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MI_NFB_updated

% Last Modified by GUIDE v2.5 18-Jul-2025 15:55:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MI_NFB_updated_OpeningFcn, ...
                   'gui_OutputFcn',  @MI_NFB_updated_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before MI_NFB_updated is made visible.
function MI_NFB_updated_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for MI_NFB_updated
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = MI_NFB_updated_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function subjectName_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function birthdate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function lateralidade_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function IntensidadeEletro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntensidadeEletro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Este trecho define o fundo branco padrão para caixas de texto no Windows
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function subjectName_Callback(hObject, eventdata, handles)
% Executado quando o usuário altera o campo de nome
% Por ora não faz nada, mas pode ser usado para validação futura
end

function birthdate_Callback(hObject, eventdata, handles)
% Executado quando o usuário altera o campo de data de nascimento
end

function lateralidade_Callback(hObject, eventdata, handles)
% Executado quando o usuário altera o campo de lateralidade
end



function nextButton_Callback(hObject, ~, handles)
    guard_callback(hObject, @() medir_impedancias_protegido(handles));
end


% --- Executes on button press in visualizarButton.
function visualizarButton_Callback(hObject, eventdata, handles)
% hObject    handle to visualizarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
        % Inicializa interface com o dispositivo
        gds_interface = inicializa_interface_gtec();

        % Inicia visualização em tempo real (bloqueia até o usuário fechar)
        inicia_visualizacao_sinais(gds_interface);

    catch ME
        errordlg(['❌ Erro ao visualizar sinais: ' ME.message], 'Erro');
    end
end


function StartRS_Callback(hObject, ~, handles)
    subject      = get(handles.subjectName, 'String');
    birthdate    = get(handles.birthdate, 'String');
    lateralidade = get(handles.lateralidade, 'String');

    % protege contra duplo clique e roda a aquisição
    guard_callback(hObject, @() inicia_resting_state(subject, birthdate, lateralidade), ...
        struct('busyText','Gravando RS… (cliques ignorados)'));
end


function StartHandsMI_Callback(hObject, ~, handles)
    subject      = get(handles.subjectName, 'String');
    birthdate    = get(handles.birthdate,   'String');
    lateralidade = get(handles.lateralidade,'String');

    guard_callback(hObject, @() inicia_MI_hands(subject, birthdate, lateralidade), ...
        struct('busyText','Executando MI Hands… (cliques ignorados)'));
end


function StartFootMI_Callback(hObject, ~, handles)
    subject      = get(handles.subjectName, 'String');
    birthdate    = get(handles.birthdate,   'String');
    lateralidade = get(handles.lateralidade,'String');

    guard_callback(hObject, @() inicia_MI_feet(subject, birthdate, lateralidade), ...
        struct('busyText','Executando MI Feet… (cliques ignorados)'));
end



function IniciarEletro_Callback(hObject, ~, handles)
    % Valida o checkbox antes de proteger/rodar
    checkbox = findobj(gcf, 'Tag', 'lockedstart');
    if isempty(checkbox) || checkbox.Value ~= 1
        errordlg('⚠️ Marque a caixa "Confirmar mudança dos eletrodos" antes de iniciar a aquisição.', ...
                 'Confirmação obrigatória');
        return;
    end

    % Coleta as informações da GUI
    subject      = get(handles.subjectName, 'String');
    birthdate    = get(handles.birthdate,   'String');
    lateralidade = get(handles.lateralidade,'String');
    descricao    = get(handles.IntensidadeEletro, 'String');

    % Protege contra duplo clique e executa
    guard_callback(hObject, @() inicia_aquisicao_eletro(subject, birthdate, lateralidade, descricao), ...
        struct('busyText','Adquirindo eletro… (cliques ignorados)'));
end




% --- Executes on button press in lockedstart.
function lockedstart_Callback(hObject, eventdata, handles)
% hObject    handle to lockedstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockedstart

%comentario exemplo
end
