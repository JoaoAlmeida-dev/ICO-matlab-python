function[xoptimo,foptimo,dffinal,NIterMean,Lopt,LNit] = descidaMaximaV1aula(seed , NPontosIniciais, nMaxIter, error, xmin,xmax,ymin,ymax, display )
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
%descidaMaximaV1aula(4414055,10,50,0.15,[-4;-4],[4; 4],true)
% ESTE m.FILE IMPLEMENTA O SDM PARA FUN��ES OBJETIVO f DEFINIDAS COMO FUNC-
% TION-HANDLE f=@(x) ATRAV�S DE UMA EXPRESS�O NAS SUAS VARI�VEIS x(i); ES-
% TAS VARI�VEIS x(i)COMPO�M A VARI�VEL x DA FUN��O f), SENDO x TRATADA A
% N�VEL DO MATLAB COMO UM VETOR COLUNA [x(1);x(2);...].

% ESTE m.FILE IMPLEMENTA O SDM COM:
% - GERA��O PSEUDO-ALEAT�RIA DE PTOS INICIAIS x_0
% - PASSO CONSTANTE lamba=0.01

% ESTE m.FILE PERMITE A EXIST�NCIA DE PAR�METROS A AJUSTAR, O QUE O TORNA +  
% FUNCIONAL; ESSES PAR�METROS PODEM SER RELATIVOS �S CONDI��ES DE PARAGEM,
% AO N� (NPontosIniciais) DE PTOS INICIAIS x_0, ETC..

% ESTE M.file RECORRE A 3 m.FILES: 
% - f de 2 VARI�VEIS:  "nivelGraficos.m", "graficosLineSearch.m" E "mean.m" 
% - f de 1 VAR.: "nivelGraficos.m", "graficosLineSearchNvar1.m" E "mean.m".


% O COMANDO clc PODE SER �TIL POR LIMPAR VARI�VEIS DO AMBIENTE DE TRABALHO

clc
%rng(2)
%rng(18)
rng(seed)
 dbstop in descidaMaximaV1aula at 188
% PARTE 1: DEFINI��O DA FUN��O OBJETIVO E DO N� DE VARI�VEIS

f=@(x) 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
%f=@(x) (x(1) + 2)*x(1)*(x(1)-2)*(x(1)-6)+(x(2) + 2)*x(2)*(x(2)-2)*(x(2)-6);

Nvar=2;                         % O N� DE VARI�VEIS: � RELEVANTE NA GERA��O
%                                 DO PTO INICIAL x_0 E NO TRATAMENTO GR�F.


% PARTE 2: C�LCULO SIMB�LICO DO VETOR GRADIENTE  [IMPLEMENTADO PARA Nvar=1
%                                                OU Nvar=2; SE Nvar>2 � NE-
%                                                CESS�RIO EDITAR O C�DIGO]

syms a b 'real'       % a E b S�O DEFINIDAS COMO VARI�VEIS SIMB�LICAS REAIS

if Nvar==1
v=a;                  % DEFINE O VETOR v DA VARI�VEL SIMB�LICA a NO CASO DE 
%                       EXISTIR APENAS UMA VARI�VEL x NA fUN��O OBJETIVO f
    elseif Nvar==2
v=[a; b];             % DEFINE O VETOR COLUNA v DAS VARI�VEIS SIMB�LICAS a 
%                       E b NO CASO DE EXISTIREM 2 VARI�VEIS x(1) E x(2) NA
%                       FUN��O OBJETIVO f
end
        
S=f(v);             % DEFINE A FUN��O OBJETIVO f COMO EXPRESS�O SIMB�LICA S

dS=jacobian(S,v);  % COMANDO jacobian PARA C�LC. SIMB�L. DO VETOR GRADIENTE
                    
