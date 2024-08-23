#==============================================================================#
#             MINICURSO ANÁLISE DE DADOS DE BIODIVERSIDADE NO R                #
#                       Contato: marinagomesdiptera@m.ufrj.br                  #
#                       Script Atualizado em 21/08/2024                        #
#==============================================================================#

#                      AULA 3 - DADOS GEOESPACIAS                              # 

# ---------------------------------------------------------------------------- #

# 1. INSTALANDO PACOTES: -------------------------------------------------------------
install.packages('sf')   # instalando o pacote 'sf'

# 2. CARREGANDO PACOTES: -------------------------------------------------------------
library(sf)                # Carregando o pacote.

# 3. CRIANDO MAPAS -------------------------------------------------------------------
#     3.1 - Mapas com formato shp usando geobr ---------------------------------------

install.packages('geobr')   # instalando o pacote 'geobr'.

library(geobr)                # Carregando o pacote.

#Acessar o github do geobr para ver as funções e dados que podemos baixar
#https://github.com/ipeaGIT/geobr
#Lembrando que os dados geobr estão no formato shp, ou seja, shapefile!!

#Vamos fazer um mapa dos biomas terrestres brasileiros 

# vamos usar a função 'read_country' para baixar a fronteira do BR
BR <- geobr::read_country(year = 2020)   # 2020 é o ano do conjunto de dados. 

plot(BR$geom)   #plot é uma função que permite visualizar a geometria de uma forma básica e rápida

# Com a função read_biomes() podemos baixar os dados dos limites dos biomas.
Biomas <- geobr::read_biomes()

plot(Biomas$geom)

# Como vamos usar apenas os biomas TERRESTRES, é importante filtrar a planilha 
# Repare que o objeto 'Biomas' quando clicamos nada mais é do que uma planilha
# portanto, pode ser manipulada como uma

# Vamos carregar o pacote dplyr, do tidyverse, que já foi instalado
library(dplyr)

# Vamos utilizar a função 'filter' para remover o bioma "Sistemas Costeiros"
Biomas <- Biomas %>%
  filter(name_biome != "Sistema Costeiro")

#Para juntarmos dois objetos num mesmo mapa, o sistema de coordenadas (CRS) precisa
#ser equivalente

sf::st_crs(BR)
sf::st_crs(Biomas)

#Para confirmar se eles são equivalentes, podemos usar uma igualdade simples
st_crs(BR) == st_crs(Biomas)

#Vamos utilizar o proprio ggplot para construir o mapa
library(ggplot2)

mapaBR <- ggplot() +
  geom_sf(data = BR,            # Dados do Brasil.
          color='white')        # Cor das linhas/bordas da camada.

mapaBR

# Plotando o mapa do Brasil com o mapa da Amazônia Legal:
mapaBR.Bioma <- mapaBR +          # Objeto com o mapa do Brasil.
  geom_sf(data = Biomas)          # Dados dos Biomas brasileiros.

mapaBR.Bioma 

#Agora vamos deixar esse mapa mais "visual"
mapaBR.Bioma <- mapaBR +          
  geom_sf(data = Biomas, aes(fill = name_biome),    # Mapeando cores diferentes para cada bioma
          alpha = 0.7) +                            # Acrescentando transparência paras as cores ficarem mais suaves
  scale_fill_viridis_d()                            # Acrescentando uma escala de cor

mapaBR.Bioma 

#Acrescentando título e fonte
mapaBR.Bioma <- mapaBR +          
  geom_sf(data = Biomas, aes(fill = name_biome),    
          alpha = 0.7) +                            
  scale_fill_viridis_d(name = "Biomas") +           # Altera o nome da legenda que estava em inglês
  labs(title = 'Biomas Brasileiros',                # Acrescenta título
       caption = 'DATUM SIRGAS 2000 | Fonte dos dados: GEOBR | Elaborado por [Seu Nome]')+
  theme_light()                                     # Muda o tema para deixar mais visual

mapaBR.Bioma 


# Para adicionar a escala gráfica e a seta norte vamos usar funções do pacote 'ggspatial'.
install.packages('ggspatial')     # instalando o pacote 'ggspatial'.

library(ggspatial)                # Carregando o pacote.

#Acrescentando elementos obrigatórios
mapaBR.Bioma2 <- mapaBR.Bioma +          
  ggspatial::annotation_scale(
    location = 'bl',                           # Localização da escala gráfica.
    bar_cols = c('black','white'),             # Cores das barras.
    height = unit(0.2, "cm"))+                 # Altura da escala gráfica.
  ggspatial::annotation_north_arrow(
    location = 'tr',                           # Localização da seta norte. 
    pad_x = unit(0.30, 'cm'),                  # Distância da borda do eixo x.
    pad_y = unit(0.30, 'cm'),                  # Distância da borda do eixo y.
    height = unit(1.0, 'cm'),                  # Altura  da seta norte.
    width = unit(1.0, 'cm'),                   # Largura da seta norte.
    style = north_arrow_fancy_orienteering(    # Tipo de seta.
      fill = c('grey40', 'white'),             # Cores de preenchimento da seta.
      line_col = 'grey20'))                    # Cor  das linhas da seta.

