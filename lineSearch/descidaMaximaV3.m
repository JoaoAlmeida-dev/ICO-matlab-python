% MÉTODO DE DECIDA MÁXIMA (SDM- STEEPEST DESCENT METHOD)

% ESTE m.FILE IMPLEMENTA O SDM PARA FUNÇ. OBJETIVO f C/ 1 SÓ VARIÁVEL DEFI-
% NIDAS COMO FUNCTION-HANDLE f=@(x) ATRAVÉS DE UMA EXPRESSÃO NA VARIÁVEL x. 

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - GERAÇÃO PSEUDO-ALEATÓRIA DE PTOS INICIAIS x_0
% - ESCOLHA DE PASSOS lambda DE ACORDO COM LINE SEARCH INEXATA;  RECORRE AO 
%   FICHEIRO "selPassosV0.m", ONDE ESTÁ IMPLEMENTADO O ALGORITMO 1 (VER FI-
%   CHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS).

% ESTE m.FILE PERMITE A EXISTÊNCIA DE PARÂMETROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PARÂMETROS PODEM SER RELATIVOS ÀS CONDIÇÕES DE PARAGEM,
% AO Nº (NPontosIniciais) DE PTOS INICIAIS x_0, ETC..

% ESTE M.file RECORRE A 4 m.FILES: 
% - "nivelGraficos.m", "graficosLineSearchNvar1.m", "selPassosV0.m" E AINDA
%   AO "mean.m".


% O COMANDO clear PODE SER ÚTIL POR REMOVER TODAS AS VARIÁVEIS DO WORKSPACE
% (O QUE CORRESPONDE A ELIMINÁ-LAS DO SISTEMA)

clear

% O COMANDO clc PODE SER ÚTIL POR LIMPAR A COMMAND WINDOW, S/ QUE AS VARIÁ-
% VEIS SEJAM ELIMINADAS DO SISTEMA

clc


% PARTE 1: DEFINIÇÃO DA FUNÇÃO OBJETIVO E DO Nº DE VARIÁVEIS

f=@(x) sin(1/x)/((x-0.2)^2+0.1);

Nvar=1;         



% PARTE 2: CÁLCULO SIMBÓLICO DO VETOR GRADIENTE  [IMPLEMENTADO PARA Nvar=1
%                                                OU Nvar=2; SE Nvar>2 É NE-
%                                                CESSÁRIO EDITAR O CÓDIGO]

syms a b 'real'   

if Nvar==1
v=a;          
    elseif Nvar==2
v=[a; b];       
end
        
S=f(v);          
dS=jacobian(S,v); 

