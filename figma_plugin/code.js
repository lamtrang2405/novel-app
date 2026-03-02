// DramaVerse Design System Builder — Figma Plugin
// Builds: Color Styles, Text Styles, Effect Styles, Components, Screen Frames

figma.showUI(__html__, { width: 420, height: 560, title: "DramaVerse Design System Builder" });

// ─── DESIGN TOKENS ────────────────────────────────────────────────────────────

const COLORS = {
  // Core
  primary:       { r: 1.000, g: 0.176, b: 0.471 }, // #FF2D78
  primaryLight:  { r: 1.000, g: 0.435, b: 0.659 }, // #FF6FA8
  primaryDark:   { r: 0.800, g: 0.000, b: 0.333 }, // #CC0055
  accent:        { r: 0.733, g: 0.235, b: 1.000 }, // #BB3CFF
  accentLight:   { r: 0.835, g: 0.502, b: 1.000 }, // #D580FF
  cyan:          { r: 0.000, g: 0.898, b: 1.000 }, // #00E5FF
  gold:          { r: 1.000, g: 0.839, b: 0.000 }, // #FFD600
  goldLight:     { r: 1.000, g: 0.918, b: 0.000 }, // #FFEA00
  // Backgrounds
  bgDeep:        { r: 0.039, g: 0.039, b: 0.059 }, // #0A0A0F
  bgDark:        { r: 0.059, g: 0.059, b: 0.102 }, // #0F0F1A
  bgCard:        { r: 0.086, g: 0.086, b: 0.145 }, // #161625
  bgCardAlt:     { r: 0.118, g: 0.118, b: 0.188 }, // #1E1E30
  // Text
  textPrimary:   { r: 0.941, g: 0.933, b: 1.000 }, // #F0EEFF
  textSecondary: { r: 0.667, g: 0.624, b: 0.769 }, // #AA9FC4
  textHint:      { r: 0.420, g: 0.380, b: 0.541 }, // #6B618A
  // Status
  success:       { r: 0.000, g: 0.902, b: 0.463 }, // #00E676
  warning:       { r: 1.000, g: 0.671, b: 0.000 }, // #FFAB00
  error:         { r: 1.000, g: 0.090, b: 0.267 }, // #FF1744
  white:         { r: 1.000, g: 1.000, b: 1.000 },
};

const GRADIENTS = {
  primary:    [{ color: COLORS.primary, pos: 0 }, { color: COLORS.accent,   pos: 1 }],
  cyan:       [{ color: COLORS.cyan,    pos: 0 }, { color: { r:0,g:0.4,b:1}, pos: 1 }],
  gold:       [{ color: COLORS.gold,    pos: 0 }, { color: { r:1,g:0.596,b:0}, pos: 1 }],
  dramatic:   [{ color: { r:0.102,g:0.039,b:0.180}, pos:0 }, { color:{r:0.239,g:0,b:0.400}, pos:0.5 }, { color:{r:0.400,g:0,b:0.200}, pos:1 }],
};

// ─── HELPERS ──────────────────────────────────────────────────────────────────

function rgb(r, g, b, a = 1) { return { r, g, b, a }; }
function hex2rgb(hex) {
  const r = parseInt(hex.slice(1,3),16)/255;
  const g = parseInt(hex.slice(3,5),16)/255;
  const b = parseInt(hex.slice(5,7),16)/255;
  return { r, g, b };
}
function solidFill(color, alpha = 1) {
  return [{ type: 'SOLID', color, opacity: alpha }];
}
function gradientFill(stops, angle = 135) {
  const rad = (angle * Math.PI) / 180;
  const cos = Math.cos(rad); const sin = Math.sin(rad);
  return [{
    type: 'GRADIENT_LINEAR',
    gradientTransform: [[cos, -sin, (1 - cos + sin) / 2], [sin, cos, (1 - cos - sin) / 2]],
    gradientStops: stops.map(s => ({
      position: s.pos,
      color: { ...s.color, a: 1 }
    }))
  }];
}

async function loadFonts() {
  await Promise.all([
    figma.loadFontAsync({ family: 'Oswald', style: 'Bold' }),
    figma.loadFontAsync({ family: 'Oswald', style: 'SemiBold' }),
    figma.loadFontAsync({ family: 'Inter', style: 'Bold' }),
    figma.loadFontAsync({ family: 'Inter', style: 'Extra Bold' }),
    figma.loadFontAsync({ family: 'Inter', style: 'Regular' }),
    figma.loadFontAsync({ family: 'Inter', style: 'Medium' }),
  ]).catch(async () => {
    // Fallback to system fonts if Google Fonts not available
    await figma.loadFontAsync({ family: 'Roboto', style: 'Bold' });
    await figma.loadFontAsync({ family: 'Roboto', style: 'Regular' });
  });
}

function makeRect(name, x, y, w, h, color) {
  const r = figma.createRectangle();
  r.name = name; r.x = x; r.y = y; r.resize(w, h);
  if (color) r.fills = solidFill(color);
  return r;
}

function makeText(content, fontFamily, fontStyle, fontSize, color, opts = {}) {
  const t = figma.createText();
  try { t.fontName = { family: fontFamily, style: fontStyle }; } catch(e) {
    t.fontName = { family: 'Roboto', style: 'Regular' };
  }
  t.fontSize = fontSize;
  t.characters = content;
  t.fills = solidFill(color);
  if (opts.letterSpacing) t.letterSpacing = { value: opts.letterSpacing, unit: 'PIXELS' };
  if (opts.lineHeight) t.lineHeight = { value: opts.lineHeight, unit: 'PERCENT' };
  if (opts.width) { t.textAutoResize = 'HEIGHT'; t.resize(opts.width, t.height); }
  if (opts.align) t.textAlignHorizontal = opts.align;
  if (opts.wrap) t.textAutoResize = 'WIDTH_AND_HEIGHT';
  return t;
}

function makeFrame(name, x, y, w, h) {
  const f = figma.createFrame();
  f.name = name; f.x = x; f.y = y; f.resize(w, h);
  f.fills = solidFill(COLORS.bgDark);
  f.clipsContent = true;
  return f;
}

function roundCorners(node, radius) {
  node.cornerRadius = radius;
  return node;
}

function send(msg) {
  figma.ui.postMessage(msg);
}

// ─── STEP 1: COLOR STYLES ─────────────────────────────────────────────────────

async function createColorStyles() {
  send({ type: 'progress', step: 'Creating Color Styles...', pct: 5 });

  const colorDefs = [
    ['DramaVerse/Primary/Pink',      COLORS.primary],
    ['DramaVerse/Primary/Pink Light', COLORS.primaryLight],
    ['DramaVerse/Primary/Pink Dark',  COLORS.primaryDark],
    ['DramaVerse/Accent/Purple',      COLORS.accent],
    ['DramaVerse/Accent/Purple Light',COLORS.accentLight],
    ['DramaVerse/Accent/Cyan',        COLORS.cyan],
    ['DramaVerse/Accent/Gold',        COLORS.gold],
    ['DramaVerse/Accent/Gold Light',  COLORS.goldLight],
    ['DramaVerse/Background/Deep',    COLORS.bgDeep],
    ['DramaVerse/Background/Dark',    COLORS.bgDark],
    ['DramaVerse/Background/Card',    COLORS.bgCard],
    ['DramaVerse/Background/Card Alt',COLORS.bgCardAlt],
    ['DramaVerse/Text/Primary',       COLORS.textPrimary],
    ['DramaVerse/Text/Secondary',     COLORS.textSecondary],
    ['DramaVerse/Text/Hint',          COLORS.textHint],
    ['DramaVerse/Status/Success',     COLORS.success],
    ['DramaVerse/Status/Warning',     COLORS.warning],
    ['DramaVerse/Status/Error',       COLORS.error],
  ];

  for (const [name, color] of colorDefs) {
    const s = figma.createPaintStyle();
    s.name = name;
    s.paints = solidFill(color);
  }
}

// ─── STEP 2: EFFECT STYLES ────────────────────────────────────────────────────

async function createEffectStyles() {
  send({ type: 'progress', step: 'Creating Effect Styles (Neon Glows)...', pct: 15 });

  const effectDefs = [
    { name: 'DramaVerse/Glow/Neon Pink',   color: { ...COLORS.primary, a: 0.5 },  blur: 20 },
    { name: 'DramaVerse/Glow/Neon Purple', color: { ...COLORS.accent,  a: 0.45 }, blur: 20 },
    { name: 'DramaVerse/Glow/Neon Cyan',   color: { ...COLORS.cyan,    a: 0.4 },  blur: 16 },
    { name: 'DramaVerse/Glow/Neon Gold',   color: { ...COLORS.gold,    a: 0.4 },  blur: 16 },
    { name: 'DramaVerse/Glow/Pink Strong', color: { ...COLORS.primary, a: 0.6 },  blur: 30 },
  ];

  for (const d of effectDefs) {
    const s = figma.createEffectStyle();
    s.name = d.name;
    s.effects = [{
      type: 'DROP_SHADOW',
      color: d.color,
      offset: { x: 0, y: 0 },
      radius: d.blur,
      spread: 1,
      visible: true,
      blendMode: 'NORMAL',
    }];
  }
}

// ─── STEP 3: TEXT STYLES ──────────────────────────────────────────────────────

