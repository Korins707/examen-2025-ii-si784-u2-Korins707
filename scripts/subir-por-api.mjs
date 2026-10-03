/**
 * Sube el contenido del repositorio a GitHub usando la API de Contents.
 *
 * Util cuando `git push` devuelve 403 por permisos y la web de GitHub
 * rechaza subir muchas carpetas de una vez.
 *
 * Crea un commit por archivo y actualiza la rama `main` del remoto.
 */

import { readFileSync, readdirSync, statSync } from 'node:fs';
import { execFileSync, spawnSync } from 'node:child_process';
import { join, relative, sep } from 'node:path';

const REPO = process.env.REPO_DESTINO ?? 'UPT-FAING-EPIS/si784-2026-ii-si784-2026-ii-examen-u1-korins707';
const RAIZ = process.cwd();
const RAMA = 'main';
const API = 'https://api.github.com';

/** Obtiene la credencial desde la sesion activa de GitHub CLI. */
function obtenerCredencial() {
  const desdeEntorno = process.env.GITHUB_TOKEN;
  if (desdeEntorno) {
    return desdeEntorno.trim();
  }

  // 'gh' puede no estar en el PATH de Node en Windows.
  const rutas = [
    'gh',
    'C:\\Program Files\\GitHub CLI\\gh.exe',
    'C:\\Program Files (x86)\\GitHub CLI\\gh.exe'
  ];

  for (const ruta of rutas) {
    const proceso = spawnSync(ruta, ['auth', 'token'], { encoding: 'utf8' });
    if (proceso.status === 0 && proceso.stdout && proceso.stdout.trim()) {
      return proceso.stdout.trim();
    }
  }

  return '';
}

const CRED = obtenerCredencial();

if (!CRED) {
  console.error('No se encontro una credencial de GitHub. Inicia sesion con: gh auth login');
  process.exit(1);
}

const IGNORAR = new Set(['.git', 'node_modules', 'bin', 'obj', 'dist', '.terraform']);
const MAX_PETICIONES_POR_MINUTO = 28;

/** Lista recursivamente los archivos a subir. */
function listarArchivos(directorio) {
  const encontrados = [];

  for (const entrada of readdirSync(directorio)) {
    if (IGNORAR.has(entrada)) {
      continue;
    }

    const completa = join(directorio, entrada);
    if (statSync(completa).isDirectory()) {
      encontrados.push(...listarArchivos(completa));
    } else {
      encontrados.push(completa);
    }
  }

  return encontrados;
}

async function api(ruta, opciones = {}) {
  const respuesta = await fetch(`${API}${ruta}`, {
    ...opciones,
    headers: {
      Authorization: `Bearer ${CRED}`,
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'Content-Type': 'application/json',
      ...(opciones.headers ?? {})
    }
  });

  const texto = await respuesta.text();
  const cuerpo = texto ? JSON.parse(texto) : null;

  if (!respuesta.ok) {
    throw new Error(`${opciones.method ?? 'GET'} ${ruta} -> ${respuesta.status} ${cuerpo?.message ?? ''}`);
  }

  return cuerpo;
}

const esperar = (ms) => new Promise((resolver) => setTimeout(resolver, ms));

/** Sube un archivo, reemplazar si ya existe (modo upsert). */
async function subirArchivo(rutaRelativa, contenidoBase64) {
  let sha;

  try {
    const existente = await api(`/repos/${REPO}/contents/${rutaRelativa}?ref=${RAMA}`);
    sha = existente.sha;
  } catch {
    sha = undefined;
  }

  const cuerpo = {
    message: sha ? `chore: actualizar ${rutaRelativa}` : `chore: agregar ${rutaRelativa}`,
    content: contenidoBase64,
    branch: RAMA
  };

  if (sha) {
    cuerpo.sha = sha;
  }

  return api(`/repos/${REPO}/contents/${rutaRelativa}`, {
    method: 'PUT',
    body: JSON.stringify(cuerpo)
  });
}

async function principal() {
  const archivos = listarArchivos(RAIZ);
  console.log(`Archivos a subir: ${archivos.length}\n`);

  let subidos = 0;
  let errores = 0;
  let ultimoMinuto = Date.now();

  for (const archivo of archivos) {
    const rutaRelativa = relative(RAIZ, archivo).split(sep).join('/');
    const contenido = readFileSync(archivo).toString('base64');

    try {
      await subirArchivo(rutaRelativa, contenido);
      subidos += 1;
      if (subidos % 10 === 0) {
        console.log(`  ${subidos}/${archivos.length} subidos`);
      }
    } catch (error) {
      errores += 1;
      console.error(`  FALLO ${rutaRelativa}: ${error.message}`);
      // Reintentar una vez: puede ser un fallo transitorio de la API.
      if (
        error.message.includes('422')
        || error.message.includes('sha')
        || error.message.includes('409')
      ) {
        await esperar(900);
        try {
          await subirArchivo(rutaRelativa, contenido);
          subidos += 1;
          errores -= 1;
          console.log(`  OK (reintento) ${rutaRelativa}`);
        } catch (errorReintento) {
          console.error(`  FALLO en reintento: ${rutaRelativa}: ${errorReintento.message}`);
        }
      }
    }

    // Respetar el limite de la API Secondary Rate Limit.
    if (Date.now() - ultimoMinuto > 60000 / MAX_PETICIONES_POR_MINUTO) {
      await esperar(60000 / MAX_PETICIONES_POR_MINUTO);
      ultimoMinuto = Date.now();
    }
  }

  console.log(`\nResultado: ${subidos} subidos, ${errores} errores.`);
  console.log(`Repositorio: https://github.com/${REPO}`);
}

principal().catch((error) => {
  console.error(error.message);
  process.exit(1);
});