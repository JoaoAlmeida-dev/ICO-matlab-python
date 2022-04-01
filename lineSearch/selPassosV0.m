function lambda=selPassosV0(x,f,dfx,d,beta)

% ALGORITMO 1 PARA ESCOLHA DE PASSOS (DE ACORDO COM LINE SEARCH INEXATA)

% ESTE m.FILE IMPLEMENTA O ALGORITMO 1 PARA ESCOLHA DE PASSOS lambda (VER O
% FICHEIRO SOBRE ESCOLHA DE PONTOS INICIAIS E DE PASSOS).  

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO � function, NESTE CASO
% selPassosV0. O NOME � SEGUIDO DE UM PAR�NTESIS ONDE CONSTAM OS INPUTS,
% QUE NESTE CASO S�O:
% - A ITERADA ATUAL x 
% - A FUN��O OBJETIVO f, ESCRITA COMO FUNCTION-HANDLE f=@(x)
% - O GRADIENTE dfx DE f EM x
% - A DIRE��O DE BUSCA d 
% - O beta DE INICIALIZA��O.

% NENHUM DESTES INPUTS x, f, dfx, d, beta � AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE � SERVIR DE SUPORTE GEN�RICO NA EXECU��O DE OUTROS
% m.FILES; S�O ESTES �LTIMOS QUE V�O "PEDIR" EXPLICITA��O DOS INPUTS x, f, 
% dfx, d E beta (OU J� OS T�M DEFINIDOS COM ESTAS MESMAS DESIGNA�./LETRAS).

% ESTE m.FILE PERMITE AJUSTAR OS PAR�METROS c E rho, O QUE O TORNA MAIS 
% FUNCIONAL.


% PARTE 1: DEFINI�AO DA FUN��O DE PENALIDADE

psi=@(a) f(x+a*d);


% PARTE 2: DEFINI��O DE psi inicial E C�LCULO DA DERIVADA DE psi EM 0

psi0=psi(0);
dpsi0=dfx'*d;


% PARTE 3: ATRIBUI��O DOS VALORES T�PICOS AOS PAR�METROS c E rho

c=1e-4;

rho=0.9;


% PARTE 4: ESTRUTURA CONDICIONAL PARA OBTEN��O DOS PASSOS lambda

fx=f(x);                  % DEFINI��O DAS IMAGENS fx PELA FUN��O OBJETIVO f
n=0;                              % VALOR INICIAL DO "�NDICE" n DE CONTAGEM

while psi(beta)>psi0+c*beta*dpsi0     % F�RMULA (1) DO FICHEIRO SOBRE ESCO-
%                                       LHA DE PONTOS INICIAIS E DE PASSOS 
%                                       (NEGA��O DA CONDI��O W1 DE WOLFE)
    beta=rho*beta;                  % ALTERA��O DO VALOR DE beta, POR rho,  
%                                     CASO A CONDI��0 ANTERIOR SE VERIFIQUE 
    n=n+1;                               % AVAN�O DO "�NDICE" n DE CONTAGEM
end

lambda=beta;                % ATRIBUI��O DO VALOR DE beta PARA PASSO lambda 