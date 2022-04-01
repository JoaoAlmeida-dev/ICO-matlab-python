% M�TODO DE DECIDA M�XIMA (SDM- STEEPEST DESCENT METHOD)

% ESTE m.FILE IMPLEMENTA O SDM PARA FUN�. OBJETIVO f C/ 1 S� VARI�VEL DEFI-
% NIDAS COMO FUNCTION-HANDLE f=@(x) ATRAV�S DE UMA EXPRESS�O NA VARI�VEL x. 

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - GERA��O PSEUDO-ALEAT�RIA DE PTOS INICIAIS x_0
% - ESCOLHA DE PASSOS lambda DE ACORDO COM LINE SEARCH INEXATA;  RECORRE AO 
%   FICHEIRO "selPassosV0.m", ONDE EST� IMPLEMENTADO O ALGORITMO 1 (VER FI-
%   CHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS).

% ESTE m.FILE PERMITE A EXIST�NCIA DE PAR�METROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PAR�METROS PODEM SER RELATIVOS �S CONDI��ES DE PARAGEM,
% AO N� (NPontosIniciais) DE PTOS INICIAIS x_0, ETC..

% ESTE M.file RECORRE A 4 m.FILES: 
% - "nivelGraficos.m", "graficosLineSearchNvar1.m", "selPassosV0.m" E AINDA
%   AO "mean.m".


% O COMANDO clear PODE SER �TIL POR REMOVER TODAS AS VARI�VEIS DO WORKSPACE
% (O QUE CORRESPONDE A ELIMIN�-LAS DO SISTEMA)

clear

% O COMANDO clc PODE SER �TIL POR LIMPAR A COMMAND WINDOW, S/ QUE AS VARI�-
% VEIS SEJAM ELIMINADAS DO SISTEMA

clc


% PARTE 1: DEFINI��O DA FUN��O OBJETIVO E DO N� DE VARI�VEIS

f=@(x) sin(1/x)/((x-0.2)^2+0.1);

Nvar=1;         



% PARTE 2: C�LCULO SIMB�LICO DO VETOR GRADIENTE  [IMPLEMENTADO PARA Nvar=1
%                                                OU Nvar=2; SE Nvar>2 � NE-
%                                                CESS�RIO EDITAR O C�DIGO]

syms a b 'real'   

if Nvar==1
v=a;          
    elseif Nvar==2
v=[a; b];       
end
        
S=f(v);          
dS=jacobian(S,v); 