async function createTextStyles() {
  send({ type: 'progress', step: 'Creating Text Styles...', pct: 25 });

  const textDefs = [
    // Oswald Display
    { name: 'DramaVerse/Display/Large',    family: 'Oswald', style: 'Bold',       size: 40, ls: 1.5,  lh: 100 },
    { name: 'DramaVerse/Display/Medium',   family: 'Oswald', style: 'Bold',       size: 30, ls: 1.0,  lh: 105 },
    { name: 'DramaVerse/Display/Small',    family: 'Oswald', style: 'SemiBold',   size: 24, ls: 0.8,  lh: 110 },
    { name: 'DramaVerse/Display/Section',  family: 'Oswald', style: 'SemiBold',   size: 18, ls: 1.2,  lh: 110 },
    // Inter Title
    { name: 'DramaVerse/Title/Large',      family: 'Inter',  style: 'Extra Bold', size: 20, ls: -0.3, lh: 120 },
    { name: 'DramaVerse/Title/Medium',     family: 'Inter',  style: 'Bold',       size: 16, ls: -0.2, lh: 130 },
    { name: 'DramaVerse/Title/Small',      family: 'Inter',  style: 'Bold',       size: 13, ls: -0.1, lh: 130 },
    // Inter Body
    { name: 'DramaVerse/Body/Large',       family: 'Inter',  style: 'Regular',    size: 16, ls: 0,    lh: 160 },
    { name: 'DramaVerse/Body/Medium',      family: 'Inter',  style: 'Regular',    size: 14, ls: 0,    lh: 155 },
    { name: 'DramaVerse/Body/Small',       family: 'Inter',  style: 'Regular',    size: 12, ls: 0,    lh: 150 },
    // Inter Label
    { name: 'DramaVerse/Label/Large',      family: 'Inter',  style: 'Bold',       size: 14, ls: 0,    lh: 140 },
    { name: 'DramaVerse/Label/Small',      family: 'Inter',  style: 'Bold',       size: 10, ls: 0.8,  lh: 140 },
  ];

  for (const d of textDefs) {
    const s = figma.createTextStyle();
    s.name = d.name;
    try {
      s.fontName = { family: d.family, style: d.style };
    } catch(e) {
      s.fontName = { family: 'Roboto', style: d.style === 'Regular' ? 'Regular' : 'Bold' };
    }
    s.fontSize = d.size;
    if (d.ls !== 0) s.letterSpacing = { value: d.ls, unit: 'PIXELS' };
    if (d.lh) s.lineHeight = { value: d.lh, unit: 'PERCENT' };
  }
}

// ─── STEP 4: TOKENS PAGE ──────────────────────────────────────────────────────

async function buildTokensPage() {
  send({ type: 'progress', step: 'Building Tokens Page...', pct: 35 });

  let page = figma.root.children.find(p => p.name === '🎨 Tokens');
  if (!page) { page = figma.createPage(); page.name = '🎨 Tokens'; }
  figma.currentPage = page;

  // Title
  const titleFrame = figma.createFrame();
  titleFrame.name = 'Tokens Header'; titleFrame.x = 0; titleFrame.y = 0;
  titleFrame.resize(1200, 80); titleFrame.fills = gradientFill(GRADIENTS.dramatic);

  const titleText = makeText('DRAMAVERSE — DESIGN TOKENS', 'Oswald', 'Bold', 32, COLORS.white, { letterSpacing: 2 });
  titleText.x = 40; titleText.y = 24;
  titleFrame.appendChild(titleText);
  page.appendChild(titleFrame);

  // Color swatches
  const swatchFrame = figma.createFrame();
  swatchFrame.name = 'Color Palette'; swatchFrame.x = 0; swatchFrame.y = 100;
  swatchFrame.resize(1200, 520); swatchFrame.fills = solidFill(COLORS.bgDeep);
  page.appendChild(swatchFrame);

  const sectionLabel = makeText('COLOR PALETTE', 'Oswald', 'Bold', 18, COLORS.primary, { letterSpacing: 2 });
  sectionLabel.x = 40; sectionLabel.y = 24;
  swatchFrame.appendChild(sectionLabel);

  const palette = [
    { name: 'Primary\nPink',   hex: '#FF2D78', color: COLORS.primary },
    { name: 'Accent\nPurple',  hex: '#BB3CFF', color: COLORS.accent },
    { name: 'Accent\nCyan',    hex: '#00E5FF', color: COLORS.cyan },
    { name: 'Gold',            hex: '#FFD600', color: COLORS.gold },
    { name: 'BG Deep',         hex: '#0A0A0F', color: COLORS.bgDeep, border: true },
    { name: 'BG Dark',         hex: '#0F0F1A', color: COLORS.bgDark, border: true },
    { name: 'BG Card',         hex: '#161625', color: COLORS.bgCard, border: true },
    { name: 'BG Card Alt',     hex: '#1E1E30', color: COLORS.bgCardAlt, border: true },
    { name: 'Text Primary',    hex: '#F0EEFF', color: COLORS.textPrimary, bg: COLORS.bgCard },
    { name: 'Text Secondary',  hex: '#AA9FC4', color: COLORS.textSecondary, bg: COLORS.bgCard },
    { name: 'Text Hint',       hex: '#6B618A', color: COLORS.textHint, bg: COLORS.bgCard },
    { name: 'Success',         hex: '#00E676', color: COLORS.success },
  ];

  palette.forEach((p, i) => {
    const col = i % 6; const row = Math.floor(i / 6);
    const sx = 40 + col * 185; const sy = 60 + row * 200;

    const swatch = figma.createFrame();
    swatch.name = `Swatch/${p.name}`; swatch.x = sx; swatch.y = sy;
    swatch.resize(165, 90); swatch.cornerRadius = 12;
    swatch.fills = solidFill(p.color);
    if (p.border) {
      swatch.strokes = [{ type: 'SOLID', color: COLORS.white, opacity: 0.15 }];
      swatch.strokeWeight = 1;
    }
    swatchFrame.appendChild(swatch);

    const nameTxt = makeText(p.name, 'Inter', 'Bold', 11, p.bg || COLORS.textPrimary, { wrap: true });
    nameTxt.x = sx; nameTxt.y = sy + 96;
    swatchFrame.appendChild(nameTxt);

    const hexTxt = makeText(p.hex, 'Inter', 'Regular', 10, COLORS.textHint);
    hexTxt.x = sx; hexTxt.y = sy + 118;
    swatchFrame.appendChild(hexTxt);
  });

  // Gradient row
  const gradFrame = figma.createFrame();
  gradFrame.name = 'Gradients'; gradFrame.x = 0; gradFrame.y = 640;
  gradFrame.resize(1200, 200); gradFrame.fills = solidFill(COLORS.bgDeep);
  page.appendChild(gradFrame);

  const gradLabel = makeText('GRADIENTS', 'Oswald', 'Bold', 18, COLORS.primary, { letterSpacing: 2 });
  gradLabel.x = 40; gradLabel.y = 24;
  gradFrame.appendChild(gradLabel);

  const grads = [
    { name: 'Primary\nPink→Purple', stops: GRADIENTS.primary },
    { name: 'Cyan\nCyan→Blue',      stops: GRADIENTS.cyan },
    { name: 'Gold\nGold→Orange',    stops: GRADIENTS.gold },
    { name: 'Dramatic\nPurple Fade',stops: GRADIENTS.dramatic },
  ];

  grads.forEach((g, i) => {
    const gRect = figma.createRectangle();
    gRect.name = g.name; gRect.x = 40 + i * 220; gRect.y = 60;
    gRect.resize(200, 60); gRect.cornerRadius = 12;
    gRect.fills = gradientFill(g.stops);
    gradFrame.appendChild(gRect);
    const gName = makeText(g.name, 'Inter', 'Regular', 10, COLORS.textSecondary, { wrap: true });
    gName.x = 40 + i * 220; gName.y = 128;
    gradFrame.appendChild(gName);
  });
}

// ─── STEP 5: COMPONENTS PAGE ──────────────────────────────────────────────────

