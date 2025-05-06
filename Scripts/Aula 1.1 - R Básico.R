#==============================================================================#
#             MINICURSO ANÁLISE DE DADOS DE BIODIVERSIDADE NO R                #
#                       Contato: marinagomesdiptera@m.ufrj.br                  #
#                       Script Atualizado em 06/05/2025                        #
#==============================================================================#

#                             AULA 1 - R BÁSICO                                # 

# ---------------------------------------------------------------------------- #

#Como funciona o R?
#Comentários precisam começar a frase com '#'

#                               1. Funções                                     #

#   Funções são chamadas com nome_da_funcao(argumentos)

#Para determinar a raiz quadrada de um número:
sqrt(16)          

#Para determinar a soma de 3 números:
sum(1, 2, 3) 


#                               2. Objetos                                     #

#   R funciona com objetos. Você pode criar objetos com <-

#Atribuindo o número 5 a um objeto
x <- 5

#Atribuindo um número a um objeto
nome <- "Ana"

#Você pode ver o conteúdo de um objeto apenas digitando o nome dele:
x


#                               3. Vetores                                     #

#   Vetores são conjuntos de valores do mesmo tipo

#Atribuindo três números ao vetor V, a função 'c()' serve para "combinar" 
#elementos em um vetor.
v <- c(10, 20, 30)

#                               4. Pacotes                                     #

#   O R funciona através de pacotes (a menos que você saiba se virar com seu código!)

#Instalando um pacote
install.packages("ggplot2")

#Carregando um pacote
library(ggplot2)