df=@(x) double(subs(dS,v,x)');  
                           


% PARTE 3: DEFINIÇÃO DOS PARÂMETROS PARA OS CRITÉRIOS/CONDIÇÕES DE PARAGEM

Nmax=5e1;  

errodf=1e-1;  



% PARTE 4: DESIGNAÇÃO DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GRÁFIC

Lista=[];    
LNit=[];       
Lopt=[];     



% PARTE 5: Nº DE PTOS INICIAIS E INTERVALO PARA SELEÇÃO DOS PTOS INICIAIS

NPontosIniciais=10; 

a=[1e-4]; b=[.5]; % É INDICADO O INTERVALO DE VISUALIZAÇÃO GRÁFICA E ONDE 
%                   SÃO TOMADOS OS PTOS INICIAIS x_0; A ESCRITA DE a E b  
%                   DEVE RNTENDER-SE COMO a=[xmin]' E  b=[xmax]'; ASSIM, A 
%                   VARIÁVEL x É TOMADA NO INTEVALO [-0.0001,0.5] 
 

                                   
% PARTE 6: IMPLEMENTAÇÃO DO MÉTODO SDM (PROCESSO ITERATIVO)

for i=1:NPontosIniciais
    x=(b-a).*rand(Nvar,1)+a; 
    Lista=[Lista, x];       % O PTO INICIAL x_0 É GUARDADO NO ARQUIVO Lista 
    dfx=df(x);            % dfx = GRADIENTE df CALCULADO NO PTO INICIAL x_0
    d=-dfx;               % CARATERIZAÇÃO DA DIREÇÃO DE BUSCA d=-dfx do SDM
    lambda=selPassosV0(x,f,dfx,d,.01); % ESCOLHA DE PASSO INICIAL lambda DE
%                                        ACORDO COM LINE SEARCH INEXATA: 1ª
%                                        ESCOLHA (=1) USANDO O FICHEIRO
%                                        "selPassosV0.m" COM ALGORITMO 1 
    xNovo=x+lambda*d;                     % CÁLCULO DA NOVA ITERADA (xNovo)
%                                           A PARTIR DO PTO INICIAL x_0
    dfxNovo=df(xNovo);           % ATUALIZAÇÃO DO GRADIENTE:  CÁLCULO DE df  
%                                  NA NOVA ITERADA xNovo RESULTANDO dfxNovo                                          
    Lista=[Lista, xNovo];     % É ARQUIVADA A NOVA ITERADA (xNovo) EM Lista
    N=2;       % Nº DE ITERAÇÕES EFETUADAS; O PTO INICIAL x_0 CONTA COMO 1ª

    while norm(dfxNovo)>errodf && N<Nmax % ESCRITA DAS CONDIÇÕES DE PARAGEM 
    dNovo=-dfxNovo         % ATUALIZAÇÃO DA DIRECÇÃO DE BUSCA:  É dNovo RE-
%                            SULTANTE DE CALCULAR -df NA NOVA ITERADA xNovo
    beta0=lambda*(dfx'*d)/(dfxNovo'*dNovo); % CÁLCULO DE beta0 PARA INICIAR 
%                                             O ALGORITMO 1 (VER FICHEIRO 
%                                             C/ ESCOLHA DE PTOS INICIAIS E
%                                             PASSOS) SEGUNDO É USUAL NO
%                                             SDM (TEM FÓRMULA ESPECÍFICA)
    lambda=selPassosV0(xNovo,f,dfxNovo,dNovo,beta0); %OBTENÇÃO DE NOVO PAS-
%                                                     SO lambda DE ACORDO 
%                                                     COM "selPassosV0.m", 
%                                                     PARA VALORES ATUALI-
%                                                     ZADOS DA  VARIÁVEL 
%                                                     E DA DIREÇÃO DE BUSCA
    xNovo=xNovo+lambda*dNovo;    % CÁLCULO DE NOVA ITERADA (xNovo) A PARTIR
%                                  DA ANTERIOR xNovo USANDO O PASSO lambda
%                                  E A DIREÇÃO DE BUSCA (dNovo) ATUALIZADOS
    Lista=[Lista, xNovo];        % ARQUIVO DA NOVA ITERADA (xNovo) EM Lista
    N=N+1;                                 % ATUALIZAÇÃO DO Nº DE ITERAÇÕES

% PARA CONTINUAR O CICLO "while...end" SÃO RETOMADAS AS DESIGNAÇ. INICIAIS:

    x=xNovo;                          % RETOMA DA VARIÁVEL: xNovo PASSA A x
    dfx=dfxNovo;                 % RETOMA DO GRADIENTE: dfxNovo PASSA A dfx
    d=dNovo;                  % RETOMA DA DIREÇÃO DE BUSCA: dNovo PASSA A d
    dfxNovo=df(xNovo);          % ATUALIZAÇÃO DO GRADENTE: CÁLCULO DE df NA 
%                                 NOVA ITERADA (xNovo) RESULTANDO dfxNovo
    end 
    
    LNit=[LNit, N];      
    Lopt=[Lopt, xNovo]   
end  



% PARTE 7: OBTENÇÃO DO MÍNIMO GLOBAL

xopt=Lopt(:,1);  

for i=2:NPontosIniciais
    if f(xopt)>f(Lopt(:,i)); 
        xopt=Lopt(:,i);       
    end
end
        


% PARTE 8: DEFINIÇÃO DOS OUTPUTS (SÃO EXIBIDOS NA COMMAND WINDOW PORQUE NÃO
%          É COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)(PARA OBTER LEGENDA
%          BASTA COLOCAR PARTE 9 DO FICHEIRO "descidaMaximaV1aula.m")

xoptimo=xopt        
foptimo=f(xopt)    
dffinal=df(xopt)   
Nmean=mean(LNit)   



% PARTE 9: EXIBIÇÃO DOS GRÁFICOS COM RECURSO A OUTROS m.FILES

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