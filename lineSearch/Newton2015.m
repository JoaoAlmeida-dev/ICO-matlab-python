function[xoptimo,foptimo,dffinal,NIterMean,Lopt,LNit] = Newton2015(seed , NPontosIniciais, display )

% M�TODO DE NEWTON-RAPHSON (N-RM)

% ESTE m.FILE IMPLEMENTA O N-RM COM:
% - GERA��O PSEUDO-ALEAT�RIA DE PTOS INICIAIS x_0
% - ESCOLHA DE PASSOS lambda DE ACORDO COM AS CONDI��ES DE WOLFE;  RECORRE  
%   AO FICHEIRO "Wolfe.m" ONDE ESTAS CONDI��ES EST�O IMPLEMENTADAS SEGUNDO 
%   O ALGORITMO 2 (VER FICHEIRO SOBRE ESCOLHA DE PTOS INICIAIS E PASSOS).

% ESTE m.FILE PERMITE A EXIST�NCIA DE PAR�METROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PAR�METROS S�O a, b E c DA FUN��O OBJETIVO E OUTROS RE
% LATIVOS �S CONDI��ES DE PARAGEM, AO N� (NPontosIniciais) DE PTOS INICIAIS
% x_0, ETC...

% ESTE M.file RECORRE A 3 m.FILES: 
% - "nivelGraficos.m", "graficosLineSearch.m", "mean.m" E AINDA "Wolfe.m". 

% APENAS S�O INDICADAS AS LINHAS DE C�DIGO QUE N�O FAZEM PARTE DOS FICHEI-
% ROS ANTERIORMENTE FORNECIDOS.

clc
clear
rng(seed)
% PARTE 1: DEFINI��O DA FUN��O OBJETIVO, DAS MATRIZES JACOBIANA (A SUBSTI-
%          TUIR O C�LCULO SIMB�LICO DO VETOR GRADIENTE PRESENTE NOS FICHEI-
%          ROS ANTERIORES) E HESSINA E DO N� DE VARI�VEIS

a=0.2;
b=1.9;
c=1.5;

f=@(x) (x(1)^2-100)*(x(1)^2-81)+(x(2)^2-25)*(x(2)^2-16)-a*cos(x(1)-b)*cos(x(2)-c);

df=@(x) [4*x(1)^3-362*x(1)+a*sin(x(1)-b)*cos(x(2)-c);4*x(2)^3-82*x(2)+a*cos(x(1)-b)*sin(x(2)-c)];

d2f=@(x) [12*x(1)^2-362+a*cos(x(1)-b)*cos(x(2)-c), -a*sin(x(1)-b)*sin(x(2)-c);... 
          -a*sin(x(1)-b)*sin(x(2)-c), 12*x(2)^2-82+a*cos(x(1)-b)*cos(x(2)-c)];

 Nvar=2;     

 
 % PARTE 2: DEFINI��O DOS PAR�METROS PARA OS CRIT�RIOS/CONDI��ES DE PARAGEM

Nmax=100; 
errodf=1e-2;  


% PARTE 3: DESIGNA��O DOS OUTPUTS ARQUIVOS (ESSENCIAIS AO TRATAMENTO GR�F.)

Lista=[];    
LNit=[];       
Lopt=[];     


% PARTE 4: N� DE PTOS INICIAIS E INTERVALO PARA SELE��O DOS PTOS INICIAIS

%NPontosIniciais=10;

a=[-15;-10]; b=[15;10];  



% PARTE 5: IMPLEMENTA��O DO M�TODO N-RM (PROCESSO ITERATIVO)
%          (TAL COMO NO FICH. "descidaMaximaV1aula.m", N�O SE USOU (-)Novo
%          PARA QUE N�O FOSSE NECESS�RIO O C�DIGO DE RETOMA DAS DESIGNA��ES
%          INICIAIS, COMO FEITO NOS FICHEIROS "descidaMaximaV3.m" e "desci-
%          daMaximaWolfe.m"; PODEMOS OPTAR POR QUALQUER UMA DAS FORMAS)

for i=1:NPontosIniciais
    x=(b-a).*rand(Nvar,1)+a; 
    lambda=1;                 
    Lista=[Lista, x];       
    dfx=df(x);               
    N=1;
    
    while norm(dfx)>errodf && N<Nmax               
    d2fx=d2f(x);
    d=-inv(d2fx)*dfx;           % CARATERIZA��O DA DIRE��O DE BUSCA do N-RM
    [lambda,]=Wolfe(x,f,df,d,1);  
    x=x+lambda*d;             
    Lista=[Lista, x];        
    dfx=df(x);               
    N=N+1;                  
    end 
    
    Lopt=[Lopt, x];
    LNit=[LNit, N];
end


% PARTE 6: OBTEN��O DO M�NIMO GLOBAL

xopt=Lopt(:,1); 

for i=2:NPontosIniciais
    if f(xopt)>f(Lopt(:,i)); 
        xopt=Lopt(:,i);      
    end
end
        

% PARTE 7: DEFINI��O E EXIBI��O DOS OUTPUTS (S�O EXIBIDOS NA COMMAND WINDOW
%          PORQUE N�O � COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)

xoptimo=xopt        
foptimo=f(xopt)    
dffinal=df(xopt)    
NIterMean=mean(LNit)   
HessianFinal=d2f(xopt)  %%% EXIBI��O DA HESSIANA NO PONTO �PTIMO
D2=det(HessianFinal)    %%% EXIBI��O DO 2� MENOR PRINCIPAL

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