mapaBR.Bioma2

#Salvando o mapaBR.Bioma2, usamos uma função específica do próprio ggplot2:
ggsave("Mapa_shapefile.png",     # nome do arquivo a ser salvo
       plot = mapaBR.Bioma2,    # nome do objeto que você quer salvar
       width = 10,          # largura em pixels da imagem
       height = 8,         # altura em pixels da imagem
       dpi = 300)          # qualidade da imagem


#     3.2 - Mapas com formato raster ---------------------------------------------

#Vamos importar o raster da nossa pasta

#Para isso, vamos precisar do pacote raster
install.packages('raster')

library(raster)

# Ler o modelo raster
temp <- raster("./Dados/wordclim_10min_bio1.tif")

#O ggplot2 não é tão fácil de usar para trabalhar com raster, então vamos usar o 
#pacote tmap, que opera na mesma lógica, mas funciona melhor para esse tipo de dado

install.packages('tmap')

library(tmap)

# Criar um mapa usando tmap
tmap_mode("plot")  # Definir o modo para "plotar"

mapa_temp <- tm_shape(temp) +
  tm_raster() 

mapa_temp


mapa_temp <- tm_shape(temp) +
  tm_raster(palette = "Oranges") 

mapa_temp

mapa_temp <- tm_shape(temp) +
  tm_raster(palette = "Oranges",
            title = "Temperatura média anual") +
  tm_scale_bar(position = c("left", "bottom"), width = 0.15, color.dark = "black") +
  tm_compass(position = c("right", "top"), size = 2)

mapa_temp

tmap_save(
  tm = mapa_temp, 
  filename = "./temperatua_media.png", 
  width = 3000, 
  height = 2800
)


#     3.3 - Mapa das espécies por bioma com shp ---------------------------------

#Vamos fazer agora o que a maioria das pessoas precisa para um trabalho ou artigo: mapa
#de distribuição de espécies com alguma variável (nesse caso, o bioma)

#         3.3.1 - Obter dados de distribuição ----------------------------------------

# Para obter os dados de distribuição, vamos usar um pacote do gbif para o R, o rgbif

install.packages(rgbif)                  #instalando o pacote

library(rgbif)                           #carregar o pacote

#Agora, vamos usar a função do próprio pacote para obter dados de uma espécie usando o 
#nome dela. Vou usar uma espécie de mosca como exemplo, mas você pode usar um animal que 
#goste e/ou trabalhe e que tenha distribuição conhecida no BR!!

gbif <- occ_data(scientificName = "Oxysarcodexia amorosa")      #puxa os dados do gbif da espécie OXysarcodexia amorosa

#observe como chegam os dados no formato 'lista'
gbif

#agora vamos extrair o dataframe apenas, que eles chamam de 'data'
occs <- gbif$data

#Perceba que o objeto occs é gigante e tem muitas colunas que não vamos usar nessa prática
#vamos selecionar as colunas de nosso interesse e filtrar apenas que tem coordenadas completas

occs <- occs %>%                                                        # o símbolo pipe (%>%) é entendido como "então"
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) %>%  # selecionamos o nome, a latitude e a longitude de acordo com os nomes do gbif para reter apenas essas colunas
  dplyr::filter(!is.na(decimalLatitude))                                # filtramos apenas as linhas que tem a coluna de latitude preenchida

#Apesar de possuir coordenadas, esse objeto é apenas uma planilha, ele não possui
#geometria nem CRS associado

#vamos associar uma geometria de ponto as coordenadas que queremos usar:
occs <- occs %>%
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), 
           remove = FALSE)

#agora vamos associar um CRS a esses pontos (no caso o SIRGAS 2000, que o geobr usa!!)
occs <- st_set_crs(occs, 4674)

#         3.3.2 - Acrescentar os pontos no mapa ----------------------------------------

#Vamos relembrar o objeto que a gente tinha montado com tudo que a gente precisa pra um mapa:
mapaBR.Bioma2

#Agora, vamos acrescentar os nossos pontos nele:
mapaBiooc <- mapaBR.Bioma2 +                            
  geom_sf(data = occs,                          #identificamos os pontos que baixamos
          color = "black",                      #adicionamos cor aos pontos
          size = 2,                             #aumentamos o tamanho dos pontos para eles ficarem visíveis
          shape = 21,                           #escolhemos o formato do ponto
          fill = "black",                       #colocamos o preenchimento como preto
          show.legend = FALSE) 

#Vamos ver como ficou nosso novo mapa
mapaBiooc

