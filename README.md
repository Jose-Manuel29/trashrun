# Manual de Configuración del Ambiente de Desarrollo - Kahot Trash Run

Bienvenido al proyecto **Kahot Trash Run**. Este documento te guiará paso a paso para configurar tu ambiente de desarrollo, independientemente de tu experiencia previa.

## Tabla de Contenidos

1. [¿Qué es este proyecto?](#qué-es-este-proyecto)
2. [Requisitos del Sistema](#requisitos-del-sistema)
3. [Instalación Paso a Paso](#instalación-paso-a-paso)
4. [Estructura del Proyecto](#estructura-del-proyecto)
5. [Cómo Ejecutar el Proyecto](#cómo-ejecutar-el-proyecto)
6. [Ejecutar Pruebas](#ejecutar-pruebas)
7. [Flujo de Trabajo con Git](#flujo-de-trabajo-con-git)
8. [Resolución de Problemas](#resolución-de-problemas)
9. [Convenciones de Código](#convenciones-de-código)

---

## ¿Qué es este proyecto?

**Kahot Trash Run** es un juego educativo desarrollado en **Godot Engine 4.5**. Es un juego de preguntas para dos jugadores donde:

- Los jugadores responden preguntas de diferentes categorías
- Tienen un tiempo límite para responder (10 segundos por defecto)
- Se registra un ranking de mejores puntajes
- Incluye un sistema de pruebas automatizadas con gdUnit4

**Tecnologías principales:**
- 🎮 **Godot Engine 4.5** - Motor de juego
- 📝 **GDScript** - Lenguaje de programación
- ✅ **gdUnit4** - Framework de testing
- 📊 **JSON** - Formato para almacenar preguntas y ranking

---

## Requisitos del Sistema

### Mínimos

| Recurso | Requisito |
|---------|-----------|
| **OS** | Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+) |
| **RAM** | 4 GB mínimo (8 GB recomendado) |
| **Almacenamiento** | 5 GB libres |
| **Procesador** | Dual Core 2 GHz o superior |
| **Internet** | Necesario para clonar el repositorio e instalar Godot |

### Software Requerido

- **Godot Engine 4.5** (gratuito y de código abierto)
- **Git** (para control de versiones)

---

## Instalación Paso a Paso

### Paso 1: Descargar e Instalar Godot Engine 4.5

#### En Windows

1. Ve a [https://godotengine.org/download](https://godotengine.org/download)
2. Descarga **Godot Engine 4.5** (versión estándar)
3. Descomprime el archivo en una carpeta (ej: `C:\Godot`)
4. ¡Listo! No requiere instalación adicional

#### En macOS

1. Ve a [https://godotengine.org/download](https://godotengine.org/download)
2. Descarga **Godot Engine 4.5**
3. Mueve el archivo `Godot.app` a la carpeta `Aplicaciones`
4. Abre desde Launchpad o Spotlight

#### En Linux

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install godot4

# O descargarlo manualmente desde https://godotengine.org/download
```

### Paso 2: Instalar Git

#### En Windows

1. Descarga desde [https://git-scm.com](https://git-scm.com)
2. Ejecuta el instalador y acepta todas las opciones por defecto
3. Reinicia la terminal/PowerShell después de instalar

#### En macOS

```bash
# Usando Homebrew (recomendado)
brew install git

# O descarga desde https://git-scm.com
```

#### En Linux

```bash
sudo apt-get update
sudo apt-get install git
```

### Paso 3: Clonar el Repositorio

Abre una terminal o PowerShell y ejecuta:

```bash
# Navega a donde quieras guardar el proyecto
cd C:\Users\TuUsuario\Documentos

# Clona el repositorio
git clone https://github.com/tu-usuario/trashrun.git

# Entra en la carpeta del proyecto
cd trashrun
```

**Nota:** Si el repositorio es privado, necesitarás configurar autenticación SSH o HTTPS en GitHub.

### Paso 4: Abrir el Proyecto en Godot

1. Abre **Godot Engine 4.5**
2. Haz clic en **"Abrir"** en el gestor de proyectos
3. Navega a la carpeta donde clonaste el proyecto (`trashrun`)
4. Selecciona el archivo `project.godot`
5. Godot cargará automáticamente el proyecto

**Primera carga:** Puede tardar 1-2 minutos mientras Godot importa recursos y scripts.

### Paso 5: Verificar la Instalación

Una vez abierto el proyecto:

1. En la pestaña **"Scene"** (izquierda), verás la jerarquía del proyecto
2. Busca la escena principal en `res://scenes/`
3. Haz doble clic para abrirla
4. Presiona **F5** o **Play** (▶) para ejecutar el juego

Si ves la pantalla de inicio del juego, ¡la instalación fue exitosa!

---

## Estructura del Proyecto

```
trashrun/
├── scenes/                  # Archivos de escenas (archivos .tscn)
│   ├── ui/                 # Interfaz gráfica
│   │   ├── start_screen.tscn
│   │   ├── question_screen.tscn
│   │   ├── ranking_screen.tscn
│   │   └── ...
│   └── ...
│
├── scripts/                # Código GDScript
│   ├── core/              # Lógica principal del juego
│   │   └── game_manager.gd  # Gestiona estado del juego
│   ├── ui/                # Scripts de interfaz
│   │   ├── start_screen.gd
│   │   ├── question_screen.gd
│   │   └── ...
│   └── data/              # Gestión de datos
│       ├── question_loader.gd    # Carga preguntas desde JSON
│       └── ranking_manager.gd    # Gestiona ranking
│
├── data/                  # Datos en JSON
│   ├── questions.json     # Preguntas del juego
│   └── ranking.json       # Ranking de jugadores
│
├── assets/                # Recursos gráficos y sonoros
│   ├── images/
│   ├── fonts/
│   └── sounds/
│
├── addons/                # Extensiones (gdUnit4)
│   └── gdUnit4/           # Framework de testing
│
├── test/                  # Pruebas automatizadas
│   └── scenes/
│       └── *_test.gd      # Archivos de test
│
├── project.godot          # Configuración principal del proyecto
├── icon.svg               # Icono del aplicación
└── README.md              # Este archivo
```

### Descripción de Carpetas Clave

| Carpeta | Propósito |
|---------|-----------|
| `scripts/core/` | Lógica central (gestor de juego, puntuación) |
| `scripts/ui/` | Código de pantallas y botones |
| `scripts/data/` | Lectura/escritura de datos (preguntas, ranking) |
| `data/` | Archivos JSON con contenido del juego |
| `scenes/ui/` | Archivos visuales de pantallas |
| `test/` | Pruebas unitarias automáticas |
| `addons/gdUnit4/` | Framework para escribir y ejecutar tests |

---

## Cómo Ejecutar el Proyecto

### Ejecutar desde Godot (Desarrollo)

**Opción 1: Botón Play**
1. Con el proyecto abierto en Godot
2. Haz clic en el botón **Play** (▶) en la esquina superior derecha
3. O presiona **F5**

**Opción 2: Ejecutar Escena Actual**
- Si tienes una escena abierta, presiona **F6** para ejecutar solo esa escena

### Ejecutar desde Línea de Comandos

```bash
# Navega a la carpeta del proyecto
cd C:\Users\TuUsuario\Documentos\trashrun

# Ejecuta el juego (requiere que Godot esté en PATH)
godot
```

### Compilar Versión de Exportación

Para crear una versión ejecutable (.exe en Windows, .app en macOS, etc.):

1. En Godot, ve a **"Project"** → **"Export..."**
2. Selecciona tu plataforma (Windows, macOS, Linux)
3. Configura opciones si es necesario
4. Haz clic en **"Export Project"**
5. Elige dónde guardar el archivo ejecutable

---

## Ejecutar Pruebas

El proyecto usa **gdUnit4** para pruebas automatizadas. Estas verifican que el código funcione correctamente.

### Ejecutar Todos los Tests

1. En Godot, abre la pestaña **"GdUnit"** (parte inferior)
2. Haz clic en **"Run All Tests"** (botón de play)
3. Espera a que terminen

**Desde terminal:**
```bash
godot --headless --script addons/gdUnit4/src/cli/GdUnitCli.gd -- -add res://test/
```

### Ejecutar un Test Específico

1. Navega a `res://test/scenes/`
2. Abre el archivo `*_test.gd` que quieras probar
3. Presiona **F6** para ejecutar solo esa prueba

### Ver Resultados

Después de ejecutar:
- **Verde** ✅ = Test pasó exitosamente
- **Rojo** ❌ = Test falló (hay un problema)
- **Amarillo** ⚠️ = Test pendiente o error de sintaxis

---

## Flujo de Trabajo con Git

Si es la primera vez usando Git, aquí está lo básico:

### Verificar Estado del Proyecto

```bash
git status
```

Muestra qué archivos fueron modificados.

### Crear una Rama para tu Trabajo

```bash
# Crear y cambiar a una nueva rama
git checkout -b mi-nueva-funcionalidad

# O si tienes Git 2.23+
git switch -c mi-nueva-funcionalidad
```

**Ejemplo:**
```bash
git checkout -b fix/pantalla-ranking
```

### Guardar Cambios (Commit)

```bash
# Ver cambios antes de guardar
git diff

# Agregar archivos a preparar
git add scripts/mi_archivo.gd

# O agregar todos
git add .

# Guardar con mensaje descriptivo
git commit -m "Descripción clara de qué cambió"
```

**Ejemplo buen mensaje:**
```bash
git commit -m "Fix: Corregir cálculo de puntuación en pregunta_screen"
```

**Ejemplo malo:**
```bash
git commit -m "cambios"  # ❌ No es descriptivo
```

### Enviar Cambios al Repositorio

```bash
git push origin mi-nueva-funcionalidad
```

### Crear un Pull Request (PR)

1. Ve a GitHub
2. Verás un botón **"Compare & pull request"**
3. Rellena descripción de qué cambiaste
4. Envía el PR

### Actualizar tu Rama Local

```bash
# Obtener cambios del repositorio remoto
git fetch origin

# Traer cambios a tu rama actual
git pull origin main
```

---

## Resolución de Problemas

### Problema 1: "Godot no abre el proyecto"

**Síntomas:** Error al abrir o proyecto no carga

**Soluciones:**

1. Verifica que tienes **Godot 4.5** exactamente
   ```bash
   godot --version
   ```

2. Elimina la carpeta `.godot/` y deja que Godot la recree
   ```bash
   rm -r .godot  # Linux/macOS
   rmdir /s .godot  # Windows (PowerShell)
   ```

3. Reinicia Godot completamente

4. Si sigue fallando, intenta:
   - Descargar Godot nuevamente
   - Usar una versión portable en lugar de instalada

### Problema 2: "Los tests no se ejecutan"

**Síntomas:** gdUnit4 no aparece en Godot

**Soluciones:**

1. Verifica que gdUnit4 esté habilitado:
   - Ve a **"Project"** → **"Project Settings"** → **"Plugins"**
   - Busca **"gdUnit4"** y marca como **"Enabled"**

2. Reinicia Godot

3. Si aún no aparece:
   ```bash
   # Desde la carpeta del proyecto
   git pull  # Actualiza para obtener la carpeta addons/
   ```

### Problema 3: "Git no reconoce cambios"

**Síntomas:** `git status` no muestra archivos modificados

**Soluciones:**

1. Verifica que estés en la carpeta correcta:
   ```bash
   pwd  # Linux/macOS
   cd   # Windows (PowerShell)
   ```

2. Asegúrate de estar en la rama correcta:
   ```bash
   git branch  # Muestra ramas locales
   git branch -a  # Muestra todas (incluidas remotas)
   ```

3. Actualiza Git:
   ```bash
   git status --short  # Vista simplificada
   ```

### Problema 4: "No puedo clonar el repositorio"

**Síntomas:** `fatal: could not read Username`

**Soluciones:**

1. **Si usas HTTPS:**
   ```bash
   # Godot pedirá usuario/contraseña
   git clone https://github.com/usuario/trashrun.git
   ```

2. **Si usas SSH (recomendado):**
   ```bash
   # Primero, configura SSH en GitHub
   ssh-keygen -t rsa -b 4096
   # Sigue las instrucciones en https://docs.github.com/en/authentication/connecting-to-github-with-ssh
   
   git clone git@github.com:usuario/trashrun.git
   ```

3. **Verificar conectividad:**
   ```bash
   ssh -T git@github.com  # Para SSH
   # o
   git credential-osxkeychain get  # macOS
   ```

### Problema 5: "Los scripts .gd tienen errores de sintaxis"

**Síntomas:** Líneas rojas en el editor, juego no corre

**Soluciones:**

1. Verifica la sintaxis abriendo el archivo en Godot
2. Lee el mensaje de error en la pestaña **"Output"** (abajo)
3. Compara con ejemplos en `scripts/ui/start_screen.gd`
4. Si no lo resuelves, busca la línea exacta del error

### Problema 6: "Preguntas no cargan (archivo questions.json vacío)"

**Síntomas:** Juego abre pero sin preguntas

**Soluciones:**

1. Verifica que el archivo exista:
   ```bash
   ls data/questions.json  # Linux/macOS
   dir data\questions.json  # Windows (cmd)
   ```

2. Si no existe, crea uno básico:
   ```json
   [
     {
       "categoria": "Matemáticas",
       "pregunta": "¿2 + 2?",
       "respuestas": ["3", "4", "5"],
       "respuesta_correcta": 1
     }
   ]
   ```

3. Verifica que el formato JSON sea válido (sin comas extras, comillas cerradas)

### Problema 7: "El ranking no guarda datos"

**Síntomas:** Cierras el juego y el ranking desaparece

**Soluciones:**

1. Verifica que tengas permisos de escritura en la carpeta `data/`

2. Revisa la carpeta de usuario:
   - Windows: `C:\Users\TuUsuario\AppData\Roaming/Godot/`
   - macOS: `~/Library/Application Support/Godot/`
   - Linux: `~/.godot/`

3. Si el archivo está corrupto, elimínalo y reinicia el juego:
   ```bash
   rm data/ranking.json  # Se recreará automáticamente
   ```

### Problema 8: "Godot está muy lento"

**Síntomas:** El editor se congela, hay lag en el juego

**Soluciones:**

1. Cierra otras aplicaciones para liberar RAM

2. En Godot, ve a **"Project"** → **"Project Settings"** → **"Rendering"**
   - Reduce `textures/vram_compression/mode` a VRAM-Compressed

3. Reinicia Godot y carga el proyecto nuevamente

4. Si persiste, verifica recursos gráficos muy pesados en `assets/`

### Problema 9: "Botones o texto no aparecen en pantalla"

**Síntomas:** Pantalla blanca o vacía al ejecutar

**Soluciones:**

1. Verifica que la escena principal esté correctamente configurada:
   - Ve a **"Project"** → **"Project Settings"** → **"Application"**
   - Revisa que `Main Scene` apunte a la escena correcta

2. Abre la escena y presiona **F6** para ver si se visualiza en el editor

3. Comprueba que los nodos tengan Canvas Layer configurado correctamente

### Problema 10: "No sé dónde reportar un error"

**Cómo reportar problemas:**

1. Describe qué intentabas hacer
2. Qué sucedió (error, comportamiento extraño)
3. Qué se esperaba que pasara
4. Incluye:
   - Sistema operativo
   - Versión de Godot
   - Pasos para reproducir el error

**Dónde reportar:**
- GitHub Issues: https://github.com/tu-usuario/trashrun/issues
- O contacta directamente al equipo de desarrollo

---

## Convenciones de Código

Para mantener el código limpio y consistente, sigue estas reglas:

### Nombres de Variables y Funciones

```gdscript
# ✅ Correcto - snake_case (minúsculas con guiones bajos)
var player_name = "Juan"
var tiempo_respuesta = 10
func cargar_preguntas():
    pass

# ❌ Incorrecto - camelCase o sin claridad
var playerName = "Juan"
var tr = 10
func cargarpreguntass():  # Mal escrito
    pass
```

### Nombres de Clases y Archivos

```gdscript
# ✅ Correcto - PascalCase para clases
extends Node
class_name GameManager

# Archivo: game_manager.gd (snake_case)

# ❌ Incorrecto
extends Node
class_name game_manager  # No es PascalCase
```

### Constantes

```gdscript
# ✅ Correcto - MAYÚSCULAS con guiones bajos
const TIEMPO_MAXIMO_RESPUESTA = 10
const MAX_JUGADORES = 2
const RUTA_PREGUNTAS = "res://data/questions.json"

# ❌ Incorrecto
const tiempoMaximo = 10
const maxJugadores = 2
```

### Comentarios

```gdscript
# ✅ Comentarios útiles
# Cargar preguntas desde el archivo JSON
func cargar_preguntas():
    # Verificar que el archivo existe
    if not FileAccess.file_exists(RUTA_PREGUNTAS):
        return []
    pass

# ❌ Comentarios inútiles
# Incrementar x
x += 1

# ❌ Comentarios obvios
# Establecer nombre
nombre = "Juan"
```

### Estructura de Archivos GDScript

```gdscript
# 1. Extend de clase padre
extends Node

# 2. Class name (si aplica)
class_name GameManager

# 3. Señales
signal juego_iniciado
signal respuesta_correcta

# 4. Constantes
const TIEMPO_MAXIMO = 10
const RUTA_DATOS = "res://data/"

# 5. Variables de clase
var jugador1_nombre := ""
var jugador2_nombre := ""

# 6. Funciones de inicialización (_ready, _process, etc.)
func _ready():
    print("Juego iniciado")

# 7. Funciones públicas (sin guion bajo)
func iniciar_juego():
    pass

# 8. Funciones privadas (con guion bajo)
func _cargar_preguntas():
    pass
```

### Indentación y Formato

- Usa **espacios (2 o 4)** para indentar, NO tabulaciones
- Máximo 100 caracteres por línea
- Deja línea en blanco entre funciones

```gdscript
# ✅ Correcto
func calcular_puntuacion(respuesta_correcta: bool, tiempo: int) -> int:
    if respuesta_correcta:
        return 100 - tiempo
    return 0

# ❌ Incorrecto - Muy largo
func calcular_puntuacion(respuesta_correcta: bool, tiempo: int) -> int: return 100 - tiempo if respuesta_correcta else 0
```

### Tipos de Datos (Type Hints)

```gdscript
# ✅ Recomendado - Indica qué tipo retorna
func obtener_puntuacion() -> int:
    return score

func cargar_preguntas() -> Array:
    return []

# ✅ Para parámetros
func sumar(a: int, b: int) -> int:
    return a + b

# ❌ Sin tipos (funciona, pero menos seguro)
func obtener_puntuacion():
    return score
```

---

## Comandos Útiles Rápidos

```bash
# Git
git status              # Ver estado actual
git log --oneline       # Ver últimos cambios
git diff                # Ver cambios no guardados
git add .               # Preparar todos los cambios
git commit -m "Mensaje" # Guardar cambios
git push                # Enviar al repositorio remoto
git pull                # Traer cambios nuevos

# Godot (desde terminal)
godot                   # Abrir Godot
godot --headless        # Ejecutar sin interfaz gráfica
godot --version         # Ver versión instalada

# Navegar en terminal
cd carpeta              # Entrar a carpeta
cd ..                   # Salir a carpeta anterior
pwd                     # Ver ubicación actual (macOS/Linux)
ls                      # Listar archivos (macOS/Linux)
dir                     # Listar archivos (Windows)
```

---

## Próximos Pasos

Después de configurar tu ambiente:

1. **Lee el código existente** - Entiende cómo funciona el juego
2. **Ejecuta los tests** - Verifica que todo esté funcionando
3. **Crea una rama** - Para tu primer cambio
4. **Modifica algo pequeño** - Practica el flujo de desarrollo
5. **Haz un commit y push** - Guarda tus cambios
6. **Abre un Pull Request** - Comparte tu trabajo

---

## Recursos Adicionales

- **Documentación de Godot:** https://docs.godotengine.org/
- **Tutoriales en YouTube:** Busca "Godot 4.5 Tutorial"
- **Comunidad:** https://discord.gg/godotengine
- **GDScript Guide:** https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html

---

## Preguntas Frecuentes

**P: ¿Necesito pagar por Godot?**
R: No, Godot es completamente gratuito y de código abierto.

**P: ¿Puedo usar VS Code en lugar del editor de Godot?**
R: Sí, puedes configurar VS Code con la extensión "GDScript" para escribir código, pero aún necesitas Godot para ejecutar el proyecto.

**P: ¿Cuánto espacio ocupa el proyecto?**
R: Aproximadamente 500 MB con todas las dependencias instaladas.

**P: ¿Qué si accidentalmente elimino una carpeta?**
R: Puedes recuperarla con `git checkout` o simplemente clonar el repositorio nuevamente.

**P: ¿Necesito internet para desarrollar?**
R: No, solo para clonar el proyecto y hacer push/pull a GitHub.

---

## Licencia y Créditos

Este proyecto fue desarrollado como parte del curso **"Control de Calidad de Software"** de la BUAP.

**Rama actual:** Jose

---

**Última actualización:** Mayo 2026

¿Necesitas ayuda? Reporta problemas en GitHub Issues o contacta al equipo de desarrollo.
