#==============================================================================#
#             MINICURSO ANÁLISE DE DADOS DE BIODIVERSIDADE NO R                #
#                       Contato: marinagomesdiptera@m.ufrj.br                  #
#                       Script Atualizado em 17/08/2024                        #
#==============================================================================#

#                             AULA 2 - GRÁFICOS                                # 

# ---------------------------------------------------------------------------- #

# 1. INSTALANDO PACOTES:
install.packages('tidyverse')   # instalando o pacote 'tidyverse'

# 2. CARREGANDO PACOTES:
library(tidyverse)                # Carregando o pacote.

# 3. IMPORTANDO DADOS
#nessa etapa, você pode usar bancos de dados já disponíveis no R

#instalar o pacote que fornece bases de dados gratuitas no R
install.packages('dados')   # instalando o pacote 'dados'

#transformar a base em um objeto para podermos trabalhar com ela
pinguins <- dados::pinguins

#ou importar sua própria planilha


# 4. ENTENDENDO SEU BANCO DE DADOS
pinguins


# 5. COMEÇANDO A FAZER PERGUNTAS
ggplot(data = pinguins) + 
  geom_point(mapping = aes(x = comprimento_bico, y = massa_corporal))
