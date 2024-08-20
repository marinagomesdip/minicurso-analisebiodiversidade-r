#==============================================================================#
#             MINICURSO ANÁLISE DE DADOS DE BIODIVERSIDADE NO R                #
#                       Contato: marinagomesdiptera@m.ufrj.br                  #
#                       Script Atualizado em 20/08/2024                        #
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
pinguins <- dados::pinguins    # atribuindo a base a um objeto utilizando <-

# 4. ENTENDENDO SEU BANCO DE DADOS
pinguins                     # chamando o objeto para ver suas características

# 5. COMEÇANDO A FAZER PERGUNTAS

#PERGUNTA 1: PINGUINS COM MAIOR MASSA CORPORAL SÃO AQUELES QUE TEM BICO MAIOR?
#Vamos fazer um gráfico:

ggplot(data = pinguins) +         # para chamar a função, tem que especificar o objeto
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico)) # X e Y são os eixos que especificam variáveis

#O gráfico mostra uma relação positiva entre a massa corporal e o comprimento do bico.
#Hipótese inicial é confirmada pelos dados.

#existem vários tipos de "geoms" é como se eles fossem as formas dos gráficos!!

#Para poder salvar o gráfico, nós precisamos transformar ele em um objeto!!
grafico1 <- ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico))

#Salvando o grafico1, usamos uma função específica do próprio ggplot2:
ggsave("Grafico1.png",     # nome do arquivo a ser salvo
       plot = grafico1,    # nome do objeto que você quer salvar
       width = 6,          # largura em pixels da imagem
       height = 4,         # altura em pixels da imagem
       dpi = 300)          # qualidade da imagem


#PERGUNTA 2: A RELAÇÃO MAIOR MASSA CORPORAL COM MAIOR BICO VARIA COM A ESPÉCIE?
#Para responder a essa pergunta, precisamos acrescentar uma terceira variável ao gráfico
#Podemos fazer isso com COR, TRANSPARÊNCIA, TAMANHO ou FORMATO dos pontos.
#Vamos ver os 3 exemplos:

#ADICIONANDO A VARIÁVEL ESPÉCIE COMO COR
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, color = especie))

#ADICIONANDO A VARIÁVEL ESPÉCIE COMO TAMANHO
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, size = especie))

#ADICIONANDO A VARIÁVEL ESPÉCIE COMO TRANSPARÊNCIA
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, alpha = especie))

#ADICIONANDO A VARIÁVEL ESPÉCIE COMO FORMATO
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, shape = especie))

#Agora nós podemos configurar essas mesmas características do gráfico sem adicionar variáveis!!
#Por exemplo, nesse último gráfico, variável com formato, o tamanho de cada simbolo ficou
#muito pequeno!! Vamos aumenta-lo:

ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, shape = especie),  #mantemos o shape como variável no gráfico
             size = 2)       #acrescentamos o argumento "size" fora de "mapping

#Se estiver difícil de ver a diferença entre os formatos:
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, shape = especie,
                           color = especie),  #também é possível usar mais de um "aesthetic" para evidenciar a mesma variável
             size = 2)

#Se quiser mostrar também a sobreposição entre os pontos:
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, shape = especie,
                           color = especie),  #também é possível usar mais de um "aesthetic" para evidenciar a mesma variável
             size = 2,
             alpha = 0.6)  #aqui nós alteramos a transparência geral do gráfico

#LEMBRETE: Se não quisermos acrescentar nada disso como variável, apenas deixar o 
#gráfico bonito, também é possível, desde que seja mantido fora do argumento "mapping"
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico),
             color = "blue",
             size = 2,
             alpha = 0.9)

#ERRO COMUNS:
ggplot(data = pinguins)       
+  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico, size = especie))

#DiCAS para deixar o gráfico mais visual:

#Você pode mudar o "tema" do gráfico:
ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico),
             color = "blue",
             size = 2,
             alpha = 0.9) +
  theme_minimal()    # aqui adicionamos o "tema" depois de adicionar os geoms

ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico),
             color = "blue",
             size = 2,
             alpha = 0.9) +
  theme_dark()

ggplot(data = pinguins) +       
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico),
             color = "blue",
             size = 2,
             alpha = 0.9) +
  theme_bw()



#                           PAUSA PARA PRÁTICA 1                              #



#Vamos agora explorar os tipos de gráficos que podemos produzir com diferentes geoms

#Alguns geoms vão fazer mais sentido para diferentes tipos de variáveis
ggplot(data = pinguins) + 
  geom_point(mapping = aes(x = massa_corporal, y = especie))
#O resumo do ggplot2 é muito bom para ajudar na seleção de qual geom usar

ggplot(data = pinguins) + 
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico))

#utilizando um geom diferente para o mesmo gráfico:
ggplot(data = pinguins) + 
  geom_smooth(mapping = aes(x = massa_corporal, y = comprimento_bico))

#também podemos mexer nas configurações de aesthetics aqui, mas pra cada geom será
#diferente

ggplot(data = pinguins) + 
  geom_smooth(mapping = aes(x = massa_corporal, y = comprimento_bico,
                            linetype = especie),   #aqui podemos ajustar o tipo de linha
              color = "red")                       #cor geral do gráfico

