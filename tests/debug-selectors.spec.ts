import { test } from '@playwright/test';

test('Debug: Inspeccionar selectores de la página', async ({ page }) => {
  await page.goto('https://repositorio.upt.edu.pe/');
  await page.waitForLoadState('domcontentloaded');
  
  // Buscar el input
  const searchInput = await page.locator('input[type="text"]').first();
  await searchInput.fill('tecnología web');
  await searchInput.press('Enter');
  
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(5000);
  
  // Tomar screenshot
  await page.screenshot({ path: 'debug-after-search.png', fullPage: true });
  
  // Imprimir HTML de la página
  const html = await page.content();
  console.log('=== ESTRUCTURA DE LA PÁGINA ===');
  
  // Buscar todos los posibles contenedores de resultados
  const selectors = [
    '.search-results',
    '.item-list',
    '[class*="result"]',
    'table',
    'ul li',
    'div[class*="item"]',
    'article'
  ];
  
  for (const selector of selectors) {
    const count = await page.locator(selector).count();
    console.log(`${selector}: ${count} elementos encontrados`);
  }
  
  // Pausar para inspeccionar
  await page.pause();
});