async function buildComponentsPage() {
  send({ type: 'progress', step: 'Building Components Page...', pct: 50 });

  let page = figma.root.children.find(p => p.name === '📐 Components');
  if (!page) { page = figma.createPage(); page.name = '📐 Components'; }
  figma.currentPage = page;

  const bgFrame = figma.createFrame();
  bgFrame.name = 'Components Canvas'; bgFrame.x = 0; bgFrame.y = 0;
  bgFrame.resize(1600, 1200); bgFrame.fills = solidFill(COLORS.bgDeep);
  page.appendChild(bgFrame);

  // Header
  const hdr = makeText('DRAMAVERSE — COMPONENTS', 'Oswald', 'Bold', 28, COLORS.white, { letterSpacing: 1.5 });
  hdr.x = 40; hdr.y = 32; bgFrame.appendChild(hdr);

  // ── Primary Button ──────────────────────────────────────────────
  const btnComp = figma.createComponent();
  btnComp.name = 'Button/Primary Gradient';
  btnComp.resize(260, 52); btnComp.cornerRadius = 14;
  btnComp.fills = gradientFill(GRADIENTS.primary);
  btnComp.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary, a:0.5}, offset:{x:0,y:0}, radius:20, spread:1, visible:true, blendMode:'NORMAL' }];
  btnComp.x = 40; btnComp.y = 90;
  const btnTxt = makeText('READ NOW', 'Oswald', 'Bold', 15, COLORS.white, { letterSpacing: 1.5, align: 'CENTER' });
  btnTxt.resize(260, 20); btnTxt.x = 0; btnTxt.y = 16;
  btnComp.appendChild(btnTxt);
  bgFrame.appendChild(btnComp);

  // Label
  const btnLbl = makeText('Button/Primary Gradient\n260×52 · radius 14 · neon pink glow', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  btnLbl.x = 40; btnLbl.y = 152; bgFrame.appendChild(btnLbl);

  // ── Gold Button ─────────────────────────────────────────────────
  const goldBtn = figma.createComponent();
  goldBtn.name = 'Button/Gold';
  goldBtn.resize(200, 52); goldBtn.cornerRadius = 14;
  goldBtn.fills = gradientFill(GRADIENTS.gold);
  goldBtn.effects = [{ type:'DROP_SHADOW', color:{...COLORS.gold, a:0.45}, offset:{x:0,y:0}, radius:18, spread:1, visible:true, blendMode:'NORMAL' }];
  goldBtn.x = 320; goldBtn.y = 90;
  const goldTxt = makeText('GET COINS 🪙', 'Oswald', 'Bold', 14, COLORS.bgDeep, { letterSpacing: 1, align: 'CENTER' });
  goldTxt.resize(200, 20); goldTxt.x = 0; goldTxt.y = 16;
  goldBtn.appendChild(goldTxt);
  bgFrame.appendChild(goldBtn);

  const goldLbl = makeText('Button/Gold\n200×52 · radius 14 · gold glow', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  goldLbl.x = 320; goldLbl.y = 152; bgFrame.appendChild(goldLbl);

  // ── Novel Card Vertical ──────────────────────────────────────────
  const cardComp = figma.createComponent();
  cardComp.name = 'Card/Novel Vertical';
  cardComp.resize(120, 220); cardComp.cornerRadius = 14;
  cardComp.fills = solidFill(COLORS.bgCard);
  cardComp.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.08 }];
  cardComp.strokeWeight = 1;
  cardComp.x = 40; cardComp.y = 200;

  // Cover placeholder
  const coverRect = figma.createRectangle();
  coverRect.name = 'Cover Image'; coverRect.resize(120, 175); coverRect.x = 0; coverRect.y = 0;
  coverRect.fills = gradientFill(GRADIENTS.dramatic);
  cardComp.appendChild(coverRect);

  // Hot badge
  const hotBadge = figma.createRectangle();
  hotBadge.name = 'Badge/Hot'; hotBadge.resize(36, 20); hotBadge.x = 8; hotBadge.y = 8;
  hotBadge.cornerRadius = 6; hotBadge.fills = gradientFill(GRADIENTS.primary);
  cardComp.appendChild(hotBadge);
  const hotTxt = makeText('🔥', 'Inter', 'Regular', 10, COLORS.white);
  hotTxt.x = 11; hotTxt.y = 4; cardComp.appendChild(hotTxt);

  // Title
  const cardTitle = makeText('Dark Romance', 'Inter', 'Bold', 11, COLORS.textPrimary, { width: 100 });
  cardTitle.x = 8; cardTitle.y = 182; cardComp.appendChild(cardTitle);
  const cardAuthor = makeText('by @author', 'Inter', 'Regular', 9, COLORS.textHint, { width: 100 });
  cardAuthor.x = 8; cardAuthor.y = 198; cardComp.appendChild(cardAuthor);

  bgFrame.appendChild(cardComp);
  const cardLbl = makeText('Card/Novel Vertical\n120×220 · radius 14', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  cardLbl.x = 40; cardLbl.y = 428; bgFrame.appendChild(cardLbl);

  // ── Novel Card Wide ──────────────────────────────────────────────
  const wideComp = figma.createComponent();
  wideComp.name = 'Card/Novel Wide';
  wideComp.resize(340, 110); wideComp.cornerRadius = 16;
  wideComp.fills = solidFill(COLORS.bgCard);
  wideComp.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.06 }];
  wideComp.strokeWeight = 1;
  wideComp.x = 200; wideComp.y = 200;

  const wideCover = figma.createRectangle();
  wideCover.name = 'Cover'; wideCover.resize(76, 110); wideCover.x = 0; wideCover.y = 0;
  wideCover.fills = gradientFill(GRADIENTS.dramatic); wideCover.cornerRadius = 16;
  wideComp.appendChild(wideCover);

  const wideTitle = makeText('The Billionaire\'s Secret', 'Inter', 'Bold', 13, COLORS.textPrimary, { width: 240 });
  wideTitle.x = 88; wideTitle.y = 14; wideComp.appendChild(wideTitle);
  const wideGenre = makeText('Dark Romance', 'Inter', 'Bold', 10, COLORS.primary, { width: 120 });
  wideGenre.x = 88; wideGenre.y = 38; wideComp.appendChild(wideGenre);
  const wideMeta = makeText('⭐ 4.8  •  125 chapters', 'Inter', 'Regular', 10, COLORS.textHint, { width: 240 });
  wideMeta.x = 88; wideMeta.y = 58; wideComp.appendChild(wideMeta);

  bgFrame.appendChild(wideComp);
  const wideLbl = makeText('Card/Novel Wide\n340×110 · radius 16', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  wideLbl.x = 200; wideLbl.y = 320; bgFrame.appendChild(wideLbl);

  // ── Genre Chip Active ────────────────────────────────────────────
  const chipActive = figma.createComponent();
  chipActive.name = 'Chip/Genre Active';
  chipActive.resize(120, 36); chipActive.cornerRadius = 30;
  chipActive.fills = gradientFill(GRADIENTS.primary);
  chipActive.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.45}, offset:{x:0,y:0}, radius:12, spread:0, visible:true, blendMode:'NORMAL' }];
  chipActive.x = 580; chipActive.y = 90;
  const chipActiveTxt = makeText('Dark Romance', 'Inter', 'Bold', 12, COLORS.white, { align: 'CENTER' });
  chipActiveTxt.resize(120, 20); chipActiveTxt.x = 0; chipActiveTxt.y = 8;
  chipActive.appendChild(chipActiveTxt);
  bgFrame.appendChild(chipActive);

  const chipActiveLbl = makeText('Chip/Genre Active\n120×36 · pill · primary gradient', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  chipActiveLbl.x = 580; chipActiveLbl.y = 136; bgFrame.appendChild(chipActiveLbl);

  // ── Genre Chip Inactive ──────────────────────────────────────────
  const chipInactive = figma.createComponent();
  chipInactive.name = 'Chip/Genre Inactive';
  chipInactive.resize(120, 36); chipInactive.cornerRadius = 30;
  chipInactive.fills = solidFill(COLORS.bgCard);
  chipInactive.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.08 }];
  chipInactive.strokeWeight = 1;
  chipInactive.x = 720; chipInactive.y = 90;
  const chipInactiveTxt = makeText('Billionaire', 'Inter', 'Bold', 12, COLORS.textHint, { align: 'CENTER' });
  chipInactiveTxt.resize(120, 20); chipInactiveTxt.x = 0; chipInactiveTxt.y = 8;
  chipInactive.appendChild(chipInactiveTxt);
  bgFrame.appendChild(chipInactive);

  const chipInactiveLbl = makeText('Chip/Genre Inactive\n120×36 · pill · bg-card', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  chipInactiveLbl.x = 720; chipInactiveLbl.y = 136; bgFrame.appendChild(chipInactiveLbl);

  // ── Mini Player ──────────────────────────────────────────────────
  const miniPlayer = figma.createComponent();
  miniPlayer.name = 'MiniPlayer';
  miniPlayer.resize(390, 62); miniPlayer.fills = solidFill(COLORS.bgCardAlt);
  miniPlayer.strokes = [{ type:'SOLID', color: COLORS.primary, opacity: 0.3 }];
  miniPlayer.strokeWeight = 1; miniPlayer.strokeAlign = 'INSIDE';
  miniPlayer.x = 580; miniPlayer.y = 200;

  // Pink stripe
  const stripe = figma.createRectangle();
  stripe.name = 'NeonStripe'; stripe.resize(3, 62); stripe.x = 0; stripe.y = 0;
  stripe.fills = gradientFill(GRADIENTS.primary, 180);
  miniPlayer.appendChild(stripe);

  // Cover placeholder
  const miniCover = figma.createRectangle();
  miniCover.name = 'Cover'; miniCover.resize(62, 62); miniCover.x = 3; miniCover.y = 0;
  miniCover.fills = gradientFill(GRADIENTS.dramatic);
  miniPlayer.appendChild(miniCover);

  // Info
  const miniTitle = makeText('His Secret Obsession', 'Inter', 'Bold', 12, COLORS.textPrimary);
  miniTitle.x = 76; miniTitle.y = 10; miniPlayer.appendChild(miniTitle);
  const miniChapter = makeText('Chapter 4 — audio', 'Inter', 'Regular', 10, COLORS.textSecondary);
  miniChapter.x = 76; miniChapter.y = 28; miniPlayer.appendChild(miniChapter);

  // Play button
  const playCircle = figma.createEllipse();
  playCircle.name = 'PlayButton'; playCircle.resize(36, 36);
  playCircle.x = 340; playCircle.y = 13;
  playCircle.fills = gradientFill(GRADIENTS.primary);
  playCircle.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.5}, offset:{x:0,y:0}, radius:10, spread:0, visible:true, blendMode:'NORMAL' }];
  miniPlayer.appendChild(playCircle);

  bgFrame.appendChild(miniPlayer);
  const miniLbl = makeText('MiniPlayer\n390×62 · dark glass · neon stripe', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  miniLbl.x = 580; miniLbl.y = 272; bgFrame.appendChild(miniLbl);

  // ── Section Label ────────────────────────────────────────────────
  const sectionComp = figma.createComponent();
  sectionComp.name = 'SectionLabel';
  sectionComp.resize(200, 20); sectionComp.fills = [];
  sectionComp.x = 40; sectionComp.y = 480;

  const bar1 = figma.createRectangle(); bar1.name = 'Bar1';
  bar1.resize(3, 16); bar1.y = 2; bar1.x = 0; bar1.cornerRadius = 2;
  bar1.fills = gradientFill(GRADIENTS.primary, 180);
  sectionComp.appendChild(bar1);
  const bar2 = figma.createRectangle(); bar2.name = 'Bar2';
  bar2.resize(3, 16); bar2.y = 2; bar2.x = 5; bar2.cornerRadius = 2;
  bar2.fills = gradientFill(GRADIENTS.primary, 180);
  sectionComp.appendChild(bar2);
  const bar3 = figma.createRectangle(); bar3.name = 'Bar3';
  bar3.resize(3, 16); bar3.y = 2; bar3.x = 10; bar3.cornerRadius = 2;
  bar3.fills = gradientFill(GRADIENTS.primary, 180);
  sectionComp.appendChild(bar3);
  const slTxt = makeText('TRENDING NOW', 'Oswald', 'SemiBold', 16, COLORS.textPrimary, { letterSpacing: 1.2 });
  slTxt.x = 20; slTxt.y = 0; sectionComp.appendChild(slTxt);
  bgFrame.appendChild(sectionComp);

  const slLbl = makeText('SectionLabel\nGradient bars + Oswald SemiBold UPPERCASE', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  slLbl.x = 40; slLbl.y = 508; bgFrame.appendChild(slLbl);

  // ── Coin Chip ────────────────────────────────────────────────────
  const coinChip = figma.createComponent();
  coinChip.name = 'Chip/Coin Balance';
  coinChip.resize(84, 30); coinChip.cornerRadius = 20;
  coinChip.fills = solidFill(COLORS.bgCard);
  coinChip.strokes = [{ type:'SOLID', color: COLORS.gold, opacity: 0.5 }];
  coinChip.strokeWeight = 1;
  coinChip.x = 580; coinChip.y = 480;
  const coinTxt = makeText('🪙  350', 'Inter', 'Bold', 12, COLORS.gold);
  coinTxt.x = 10; coinTxt.y = 6; coinChip.appendChild(coinTxt);
  bgFrame.appendChild(coinChip);

  const coinLbl = makeText('Chip/Coin Balance\n84×30 · bg-card · gold border', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  coinLbl.x = 580; coinLbl.y = 518; bgFrame.appendChild(coinLbl);

  // ── Bottom Nav Bar ───────────────────────────────────────────────
  const navBar = figma.createComponent();
  navBar.name = 'Navigation/Bottom Bar';
  navBar.resize(390, 60); navBar.fills = solidFill(COLORS.bgCard, 0.95);
  navBar.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.07 }];
  navBar.strokeWeight = 1; navBar.strokeAlign = 'INSIDE';
  navBar.x = 40; navBar.y = 560;

  const navItems = [
    { label: 'Home',     icon: '⌂', active: true },
    { label: 'Discover', icon: '◎', active: false },
    { label: 'Library',  icon: '☰', active: false },
    { label: 'Profile',  icon: '◉', active: false },
  ];
  navItems.forEach((item, i) => {
    const nx = 8 + i * 94;
    if (item.active) {
      const pill = figma.createRectangle();
      pill.name = 'ActivePill'; pill.resize(48, 32); pill.x = nx + 23; pill.y = 14;
      pill.cornerRadius = 12;
      pill.fills = [{ type:'SOLID', color:{r:1,g:0.176,b:0.471}, opacity:0.15 }];
      navBar.appendChild(pill);
    }
    const iconTxt = makeText(item.icon, 'Inter', 'Bold', 18, item.active ? COLORS.primary : COLORS.textHint, { align: 'CENTER' });
    iconTxt.x = nx + 29; iconTxt.y = 8; navBar.appendChild(iconTxt);
    const lblTxt = makeText(item.label, 'Inter', 'Bold', 9, item.active ? COLORS.primary : COLORS.textHint, { align: 'CENTER' });
    lblTxt.x = nx + 20; lblTxt.y = 42; navBar.appendChild(lblTxt);
  });
  bgFrame.appendChild(navBar);

  const navLbl = makeText('Navigation/Bottom Bar\n390×60 · glass dark · active neon glow pill', 'Inter', 'Regular', 10, COLORS.textHint, { wrap: true });
  navLbl.x = 40; navLbl.y = 628; bgFrame.appendChild(navLbl);
}