#o mais legal do ggplot2 é que podemos combinar mais de um geom no mesmo gráfico!!
ggplot(data = pinguins) + 
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico)) +
  geom_smooth(mapping = aes(x = massa_corporal, y = comprimento_bico))

#outra sintaxe para o mesmo gráfico (código + limpo)
ggplot(data = pinguins, mapping = aes(x = massa_corporal, y = comprimento_bico)) + 
  geom_point() + 
  geom_smooth()

#podemos ir alterando e configurando o gráfico dependendo do objetivo do trabalho
ggplot(data = pinguins, mapping = aes(x = massa_corporal, y = comprimento_bico)) + 
  geom_point(mapping = aes(color = especie)) + # classificando apenas os pontos por especie
  geom_smooth()

ggplot(data = pinguins, mapping = aes(x = massa_corporal, y = comprimento_bico)) + 
  geom_point(mapping = aes(color = especie)) + 
  geom_smooth(se = FALSE,       # removendo a "sombra" da linha
              color = "black")  # mudando a cor da linha

#podemos inclusive incluir mais de uma variável no gráfico mudando as cores de cada uma
ggplot(data = pinguins) + 
  geom_point(mapping = aes(x = massa_corporal, y = comprimento_bico), color = "black") +
  geom_point(mapping = aes(x = massa_corporal, y = profundidade_bico), color = "red")

#exemplo de gráfico de variável quantitativa x qualitativa
ggplot(data = pinguins, mapping = aes(x = especie, y = massa_corporal)) + 
  geom_boxplot()

ggplot(data = pinguins, mapping = aes(x = ano, y = massa_corporal)) + 
  geom_boxplot()

ggplot(data = pinguins, mapping = aes(x = factor(ano), y = massa_corporal)) + #usando "factor" o x fica discretizado
  geom_boxplot()

#exemplo de gráfico com duas variáveis qualitativas
ggplot(data = pinguins, mapping = aes(x = especie, y = ilha)) + 
  geom_jitter()


#                           PAUSA PARA PRÁTICA 2                              #


#Resposta prática 2:

atmosfera <- dados::dados_atmosfera	

ggplot(data = atmosfera, mapping = aes(x = factor(ano), y = temp_superficie)) + 
  geom_violin() + 
  theme_bw()

#PERGUNTA 3: A massa corporal de pinguins fêmeas varia por espécie?
ggplot(data = pinguins, mapping = aes(x = especie, y = massa_corporal,
                                      color = sexo)) + 
  geom_boxplot()

#Para deixar o gráfico mais limpo nós podemos usar filtrar apenas os pinguins fêmeas
ggplot(data = subset(pinguins, sexo == "fêmea"),   #usando subset para filtrar o objeto original
       mapping = aes(x = especie, y = massa_corporal)) + 
  geom_boxplot()



#                           PAUSA PARA PRÁTICA 3                              #


#Resposta prática 3:
ggplot(data = subset(pinguins, ilha == "Dream" & !is.na(sexo)), #usando duas regras para o subset, conectadas pelo "&"
       mapping = aes(x = especie, y = massa_corporal, color = sexo)) + 
  geom_boxplot()


#PERGUNTA 4: O número de espécimes amostrados foi igual entre os sexos?
ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo))    # o geom_bar produz um histograma, ou seja, é a quantidade de vezes que algo aparece no dataset

#É possível renomear os eixos do histogramas:
ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo)) +
  labs(x = "sexo", y = "número de espécimes")  #usamos o labs para renomear os eixos 

ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo, fill = sexo)) +  #o fill pode ser usado para colorir diferenciando colunas
  labs(x = "sexo", y = "número de espécimes") 

ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo, fill = especie)) +  #mas fill também permite incluir a terceira variável no histograma
  labs(x = "sexo", y = "número de espécimes") 

ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo, fill = especie),
           position = "dodge") +  # esse argumento pode separar as colunas ao invés de agrupar
  labs(x = "sexo", y = "número de espécimes")

ggplot(data = pinguins) + 
  geom_bar(mapping = aes(x = sexo, fill = especie),
           position = "fill") +  # ou também igualar os valores transformando em proporções
  labs(x = "sexo", y = "proporção de espécimes")

#Para a prática 4, vamos precisar de um dataset externo (poderia ser a planilha da sua pesquisa por exemplo)
grilos <- read_csv("./Dados/Grilos_saltos.csv")


#                           PAUSA PARA PRÁTICA 4                              #


#Resposta prática 4:
ggplot(data = dados, mapping = aes(x = tamanho_perna, y = altura_salto)) + 
  geom_point()

ggplot(data = dados, mapping = aes(x = tamanho_perna, y = altura_salto)) + 
  geom_smooth()

ggplot(data = dados, mapping = aes(x = tamanho_perna, y = altura_salto)) + 
  geom_smooth(mapping = aes(color = sexo))

ggplot(data = dados, mapping = aes(x = tamanho_perna, y = altura_salto)) + 
  geom_smooth(mapping = aes(color = especie))

ggplot(data = dados, mapping = aes(x = sexo, y = comprimento_corpo)) + 
  geom_boxplot()

ggplot(data = dados, mapping = aes(x = sexo, y = comprimento_corpo,
                                   color = especie)) + 
  geom_boxplot()