df=@(x) double(subs(dS,v,x)');  
                           


% PARTE 3: DEFINI��O DOS PAR�METROS PARA OS CRIT�RIOS/CONDI��ES DE PARAGEM

Nmax=5e1;  

errodf=1e-1;  



% PARTE 4: DESIGNA��O DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GR�FIC

Lista=[];    
LNit=[];       
Lopt=[];     



% PARTE 5: N� DE PTOS INICIAIS E INTERVALO PARA SELE��O DOS PTOS INICIAIS

NPontosIniciais=10; 

a=[1e-4]; b=[.5]; % � INDICADO O INTERVALO DE VISUALIZA��O GR�FICA E ONDE 
%                   S�O TOMADOS OS PTOS INICIAIS x_0; A ESCRITA DE a E b  
%                   DEVE RNTENDER-SE COMO a=[xmin]' E  b=[xmax]'; ASSIM, A 
%                   VARI�VEL x � TOMADA NO INTEVALO [-0.0001,0.5] 
 

                                   
% PARTE 6: IMPLEMENTA��O DO M�TODO SDM (PROCESSO ITERATIVO)

for i=1:NPontosIniciais
    x=(b-a).*rand(Nvar,1)+a; 
    Lista=[Lista, x];       % O PTO INICIAL x_0 � GUARDADO NO ARQUIVO Lista 
    dfx=df(x);            % dfx = GRADIENTE df CALCULADO NO PTO INICIAL x_0
    d=-dfx;               % CARATERIZA��O DA DIRE��O DE BUSCA d=-dfx do SDM
    lambda=selPassosV0(x,f,dfx,d,.01); % ESCOLHA DE PASSO INICIAL lambda DE
%                                        ACORDO COM LINE SEARCH INEXATA: 1�
%                                        ESCOLHA (=1) USANDO O FICHEIRO
%                                        "selPassosV0.m" COM ALGORITMO 1 
    xNovo=x+lambda*d;                     % C�LCULO DA NOVA ITERADA (xNovo)
%                                           A PARTIR DO PTO INICIAL x_0
    dfxNovo=df(xNovo);           % ATUALIZA��O DO GRADIENTE:  C�LCULO DE df  
%                                  NA NOVA ITERADA xNovo RESULTANDO dfxNovo                                          
    Lista=[Lista, xNovo];     % � ARQUIVADA A NOVA ITERADA (xNovo) EM Lista
    N=2;       % N� DE ITERA��ES EFETUADAS; O PTO INICIAL x_0 CONTA COMO 1�

    while norm(dfxNovo)>errodf && N<Nmax % ESCRITA DAS CONDI��ES DE PARAGEM 
    dNovo=-dfxNovo         % ATUALIZA��O DA DIREC��O DE BUSCA:  � dNovo RE-
%                            SULTANTE DE CALCULAR -df NA NOVA ITERADA xNovo
    beta0=lambda*(dfx'*d)/(dfxNovo'*dNovo); % C�LCULO DE beta0 PARA INICIAR 
%                                             O ALGORITMO 1 (VER FICHEIRO 
%                                             C/ ESCOLHA DE PTOS INICIAIS E
%                                             PASSOS) SEGUNDO � USUAL NO
%                                             SDM (TEM F�RMULA ESPEC�FICA)
    lambda=selPassosV0(xNovo,f,dfxNovo,dNovo,beta0); %OBTEN��O DE NOVO PAS-
%                                                     SO lambda DE ACORDO 
%                                                     COM "selPassosV0.m", 
%                                                     PARA VALORES ATUALI-
%                                                     ZADOS DA  VARI�VEL 
%                                                     E DA DIRE��O DE BUSCA
    xNovo=xNovo+lambda*dNovo;    % C�LCULO DE NOVA ITERADA (xNovo) A PARTIR
%                                  DA ANTERIOR xNovo USANDO O PASSO lambda
%                                  E A DIRE��O DE BUSCA (dNovo) ATUALIZADOS
    Lista=[Lista, xNovo];        % ARQUIVO DA NOVA ITERADA (xNovo) EM Lista
    N=N+1;                                 % ATUALIZA��O DO N� DE ITERA��ES

% PARA CONTINUAR O CICLO "while...end" S�O RETOMADAS AS DESIGNA�. INICIAIS:

    x=xNovo;                          % RETOMA DA VARI�VEL: xNovo PASSA A x
    dfx=dfxNovo;                 % RETOMA DO GRADIENTE: dfxNovo PASSA A dfx
    d=dNovo;                  % RETOMA DA DIRE��O DE BUSCA: dNovo PASSA A d
    dfxNovo=df(xNovo);          % ATUALIZA��O DO GRADENTE: C�LCULO DE df NA 
%                                 NOVA ITERADA (xNovo) RESULTANDO dfxNovo
    end 
    
    LNit=[LNit, N];      
    Lopt=[Lopt, xNovo]   
end  



% PARTE 7: OBTEN��O DO M�NIMO GLOBAL

xopt=Lopt(:,1);  

for i=2:NPontosIniciais
    if f(xopt)>f(Lopt(:,i)); 
        xopt=Lopt(:,i);       
    end
end
        


% PARTE 8: DEFINI��O DOS OUTPUTS (S�O EXIBIDOS NA COMMAND WINDOW PORQUE N�O
%          � COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)(PARA OBTER LEGENDA
%          BASTA COLOCAR PARTE 9 DO FICHEIRO "descidaMaximaV1aula.m")

xoptimo=xopt        
foptimo=f(xopt)    
dffinal=df(xopt)   
Nmean=mean(LNit)   



% PARTE 9: EXIBI��O DOS GR�FICOS COM RECURSO A OUTROS m.FILES

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