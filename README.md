# 🎓 Proyecto Final - Estadística Aplicada III

Análisis Multivariado del Dataset **Breast Cancer Wisconsin (Diagnostic)** usando R en un entorno containerizado con Docker.

---

## 📋 Tabla de Contenidos

- [Requisitos Previos](#-requisitos-previos)
- [Inicio Rápido](#-inicio-rápido)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Uso del Contenedor](#-uso-del-contenedor)
- [Generar el PDF](#-generar-el-pdf)
- [Trabajo en Equipo](#-trabajo-en-equipo)
- [Troubleshooting](#-troubleshooting)

---

## 🛠️ Requisitos Previos

**Solo necesitas tener instalado Docker en tu máquina. Nada más.**

- **Docker Desktop** (Windows/Mac): [Descargar aquí](https://www.docker.com/products/docker-desktop/)
- **Docker Engine** (Linux): [Instrucciones de instalación](https://docs.docker.com/engine/install/)

Para verificar que Docker está instalado:

```bash
docker --version
docker-compose --version
```

---

## 🚀 Inicio Rápido

### 1. Clonar el Repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd classTumor
```

### 2. Construir el Contenedor

```bash
docker-compose build
```

⏱️ **Nota:** La primera construcción tardará ~10-15 minutos porque descarga R, RStudio, LaTeX y todos los paquetes necesarios. Las siguientes veces será mucho más rápido gracias al caché.

### 3. Iniciar el Contenedor

```bash
docker-compose up -d
```

### 4. Acceder a RStudio Server

Abre tu navegador en:

```
http://localhost:8787
```

**Credenciales:**
- **Usuario:** `rstudio`
- **Contraseña:** `estadistica123` (configurable en `docker-compose.yml`)

---

## 📁 Estructura del Proyecto

```
classTumor/
├── data/
│   ├── wdbc.data           # Dataset de cáncer de mama
│   └── wdbc.names          # Documentación del dataset
├── proyecto_final_estadistica.Rmd  # Documento principal R Markdown
├── Dockerfile              # Definición del contenedor
├── docker-compose.yml      # Configuración de servicios
├── install_packages.R      # Script de instalación de paquetes
├── .dockerignore          # Archivos excluidos del build
├── .gitignore             # Archivos excluidos de Git
└── README.md              # Este archivo
```

---

## 💻 Uso del Contenedor

### Iniciar el Contenedor

```bash
docker-compose up -d
```

El flag `-d` lo ejecuta en modo "detached" (background).

### Ver Logs

```bash
docker-compose logs -f
```

### Detener el Contenedor

```bash
docker-compose down
```

### Reiniciar (después de cambios en código)

```bash
docker-compose restart
```

### Reconstruir (después de cambios en Dockerfile o dependencias)

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 📄 Generar el PDF

Hay **dos formas** de renderizar el documento R Markdown a PDF:

### Opción 1: Desde RStudio Server (Recomendado)

1. Abre `http://localhost:8787` en tu navegador
2. Navega al archivo `proyecto_final_estadistica.Rmd` en el panel de archivos
3. Haz clic en el botón **"Knit"** (o presiona `Ctrl+Shift+K`)
4. El PDF se generará automáticamente en el mismo directorio

### Opción 2: Desde la Terminal (Línea de Comandos)

```bash
docker-compose exec rstudio Rscript -e "rmarkdown::render('/home/rstudio/proyecto/proyecto_final_estadistica.Rmd')"
```

El PDF generado estará disponible en tu directorio local (montado como volumen).

---

## 👥 Trabajo en Equipo

### Flujo de Trabajo Recomendado

1. **Clona el repositorio**
   ```bash
   git clone <URL_DEL_REPO>
   cd classTumor
   ```

2. **Construye el contenedor**
   ```bash
   docker-compose build
   docker-compose up -d
   ```

3. **Trabaja en RStudio**
   - Abre `http://localhost:8787`
   - Edita el código
   - Los cambios se guardan automáticamente en tu directorio local (gracias al volumen montado)

4. **Haz commit de tus cambios**
   ```bash
   git add proyecto_final_estadistica.Rmd
   git commit -m "Agregué análisis de XYZ"
   git push
   ```

5. **Tus compañeros hacen pull**
   ```bash
   git pull
   # Los cambios se reflejan automáticamente en el contenedor
   ```

### ⚠️ Importante para Colaboración

- **NO subas archivos generados** (`.pdf`, `.html`) al repositorio. Estos están en `.gitignore`.
- **NO subas el `.dockerignore`** al repositorio (está ignorado).
- **SÍ sube** el código fuente (`.Rmd`), datos (`data/`), y configuración Docker (`Dockerfile`, `docker-compose.yml`).

---

## 🔧 Troubleshooting

### Problema: "Puerto 8787 ya está en uso"

**Solución:** Cambia el puerto en `docker-compose.yml`:

```yaml
ports:
  - "8888:8787"  # Usa http://localhost:8888 en lugar de 8787
```

### Problema: "No se puede renderizar el PDF - LaTeX error"

**Solución:** Reconstruye el contenedor para asegurar que TinyTeX está instalado:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Problema: "Paquete X no encontrado"

**Solución 1 (temporal):** Instala manualmente en RStudio:

```r
install.packages("nombre_paquete")
```

**Solución 2 (permanente):** Agrega el paquete a `install_packages.R` y reconstruye:

```r
packages <- c(
  ...,
  "nuevo_paquete"  # Agregar aquí
)
```

Luego:

```bash
docker-compose build
docker-compose up -d
```

### Problema: "Los cambios no se reflejan en el contenedor"

**Solución:** Verifica que el volumen esté montado correctamente:

```bash
docker-compose down
docker-compose up -d
```

Si persiste, revisa `docker-compose.yml` para asegurar que la sección `volumes` esté correcta:

```yaml
volumes:
  - ./:/home/rstudio/proyecto
```

### Problema: "El contenedor se detiene inmediatamente"

**Solución:** Revisa los logs para ver el error:

```bash
docker-compose logs
```

---

## 📊 Análisis Incluidos en el Proyecto

El documento R Markdown contiene:

### ✅ Análisis No Supervisados
- **PCA Manual** (implementación con álgebra matricial)
- **Factor Analysis** (rotación Varimax)
- **Canonical Correlation Analysis** (CCA)

### ✅ Modelos Supervisados
- **LDA Manual** (implementación desde cero)
- **Regresión Logística**
- **Random Forest**

### ✅ Validación de Supuestos
- Test de Mardia (normalidad multivariada)
- Test de Royston

### ✅ Visualizaciones
- Scree Plots
- Biplots
- Distribuciones de proyecciones LDA
- Importancia de variables (Random Forest)
- Comparación de modelos

---

## 🎯 Ventajas de Este Setup

✅ **Cero configuración local** - Solo Docker
✅ **Reproducibilidad total** - Mismo entorno para todo el equipo
✅ **Aislamiento** - No contamina tu sistema con paquetes
✅ **Portabilidad** - Funciona en Windows, Mac, Linux
✅ **Versionado completo** - Dockerfile documenta todas las dependencias
✅ **Fácil debugging** - Logs accesibles con `docker-compose logs`

---

## 🧑‍🏫 Información del Dataset

**Nombre:** Wisconsin Diagnostic Breast Cancer (WDBC)
**Fuente:** UCI Machine Learning Repository
**Observaciones:** 569
**Variables:** 30 (+ 1 ID + 1 Diagnosis)
**Clases:** Maligno (M) / Benigno (B)

---

## 📝 Notas Adicionales

- **Memoria RAM recomendada:** 4GB+ para el contenedor
- **Espacio en disco:** ~5GB para imagen Docker + dependencias
- **Tiempo de build inicial:** 10-15 minutos
- **Tiempo de renders posteriores:** 2-5 minutos

---

## 🤝 Contribuciones

Para contribuir al proyecto:

1. Crea un branch: `git checkout -b feature/nueva-funcionalidad`
2. Haz tus cambios
3. Commit: `git commit -m "Descripción del cambio"`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

---

## 📧 Contacto

**Curso:** Estadística Aplicada III
**Institución:** ITAM
**Profesor:** [Nombre del Profesor]

Para preguntas técnicas sobre Docker, consulta la [documentación oficial](https://docs.docker.com/).

---

**🎓 ¡Buena suerte con tu proyecto final!**
