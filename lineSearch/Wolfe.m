function [lambda]=Wolfe(x,f,df,d,beta0)

% ALGORITMO GEN�TICO 2 PARA ESCOLHA DE PASSOS ATRAV�S DAS CONDI�. DE WOLFE

% ESTE m.FILE IMPLEMENTA O ALGORITMO 2 PARA ESCOLHA DE PASSOS lambda (VER O
% FICHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS) ATRAV�S DAS CONDI-
% ��ES DE WOLFE (W1 E W2) QUE EVITAM QUE OS PASSOS lambda FIQUEM DEMASIADO
% PEQUENOS.  A ESCOLHA � ASSOCIADA A 3 CRIT�RIOS DE CLASSIFI��O: 
% - "Adequado" SE S�O SATISFEITAS AMBAS AS CONDI��ES DE WOLFE, W1 E W2
% - "Grande" SE N�O � SATISFEITA A CONDI��O W1
% - "Pequeno" SE A CONDI��O W1 � SATISFEITA MAS A CONDI��O W2 N�O �.

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO � function, NESTE CASO
% Wolfe. O NOME � SEGUIDO DE UM PAR�NTESIS ONDE CONSTAM OS INPUTS,
% QUE NESTE CASO S�O:
% - A ITERADA ATUAL x 
% - A FUN��O OBJETIVO f, ESCRITA COMO FUNCTION-HANDLE f=@(x)
% - O GRADIENTE dfx DE f EM x
% - A DIRE��O DE BUSCA d 
% - O beta0 DE INICIALIZA��O.

% NENHUM DESTES INPUTS x, f, dfx, d, beta0 � AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE � SERVIR DE SUPORTE GEN�RICO NA EXECU��O DE OUTROS
% m.FILES; S�O ESTES �LTIMOS QUE V�O "PEDIR" EXPLICITA��O DOS INPUTS x, f, 
% dfx, d, beta0 (OU J� OS T�M DEFINIDOS COM ESTAS MESMAS DESIGNA�./LETRAS).

% ESTE m.FILE PERMITE AJUSTAR OS PAR�METROS c1, c2, c, tmax E Nmax, O QUE O
% TORNA MAIS FUNCIONAL.


%%% PARTE 1: DEFINI��O DA FUN��O DE PENALIDADE E SUA DERIVADA

psi=@(t) f(x+t*d);
dpsi=@(t) df(x+t*d)'*d;


% PARTE 2: DEFINI��O DE psi inicial E DA DERIVADA DE psi EM 0

psi0=psi(0);
dpsi0=dpsi(0);



% PARTE 3: ATRIBUI��O DE VALORES AOS PAR�METROS c1, c2, c, tmax E Nmax

c1=0.3;
c2=0.6;
c=10;                                                           % TOMAR c>1
tmax=1e5;
Nmax=1e2;



% PARTE 4: ATRIBUI��O DOS VALORES T�PICOS AOS PAR�METROS c E rho

t=beta0;

tL=0;                                                          % FIXAR tL=0
tR=0;                                                          % FIXAR tR=0

N=0;


% PARTE 5: DETERMINA��O DE tR>0

while tR==0 && t<tmax && N<Nmax                          % INICIAR COM tR=0
     if psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)>=c2*t*dpsi0    % W1 E W2 VALIDADAS  
            lambda=t;                 % FICA ENCONTRADO O VALOR PARA lambda 
%                                                   CLASSIFICA��O: Adequado
            return   
     elseif psi(t)>psi0+c1*t*dpsi0    % QUANDO FALHA A CONDI��O DE WOLFE W1 
            tR=t;                   % � ENCONTRADO tR QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                     CLASSIFICA��O: Grande
     else                                                  
         t=c*t;      % CASO CONTR�RIO, AUMENTO DE t FAZENDO PRODUTO POR c>1
     end
     N=N+1;
end


% PARTE 6: INTERPOLA��O (CONFORME O M�TODO NUM�RICO DA BISSE��O)

t=(tR+tL)/2;                   % ESCOLHER t NO INTERVALO ]tL,tR[ E TESTAR t
%                                (M�TODO NUM�RICO DA BISSE��O DO INTERVALO)

while N<Nmax
    while t<tmax && N<Nmax
        if psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)>=c2*t*dpsi0 % W1 E W2 VALIDADAS
            lambda=t;                 % FICA ENCONTRADO O VALOR PARA lambda 
%                                                   CLASSIFICA��O: Adequado            
            return
            elseif psi(t)>psi0+c1*t*dpsi0      % QUANDO FALHA A CONDI��O W1
            tR=t;                   % � ENCONTRADO tR QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                     CLASSIFICA��O: Grande
            elseif psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)<c2*t*dpsi0 % SE W1 �
%                                                                V�LIDA MAS
%                                                                FALHA W2
            tL=t;                   % � ENCONTRADO tL QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                    CLASSIFICA��O: Pequeno
        end
        N=N+1;
    end
   t=(tR+tL)/2;                % ESCOLHER t NO INTERVALO ]tL,tR[ E TESTAR t
%                                (M�TODO NUM�RICO DA BISSE��O DO INTERVALO)
   N=N+1;
end

