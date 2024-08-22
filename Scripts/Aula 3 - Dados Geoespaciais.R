#==============================================================================#
#             MINICURSO ANÁLISE DE DADOS DE BIODIVERSIDADE NO R                #
#                       Contato: marinagomesdiptera@m.ufrj.br                  #
#                       Script Atualizado em 21/08/2024                        #
#==============================================================================#

#                      AULA 3 - DADOS GEOESPACIAS                              # 

# ---------------------------------------------------------------------------- #

# 1. INSTALANDO PACOTES: 
install.packages('sf')   # instalando o pacote 'sf'

# 2. CARREGANDO PACOTES:
library(sf)                # Carregando o pacote.

# 3. CRIANDO MAPAS
#     3.1 - Mapas com formato shp usando geobr

install.packages('geobr')   # instalando o pacote 'geobr'.

library(geobr)                # Carregando o pacote.

#Acessar o github do geobr para ver as funções e dados que podemos baixar
#https://github.com/ipeaGIT/geobr
#Lembrando que os dados geobr estão no formato shp, ou seja, shapefile!!

#Vamos fazer um mapa dos biomas brasileiros

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

#     3.2 - Mapas com formato raster usando 

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
  tm_scale_bar(position = c("left", "bottom"), width = 0.15, color.dark = "gray44")

mapa_temp

tmap_save(
  tm = mapa_temp, 
  filename = "./temperatua_media.png", 
  width = 3000, 
  height = 2800
)


# TÁ DANDO ERRO MEU SENHOR
#Cortar apenas BR

# Extensão geográfica do Brasil
extensao_brasil <- extent(-74, -34, -34, 5)

# Cortar na região alvo
temp_BR <- crop(temp, extensao_brasil)

#Plotar uma espécie no mapa de temp

#usar GBIF
install.packages('rgibf')

library(rgbif)

gbif <- occ_data(scientificName = "Oxysarcodexia amorosa")

occ <- gbif$data

occ <- occ %>%
  dplyr::select(decimalLatitude, decimalLongitude) %>%
  dplyr::filter(!is.na(decimalLatitude))

occ <- as.data.frame(occ)

occ <- st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = 4326, remove = FALSE)

map3 <- map2 +
  tm_shape(species) +
  tm_dots(size = 0.1)