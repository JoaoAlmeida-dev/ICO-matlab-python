function graficosLineSearch(Lista,LNit,Lopt) 

% ESTE m.FILE FORNECE O TRATAMENTO GR�FICO DOS M�TODOS LINE SEARCH (LS) PA-
% RA FUN��ES f DE 2 VARI�VEIS (NVAR=2). 

% COMO TAL, RECEBE OS SEGUINTES INPUTS (QUE S�O OS OUTPUTS DESSES M�TODOS):
% - Lista: ARQUIVO DAS ITERADAS x_k OBTIDAS EM CADA ITERA��O DO M�TODO LS 
%          USADO E PARA TODOS OS PTOS INICIAIS  
% - LNit: ARQUIVO DO N� DE ITERA��ES USADAS EM CADA PTO INICIAL
% - Lopt: ARQUIVO DOS CANDIDATOS A PTOS �PTIMOS (OS �PTIMOS LOCAIS) CASO SE
%         PRETENDAM EXPLORA��ES MAIS EXIGENTES DESTE m.FILE E RELACIONADOS
%         (AQUI � DISPENS�VEL)
        
% CONCRETAMENTE ESTE m.FILE FORNECE OS SEGUINTES OUTPUTS:
% - GR�FICO DAS CURVAS DE N�VEL DA FUN��O f (NECESS�RIAS � COMPREENS�O DOS
%   M�TODOS LS)
% - SEQU�NCIAS DOS PTOS GERADOS PELO PROC. ITERATIVO A PARTIR DE CADA PTO
%   INICIAL (UM OU MAIS), REPRESENTADAS SOBRE O GR�FICO DAS CURVAS DE N�VEL
%   DE f (VISTO QUE, SE EXISTEM MAIS DO QUE 1 PTO INICIAL, � NECESS�RIO FA-
%   ZER COMPARA��O DOS VALORES �PTIMOS LOCAIS PARA DECIDIR QUAL O VALOR �P-
%   TIMO GLOBAL)

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO � function, NESTE CASO
% graficosLinesearch. O NOME � SEGUIDO DE UM PAR�NTESIS ONDE CONSTAM OS 
% INPUTS, QUE NESTE CASO S�O Lista, LNit E Lopt.

% NENHUM DESTES INPUTS Lista, LNit, Lopt � AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE � SERVIR DE SUPORTE NA EXECU��O DE OUTROS m.FILES;
% S�O ESTES �LTIMOS QUE V�O "PEDIR" INDICA��O DE Lista, LNit, Lopt (OU J�
% OS T�M DEFINIDOS COM ESTAS DESIGNA��ES).

% BREVE DESCRI��O: PARA CADA PTO INICIAL, O OBJETIVO � REPRESENTAR SOBRE AS
% CURVAS DE N�VEL O RESPETIVO PROCESSO ITERATIVO A VERMELHO COM O PTO INI- 
% CIAL SINALIZADO COM UMA BOLA VERDE E O PTO RESULTANTE DA �LTIMA ITERA��O
% (PTO FINAL= CANDIDATO A PTO �PTIMO GLOBAL) SINALIZADO COM UMA CRUZ.

% NOTA: USAMOS O TERMO PTO INICIAL, QUER SE TRATE DE x_0 OU DE UMA ITERADA
%       x_k QUE EST� A TOMAR NESSA PARTE DO PROCESSO O PAPEL DE PTO INICIAL


% ESTE m.FILE � CONSTITUIDO POR UM �NICO CICLO (ESTRUTURA CONDICIONAL):

Ninicial=1;        % INICIAR A CONTAGEM DAS ITERA��ES A PARTIR DA PRIMEIRA, 
                   % FUNDAMENTAL PARA OBTER O N� FINAL Nfinal DE ITERA��ES

