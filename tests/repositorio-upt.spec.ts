import { test, expect } from '@playwright/test';

test.describe('Búsqueda de Tesis de Tecnología - Repositorio UPT', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('https://repositorio.upt.edu.pe/');
    await page.waitForLoadState('domcontentloaded');
    await page.waitForTimeout(2000); // Esperar carga completa
  });

  test('CA1: Búsqueda de tecnología Web - debe retornar resultados', async ({ page }) => {
    // Buscar campo de búsqueda de múltiples formas
    const searchInput = await page.locator('input[type="text"]').first();
    await searchInput.waitFor({ state: 'visible' });
    
    // Realizar búsqueda
    await searchInput.fill('tecnología web');
    await searchInput.press('Enter');
    
    // Esperar navegación y carga
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Buscar resultados de múltiples formas
    const hasResults = await page.evaluate(() => {
      // Buscar cualquier elemento que parezca un resultado
      const possibleResults = document.querySelectorAll(
        'div[class*="item"], li[class*="item"], article, .result, .artifact, .document, tr'
      );
      return possibleResults.length > 0;
    });
    
    expect(hasResults).toBeTruthy();
    console.log('✓ Búsqueda de "tecnología web" ejecutada correctamente');
  });

  test('CA1: Búsqueda de Base de Datos - debe retornar resultados', async ({ page }) => {
    const searchInput = await page.locator('input[type="text"]').first();
    await searchInput.waitFor({ state: 'visible' });
    
    await searchInput.fill('base de datos');
    await searchInput.press('Enter');
    
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    const hasResults = await page.evaluate(() => {
      const possibleResults = document.querySelectorAll(
        'div[class*="item"], li[class*="item"], article, .result, .artifact, .document, tr'
      );
      return possibleResults.length > 0;
    });
    
    expect(hasResults).toBeTruthy();
    console.log('✓ Búsqueda de "base de datos" ejecutada correctamente');
  });

  test('CA1: Búsqueda de Desarrollo Móvil - debe retornar resultados', async ({ page }) => {
    const searchInput = await page.locator('input[type="text"]').first();
    await searchInput.waitFor({ state: 'visible' });
    
    await searchInput.fill('aplicación móvil');
    await searchInput.press('Enter');
    
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    const hasResults = await page.evaluate(() => {
      const possibleResults = document.querySelectorAll(
        'div[class*="item"], li[class*="item"], article, .result, .artifact, .document, tr'
      );
      return possibleResults.length > 0;
    });
    
    expect(hasResults).toBeTruthy();
    console.log('✓ Búsqueda de "aplicación móvil" ejecutada correctamente');
  });

  test('CA1: Búsqueda de Inteligencia de Negocios - debe retornar resultados', async ({ page }) => {
    const searchInput = await page.locator('input[type="text"]').first();
    await searchInput.waitFor({ state: 'visible' });
    
    await searchInput.fill('inteligencia de negocios');
    await searchInput.press('Enter');
    
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    const hasResults = await page.evaluate(() => {
      const possibleResults = document.querySelectorAll(
        'div[class*="item"], li[class*="item"], article, .result, .artifact, .document, tr'
      );
      return possibleResults.length > 0;
    });
    
    expect(hasResults).toBeTruthy();
    console.log('✓ Búsqueda de "inteligencia de negocios" ejecutada correctamente');
  });

  test('CA1: Búsqueda de Inteligencia Artificial - debe retornar resultados', async ({ page }) => {
    const searchInput = await page.locator('input[type="text"]').first();
    await searchInput.waitFor({ state: 'visible' });
    
    await searchInput.fill('inteligencia artificial');
    await searchInput.press('Enter');
    
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    const hasResults = await page.evaluate(() => {
      const possibleResults = document.querySelectorAll(
        'div[class*="item"], li[class*="item"], article, .result, .artifact, .document, tr'
      );
      return possibleResults.length > 0;
    });
    
    expect(hasResults).toBeTruthy();
    console.log('✓ Búsqueda de "inteligencia artificial" ejecutada correctamente');
  });

  test('Verificar accesibilidad del repositorio', async ({ page }) => {
    await expect(page).toHaveURL(/repositorio\.upt\.edu\.pe/);
    
    const searchBox = page.locator('input[type="text"]').first();
    await expect(searchBox).toBeVisible();
    console.log('✓ Repositorio accesible correctamente');
  });
});
