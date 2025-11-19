# Dockerfile para Proyecto de Estadística Multivariada
# Basado en Rocker con RStudio Server y TinyTeX

FROM rocker/verse:4.3.2

# Metadatos
LABEL maintainer="tu-email@example.com"
LABEL description="Entorno R containerizado para análisis multivariado"

# Configurar timezone
ENV TZ=America/Mexico_City
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar dependencias del sistema para paquetes R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgit2-dev \
    libgsl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar TinyTeX para generación de PDFs
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
    /root/.TinyTeX/bin/*/tlmgr path add && \
    tlmgr install \
    amsmath \
    amssymb \
    booktabs \
    float \
    geometry \
    hyperref \
    kableExtra \
    multirow \
    wrapfig \
    colortbl \
    xcolor \
    fancyhdr \
    pdflscape \
    tabu \
    threeparttable \
    threeparttablex \
    environ \
    trimspaces \
    ulem

# Crear directorio de trabajo
WORKDIR /home/rstudio/proyecto

# Copiar archivo de dependencias primero (mejor caché de Docker)
COPY install_packages.R /tmp/install_packages.R

# Instalar paquetes R necesarios
RUN Rscript /tmp/install_packages.R

# Copiar archivos del proyecto
COPY --chown=rstudio:rstudio . /home/rstudio/proyecto/

# Configurar RStudio Server
# Usuario: rstudio, Password: se configura en docker-compose.yml
ENV USER=rstudio

# Exponer puerto de RStudio Server
EXPOSE 8787

# Comando por defecto: iniciar RStudio Server
CMD ["/init"]
