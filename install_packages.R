# Script de instalación de paquetes R
# Este script se ejecuta durante el build del contenedor Docker

cat("📦 Instalando paquetes R necesarios...\n\n")

# Configurar repositorio CRAN
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Lista de paquetes requeridos
packages <- c(
  # Análisis multivariado
  "tidyverse",     # Manipulación y visualización de datos
  "MVN",           # Tests de normalidad multivariada
  "psych",         # Factor Analysis
  "CCA",           # Canonical Correlation Analysis
  "MASS",          # LDA

  # Machine Learning
  "caret",         # Partición de datos y métricas
  "randomForest",  # Random Forest

  # Presentación
  "knitr",         # Generación de reportes
  "kableExtra",    # Tablas elegantes
  "rmarkdown"      # R Markdown
)

# Función para instalar paquetes faltantes
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste0("→ Instalando ", pkg, "...\n"))
    install.packages(pkg, dependencies = TRUE, quiet = FALSE)
  } else {
    cat(paste0("✓ ", pkg, " ya instalado\n"))
  }
}

# Instalar todos los paquetes
invisible(lapply(packages, install_if_missing))

cat("\n✅ Todos los paquetes instalados correctamente!\n")

# Verificar instalación
cat("\n🔍 Verificando instalación...\n")
all_installed <- all(sapply(packages, require, character.only = TRUE, quietly = TRUE))

if (all_installed) {
  cat("✅ VERIFICACIÓN EXITOSA: Todos los paquetes cargaron correctamente\n")
} else {
  cat("❌ ERROR: Algunos paquetes no se pudieron cargar\n")
  quit(status = 1)
}
