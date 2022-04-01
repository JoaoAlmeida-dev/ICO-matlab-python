function[xoptimo,foptimo,dffinal,NIterMean,Lopt,LNit] = descidaMaximaWolf(seed , NPontosIniciais, nMaxIter, error, xmin,xmax,ymin,ymax, display )
    arguments
        seed  int64
        NPontosIniciais int64
        nMaxIter int64
        error double
        xmin int64
        xmax int64
        ymin int64
        ymax int64
        display logical
    end

% M�TODO DE DECIDA M�XIMA (SDM- STEEPEST DESCENT METHOD)

% ESTE m.FILE IMPLEMENTA O SDM PARA FUN��ES OBJETIVO f DEFINIDAS COMO FUNC-
% TION-HANDLE f=@(x) ATRAV�S DE UMA EXPRESS�O NAS SUAS VARI�VEIS x(i); ES-
% TAS VARI�VEIS x(i)COMPO�M A VARI�VEL x DA FUN��O f), SENDO x TRATADA A
% N�VEL DO MATLAB COMO UM VETOR COLUNA [x(1);x(2);...].

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - GERA��O PSEUDO-ALEAT�RIA DE PTOS INICIAIS x_0
% - ESCOLHA DE PASSOS lambda DE ACORDO COM AS CONDI��ES DE WOLFE;  RECORRE  
%   AO FICHEIRO "Wolfe.m" ONDE ESTAS CONDI��ES EST�O IMPLEMENTADAS SEGUNDO 
%   O ALGORITMO 2 (VER FICHEIRO SOBRE ESCOLHA DE PTOS INICIAIS E PASSOS).

% ESTE m.FILE PERMITE A EXIST�NCIA DE PAR�METROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PAR�METROS PODEM SER RELATIVOS �S CONDI��ES DE PARAGEM,
% AO N� (NPontosIniciais) DE PTOS INICIAIS x_0, ETC..

% ESTE M.file RECORRE A 3 m.FILES: 
% - "nivelGraficos.m", "graficosLineSearch.m", "mean.m" E AINDA "Wolfe.m". 

% APENAS S�O INDICADAS AS LINHAS DE C�DIGO QUE N�O FAZEM PARTE DOS FICHEI-
% ROS "descidaMaximaV1aula.m" E "descidaMaximaV3".


% O COMANDO clc PODE SER �TIL POR LIMPAR VARI�VEIS DO AMBIENTE DE TRABALHO

clc
rng(seed)

% PARTE 1: DEFINI��O DA FUN��O OBJETIVO E DO N� DE VARI�VEIS
f=@(x) 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
Nvar=2;
syms a b 'real'
if Nvar==1
        v=a;
elseif Nvar==2
    v=[a; b];
end
        
S=f(v);
dS=jacobian(S,v);
df=@(x) double(subs(dS,v,x)');

% PARTE 4: DESIGNA��O DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GR�FIC

Lista=[];    
LNit=[];       
Lopt=[];     



% PARTE 5: N� DE PTOS INICIAIS E INTERVALO PARA SELE��O DOS PTOS INICIAIS

%NPontosIniciais=3;

%a=[-4,-4]'; b=[4,4]';
a=[double(xmin), double(ymin)]'; b=[double(xmax), double(ymax)]';


% PARTE 6: IMPLEMENTA��O DO M�TODO SDM (PROCESSO ITERATIVO)

for i=1:NPontosIniciais
    x=(b-a).*rand(Nvar,1)+a; 
    Lista=[Lista, x];
    dfx=df(x);
    d=-dfx;
    beta0=.1;              % beta DE INICIALIZA��O PARA A ESCOLHA DE PASSOS 
    lambda=Wolfe(x,f,df,d,beta0);    % O PASSO lambda CONFORME AS CONDI��ES
%                                      DE WOLFE, SEGUNDO O FICHEIRO Wolfe.m                  
    xNovo=x+lambda*d;                     
    
    dfxNovo=df(xNovo);          
    
    Lista=[Lista, xNovo];     
    N=2;       
    
    while norm(dfxNovo)>error && N<nMaxIter
    dNovo=-dfxNovo;       
    
    beta0=lambda*(dfx'*d)/(dfxNovo'*dNovo); % C�LCULO DE beta0 PARA INICIAR 
%                                             O ALGORITMO 2 (VER FICHEIRO 
%                                             C/ ESCOLHA DE PTOS INICIAIS E
%                                             PASSOS) SEGUNDO � USUAL NO
%                                             SDM (TEM F�RMULA ESPEC�FICA)
    lambda=Wolfe(xNovo,f,df,dNovo,beta0);   % OBTEN��O DO NOVO PASSO lambda 
%                                             CONFORME AS CONDI��ES DE WOL- 
%                                             FE (FICHEIRO "Wolfe.m") PARA 
%                                             VALORES ATUALIZADOS DA VARI�-
%                                             VEL E DA DIRE��O DE BUSCA
    xNovo=xNovo+lambda*dNovo;    
    
    Lista=[Lista, xNovo];        
    N=N+1;                         

    x=xNovo;                       
    dfx=dfxNovo;                   
    d=dNovo;                      
    dfxNovo=df(xNovo);             
    end 
    
    LNit=[LNit, N];             
    Lopt=[Lopt, xNovo];         
end  



% PARTE 7: OBTEN��O DO M�NIMO GLOBAL

xopt=Lopt(:,1); 

for i=2:NPontosIniciais
    if f(xopt)>f(Lopt(:,i)); 
        xopt=Lopt(:,i);      
    end
end
        

% PARTE 8: DEFINI��O E EXIBI��O DOS OUTPUTS (S�O EXIBIDOS NA COMMAND WINDOW
%          PORQUE N�O � COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)(PARA OB-
%          TER LEGENDA COLOCAR PARTE 9 DO FICHEIRO "descidaMaximaV1aula.m")

xoptimo=xopt;
foptimo=f(xopt);
dffinal=df(xopt);
NIterMean=mean(LNit);



% PARTE 9: EXIBI��O DOS GR�FICOS COM RECURSO A OUTROS m.FILES
if display
    close all

    if Nvar==2
        nivelGraficos(f,a(1),b(1),a(2),b(2))
        hold on
        graficosLineSearch(Lista,LNit,Lopt)
        hold off
    elseif Nvar==1
        graficosLineSearchNvar1(f,Lista,LNit,Lopt)
        hold on
        fplot(f,[a(1),b(1)])
        hold off
    end
end