// ─── STEP 6: SCREENS PAGE ─────────────────────────────────────────────────────

async function buildScreensPage() {
  send({ type: 'progress', step: 'Building Screen Frames...', pct: 70 });

  let page = figma.root.children.find(p => p.name === '📱 Screens');
  if (!page) { page = figma.createPage(); page.name = '📱 Screens'; }
  figma.currentPage = page;

  const SCREEN_W = 390;
  const SCREEN_H = 844;
  const GAP = 80;
  const screens = [];

  // ── SPLASH SCREEN ──────────────────────────────────────────────
  {
    const f = makeFrame('Splash Screen', 0, 0, SCREEN_W, SCREEN_H);
    f.fills = solidFill(COLORS.bgDeep);

    // Background glow orbs
    const orb1 = figma.createEllipse();
    orb1.name = 'Glow/TopRight'; orb1.resize(280, 280); orb1.x = 160; orb1.y = -60;
    orb1.fills = [{ type:'SOLID', color: COLORS.accent, opacity: 0.18 }];
    orb1.effects = [{ type:'LAYER_BLUR', radius: 60, visible:true }];
    f.appendChild(orb1);

    const orb2 = figma.createEllipse();
    orb2.name = 'Glow/BottomLeft'; orb2.resize(300, 300); orb2.x = -80; orb2.y = 560;
    orb2.fills = [{ type:'SOLID', color: COLORS.primary, opacity: 0.2 }];
    orb2.effects = [{ type:'LAYER_BLUR', radius: 60, visible:true }];
    f.appendChild(orb2);

    // Logo circle
    const logoCircle = figma.createEllipse();
    logoCircle.name = 'Logo/Circle'; logoCircle.resize(100, 100); logoCircle.x = 145; logoCircle.y = 290;
    logoCircle.fills = gradientFill(GRADIENTS.primary);
    logoCircle.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.55}, offset:{x:0,y:0}, radius:30, spread:2, visible:true, blendMode:'NORMAL' }];
    f.appendChild(logoCircle);

    const playIcon = makeText('▶', 'Inter', 'Bold', 36, COLORS.white, { align: 'CENTER' });
    playIcon.resize(100, 50); playIcon.x = 145; playIcon.y = 315;
    f.appendChild(playIcon);

    // App name
    const appName = makeText('DRAMAVERSE', 'Oswald', 'Bold', 40, COLORS.white, { letterSpacing: 2, align: 'CENTER' });
    appName.resize(SCREEN_W, 48); appName.x = 0; appName.y = 416;
    f.appendChild(appName);

    // Tagline
    const tagline = makeText('Your Drama. Your Story.', 'Inter', 'Regular', 13, COLORS.textSecondary, { letterSpacing: 0.5, align: 'CENTER' });
    tagline.resize(SCREEN_W, 20); tagline.x = 0; tagline.y = 470;
    f.appendChild(tagline);

    // Loading dots
    [0, 1, 2].forEach((i) => {
      const dot = figma.createEllipse();
      dot.name = `Dot${i}`; dot.resize(6, 6);
      dot.x = 183 + i * 12; dot.y = 520;
      dot.fills = gradientFill(GRADIENTS.primary);
      f.appendChild(dot);
    });

    page.appendChild(f);
    screens.push(f);
  }

  // ── HOME SCREEN ────────────────────────────────────────────────
  {
    const f = makeFrame('Home Screen', SCREEN_W + GAP, 0, SCREEN_W, SCREEN_H);

    // App bar
    const appBar = figma.createRectangle();
    appBar.name = 'AppBar'; appBar.resize(SCREEN_W, 70); appBar.x = 0; appBar.y = 0;
    appBar.fills = solidFill(COLORS.bgDark);
    f.appendChild(appBar);

    const greeting = makeText('Good evening', 'Inter', 'Regular', 12, COLORS.textSecondary);
    greeting.x = 20; greeting.y = 14; f.appendChild(greeting);
    const appBarTitle = makeText('DRAMAVERSE', 'Oswald', 'Bold', 22, COLORS.white, { letterSpacing: 1 });
    appBarTitle.x = 20; appBarTitle.y = 30; f.appendChild(appBarTitle);

    // Coin chip
    const coin = figma.createRectangle();
    coin.name = 'CoinChip'; coin.resize(76, 28); coin.x = 290; coin.y = 22;
    coin.cornerRadius = 20; coin.fills = solidFill(COLORS.bgCard);
    coin.strokes = [{ type:'SOLID', color: COLORS.gold, opacity: 0.5 }]; coin.strokeWeight = 1;
    f.appendChild(coin);
    const coinTxt = makeText('🪙 350', 'Inter', 'Bold', 11, COLORS.gold);
    coinTxt.x = 296; coinTxt.y = 27; f.appendChild(coinTxt);

    // Featured section
    const featLabel = makeText('✦  FEATURED', 'Oswald', 'SemiBold', 16, COLORS.textPrimary, { letterSpacing: 1.2 });
    featLabel.x = 20; featLabel.y = 82; f.appendChild(featLabel);

    // Featured card
    const featCard = figma.createRectangle();
    featCard.name = 'FeaturedCard'; featCard.resize(340, 200); featCard.x = 25; featCard.y = 108;
    featCard.cornerRadius = 24; featCard.fills = gradientFill(GRADIENTS.dramatic);
    featCard.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.3}, offset:{x:0,y:8}, radius:24, spread:2, visible:true, blendMode:'NORMAL' }];
    f.appendChild(featCard);

    const featTitle = makeText('His Secret\nObsession', 'Inter', 'Extra Bold', 20, COLORS.white);
    featTitle.x = 45; featTitle.y = 270; f.appendChild(featTitle);

    const genrePill = figma.createRectangle();
    genrePill.name = 'GenrePill'; genrePill.resize(110, 24); genrePill.x = 45; genrePill.y = 248;
    genrePill.cornerRadius = 20;
    genrePill.fills = [{ type:'SOLID', color: COLORS.white, opacity: 0.15 }];
    genrePill.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.25 }]; genrePill.strokeWeight = 1;
    f.appendChild(genrePill);
    const genreTxt = makeText('DARK ROMANCE', 'Inter', 'Bold', 9, COLORS.white, { letterSpacing: 0.5 });
    genreTxt.x = 50; genreTxt.y = 252; f.appendChild(genreTxt);

    // Trending label
    const trendLabel = makeText('✦  TRENDING', 'Oswald', 'SemiBold', 16, COLORS.textPrimary, { letterSpacing: 1.2 });
    trendLabel.x = 20; trendLabel.y = 332; f.appendChild(trendLabel);

    // Small novel cards row
    [0, 1, 2].forEach((i) => {
      const sc = figma.createRectangle();
      sc.name = `SmallCard${i}`; sc.resize(110, 160); sc.x = 20 + i * 124; sc.y = 358;
      sc.cornerRadius = 14; sc.fills = gradientFill(GRADIENTS.dramatic);
      f.appendChild(sc);
      const st = makeText(`Novel ${i+1}`, 'Inter', 'Bold', 10, COLORS.textPrimary);
      st.x = 20 + i * 124; st.y = 526; f.appendChild(st);
    });

    // Bottom nav placeholder
    const nav = figma.createRectangle();
    nav.name = 'BottomNav'; nav.resize(SCREEN_W, 60); nav.x = 0; nav.y = SCREEN_H - 60;
    nav.fills = solidFill(COLORS.bgCard, 0.95);
    nav.strokes = [{ type:'SOLID', color: COLORS.white, opacity: 0.07 }]; nav.strokeWeight = 1;
    f.appendChild(nav);

    const navIcons = ['⌂', '◎', '☰', '◉'];
    const navLabels = ['Home', 'Discover', 'Library', 'Profile'];
    navIcons.forEach((ic, i) => {
      const nx = 24 + i * 92;
      const isTxt = makeText(ic, 'Inter', i===0?'Bold':'Regular', 18, i===0?COLORS.primary:COLORS.textHint, { align: 'CENTER' });
      isTxt.x = nx; isTxt.y = SCREEN_H - 52; f.appendChild(isTxt);
      const lTxt = makeText(navLabels[i], 'Inter', 'Bold', 9, i===0?COLORS.primary:COLORS.textHint, { align: 'CENTER' });
      lTxt.x = nx - 6; lTxt.y = SCREEN_H - 20; f.appendChild(lTxt);
    });

    page.appendChild(f);
    screens.push(f);
  }

  // ── NOVEL DETAIL SCREEN ────────────────────────────────────────
  {
    const f = makeFrame('Novel Detail Screen', (SCREEN_W + GAP) * 2, 0, SCREEN_W, SCREEN_H);

    // Hero image
    const hero = figma.createRectangle();
    hero.name = 'HeroCover'; hero.resize(SCREEN_W, 220); hero.x = 0; hero.y = 0;
    hero.fills = gradientFill(GRADIENTS.dramatic);
    f.appendChild(hero);

    // Gradient overlay
    const overlay = figma.createRectangle();
    overlay.name = 'HeroOverlay'; overlay.resize(SCREEN_W, 220); overlay.x = 0; overlay.y = 0;
    overlay.fills = [{ type:'GRADIENT_LINEAR',
      gradientTransform: [[0,1,0],[-1,0,1]],
      gradientStops: [
        { position:0, color:{r:0,g:0,b:0,a:0} },
        { position:1, color:{r:0.059,g:0.059,b:0.102,a:1} }
      ]
    }];
    f.appendChild(overlay);

    // Back button
    const backBtn = figma.createEllipse();
    backBtn.name = 'BackButton'; backBtn.resize(38, 38); backBtn.x = 16; backBtn.y = 48;
    backBtn.fills = [{ type:'SOLID', color:{r:0,g:0,b:0}, opacity:0.5 }];
    backBtn.strokes = [{ type:'SOLID', color: COLORS.white, opacity:0.2 }]; backBtn.strokeWeight = 1;
    f.appendChild(backBtn);
    const backArrow = makeText('←', 'Inter', 'Bold', 18, COLORS.white, { align: 'CENTER' });
    backArrow.x = 16; backArrow.y = 53; f.appendChild(backArrow);

    // Title
    const detailTitle = makeText('HIS SECRET OBSESSION', 'Oswald', 'Bold', 26, COLORS.white, { letterSpacing: 0.5, width: 350 });
    detailTitle.x = 20; detailTitle.y = 240; f.appendChild(detailTitle);

    const detailAuthor = makeText('by Sarah Mitchell', 'Inter', 'Regular', 14, COLORS.textSecondary);
    detailAuthor.x = 20; detailAuthor.y = 284; f.appendChild(detailAuthor);

    // Stats card
    const statsCard = figma.createRectangle();
    statsCard.name = 'StatsCard'; statsCard.resize(350, 60); statsCard.x = 20; statsCard.y = 314;
    statsCard.cornerRadius = 16; statsCard.fills = solidFill(COLORS.bgCard);
    statsCard.strokes = [{ type:'SOLID', color: COLORS.white, opacity:0.06 }]; statsCard.strokeWeight = 1;
    f.appendChild(statsCard);

    const stats = [['⭐ 4.8','Rating'], ['👁 2.5M','Reads'], ['📖 125','Chapters'], ['🟢','Ongoing']];
    stats.forEach(([val, lbl], i) => {
      const sx = 40 + i * 86;
      const sv = makeText(val, 'Inter', 'Bold', 11, COLORS.primary);
      sv.x = sx; sv.y = 320; f.appendChild(sv);
      const sl = makeText(lbl, 'Inter', 'Regular', 9, COLORS.textHint);
      sl.x = sx; sl.y = 337; f.appendChild(sl);
    });

    // Action buttons
    const readBtn = figma.createRectangle();
    readBtn.name = 'ReadButton'; readBtn.resize(220, 50); readBtn.x = 20; readBtn.y = 390;
    readBtn.cornerRadius = 14; readBtn.fills = gradientFill(GRADIENTS.primary);
    readBtn.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.45}, offset:{x:0,y:0}, radius:16, spread:1, visible:true, blendMode:'NORMAL' }];
    f.appendChild(readBtn);
    const readTxt = makeText('📖  READ', 'Oswald', 'Bold', 15, COLORS.white, { letterSpacing: 1, align: 'CENTER' });
    readTxt.resize(220, 20); readTxt.x = 20; readTxt.y = 405; f.appendChild(readTxt);

    const listenBtn = figma.createRectangle();
    listenBtn.name = 'ListenButton'; listenBtn.resize(130, 50); listenBtn.x = 250; listenBtn.y = 390;
    listenBtn.cornerRadius = 14; listenBtn.fills = solidFill(COLORS.bgCard);
    listenBtn.strokes = [{ type:'SOLID', color: COLORS.accent, opacity:0.5 }]; listenBtn.strokeWeight = 1;
    f.appendChild(listenBtn);
    const listenTxt = makeText('🎧  LISTEN', 'Oswald', 'Bold', 13, COLORS.accentLight, { letterSpacing: 1, align:'CENTER' });
    listenTxt.resize(130, 20); listenTxt.x = 250; listenTxt.y = 405; f.appendChild(listenTxt);

    // Chapter list
    const chapLabel = makeText('CHAPTERS', 'Oswald', 'SemiBold', 16, COLORS.textPrimary, { letterSpacing: 1.2 });
    chapLabel.x = 20; chapLabel.y = 460; f.appendChild(chapLabel);

    [0, 1, 2, 3].forEach((i) => {
      const isFree = i < 3;
      const chapTile = figma.createRectangle();
      chapTile.name = `ChapterTile/${i+1}`; chapTile.resize(350, 60); chapTile.x = 20; chapTile.y = 490 + i * 72;
      chapTile.cornerRadius = 14;
      chapTile.fills = solidFill(COLORS.bgCard);
      chapTile.strokes = [{ type:'SOLID', color: isFree ? COLORS.primary : COLORS.white, opacity: isFree ? 0.2 : 0.06 }];
      chapTile.strokeWeight = 1;
      f.appendChild(chapTile);

      const chapNum = figma.createEllipse();
      chapNum.name = 'ChapNum'; chapNum.resize(36, 36); chapNum.x = 32; chapNum.y = 502 + i * 72;
      chapNum.fills = isFree ? gradientFill(GRADIENTS.primary) : solidFill(COLORS.bgCardAlt);
      f.appendChild(chapNum);

      const chapNumTxt = makeText(`${i+1}`, 'Inter', 'Bold', 13, isFree ? COLORS.white : COLORS.textHint, { align:'CENTER' });
      chapNumTxt.resize(36, 20); chapNumTxt.x = 32; chapNumTxt.y = 507 + i * 72; f.appendChild(chapNumTxt);

      const chapTitle = makeText(`Chapter ${i+1}: ${i===0?'The Meeting':i===1?'First Kiss':i===2?'Hidden Truth':'Locked'}`, 'Inter', 'Bold', 12, COLORS.textPrimary, { width: 220 });
      chapTitle.x = 80; chapTitle.y = 502 + i * 72; f.appendChild(chapTitle);

      const badge = makeText(isFree ? 'FREE' : '🪙 2', 'Inter', 'Bold', 10, isFree ? COLORS.cyan : COLORS.gold);
      badge.x = 324; badge.y = 510 + i * 72; f.appendChild(badge);
    });

    page.appendChild(f);
    screens.push(f);
  }

  // ── CHAPTER READER SCREEN ─────────────────────────────────────
  {
    const f = makeFrame('Chapter Reader', (SCREEN_W + GAP) * 3, 0, SCREEN_W, SCREEN_H);
    f.fills = solidFill(COLORS.bgDark);

    // Top bar
    const topBar = figma.createRectangle();
    topBar.name = 'TopBar'; topBar.resize(SCREEN_W, 56); topBar.x = 0; topBar.y = 44;
    topBar.fills = solidFill(COLORS.bgDark, 0.95);
    f.appendChild(topBar);

    const backBtn2 = figma.createRectangle();
    backBtn2.name = 'BackBtn'; backBtn2.resize(38, 38); backBtn2.x = 16; backBtn2.y = 53;
    backBtn2.cornerRadius = 10; backBtn2.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.08 }];
    f.appendChild(backBtn2);
    const backTxt = makeText('←', 'Inter', 'Bold', 18, COLORS.white);
    backTxt.x = 20; backTxt.y = 57; f.appendChild(backTxt);

    const readerTitle = makeText('DARK ROMANCE', 'Inter', 'Bold', 11, COLORS.textSecondary, { align:'CENTER' });
    readerTitle.resize(200, 16); readerTitle.x = 95; readerTitle.y = 58; f.appendChild(readerTitle);
    const readerChap = makeText('Chapter 4', 'Inter', 'Regular', 10, COLORS.textHint, { align:'CENTER' });
    readerChap.resize(200, 14); readerChap.x = 95; readerChap.y = 74; f.appendChild(readerChap);

    const settingsBtn = figma.createRectangle();
    settingsBtn.name = 'SettingsBtn'; settingsBtn.resize(38, 38); settingsBtn.x = 336; settingsBtn.y = 53;
    settingsBtn.cornerRadius = 10; settingsBtn.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.08 }];
    f.appendChild(settingsBtn);
    const settingsTxt = makeText('⚙', 'Inter', 'Regular', 18, COLORS.textPrimary);
    settingsTxt.x = 340; settingsTxt.y = 57; f.appendChild(settingsTxt);

    // Chapter tag
    const chapTag = figma.createRectangle();
    chapTag.name = 'ChapterTag'; chapTag.resize(90, 22); chapTag.x = 20; chapTag.y = 114;
    chapTag.cornerRadius = 6; chapTag.fills = gradientFill(GRADIENTS.primary);
    f.appendChild(chapTag);
    const chapTagTxt = makeText('CHAPTER 4', 'Inter', 'Bold', 9, COLORS.white, { letterSpacing: 0.5 });
    chapTagTxt.x = 26; chapTagTxt.y = 118; f.appendChild(chapTagTxt);

    // Chapter title
    const chapTitleTxt = makeText('The Revelation', 'Oswald', 'Bold', 26, COLORS.white, { letterSpacing: 0.5, width: 350 });
    chapTitleTxt.x = 20; chapTitleTxt.y = 148; f.appendChild(chapTitleTxt);

    // Divider line
    const divL = figma.createRectangle();
    divL.name = 'DivLeft'; divL.resize(60, 2); divL.x = 20; divL.y = 196;
    divL.fills = gradientFill(GRADIENTS.primary); f.appendChild(divL);
    const divDot = makeText('✦', 'Inter', 'Bold', 14, COLORS.primary, { align:'CENTER' });
    divDot.x = 90; divDot.y = 188; f.appendChild(divDot);
    const divR = figma.createRectangle();
    divR.name = 'DivRight'; divR.resize(60, 2); divR.x = 110; divR.y = 196;
    divR.fills = gradientFill(GRADIENTS.accent); f.appendChild(divR);

    // Body text lines
    const bodyLines = [
      'The silence between them stretched like',
      'a wound that refused to heal. Alexander',
      'stepped closer, his cologne a familiar',
      'memory she couldn\'t erase...',
      '',
      '"You knew," she whispered. "You knew',
      'all along and said nothing."',
      '',
      'His jaw tightened. The moonlight carved',
      'shadows across the sharp angles of his',
      'face — beautiful, devastating, dangerous.',
    ];
    bodyLines.forEach((line, i) => {
      if (!line) return;
      const lt = makeText(line, 'Inter', 'Regular', 16, COLORS.textPrimary);
      lt.x = 24; lt.y = 218 + i * 30; f.appendChild(lt);
    });

    // Bottom bar
    const botBar = figma.createRectangle();
    botBar.name = 'BottomBar'; botBar.resize(SCREEN_W, 80); botBar.x = 0; botBar.y = SCREEN_H - 80;
    botBar.fills = solidFill(COLORS.bgDark, 0.95); f.appendChild(botBar);

    // Progress bar
    const progBg = figma.createRectangle();
    progBg.name = 'ProgressBg'; progBg.resize(350, 3); progBg.x = 20; progBg.y = SCREEN_H - 74;
    progBg.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.1 }]; progBg.cornerRadius = 2;
    f.appendChild(progBg);
    const progFill = figma.createRectangle();
    progFill.name = 'ProgressFill'; progFill.resize(140, 3); progFill.x = 20; progFill.y = SCREEN_H - 74;
    progFill.fills = gradientFill(GRADIENTS.primary); progFill.cornerRadius = 2;
    progFill.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.6}, offset:{x:0,y:0}, radius:4, spread:0, visible:true, blendMode:'NORMAL' }];
    f.appendChild(progFill);

    const prevBtn = figma.createRectangle();
    prevBtn.name = 'PrevBtn'; prevBtn.resize(80, 32); prevBtn.x = 20; prevBtn.y = SCREEN_H - 56;
    prevBtn.cornerRadius = 20; prevBtn.fills = solidFill(COLORS.bgCard);
    f.appendChild(prevBtn);
    const prevTxt = makeText('← PREV', 'Inter', 'Bold', 10, COLORS.textHint, { align:'CENTER' });
    prevTxt.resize(80, 16); prevTxt.x = 20; prevTxt.y = SCREEN_H - 48; f.appendChild(prevTxt);

    const nextBtn = figma.createRectangle();
    nextBtn.name = 'NextBtn'; nextBtn.resize(80, 32); nextBtn.x = SCREEN_W - 100; nextBtn.y = SCREEN_H - 56;
    nextBtn.cornerRadius = 20; nextBtn.fills = gradientFill(GRADIENTS.primary);
    nextBtn.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.45}, offset:{x:0,y:0}, radius:10, spread:0, visible:true, blendMode:'NORMAL' }];
    f.appendChild(nextBtn);
    const nextTxt = makeText('NEXT →', 'Inter', 'Bold', 10, COLORS.white, { align:'CENTER' });
    nextTxt.resize(80, 16); nextTxt.x = SCREEN_W - 100; nextTxt.y = SCREEN_H - 48; f.appendChild(nextTxt);

    page.appendChild(f);
    screens.push(f);
  }

  // ── AUDIO PLAYER SCREEN ────────────────────────────────────────
  {
    const f = makeFrame('Audio Player', (SCREEN_W + GAP) * 4, 0, SCREEN_W, SCREEN_H);
    f.fills = solidFill(COLORS.bgDeep);

    // BG orbs
    const aOrb1 = figma.createEllipse();
    aOrb1.name = 'Orb1'; aOrb1.resize(260, 260); aOrb1.x = 140; aOrb1.y = -40;
    aOrb1.fills = [{ type:'SOLID', color: COLORS.primary, opacity:0.18 }];
    aOrb1.effects = [{ type:'LAYER_BLUR', radius:60, visible:true }];
    f.appendChild(aOrb1);

    const aOrb2 = figma.createEllipse();
    aOrb2.name = 'Orb2'; aOrb2.resize(240, 240); aOrb2.x = -80; aOrb2.y = 580;
    aOrb2.fills = [{ type:'SOLID', color: COLORS.accent, opacity:0.2 }];
    aOrb2.effects = [{ type:'LAYER_BLUR', radius:60, visible:true }];
    f.appendChild(aOrb2);

    // Top bar
    const nowPlaying = makeText('NOW PLAYING', 'Inter', 'Bold', 11, COLORS.textSecondary, { letterSpacing: 1.5, align:'CENTER' });
    nowPlaying.resize(SCREEN_W, 18); nowPlaying.x = 0; nowPlaying.y = 64;
    f.appendChild(nowPlaying);

    // Album art
    const album = figma.createRectangle();
    album.name = 'AlbumArt'; album.resize(260, 260); album.x = 65; album.y = 140;
    album.cornerRadius = 20; album.fills = gradientFill(GRADIENTS.dramatic);
    album.effects = [
      { type:'DROP_SHADOW', color:{...COLORS.primary,a:0.4}, offset:{x:0,y:0}, radius:40, spread:0, visible:true, blendMode:'NORMAL' },
      { type:'DROP_SHADOW', color:{...COLORS.accent,a:0.3}, offset:{x:0,y:0}, radius:60, spread:0, visible:true, blendMode:'NORMAL' },
    ];
    f.appendChild(album);

    // Track info
    const trackTitle = makeText('HIS SECRET OBSESSION', 'Inter', 'Extra Bold', 20, COLORS.white, { letterSpacing: -0.3, align:'CENTER' });
    trackTitle.resize(SCREEN_W - 40, 28); trackTitle.x = 20; trackTitle.y = 426; f.appendChild(trackTitle);
    const trackChap = makeText('Chapter 4 — The Revelation', 'Inter', 'Regular', 14, COLORS.textSecondary, { align:'CENTER' });
    trackChap.resize(SCREEN_W - 40, 20); trackChap.x = 20; trackChap.y = 460; f.appendChild(trackChap);

    // Progress bar
    const pBg = figma.createRectangle();
    pBg.name = 'ProgressBg'; pBg.resize(350, 4); pBg.x = 20; pBg.y = 500;
    pBg.cornerRadius = 2; pBg.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.12 }];
    f.appendChild(pBg);
    const pFill = figma.createRectangle();
    pFill.name = 'ProgressFill'; pFill.resize(140, 4); pFill.x = 20; pFill.y = 500;
    pFill.cornerRadius = 2; pFill.fills = gradientFill(GRADIENTS.primary);
    f.appendChild(pFill);
    const thumb = figma.createEllipse();
    thumb.name = 'Thumb'; thumb.resize(12, 12); thumb.x = 154; thumb.y = 496;
    thumb.fills = solidFill(COLORS.white); f.appendChild(thumb);

    const timeStart = makeText('12:30', 'Inter', 'Regular', 10, COLORS.textHint);
    timeStart.x = 20; timeStart.y = 512; f.appendChild(timeStart);
    const timeEnd = makeText('45:00', 'Inter', 'Regular', 10, COLORS.textHint);
    timeEnd.x = 355; timeEnd.y = 512; f.appendChild(timeEnd);

    // Speed selector
    const speedRow = makeText('SPEED  1.0x  1.25x  1.5x  2.0x', 'Inter', 'Bold', 11, COLORS.textSecondary, { align:'CENTER' });
    speedRow.resize(SCREEN_W, 16); speedRow.x = 0; speedRow.y = 542; f.appendChild(speedRow);

    // Controls
    const playBtn = figma.createEllipse();
    playBtn.name = 'PlayPause'; playBtn.resize(72, 72); playBtn.x = 159; playBtn.y = 580;
    playBtn.fills = gradientFill(GRADIENTS.primary);
    playBtn.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.55}, offset:{x:0,y:0}, radius:24, spread:2, visible:true, blendMode:'NORMAL' }];
    f.appendChild(playBtn);
    const playTxt = makeText('▶', 'Inter', 'Bold', 28, COLORS.white, { align:'CENTER' });
    playTxt.resize(72, 40); playTxt.x = 159; playTxt.y = 594; f.appendChild(playTxt);

    const rew = makeText('↺10', 'Inter', 'Bold', 22, COLORS.textPrimary, { align:'CENTER' });
    rew.x = 90; rew.y = 596; f.appendChild(rew);
    const fwd = makeText('10↻', 'Inter', 'Bold', 22, COLORS.textPrimary, { align:'CENTER' });
    fwd.x = 260; fwd.y = 596; f.appendChild(fwd);
    const skipPrev = makeText('⏮', 'Inter', 'Regular', 22, COLORS.textSecondary);
    skipPrev.x = 40; skipPrev.y = 596; f.appendChild(skipPrev);
    const skipNext = makeText('⏭', 'Inter', 'Regular', 22, COLORS.textSecondary);
    skipNext.x = 316; skipNext.y = 596; f.appendChild(skipNext);

    page.appendChild(f);
    screens.push(f);
  }

  // ── LIBRARY SCREEN ────────────────────────────────────────────
  {
    const f = makeFrame('Library Screen', (SCREEN_W + GAP) * 5, 0, SCREEN_W, SCREEN_H);

    const libHeader = makeText('MY LIBRARY', 'Oswald', 'Bold', 28, COLORS.white, { letterSpacing: 1 });
    libHeader.x = 20; libHeader.y = 56; f.appendChild(libHeader);

    // Tab bar
    const tabBg = figma.createRectangle();
    tabBg.name = 'TabBar'; tabBg.resize(350, 44); tabBg.x = 20; tabBg.y = 104;
    tabBg.cornerRadius = 22; tabBg.fills = solidFill(COLORS.bgCard);
    tabBg.strokes = [{ type:'SOLID', color: COLORS.white, opacity:0.06 }]; tabBg.strokeWeight = 1;
    f.appendChild(tabBg);

    const activeTab = figma.createRectangle();
    activeTab.name = 'ActiveTab'; activeTab.resize(168, 36); activeTab.x = 24; activeTab.y = 108;
    activeTab.cornerRadius = 22; activeTab.fills = gradientFill(GRADIENTS.primary);
    activeTab.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.4}, offset:{x:0,y:0}, radius:8, spread:0, visible:true, blendMode:'NORMAL' }];
    f.appendChild(activeTab);

    const tabTxt1 = makeText('READING', 'Inter', 'Bold', 12, COLORS.white, { align:'CENTER' });
    tabTxt1.resize(168, 16); tabTxt1.x = 24; tabTxt1.y = 118; f.appendChild(tabTxt1);
    const tabTxt2 = makeText('BOOKMARKS', 'Inter', 'Bold', 12, COLORS.textHint, { align:'CENTER' });
    tabTxt2.resize(168, 16); tabTxt2.x = 200; tabTxt2.y = 118; f.appendChild(tabTxt2);

    // Reading cards
    [0, 1, 2].forEach((i) => {
      const rc = figma.createRectangle();
      rc.name = `ReadingCard/${i}`; rc.resize(350, 110); rc.x = 20; rc.y = 168 + i * 128;
      rc.cornerRadius = 16; rc.fills = solidFill(COLORS.bgCard);
      rc.strokes = [{ type:'SOLID', color: COLORS.white, opacity:0.06 }]; rc.strokeWeight = 1;
      f.appendChild(rc);

      const rCover = figma.createRectangle();
      rCover.name = 'Cover'; rCover.resize(76, 110); rCover.x = 20; rCover.y = 168 + i * 128;
      rCover.cornerRadius = 16; rCover.fills = gradientFill(GRADIENTS.dramatic);
      f.appendChild(rCover);

      const rTitle = makeText(`Novel Title ${i+1}`, 'Inter', 'Bold', 13, COLORS.textPrimary, { width: 240 });
      rTitle.x = 108; rTitle.y = 178 + i * 128; f.appendChild(rTitle);

      const rChap = makeText(`Chapter ${(i+1)*4} of 125`, 'Inter', 'Regular', 11, COLORS.textSecondary);
      rChap.x = 108; rChap.y = 200 + i * 128; f.appendChild(rChap);

      // Progress bar
      const pBg = figma.createRectangle();
      pBg.name = 'ProgBg'; pBg.resize(240, 4); pBg.x = 108; pBg.y = 224 + i * 128;
      pBg.cornerRadius = 2; pBg.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.1 }];
      f.appendChild(pBg);
      const pct = (i + 1) * 0.15 + 0.1;
      const pFill = figma.createRectangle();
      pFill.name = 'ProgFill'; pFill.resize(Math.round(240 * pct), 4); pFill.x = 108; pFill.y = 224 + i * 128;
      pFill.cornerRadius = 2; pFill.fills = gradientFill(GRADIENTS.primary);
      f.appendChild(pFill);

      const contBtn = figma.createRectangle();
      contBtn.name = 'ContinueBtn'; contBtn.resize(80, 26); contBtn.x = 270; contBtn.y = 244 + i * 128;
      contBtn.cornerRadius = 13; contBtn.fills = gradientFill(GRADIENTS.primary);
      f.appendChild(contBtn);
      const contTxt = makeText('CONTINUE', 'Inter', 'Bold', 8, COLORS.white, { letterSpacing: 0.3, align:'CENTER' });
      contTxt.resize(80, 14); contTxt.x = 270; contTxt.y = 250 + i * 128; f.appendChild(contTxt);
    });

    // Bottom nav
    const nav2 = figma.createRectangle();
    nav2.name = 'BottomNav'; nav2.resize(SCREEN_W, 60); nav2.x = 0; nav2.y = SCREEN_H - 60;
    nav2.fills = solidFill(COLORS.bgCard, 0.95);
    nav2.strokes = [{ type:'SOLID', color: COLORS.white, opacity:0.07 }]; nav2.strokeWeight = 1;
    f.appendChild(nav2);

    page.appendChild(f);
    screens.push(f);
  }

  // ── LOCKED CHAPTER SCREEN ─────────────────────────────────────
  {
    const f = makeFrame('Locked Chapter', (SCREEN_W + GAP) * 6, 0, SCREEN_W, SCREEN_H);
    f.fills = solidFill(COLORS.bgDark);

    // Semi-transparent cover bg
    const covBg = figma.createRectangle();
    covBg.name = 'CoverBg'; covBg.resize(SCREEN_W, SCREEN_H); covBg.x = 0; covBg.y = 0;
    covBg.fills = gradientFill(GRADIENTS.dramatic, 180); covBg.opacity = 0.15;
    f.appendChild(covBg);

    const backBtnL = figma.createRectangle();
    backBtnL.name = 'BackBtn'; backBtnL.resize(40, 40); backBtnL.x = 16; backBtnL.y = 52;
    backBtnL.cornerRadius = 10; backBtnL.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.08 }];
    f.appendChild(backBtnL);
    const backTxtL = makeText('←', 'Inter', 'Bold', 18, COLORS.white);
    backTxtL.x = 20; backTxtL.y = 56; f.appendChild(backTxtL);

    // Lock icon
    const lockCircle = figma.createEllipse();
    lockCircle.name = 'LockCircle'; lockCircle.resize(80, 80); lockCircle.x = 155; lockCircle.y = 280;
    lockCircle.fills = solidFill(COLORS.bgCard);
    lockCircle.strokes = [{ type:'SOLID', color: COLORS.primary, opacity:1 }]; lockCircle.strokeWeight = 1.5;
    lockCircle.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.45}, offset:{x:0,y:0}, radius:20, spread:1, visible:true, blendMode:'NORMAL' }];
    f.appendChild(lockCircle);
    const lockTxt = makeText('🔒', 'Inter', 'Regular', 32, COLORS.primary, { align:'CENTER' });
    lockTxt.resize(80, 46); lockTxt.x = 155; lockTxt.y = 294; f.appendChild(lockTxt);

    const lockTitle = makeText('CHAPTER 5 LOCKED', 'Oswald', 'Bold', 26, COLORS.white, { letterSpacing: 0.5, align:'CENTER' });
    lockTitle.resize(SCREEN_W - 40, 36); lockTitle.x = 20; lockTitle.y = 380; f.appendChild(lockTitle);

    const lockDesc = makeText('Unlock this chapter with 2 coins\nor get VIP to read everything free', 'Inter', 'Regular', 14, COLORS.textSecondary, { align:'CENTER', wrap: true });
    lockDesc.resize(300, 48); lockDesc.x = 45; lockDesc.y = 428; f.appendChild(lockDesc);

    const coinBal = makeText('🪙  Your balance: 350 coins', 'Inter', 'Bold', 14, COLORS.gold, { align:'CENTER' });
    coinBal.resize(SCREEN_W - 40, 20); coinBal.x = 20; coinBal.y = 490; f.appendChild(coinBal);

    const unlockBtn = figma.createRectangle();
    unlockBtn.name = 'UnlockBtn'; unlockBtn.resize(310, 52); unlockBtn.x = 40; unlockBtn.y = 530;
    unlockBtn.cornerRadius = 14; unlockBtn.fills = gradientFill(GRADIENTS.primary);
    unlockBtn.effects = [{ type:'DROP_SHADOW', color:{...COLORS.primary,a:0.5}, offset:{x:0,y:0}, radius:20, spread:1, visible:true, blendMode:'NORMAL' }];
    f.appendChild(unlockBtn);
    const unlockTxt = makeText('🔓  UNLOCK FOR 2 COINS', 'Oswald', 'Bold', 15, COLORS.white, { letterSpacing: 1, align:'CENTER' });
    unlockTxt.resize(310, 20); unlockTxt.x = 40; unlockTxt.y = 546; f.appendChild(unlockTxt);

    const vipBtn = figma.createRectangle();
    vipBtn.name = 'VIPBtn'; vipBtn.resize(310, 50); vipBtn.x = 40; vipBtn.y = 596;
    vipBtn.cornerRadius = 14; vipBtn.fills = solidFill(COLORS.bgCard);
    vipBtn.strokes = [{ type:'SOLID', color: COLORS.accent, opacity:0.5 }]; vipBtn.strokeWeight = 1;
    f.appendChild(vipBtn);
    const vipTxt = makeText('👑  GET VIP — READ ALL FREE', 'Oswald', 'Bold', 13, COLORS.accentLight, { letterSpacing: 1, align:'CENTER' });
    vipTxt.resize(310, 20); vipTxt.x = 40; vipTxt.y = 611; f.appendChild(vipTxt);

    page.appendChild(f);
    screens.push(f);
  }
}