for i=1:length(LNit)  % INDEXA��O POR i DOS PTOS INICIAIS USADOS NO PROCES-
                      % SO ITERATIVO, SENDO O N� DE PTOS INICIAIS IGUAL AO
                      % COMPRIMENTO length(LNit) DO ARQUIVO LNit
    Nfinal=Ninicial+LNit(i)-1; % CONTAGEM DO N� FINAL (Nfinal) DE ITERA�OES
                               % OBTIDAS DO i-�SIMO PTO INICIAL. EXEMPLO:
                               % QUANDO Ninicial=1 ENT�O LNit(1)=3 SIGNIFI-
                               % CA QUE O PTO INICIAL i=1 GEROU UM PROCESSO
                               % ITERATIVO QUE DEMOROU 3 ITERA�. AT� PARAR 
        Lx=Lista(1,Ninicial:Nfinal);  % OBTEN��O DO ARQUIVO Lx DAS ABCISSAS 
                                      % (POSI��O 1) DOS PTOS DA SEQU�NCIA
                                      % GERADA A PARTIR DO i-�SIMO PTO INI-
                                      % CIAL DESDE A SUA 1� ITERA�AO AT� �
                                      % SUA �LTIMA ITERA��O Nfinal
        Ly=Lista(2,Ninicial:Nfinal);  % OBTEN��O O ARQUIVO Ly DAS ORDENADAS 
                                      % (POSI��O 2) DOS PTOS DA SEQU�NCIA
                                      % GERADA A PARTIR DO i-�SIMO PTO INI-
                                      % CIAL DESDE A SUA 1� ITERA�AO AT� �
                                      % SUA �LTIMA ITERA��O Nfinal
        hold on     % COMANDO hold on PARA INICIAR QUE OS OUTPUTS SEGUINTES 
                    % SEJAM DADOS NA MESMA FIGURA, OU SEJA, ELES S�O SUCES-
                    % SIVAMENTE RETIDOS AT� hold off; TAMB�M OS NECESS�RIOS 
                    % Nfinal, Lx,Ly N�O S�O ULTRAPASSADOS POR ESSES OUTPUTS
        plot(Lx,Ly,'ro-')  % REPRESENTA GRAFICAMENTE A VERMELHO, C/ BOLAS E
                           % TRA�OS, A SEQU�NCIA GERADA A PARTIR DO i-�SIMO
                           % PTO INICIAL, A PARTIR DAS DUAS LISTAS Lx E Ly
        plot(Lista(1,Ninicial),Lista(2,Ninicial),'go',...
            'LineWidth',4,'MarkerSize',20)  % REPRESENTA A VERDE C/ UMA BO-
                                            % LA CADA i-�SIMO PTO INICIAL
                                            % DE COORDENADAS DADAS POR
                                            % Lista(1,Ninicial) E Lista(2,N
                                            % inicial); O COMANDO LineWidth
                                            % ESTABELECE A ESPESSURA DA BO-
                                            % LA E O COMANDO MarkSize ESTA-
                                            % BELECE O SEU TAMANHO                                       
        plot(Lista(1,Nfinal),Lista(2,Nfinal),'x',...
            'LineWidth',4, 'MarkerSize',20)  % REPRESENTA POR UMA CRUZ CADA
                                             % i-�SIMO PTO �PTIMO (OU SEJA,
                                             % O OBTIDO PELA �LTIMA ITERA-
                                             % ��O Nfinal) DE COORDENADAS 
                                             % DADAS POR Lista(1,Nfinal) E 
                                             % Lista(2,Ninicial)                                   
    Ninicial=Nfinal+1;             % ATUALIZA��O DO Ninicial PARA IN�CIO DE
                                   % UM NOVO CICLO (PARA OUTRO PTO INICIAL)
end

hold off    % COMANDO hold off PARA TERMINAR A RETEN��O DE OUTPUTS (QUE S�O
            % + DO QUE 1) E PERMITIR QUE TODOS SEJAM DADOS NA MESMA FIGURA