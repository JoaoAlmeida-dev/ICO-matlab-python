function graficosLineSearch(Lista,LNit,Lopt) 

% ESTE m.FILE FORNECE O TRATAMENTO GRÁFICO DOS MÉTODOS LINE SEARCH (LS) PA-
% RA FUNÇÕES f DE 2 VARIÁVEIS (NVAR=2). 

% COMO TAL, RECEBE OS SEGUINTES INPUTS (QUE SÃO OS OUTPUTS DESSES MÉTODOS):
% - Lista: ARQUIVO DAS ITERADAS x_k OBTIDAS EM CADA ITERAÇÃO DO MÉTODO LS 
%          USADO E PARA TODOS OS PTOS INICIAIS  
% - LNit: ARQUIVO DO Nº DE ITERAÇÕES USADAS EM CADA PTO INICIAL
% - Lopt: ARQUIVO DOS CANDIDATOS A PTOS ÓPTIMOS (OS ÓPTIMOS LOCAIS) CASO SE
%         PRETENDAM EXPLORAÇÕES MAIS EXIGENTES DESTE m.FILE E RELACIONADOS
%         (AQUI É DISPENSÁVEL)
        
% CONCRETAMENTE ESTE m.FILE FORNECE OS SEGUINTES OUTPUTS:
% - GRÁFICO DAS CURVAS DE NÍVEL DA FUNÇÃO f (NECESSÁRIAS À COMPREENSÃO DOS
%   MÉTODOS LS)
% - SEQUÊNCIAS DOS PTOS GERADOS PELO PROC. ITERATIVO A PARTIR DE CADA PTO
%   INICIAL (UM OU MAIS), REPRESENTADAS SOBRE O GRÁFICO DAS CURVAS DE NÍVEL
%   DE f (VISTO QUE, SE EXISTEM MAIS DO QUE 1 PTO INICIAL, É NECESSÁRIO FA-
%   ZER COMPARAÇÃO DOS VALORES ÓPTIMOS LOCAIS PARA DECIDIR QUAL O VALOR ÓP-
%   TIMO GLOBAL)

% QUALQUER m.FILE DEVE SER GRAVADO COM O NOME DADO À function, NESTE CASO
% graficosLinesearch. O NOME É SEGUIDO DE UM PARÊNTESIS ONDE CONSTAM OS 
% INPUTS, QUE NESTE CASO SÃO Lista, LNit E Lopt.

% NENHUM DESTES INPUTS Lista, LNit, Lopt É AQUI EXPLICITADO, VISTO QUE A
% VANTAGEM DESTE m.FILE É SERVIR DE SUPORTE NA EXECUÇÃO DE OUTROS m.FILES;
% SÃO ESTES ÚLTIMOS QUE VÃO "PEDIR" INDICAÇÃO DE Lista, LNit, Lopt (OU JÁ
% OS TÊM DEFINIDOS COM ESTAS DESIGNAÇÕES).

% BREVE DESCRIÇÃO: PARA CADA PTO INICIAL, O OBJETIVO É REPRESENTAR SOBRE AS
% CURVAS DE NÍVEL O RESPETIVO PROCESSO ITERATIVO A VERMELHO COM O PTO INI- 
% CIAL SINALIZADO COM UMA BOLA VERDE E O PTO RESULTANTE DA ÚLTIMA ITERAÇÃO
% (PTO FINAL= CANDIDATO A PTO ÓPTIMO GLOBAL) SINALIZADO COM UMA CRUZ.

% NOTA: USAMOS O TERMO PTO INICIAL, QUER SE TRATE DE x_0 OU DE UMA ITERADA
%       x_k QUE ESTÁ A TOMAR NESSA PARTE DO PROCESSO O PAPEL DE PTO INICIAL


% ESTE m.FILE É CONSTITUIDO POR UM ÚNICO CICLO (ESTRUTURA CONDICIONAL):

Ninicial=1;        % INICIAR A CONTAGEM DAS ITERAÇÕES A PARTIR DA PRIMEIRA, 
                   % FUNDAMENTAL PARA OBTER O Nº FINAL Nfinal DE ITERAÇÕES