// ─── STEP 7: SPECS PAGE ───────────────────────────────────────────────────────

async function buildSpecsPage() {
  send({ type: 'progress', step: 'Building Specs Page...', pct: 90 });

  let page = figma.root.children.find(p => p.name === '📋 Specs');
  if (!page) { page = figma.createPage(); page.name = '📋 Specs'; }
  figma.currentPage = page;

  const bg = figma.createFrame();
  bg.name = 'Specs'; bg.x = 0; bg.y = 0; bg.resize(1200, 1400);
  bg.fills = solidFill(COLORS.bgDeep);
  page.appendChild(bg);

  const title = makeText('DRAMAVERSE — DESIGN SPECS', 'Oswald', 'Bold', 28, COLORS.white, { letterSpacing: 1.5 });
  title.x = 40; title.y = 40; bg.appendChild(title);

  const specsData = [
    { section: 'SCREEN DIMENSIONS', items: [
      ['Mobile frame', '390 × 844 px (iPhone 14 Pro)'],
      ['Status bar', '44 px height'],
      ['Bottom safe area', '34 px'],
      ['AppBar height', '56–70 px'],
      ['Bottom nav height', '60 px'],
    ]},
    { section: 'SPACING', items: [
      ['xs', '4 px'],
      ['sm', '8 px'],
      ['md', '12 px'],
      ['lg', '16 px'],
      ['xl', '20 px'],
      ['2xl', '24 px'],
      ['3xl', '32 px'],
      ['Screen horizontal padding', '20 px'],
    ]},
    { section: 'BORDER RADIUS', items: [
      ['sm — chips, badges', '6–8 px'],
      ['md — inputs', '12 px'],
      ['lg — standard cards', '14–16 px'],
      ['xl — featured cards', '20–24 px'],
      ['pill — buttons, tags', '30 px'],
      ['full — avatars, dots', '9999 px'],
    ]},
    { section: 'COMPONENT HEIGHTS', items: [
      ['Primary button', '50–56 px'],
      ['Bottom nav bar', '60 px'],
      ['Mini player', '62 px'],
      ['Chapter tile', '60 px'],
      ['Reading card', '110 px'],
      ['Genre chip', '36 px'],
      ['Novel card (vertical)', '120 × 220 px'],
      ['Novel card (wide)', '340 × 110 px'],
      ['Featured card', '340 × 200 px'],
      ['Audio play button', '72 × 72 px'],
    ]},
    { section: 'ANIMATION TIMING', items: [
      ['Screen transition', '300 ms ease-out'],
      ['Button press scale', '100 ms linear (→ 0.96)'],
      ['Featured card scale', '300 ms ease-out'],
      ['Chip select', '200 ms ease-in-out'],
      ['Neon glow pulse', '1500 ms repeat-reverse'],
      ['Loading dots', '600 ms stagger 150 ms'],
      ['UI show/hide (reader)', '250 ms ease-in-out'],
      ['Album art size', '400 ms ease-out'],
    ]},
    { section: 'FONT USAGE', items: [
      ['Oswald Bold 40px', 'Display titles, app name'],
      ['Oswald Bold 26–30px', 'Screen headers'],
      ['Oswald SemiBold 16–18px', 'Section labels'],
      ['Inter ExtraBold 20px', 'Card titles'],
      ['Inter Bold 13–16px', 'UI titles, buttons'],
      ['Inter Regular 12–16px', 'Body text, metadata'],
      ['Inter Bold 10px', 'Labels, badges'],
      ['Crimson Text Regular 18px', 'Chapter reading body'],
    ]},
  ];

  let colY = 100;
  specsData.forEach((sec, si) => {
    const cx = 40 + (si % 2) * 580;
    const cy = colY + Math.floor(si / 2) * 320;

    const secTitle = makeText(sec.section, 'Oswald', 'Bold', 16, COLORS.primary, { letterSpacing: 1.5 });
    secTitle.x = cx; secTitle.y = cy; bg.appendChild(secTitle);

    const divider = figma.createRectangle();
    divider.name = 'Divider'; divider.resize(520, 1); divider.x = cx; divider.y = cy + 28;
    divider.fills = [{ type:'SOLID', color: COLORS.white, opacity:0.08 }];
    bg.appendChild(divider);

    sec.items.forEach(([key, val], ii) => {
      const itemBg = figma.createRectangle();
      itemBg.name = 'ItemBg'; itemBg.resize(520, 28); itemBg.x = cx; itemBg.y = cy + 36 + ii * 30;
      itemBg.fills = [{ type:'SOLID', color: ii%2===0?COLORS.bgCard:COLORS.bgDeep, opacity:0.5 }];
      itemBg.cornerRadius = 4;
      bg.appendChild(itemBg);

      const keyTxt = makeText(key, 'Inter', 'Regular', 11, COLORS.textSecondary);
      keyTxt.x = cx + 10; keyTxt.y = cy + 44 + ii * 30; bg.appendChild(keyTxt);

      const valTxt = makeText(val, 'Inter', 'Bold', 11, COLORS.textPrimary);
      valTxt.x = cx + 280; valTxt.y = cy + 44 + ii * 30; bg.appendChild(valTxt);
    });
  });
}