#Repare que como essa espécie ocorre em toda a América do Sul, alguns pontos ficaram de fora do shp
#Mas como nosso objetivo aqui é mostrar a distribuição apenas no Brasil, vamos recortar esses pontos

occs_BR <- st_intersection(occs, BR)              #Recorta os pontos com os limites do shp

#Vamos agora corrigir isso mudando o objeto do mapa:
mapaBiooc <- mapaBR.Bioma2 +                            
  geom_sf(data = occs_BR,                       #identificamos os pontos que baixamos
          color = "black",                      #adicionamos cor aos pontos
          size = 2,                             #aumentamos o tamanho dos pontos para eles ficarem visíveis
          shape = 21,                           #escolhemos o formato do ponto
          fill = "black",                       #colocamos o preenchimento como preto
          show.legend = FALSE) 

#Verificando o resultado:
mapaBiooc

#Para salvar, usar o ggsave
ggsave("Oxysarcodexia_biomas.png",     # nome do arquivo a ser salvo
       plot = mapaBiooc,    # nome do objeto que você quer salvar
       width = 10,          # largura em pixels da imagem
       height = 8,         # altura em pixels da imagem
       dpi = 300)          # qualidade da imagem

#     3.4 - Mapa de distribuição de espécies com raster ----------------------------

#Agora vamos repetir o processo, mas com o mapa de temperatura para entender como
#a espécie alvo se distribui de acordo com a temperatura

#Como estamos trabalhando na escala a nível de Brasil, vamos recortar o raster 
extensao_brasil <- extent(-74, -34, -34, 5)                    # a função extent recorta o raster de acordo com as coordenadas

# Cortar na região alvo
temp_BR <- crop(temp, extensao_brasil)

#Vamos refazer o mapa de temperatura, mas agora usando a região recortada
mapa_tempBR <- tm_shape(temp_BR) +
  tm_raster(palette = "Oranges",
            title = "Temperatura média anual") +
  tm_scale_bar(position = c("left", "bottom"), 
               width = 0.15, 
               color.dark = "black") +
  tm_compass(position = c("right", "top"), 
             size = 2)

#Verificando como ficou o mapa:
mapa_tempBR

#Vamos acrescentar os limites do território brasileiro pra ficar mais fácil de visualizar
mapa_tempBR <- mapa_tempBR +
  tm_shape(BR) +
  tm_borders(lwd = 2,
             col = "black")

#Verificando como ficou o mapa:
mapa_tempBR

#Esquecemos de uma etapa importante: O CRS!!!!
st_crs(BR) == st_crs(temp_BR)

#Como estamos trabalhando com a América do Sul, vamos converter o raster de WGS84 para SIRGAS2000
temp_BR <- projectRaster(temp_BR, crs = 4674)

#Vamos testar se deu certo??
st_crs(BR) == st_crs(temp_BR)

#Agora precisamos refazer as etapas anteriores
mapa_tempBR <- tm_shape(temp_BR) +
  tm_raster(palette = "Oranges",
            title = "Temperatura média anual") +
  tm_scale_bar(position = c("left", "bottom"), 
               width = 0.15, 
               color.dark = "black") +
  tm_compass(position = c("right", "top"), 
             size = 2)

mapa_tempBR <- mapa_tempBR +
  tm_shape(BR) +
  tm_borders(lwd = 2,
             col = "black")

#Verificando como ficou o mapa agora:
mapa_tempBR

#Agora sim podemos adicionar a camada dos pontos, que já está em SIRGAS 2000
mapa_tempBR <- mapa_tempBR +
  tm_shape(occs_BR) +
  tm_dots(size = 0.5)

#Vamos ver como ficou
mapa_tempBR

#Agora é só salvar!!
tmap_save(
  tm = mapa_tempBR, 
  filename = "./Oxysarcodexia_temp.png", 
  width = 3000, 
  height = 2800)

# 4. Resumir dados de ocorrências por unidade padronizada -------------------------------

#Minha pergunta agora é: quantas espécies de Tangarás já foram amostradas na Mata Atlântica
#E em quais partes?

#BORA RESPONDER ESSA DOIDERA baseado no livro Análises Ecológicas no R

# 4.1 Baixar dados do GBIF ---------------------------------------------------------------
gbif2 <- occ_data(genusKey = 2487764)      #puxa os dados do gbif do gênero Chiroxiphia

tang <- gbif2$data                           #extrai os dados dos metadados

tang <- tang %>%                                                        
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) %>%  # selecionamos o nome, a latitude e a longitude de acordo com os nomes do gbif para reter apenas essas colunas
  dplyr::filter(!is.na(decimalLatitude))                                # filtramos apenas as linhas que tem a coluna de latitude preenchida

tang <- tang %>%
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),           #associando geometria aos pontos
           remove = FALSE)