df=@(x) double(subs(dS,v,x)');    % DEFINE O VETOR GRADIENTE COMO FUNCTION-
%                                   -HANDLE df=@(x) DADO POR dS; O COMANDO 
%                                   subs PERMITE QUE ESTA FUN��O GRADIENTE 
%                                   POSSA SER USADA PARA C�LCULO NUM�RICO 
%                                   QUANDO SE SUBSTITUI O VETOR SIMB�LICO v
%                                   POR VALORES CONCRETOS DE x; RESULTA NUM
%                                   VETOR COLUNA POR USO DA NOTA��O '
                           

% PARTE 3: DEFINI��O DOS PAR�METROS PARA OS CRIT�RIOS/CONDI��ES DE PARAGEM

%nMaxIter=50;     nMaxIter  % � INDICADO O N� M�XIMO DE ITERA��ES (Nmax): 50
%error=0.15; error  % � INDICADO O ERRO (errodf) PERMITIDO NO GRADIENte: 10^(-1)



% PARTE 4: DESIGNA��O DOS OUTPUTS ARQUIVOS, ESSENCIAIS AO TRATAMENTO GR�FIC

Lista=[];  % Lista: ARQUIVA AS ITERADAS x_k OBTIDAS EM CADA PTO INICIAL x_0 
LNit=[];   % LNit: ARQUIVA O N� DE ITERA��ES USADAS EM CADA PTO INICIAL x_0
Lopt=[];   % Lopt: ARQUIVA OS CANDIDATOS A PTOS �PTIMOS (OS �PTIMOS LOCAIS)



% PARTE 5: N� DE PTOS INICIAIS E INTERVALO PARA SELE��O DOS PTOS INICIAIS

%NPontosIniciais=13; %� INDICADO O N� (NPontosIniciais) DE PTOS INICIAIS: 10

 % � INDICADO O INTERVALO DE VISUALIZA��O GR�FICA, ONDE S�O TOMADOS OS PTOS INICIAIS x_0(A ESCRITA DE a E b DEVE ENTENDER-SE COMOa=[xmin,ymin]' E  b=[xmax,ymax]', LOGO x(1) E x(2) S�O TOMADAS NO INTERVALO [-2.5,6.5])
a=[4,4]';b=[-4,-4]';

                                   
% PARTE 6: IMPLEMENTA��O DO M�TODO SDM (PROCESSO ITERATIVO)

for i=1:NPontosIniciais             % INDEXA��O POR i DOS PTOS INICIAIS x_0
    x=(b-a).*rand(Nvar,1)+a;  % PROCESSO DE ESCOLHA DOS PTOS INICIAIS x_0,
%                                NESTE CASO � POR GERA��O PSEUDO-ALEAT�RIA
    lambda=.001;           % ESCOLHA DO PASSO / STEPSIZE CONST. LAMBDA: 0.01
    Lista=[Lista, x];       % O PTO INICIAL x_0 � GUARDADO NO ARQUIVO Lista 
    dfx=df(x);            % dfx = GRADIENTE df CALCULADO NO PTO INICIAL x_0     
    N=1;       % N� DE ITERA��ES EFETUADAS; O PTO INICIAL x_0 CONTA COMO 1�     
    
    while norm(dfx)>error && N<nMaxIter     % ESCRITA DAS CONDI��ES DE PARAGEM
        d=-dfx;           % CARATERIZA��O DA DIRE��O DE BUSCA d=-dfx do SDM                    
        x=x+lambda*d;   % C�LC. DA NOVA ITERADA A PARTIR DO PTO INICIAL x_0
        Lista=[Lista, x];                % ARQUIVO DA NOVA ITERADA EM Lista
        dfx=df(x);    % ATUALIZA�. DO GRADIENTE: C�LC. DE df NA NOVA ITERADA
        N=N+1;                             % ATUALIZA��O DO N� DE ITERA��ES           
    end 
    
    % A �LTIMA ITERADA PARA CADA PTO INICIAL x_0 [FACE AO(S) CRIT�RIO(S) DE PARAGEM]  � AR-QUIVADA EM Lopt COMO PTO CANDIDATO A �PTI- MO GLOBAL (AT� AQUI � UM PTO �PTIMO LOCAL)
    Lopt=[Lopt x];
    % O N� (N) DE ITERA��ES � GUARDADO NO ARQUIVO LNit
    LNit=[LNit N];
end



% PARTE 7: OBTEN��O DO M�NIMO GLOBAL

% DESIGNA-SE O 1� CANDIDATO A �PTIMO GLOBAL POR xopt E � TOMADO COMO O 1� ELEMENTO DO ARQUIVO Lopt
xopt=Lopt(:,1);

% INDEXA��O POR i DOS DIFERENTES CANDIDATOS, SENDO O N� DE CANDIDATOS IGUAL AO N� (NPontosIniciais)DE PTOS INICIAIS x_0
for i=2:NPontosIniciais
    % AVALIA��O DO CANDIDATO FACE AO RESTAN-TES CANDIDATOS: TEM A MENOR IMAGEM porf FACE AOS RESTANTES DO ARQUIVO Lopt
    if f(xopt)>f(Lopt(:,i))
        % TROCA DE CANDIDATO A �PTIMO GLOBAL SEMPRE QUE A AVALIA��O ANTERIOR N�O FOR FAVOR�VEL � MINIMIZA- ��O,ISTO �, SE A RESPOSTA � QUEST�O ANTER. � N�O
        xopt=Lopt(:,i);
    end
end



% PARTE 8: DEFINI��O DOS OUTPUTS

xoptimo=xopt;    % DESIGNA-SE O PONTO �PTIMO POR xoptimo, ISTO �, xoptimo =
%                  = MELHOR CANDIDATO xopt OBTIDO DO CICLO ANTERIOR   
                 
foptimo=f(xopt);               % DESIGNA-SE POR foptimo O VALOR �PTIMO (M�-
%                                N�MO GLOBAL) OBTIDO, ISTO �, foptimo=VALOR
%                                �PTIMO: foptimo = f(PTO �PTIMO)=f(xopt)
                 
dffinal=df(xopt);                      % DESIGNA-SE O VETOR GRADIENTE CAL-
%                                        CULADO NO PONTO �PTIMO POR dffinal  
                                       
NIterMean=mean(LNit);        % C�LCULO DO N� M�DIO (NIterMEAN) DE ITERA��ES  
%                              NECESS�RIAS ATRAV�S DO FICHEIRO "mean.m"
     


% PARTE 9: EXIBI��O DE OUTPUTS NA COMMAND WINDOW
disp('xoptimo:');                 % EXIBIR PTO �PTIMO LEGENDADO 'xoptimo'
disp(xoptimo);                    % EXIBI��O DO (OUTPUT) PTO �PTIMO xoptimo

disp('foptimo:');               % EXIBIR VALOR �PTIMO LEGENDADA 'foptimo'
disp(foptimo);                  % EXIBI��O DO (OUTPUT) VALOR �PTIMO foptimo

disp('dffinal:');    % EXIBIR GRADIENTE NO PTO �PTIMO LEGENDADO 'dffinal'
disp(dffinal);       % EXIBI��O DO (OUTPUT) GRADIENTE NO PTO �PTIMO dffinal

disp('NIterMean:');  % EXIBIR N� M�DIO DE ITERA�. LEGENDADO 'NIterMean'
disp(NIterMean);     % EXIBI��O DO (OUTPUT) N� M�DIO DE ITERA��ES NIterMean

disp('Lopt:');
disp(Lopt);

disp('LNit:');
disp(LNit);



% PARTE 10: EXIBI��O DOS GR�FICOS COM RECURSO A OUTROS m.FILES

if display
    close all                      % LIMPAR ANTES DE RECORRER A OUTROS m.FILES

     % SE O N� DE VARI�VEIS DA FUN��O OBJETIVO f FOR 2
     if Nvar==2
         % REPRESENTA��O GR�FICA DAS CURVAS DE N�VEL ATRAV�S DO FICHEIRO "nivelGraficos.m"
         nivelGraficos(f,a(1),b(1),a(2),b(2))
         % (COMANDO J� EXPLICADO NOUTROS m.FILE)
         hold on

         % E TRATAMENTO GR�FICO DOS OUTPUTS Lista E LNit ATRAV�S DO FICHEIRO "graficosLineSearch.m"
         graficosLineSearch(Lista,LNit,Lopt)
         % (COMANDO J� EXPLICADO NOUTROS m.FILE)
         hold off
    elseif Nvar==1                        % SE O N� DE VARI�VEIS DE f FOR 1
         graficosLineSearchNvar1(f,Lista,LNit,Lopt)   % TRATAMENTO GR�FICO DOS OUTPUTS f, Lista E LNit PELO "graficosLineSearchNvar1.m"
         hold on
         fplot(f,[a(1),b(1)])           % EXIBI��O DO GR�FICO (TRIDIMENSIONAL) DE f
         hold off
     end
 end