for i=1:length(LNit)  % INDEXAÇÃO POR i DOS PTOS INICIAIS USADOS NO PROCES-
                      % SO ITERATIVO, SENDO O Nº DE PTOS INICIAIS IGUAL AO
                      % COMPRIMENTO length(LNit) DO ARQUIVO LNit
    Nfinal=Ninicial+LNit(i)-1; % CONTAGEM DO Nº FINAL (Nfinal) DE ITERAÇOES
                               % OBTIDAS DO i-ÉSIMO PTO INICIAL. EXEMPLO:
                               % QUANDO Ninicial=1 ENTÃO LNit(1)=3 SIGNIFI-
                               % CA QUE O PTO INICIAL i=1 GEROU UM PROCESSO
                               % ITERATIVO QUE DEMOROU 3 ITERAÇ. ATÉ PARAR 
        Lx=Lista(1,Ninicial:Nfinal);  % OBTENÇÃO DO ARQUIVO Lx DAS ABCISSAS 
                                      % (POSIÇÃO 1) DOS PTOS DA SEQUÊNCIA
                                      % GERADA A PARTIR DO i-ÉSIMO PTO INI-
                                      % CIAL DESDE A SUA 1ª ITERAÇAO ATÉ À
                                      % SUA ÚLTIMA ITERAÇÃO Nfinal
        Ly=Lista(2,Ninicial:Nfinal);  % OBTENÇÃO O ARQUIVO Ly DAS ORDENADAS 
                                      % (POSIÇÃO 2) DOS PTOS DA SEQUÊNCIA
                                      % GERADA A PARTIR DO i-ÉSIMO PTO INI-
                                      % CIAL DESDE A SUA 1ª ITERAÇAO ATÉ À
                                      % SUA ÚLTIMA ITERAÇÃO Nfinal
        hold on     % COMANDO hold on PARA INICIAR QUE OS OUTPUTS SEGUINTES 
                    % SEJAM DADOS NA MESMA FIGURA, OU SEJA, ELES SÃO SUCES-
                    % SIVAMENTE RETIDOS ATÉ hold off; TAMBÉM OS NECESSÁRIOS 
                    % Nfinal, Lx,Ly NÃO SÃO ULTRAPASSADOS POR ESSES OUTPUTS
        plot(Lx,Ly,'ro-')  % REPRESENTA GRAFICAMENTE A VERMELHO, C/ BOLAS E
                           % TRAÇOS, A SEQUÊNCIA GERADA A PARTIR DO i-ÉSIMO
                           % PTO INICIAL, A PARTIR DAS DUAS LISTAS Lx E Ly
        plot(Lista(1,Ninicial),Lista(2,Ninicial),'go',...
            'LineWidth',4,'MarkerSize',20)  % REPRESENTA A VERDE C/ UMA BO-
                                            % LA CADA i-ÉSIMO PTO INICIAL
                                            % DE COORDENADAS DADAS POR
                                            % Lista(1,Ninicial) E Lista(2,N
                                            % inicial); O COMANDO LineWidth
                                            % ESTABELECE A ESPESSURA DA BO-
                                            % LA E O COMANDO MarkSize ESTA-
                                            % BELECE O SEU TAMANHO                                       
        plot(Lista(1,Nfinal),Lista(2,Nfinal),'x',...
            'LineWidth',4, 'MarkerSize',20)  % REPRESENTA POR UMA CRUZ CADA
                                             % i-ÉSIMO PTO ÓPTIMO (OU SEJA,
                                             % O OBTIDO PELA ÚLTIMA ITERA-
                                             % ÇÃO Nfinal) DE COORDENADAS 
                                             % DADAS POR Lista(1,Nfinal) E 
                                             % Lista(2,Ninicial)                                   
    Ninicial=Nfinal+1;             % ATUALIZAÇÃO DO Ninicial PARA INÍCIO DE
                                   % UM NOVO CICLO (PARA OUTRO PTO INICIAL)
end

hold off    % COMANDO hold off PARA TERMINAR A RETENÇÃO DE OUTPUTS (QUE SÃO
            % + DO QUE 1) E PERMITIR QUE TODOS SEJAM DADOS NA MESMA FIGURA