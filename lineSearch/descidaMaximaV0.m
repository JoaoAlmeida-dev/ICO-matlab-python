% M�TODO DE DECIDA M�XIMA (SDM- STEEPEST DESCENT METHOD)

% ESTE m.FILE IMPLEMENTA O SDM PARA FUN��ES OBJETIVO f DEFINIDAS COMO FUNC-
% TION-HANDLE f=@(x) ATRAV�S DE UMA EXPRESS�O NAS SUAS VARI�VEIS x(i); ES-
% TAS VARI�VEIS x(i)COMPO�M A VARI�VEL x DA FUN��O f), SENDO x TRATADA A
% N�VEL DO MATLAB COMO UM VETOR COLUNA [x(1);x(2);...].

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - PASSO CONSTANTE lamba=0.01
% - UM S� PTO INICIAL x_0

% ESTE m.FILE PERMITE A EXIST�NCIA DE PAR�METROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PAR�METROS PODEM SER RELATIVOS �S CONDI��ES DE PARAGEM,
% AO PTO INICIAL x_0 ESCOLHIDO, ETC..

% ESTE M.file RECORRE A 3 m.FILES: 
% - f de 2 VARI�VEIS:  "nivelGraficos.m", "graficosLineSearch.m" E "mean.m" 
% - f de 1 VAR.: "nivelGraficos.m", "graficosLineSearchNvar1.m" E "mean.m".


% O COMANDO clear PODE SER �TIL POR REMOVER TODAS AS VARI�VEIS DO WORKSPACE
%                 (O QUE CORRESPONDE A ELIMIN�-LAS DO SISTEMA)

clear

% O COMANDO clc PODE SER �TIL POR LIMPAR A COMMAND WINDOW, S/ QUE AS VARI�-
%               VEIS SEJAM ELIMINADAS DO SISTEMA

clc


% PARTE 1: DEFINI��O DA FUN��O OBJETIVO E DO N� DE VARI�VEIS

f=@(x)  x(1)^2+x(2)^2;             % CUJO GR�FICO � UM PARABOL�IDE CIRCULAR

Nvar=2;        



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

% CASO A TOOLBOX Symbolic Math N�O ESTEJA DISPON�VEL, TEM DE SER INTRODUZI- 
% DA NO C�DIGO A EXPRESS�O DO VETOR GRADIENTE DE f (COMO VETOR COLUNA):

% df=@(x) [2*x(1)^2; 2*x(2)^2];                  
                         
   

% PARTE 3: DEFINI��O DOS PAR�METROS PARA OS CRIT�RIOS/CONDI��ES DE PARAGEM

Nmax=500;  

errodf=1e-2; 



% PARTE 4: DESIGNA��O DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GR�F.

Lista=[];   % Lista: ARQUIVA AS ITERADAS x_k OBTIDAS A PARTIR DO PTO INICI-
%             AL x_0 (NESTE CASO APENAS SE VAI ESCOLHE UM PTO INICIAL x_0)
LNit=[];      
Lopt=[];     



% PARTE 5: N� PTOS INICIAIS (NA) E INTERVALO PARA SELE��O DOS PTOS INICIAIS

% NPontosIniciais=0; 

 a=[-2,-2]'; b=[2,2]'; 

 
                               
% PARTE 6: IMPLEMENTA��O DO M�TODO SDM (PROCESSO ITERATIVO)
    
    x=[1.1,1.1]';  % ESCOLHA DO �NICO PTO INICIAL x_0=(x(1),x(2))=(1.1,1.1)
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
       
    xopt=x;                          % DESIGNA-SE POR xopt A �LTIMA ITERA-
%                                      DA FACE AO(S) CRIT�RIO(S) DE PARAGEM
    Lopt=x;                     % x=xopt � O �NICO ELEMENTO DO ARQUIVO Lopt
    LNit=N;                      % O N� (N) DE ITERA��ES OBTIDO A PARTIR DE
%                                  x_0 � O �NICO ELEMENTO DO ARQUIVO LNit      
    

% PARTE 7: OBTEN��O DO M�NIMO GLOBAL (NA: NESTE CASO O CANDIDATO � �NICO)
                          
% xopt=Lopt(:,1);

% for i=2:NPontosIniciais
%     if f(xopt)>f(Lopt(:,i)); 
%         xopt=Lopt(:,i);      
%     end
% end
        

% PARTE 8: DEFINI��O E EXIBI��O DOS OUTPUTS (S�O EXIBIDOS NA COMMAND WINDOW
%          PORQUE N�O � COLOCADO ";" NO FINAL, EMBORA SEM LEGENDA)(PARA OB-
%          TER LEGENDA COLOCAR PARTE 9 DO FICHEIRO "descidaMaximaV1aula.m")

xoptimo=xopt        
foptimo=f(xopt)    
dffinal=df(xopt)    
NIterMean=mean(LNit)   


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