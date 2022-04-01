% MÉTODO DE DECIDA MÁXIMA (SDM- STEEPEST DESCENT METHOD)

% ESTE m.FILE IMPLEMENTA O SDM PARA FUNÇÕES OBJETIVO f DEFINIDAS COMO FUNC-
% TION-HANDLE f=@(x) ATRAVÉS DE UMA EXPRESSÃO NAS SUAS VARIÁVEIS x(i); ES-
% TAS VARIÁVEIS x(i)COMPOÊM A VARIÁVEL x DA FUNÇÃO f), SENDO x TRATADA A
% NÍVEL DO MATLAB COMO UM VETOR COLUNA [x(1);x(2);...].

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - PASSO CONSTANTE lamba=0.01
% - UM SÓ PTO INICIAL x_0

% ESTE m.FILE PERMITE A EXISTÊNCIA DE PARÂMETROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PARÂMETROS PODEM SER RELATIVOS ÀS CONDIÇÕES DE PARAGEM,
% AO PTO INICIAL x_0 ESCOLHIDO, ETC..

% ESTE M.file RECORRE A 3 m.FILES: 
% - f de 2 VARIÁVEIS:  "nivelGraficos.m", "graficosLineSearch.m" E "mean.m" 
% - f de 1 VAR.: "nivelGraficos.m", "graficosLineSearchNvar1.m" E "mean.m".


% O COMANDO clear PODE SER ÚTIL POR REMOVER TODAS AS VARIÁVEIS DO WORKSPACE
%                 (O QUE CORRESPONDE A ELIMINÁ-LAS DO SISTEMA)

clear

% O COMANDO clc PODE SER ÚTIL POR LIMPAR A COMMAND WINDOW, S/ QUE AS VARIÁ-
%               VEIS SEJAM ELIMINADAS DO SISTEMA

clc


% PARTE 1: DEFINIÇÃO DA FUNÇÃO OBJETIVO E DO Nº DE VARIÁVEIS

f=@(x)  x(1)^2+x(2)^2;             % CUJO GRÁFICO É UM PARABOLÓIDE CIRCULAR

Nvar=2;        



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

% CASO A TOOLBOX Symbolic Math NÃO ESTEJA DISPONÍVEL, TEM DE SER INTRODUZI- 
% DA NO CÓDIGO A EXPRESSÃO DO VETOR GRADIENTE DE f (COMO VETOR COLUNA):

% df=@(x) [2*x(1)^2; 2*x(2)^2];                  
                         
   

% PARTE 3: DEFINIÇÃO DOS PARÂMETROS PARA OS CRITÉRIOS/CONDIÇÕES DE PARAGEM

Nmax=500;  

errodf=1e-2; 



% PARTE 4: DESIGNAÇÃO DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GRÁF.

Lista=[];   % Lista: ARQUIVA AS ITERADAS x_k OBTIDAS A PARTIR DO PTO INICI-
%             AL x_0 (NESTE CASO APENAS SE VAI ESCOLHE UM PTO INICIAL x_0)
LNit=[];      
Lopt=[];     



% PARTE 5: Nº PTOS INICIAIS (NA) E INTERVALO PARA SELEÇÃO DOS PTOS INICIAIS

% NPontosIniciais=0; 

 a=[-2,-2]'; b=[2,2]'; 

 
                               
% PARTE 6: IMPLEMENTAÇÃO DO MÉTODO SDM (PROCESSO ITERATIVO)
    
    x=[1.1,1.1]';  % ESCOLHA DO ÚNICO PTO INICIAL x_0=(x(1),x(2))=(1.1,1.1)
    lambda=.01
    Lista=[Lista, x];        
    dfx=df(x);               
    N=1;                     
    
    while norm(dfx)>errodf && N<Nmax 
    d=-dfx;                                
    x=x+lambda*d;             
    Lista=[Lista, x];        
    dfx=df(x);               
    N=N+1;                   
    end 
       
    xopt=x;                          % DESIGNA-SE POR xopt A ÚLTIMA ITERA-
%                                      DA FACE AO(S) CRITÉRIO(S) DE PARAGEM
    Lopt=x;                     % x=xopt É O ÚNICO ELEMENTO DO ARQUIVO Lopt
    LNit=N;                      % O Nº (N) DE ITERAÇÕES OBTIDO A PARTIR DE
%                                  x_0 É O ÚNICO ELEMENTO DO ARQUIVO LNit      
    

% PARTE 7: OBTENÇÃO DO MÍNIMO GLOBAL (NA: NESTE CASO O CANDIDATO É ÚNICO)
                          
% xopt=Lopt(:,1);

% for i=2:NPontosIniciais
%     if f(xopt)>f(Lopt(:,i)); 
%         xopt=Lopt(:,i);      
%     end
% end
        

% PARTE 8: DEFINIÇÃO E EXIBIÇÃO DOS OUTPUTS (SÃO EXIBIDOS NA COMMAND WINDOW
%          PORQUE NÃO É COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)(PARA OB-
%          TER LEGENDA COLOCAR PARTE 9 DO FICHEIRO "descidaMaximaV1aula.m")

xoptimo=xopt        
foptimo=f(xopt)    
dffinal=df(xopt)    
NIterMean=mean(LNit)   


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