tang <- st_set_crs(tang, 4674)                                          #associando um CRS

#4.2 Obtendo os limites da Mata Atlântica -----------------------------------------------------

#nós já baixamos os limites dos biomas no objeto Biomas
plot(Biomas$geom)

#agora vamos criar um novo objeto apenas com a mata atlantica
ma <- Biomas %>% 
  dplyr::filter(name_biome == "Mata Atlântica")

#4.3 Vizualizar nossos dados com o tmap -------------------------------------------------

tm_shape(ma,                                #puxa os dados amazonia
         bbox = tang) +                           #puxa os dados dos pontos
  tm_polygons() +                                 #plota a base da amazonia
  tm_shape(tang) +                                #plota os pontos
  tm_dots(size = .1, col = "forestgreen")         #muda os pontos para serem verdes

#4.4 Retirar os dados que caem fora da Mata Atlântica ------------------------------------

tang_BR <- st_intersection(tang, ma)             #recorta as ocorrência com os limites do shp

#Vamos ver como ficou agora no mapa:
tm_shape(ma,                                
         bbox = tang_BR) +                         
  tm_polygons() +                                 
  tm_shape(tang_BR) +                               
  tm_dots(size = .1, col = "forestgreen")

#4.5 Criar um grid de hexagonos para a Mata Atlântica --------------------------------

#Para resumir os dados por unidade amostral, precisamos criar as unidades amostrais em si
#Nesse caso, usaremos pequenos hexágonos para entender a distribuição dos Tangaras

ma_hex <- sf::st_make_grid(x = ma,                #st_make_grid cria o grid
                           cellsize = 1,
                           square = FALSE) %>% 
                           sf::st_as_sf() %>%     #essa função transforma em geometria (já usamos ela!)                    
  dplyr::mutate(areakm2 = sf::st_area(.)/1e6) %>% #aqui nós vamos dizer a área de cada hexagono
  tibble::rowid_to_column("id_hex")               #por fim, adicionamos um identificador a cada hexagono


#agora, precisamos selecionar os hexágonos que caem na Mata Atlântica
ma_hex <- ma_hex[ma, ]

#Vamos conferir os hexágonos 
tm_shape(ma,                                      #puxa os dados do vetor da mata atlantica
         bbox = ma_hex) +                         #puxa o grid hexagonal
  tm_polygons() +                                 #cria o fundo da mata atlantica
  tm_shape(ma_hex) +                              #seleciona apenas o grid
  tm_borders()                                    #seleciona só a borda do grid

#4.6 Unir as informações das espécies com os hexágonos ----------------------------------

#Para isso usaremos um "join" espacial do pacote sf
ma_hex_sp <- sf::st_join(x = ma_hex,              #x é a planilha que juntará os dados
                         y = tang_BR,             #y é a planilha que será juntada
                         left = TRUE)

#Agora que juntamos as informações espaciais de ocorrência das espécies com os hexágonos,
#nós precisamos resumir elas por cada unidade amostral

ma_hex_oco_riq <- ma_hex_sp %>%
  dplyr::group_by(id_hex) %>% 
  dplyr::summarise(ocorrencias = length(scientificName[!is.na(scientificName)]),
                   riqueza = n_distinct(scientificName, na.rm = TRUE))

#Agora vamos visualizar como ficou isso no resultado final

# Mapa com número de ocorrências
mapa_oco <- tm_shape(ma_hex_oco_riq) +
  tm_polygons(title = "Ocorrência de Chiroxiphia",
              col = "ocorrencias", 
              pal = "viridis",
              style = "pretty") +
  tm_text("ocorrencias", size = .4) +
  tm_graticules(lines = FALSE) +
  tm_compass() +
  tm_scale_bar() +
  tm_layout(legend.title.size = 2,
            legend.title.fontface = "bold",
            legend.position = c("left", "top"))

mapa_oco

# Mapa com riqueza de espécies
mapa_riq <- tm_shape(ma_hex_oco_riq) +
  tm_polygons(title = "Riqueza de Chiroxiphia",
              col = "riqueza", 
              pal = "viridis",
              style = "cat") +
  tm_text("riqueza", size = .4) +
  tm_graticules(lines = FALSE) +
  tm_compass() +
  tm_scale_bar() +
  tm_layout(legend.title.size = 2,
            legend.title.fontface = "bold",
            legend.position = c("left", "top"))

mapa_riq

#Juntar os dois mapas
arranjo <- tmap_arrange(mapa_oco, mapa_riq)

#Verificar o resultado final
arranjo

#Salvar o mapa 
tmap_save(
  tm = arranjo, 
  filename = "./Tangara_riq_oco.png", 
  width = 3000, 
  height = 2800)

#AGORA QUE ESTÃO COM O CÉREBRO FRITO, BORA LANCHAR E ATÉ AMANHÃ!!