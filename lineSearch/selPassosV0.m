function lambda=selPassosV0(x,f,dfx,d,beta)

% ALGORITMO 1 PARA ESCOLHA DE PASSOS (DE ACORDO COM LINE SEARCH INEXATA)

% ESTE m.FILE IMPLEMENTA O ALGORITMO 1 PARA ESCOLHA DE PASSOS lambda (VER O
% FICHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS).  

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO À function, NESTE CASO
% selPassosV0. O NOME É SEGUIDO DE UM PARÊNTESIS ONDE CONSTAM OS INPUTS,
% QUE NESTE CASO SÃO:
% - A ITERADA ATUAL x 
% - A FUNÇÃO OBJETIVO f, ESCRITA COMO FUNCTION-HANDLE f=@(x)
% - O GRADIENTE dfx DE f EM x
% - A DIREÇÃO DE BUSCA d 
% - O beta DE INICIALIZAÇÃO.

% NENHUM DESTES INPUTS x, f, dfx, d, beta É AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE É SERVIR DE SUPORTE GENÉRICO NA EXECUÇÃO DE OUTROS
% m.FILES; SÃO ESTES ÚLTIMOS QUE VÃO "PEDIR" EXPLICITAÇÃO DOS INPUTS x, f, 
% dfx, d E beta (OU JÁ OS TÊM DEFINIDOS COM ESTAS MESMAS DESIGNAÇ./LETRAS).

% ESTE m.FILE PERMITE AJUSTAR OS PARÂMETROS c E rho, O QUE O TORNA MAIS 
% FUNCIONAL.


% PARTE 1: DEFINIÇAO DA FUNÇÃO DE PENALIDADE

psi=@(a) f(x+a*d);


% PARTE 2: DEFINIÇÃO DE psi inicial E CÁLCULO DA DERIVADA DE psi EM 0

psi0=psi(0);
dpsi0=dfx'*d;


% PARTE 3: ATRIBUIÇÃO DOS VALORES TÍPICOS AOS PARâMETROS c E rho

c=1e-4;

rho=0.9;


% PARTE 4: ESTRUTURA CONDICIONAL PARA OBTENÇÃO DOS PASSOS lambda

fx=f(x);                  % DEFINIÇÃO DAS IMAGENS fx PELA FUNÇÃO OBJETIVO f
n=0;                              % VALOR INICIAL DO "ÍNDICE" n DE CONTAGEM

while psi(beta)>psi0+c*beta*dpsi0     % FÓRMULA (1) DO FICHEIRO SOBRE ESCO-
%                                       LHA DE PONTOS INICIAIS E DE PASSOS 
%                                       (NEGAÇÃO DA CONDIÇÃO W1 DE WOLFE)
    beta=rho*beta;                  % ALTERAÇÃO DO VALOR DE beta, POR rho,  
%                                     CASO A CONDIÇÃ0 ANTERIOR SE VERIFIQUE 
    n=n+1;                               % AVANÇO DO "ÍNDICE" n DE CONTAGEM
end

lambda=beta;                % ATRIBUIÇÃO DO VALOR DE beta PARA PASSO lambda 