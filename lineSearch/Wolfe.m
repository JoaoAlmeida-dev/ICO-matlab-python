function [lambda]=Wolfe(x,f,df,d,beta0)

% ALGORITMO GENÉTICO 2 PARA ESCOLHA DE PASSOS ATRAVÉS DAS CONDIÇ. DE WOLFE

% ESTE m.FILE IMPLEMENTA O ALGORITMO 2 PARA ESCOLHA DE PASSOS lambda (VER O
% FICHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS) ATRAVÉS DAS CONDI-
% ÇÕES DE WOLFE (W1 E W2) QUE EVITAM QUE OS PASSOS lambda FIQUEM DEMASIADO
% PEQUENOS.  A ESCOLHA É ASSOCIADA A 3 CRITÉRIOS DE CLASSIFIÇÃO: 
% - "Adequado" SE SÃO SATISFEITAS AMBAS AS CONDIÇÕES DE WOLFE, W1 E W2
% - "Grande" SE NÃO É SATISFEITA A CONDIÇÃO W1
% - "Pequeno" SE A CONDIÇÃO W1 É SATISFEITA MAS A CONDIÇÃO W2 NÃO É.

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO À function, NESTE CASO
% Wolfe. O NOME É SEGUIDO DE UM PARÊNTESIS ONDE CONSTAM OS INPUTS,
% QUE NESTE CASO SÃO:
% - A ITERADA ATUAL x 
% - A FUNÇÃO OBJETIVO f, ESCRITA COMO FUNCTION-HANDLE f=@(x)
% - O GRADIENTE dfx DE f EM x
% - A DIREÇÃO DE BUSCA d 
% - O beta0 DE INICIALIZAÇÃO.

% NENHUM DESTES INPUTS x, f, dfx, d, beta0 É AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE É SERVIR DE SUPORTE GENÉRICO NA EXECUÇÃO DE OUTROS
% m.FILES; SÃO ESTES ÚLTIMOS QUE VÃO "PEDIR" EXPLICITAÇÃO DOS INPUTS x, f, 
% dfx, d, beta0 (OU JÁ OS TÊM DEFINIDOS COM ESTAS MESMAS DESIGNAÇ./LETRAS).

% ESTE m.FILE PERMITE AJUSTAR OS PARÂMETROS c1, c2, c, tmax E Nmax, O QUE O
% TORNA MAIS FUNCIONAL.


%%% PARTE 1: DEFINIÇÃO DA FUNÇÃO DE PENALIDADE E SUA DERIVADA

psi=@(t) f(x+t*d);
dpsi=@(t) df(x+t*d)'*d;


% PARTE 2: DEFINIÇÃO DE psi inicial E DA DERIVADA DE psi EM 0

psi0=psi(0);
dpsi0=dpsi(0);



% PARTE 3: ATRIBUIÇÃO DE VALORES AOS PARÃMETROS c1, c2, c, tmax E Nmax

c1=0.3;
c2=0.6;
c=10;                                                           % TOMAR c>1
tmax=1e5;
Nmax=1e2;



% PARTE 4: ATRIBUIÇÃO DOS VALORES TÍPICOS AOS PARÃMETROS c E rho

t=beta0;

tL=0;                                                          % FIXAR tL=0
tR=0;                                                          % FIXAR tR=0

N=0;


% PARTE 5: DETERMINAÇÃO DE tR>0

while tR==0 && t<tmax && N<Nmax                          % INICIAR COM tR=0
     if psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)>=c2*t*dpsi0    % W1 E W2 VALIDADAS  
            lambda=t;                 % FICA ENCONTRADO O VALOR PARA lambda 
%                                                   CLASSIFICAÇÃO: Adequado
            return   
     elseif psi(t)>psi0+c1*t*dpsi0    % QUANDO FALHA A CONDIÇÃO DE WOLFE W1 
            tR=t;                   % É ENCONTRADO tR QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                     CLASSIFICAÇÃO: Grande
     else                                                  
         t=c*t;      % CASO CONTRÁRIO, AUMENTO DE t FAZENDO PRODUTO POR c>1
     end
     N=N+1;
end


% PARTE 6: INTERPOLAÇÃO (CONFORME O MÉTODO NUMÉRICO DA BISSEÇÃO)

t=(tR+tL)/2;                   % ESCOLHER t NO INTERVALO ]tL,tR[ E TESTAR t
%                                (MÉTODO NUMÉRICO DA BISSEÇÃO DO INTERVALO)

while N<Nmax
    while t<tmax && N<Nmax
        if psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)>=c2*t*dpsi0 % W1 E W2 VALIDADAS
            lambda=t;                 % FICA ENCONTRADO O VALOR PARA lambda 
%                                                   CLASSIFICAÇÃO: Adequado            
            return
            elseif psi(t)>psi0+c1*t*dpsi0      % QUANDO FALHA A CONDIÇÃO W1
            tR=t;                   % É ENCONTRADO tR QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                     CLASSIFICAÇÃO: Grande
            elseif psi(t)<=psi0+c1*t*dpsi0 && dpsi(t)<c2*t*dpsi0 % SE W1 É
%                                                                VÁLIDA MAS
%                                                                FALHA W2
            tL=t;                   % É ENCONTRADO tL QUE TOMA O VALOR DE t
            break                                     % TERMINA O ALGORITMO
%                                                    CLASSIFICAÇÃO: Pequeno
        end
        N=N+1;
    end
   t=(tR+tL)/2;                % ESCOLHER t NO INTERVALO ]tL,tR[ E TESTAR t
%                                (MÉTODO NUMÉRICO DA BISSEÇÃO DO INTERVALO)
   N=N+1;
end