// ─── MAIN ────────────────────────────────────────────────────────────────────

async function buildAll() {
  try {
    send({ type: 'progress', step: 'Loading fonts...', pct: 2 });
    await loadFonts();

    await createColorStyles();
    await createEffectStyles();
    await createTextStyles();
    await buildTokensPage();
    await buildComponentsPage();
    await buildScreensPage();
    await buildSpecsPage();

    // Rename first (default) page or remove it
    const defaultPage = figma.root.children.find(p => p.name === 'Page 1');
    if (defaultPage && figma.root.children.length > 1) {
      defaultPage.name = '🚀 Start Here';
      figma.currentPage = defaultPage;

      const startFrame = figma.createFrame();
      startFrame.name = 'Welcome'; startFrame.x = 0; startFrame.y = 0;
      startFrame.resize(800, 400); startFrame.fills = gradientFill(GRADIENTS.dramatic);
      startFrame.cornerRadius = 24;

      const welcome = makeText('DRAMAVERSE DESIGN SYSTEM', 'Oswald', 'Bold', 36, COLORS.white, { letterSpacing: 2, align:'CENTER' });
      welcome.resize(720, 48); welcome.x = 40; welcome.y = 80; startFrame.appendChild(welcome);

      const sub = makeText('Navigate the pages to explore: 🎨 Tokens  •  📐 Components  •  📱 Screens  •  📋 Specs', 'Inter', 'Regular', 16, COLORS.textSecondary, { align:'CENTER', wrap: true });
      sub.resize(720, 52); sub.x = 40; sub.y = 148; startFrame.appendChild(sub);

      const built = makeText('Built with DramaVerse Design System Builder Plugin  •  v1.0.0', 'Inter', 'Regular', 12, COLORS.textHint, { align:'CENTER' });
      built.resize(720, 18); built.x = 40; built.y = 260; startFrame.appendChild(built);

      defaultPage.appendChild(startFrame);
    }

    send({ type: 'progress', step: 'Done! ✅', pct: 100 });
    send({ type: 'done' });

  } catch (err) {
    send({ type: 'error', message: String(err) });
  }
}

figma.ui.onmessage = (msg) => {
  if (msg.type === 'build') buildAll();
  if (msg.type === 'close') figma.closePlugin();
};
