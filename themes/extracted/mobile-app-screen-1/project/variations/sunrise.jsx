// Variation B — Sunrise (Vibrant / Gamified, Dark Mode)
// Deep plum-night with marigold + magenta accents. Manrope display.
// Sadhana journey, ring progress, devotional feedback.

const SR = {
  bg: '#1a1230',
  bg2: '#241844',
  card: '#2a1d52',
  cardHi: '#352366',
  ink: '#f5e6ff',
  ink2: '#b9a4d8',
  ink3: '#7a6699',
  line: 'rgba(255,255,255,0.08)',
  marigold: '#ffb13b',
  marigoldDeep: '#ff8c1a',
  magenta: '#ff4d8d',
  jade: '#3ddc97',
  cyan: '#5ad7ff',
  sans: '"Manrope", system-ui, sans-serif',
  mono: '"JetBrains Mono", ui-monospace, monospace',
  mal: '"Noto Sans Malayalam", "Manrope", system-ui, sans-serif'
};

const SrIcon = ({ d, size = 20, color = SR.ink, sw = 1.8 }) =>
<svg width={size} height={size} viewBox="0 0 24 24" fill="none"
stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;


const sr_plus = <><path d="M12 5v14M5 12h14" /></>;
const sr_dots = <><circle cx="12" cy="5" r="1.5" fill={SR.ink} stroke="none" /><circle cx="12" cy="12" r="1.5" fill={SR.ink} stroke="none" /><circle cx="12" cy="19" r="1.5" fill={SR.ink} stroke="none" /></>;
const sr_back = <><path d="M15 6l-6 6 6 6" /></>;
const sr_cal = <><rect x="4" y="5" width="16" height="15" rx="2" /><path d="M8 3v4M16 3v4M4 10h16" /></>;
const sr_trash = <><path d="M4 7h16M9 7V5a2 2 0 012-2h2a2 2 0 012 2v2M6 7l1 13a2 2 0 002 2h6a2 2 0 002-2l1-13" /></>;
const sr_chevR = <><path d="M9 6l6 6-6 6" /></>;
const sr_check = <><path d="M5 12l5 5L20 7" /></>;
const sr_play = <><path d="M7 5l12 7-12 7V5z" fill={SR.ink} stroke="none" /></>;
const sr_bell = <><path d="M6 16V11a6 6 0 0112 0v5l1.5 2h-15L6 16zM10 20a2 2 0 004 0" /></>;
const sr_vibrate = <><rect x="9" y="6" width="6" height="12" rx="1" /><path d="M5 9v6M19 9v6M3 11v2M21 11v2" /></>;
const sr_sound = <><path d="M5 10v4h3l4 4V6L8 10H5zM16 9a4 4 0 010 6" /></>;
const sr_music = <><path d="M9 17V5l10-2v12" /><circle cx="7" cy="17" r="2" /><circle cx="17" cy="15" r="2" /></>;
const sr_file = <><path d="M14 3H7a2 2 0 00-2 2v14a2 2 0 002 2h10a2 2 0 002-2V8l-5-5zM14 3v5h5" /></>;
const sr_clock = <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>;
const sr_brightness = <><circle cx="12" cy="12" r="4" /><path d="M12 3v2M12 19v2M3 12h2M19 12h2M5.5 5.5l1.4 1.4M17.1 17.1l1.4 1.4M5.5 18.5l1.4-1.4M17.1 6.9l1.4-1.4" /></>;
const sr_flame = <><path d="M12 3c0 4-5 5-5 10a5 5 0 0010 0c0-2-1-3-2-4 0 1-1 2-2 2 0-3 1-5-1-8z" /></>;
const sr_trophy = <><path d="M8 4h8v6a4 4 0 01-8 0V4zM8 7H5v2a3 3 0 003 3M16 7h3v2a3 3 0 01-3 3M9 18h6M12 14v4" /></>;
const sr_lotus = <><path d="M12 21 C 5 16, 4 9, 4 4 C 8 6, 11 11, 12 17 C 13 11, 16 6, 20 4 C 20 9, 19 16, 12 21 Z" /></>;
const sr_zap = <><path d="M13 3L4 14h7l-1 7 9-11h-7l1-7z" /></>;
const sr_minus = <><path d="M5 12h14" /></>;
const sr_settings = <><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.7 1.7 0 00.3 1.8l.1.1a2 2 0 11-2.8 2.8l-.1-.1a1.7 1.7 0 00-1.8-.3 1.7 1.7 0 00-1 1.5V21a2 2 0 11-4 0v-.1a1.7 1.7 0 00-1-1.5 1.7 1.7 0 00-1.9.3l-.1.1a2 2 0 11-2.8-2.8l.1-.1a1.7 1.7 0 00.3-1.8 1.7 1.7 0 00-1.5-1H3a2 2 0 110-4h.1a1.7 1.7 0 001.5-1 1.7 1.7 0 00-.3-1.9l-.1-.1a2 2 0 112.8-2.8l.1.1a1.7 1.7 0 001.8.3H9a1.7 1.7 0 001-1.5V3a2 2 0 114 0v.1a1.7 1.7 0 001 1.5 1.7 1.7 0 001.9-.3l.1-.1a2 2 0 112.8 2.8l-.1.1a1.7 1.7 0 00-.3 1.8V9a1.7 1.7 0 001.5 1H21a2 2 0 110 4h-.1a1.7 1.7 0 00-1.5 1z" /></>;

// pill button
const srPillBtn = (extra = {}) => ({
  height: 36, padding: '0 14px', borderRadius: 100,
  background: SR.cardHi, color: SR.ink, border: `1px solid ${SR.line}`,
  display: 'inline-flex', alignItems: 'center', gap: 6,
  fontFamily: SR.sans, fontWeight: 700, fontSize: 13, cursor: 'pointer',
  ...extra
});

// ─────────────────────────────────────────────────────────────
// Screen 1 — Counter list
// ─────────────────────────────────────────────────────────────
function SunriseList() {
  const items = [
  { t: 'ലളിതാ സഹസ്രനാമം', en: 'Lalita Sahasranama', count: 31, mala: 0, today: 1, daily: 100, life: 3.1, color: SR.magenta, lifeShown: true },
  { t: 'കൃഷ്ണായ നമ', en: 'Krishnaya Namah', count: 3456, mala: 32, today: 108, daily: 100, life: null, color: SR.cyan, lifeShown: false },
  { t: 'ഗണപതയേ നമ', en: 'Ganapataye Namah', count: 3456, mala: 32, today: 108, daily: 100, life: null, color: SR.marigold, lifeShown: false },
  { t: 'Om Durgaayai Namaha', en: null, count: 17543, mala: 162, today: 108, daily: 4.3, life: 1.5, color: SR.jade, lifeShown: true }];

  return (
    <div style={{ background: SR.bg, minHeight: '100%', fontFamily: SR.sans, color: SR.ink, position: 'relative' }}>
      {/* glow */}
      <div style={{ position: 'absolute', top: -100, left: -50, width: 300, height: 300, background: 'radial-gradient(circle, rgba(255,77,141,0.25), transparent 70%)', pointerEvents: 'none' }} />
      <div style={{ position: 'absolute', top: -120, right: -80, width: 320, height: 320, background: 'radial-gradient(circle, rgba(255,177,59,0.2), transparent 70%)', pointerEvents: 'none' }} />

      <div style={{ padding: '20px 18px 12px', position: 'relative', height: "80px" }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 11, letterSpacing: 2, color: SR.ink3, fontWeight: 700, width: "0px", height: "0px", opacity: "0" }}>NAMASTE · MORNING SADHANA</div>
            <div style={{ fontSize: 26, fontWeight: 800, marginTop: 2, letterSpacing: -0.5 }}>Mantra <span style={{ color: SR.marigold, fontStyle: "italic" }}>Counter</span></div>
          </div>
          <button style={{ width: 44, height: 44, borderRadius: 14, background: SR.marigold, border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: `0 8px 24px ${SR.marigold}55` }}>
            <SrIcon d={sr_plus} color="#1a1230" sw={2.5} />
          </button>
        </div>

        {/* Streak + Today bar */}
        <div style={{ marginTop: 16, background: 'linear-gradient(135deg,#ff4d8d 0%,#ff8c1a 100%)', borderRadius: 18, padding: 16, position: 'relative', overflow: 'hidden', width: "0px", height: "0px" }}>
          <div style={{ position: 'absolute', right: -10, top: -10, fontSize: 80, opacity: 0.15 }}><SrIcon d={sr_flame} color="#fff" size={120} sw={2} /></div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#fff' }}>
            <SrIcon d={sr_flame} color="#fff" size={16} />
            <span style={{ fontSize: 11, letterSpacing: 2, fontWeight: 800 }}>STREAK · 31 DAYS</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginTop: 6, color: '#fff' }}>
            <span style={{ fontSize: 32, fontWeight: 900, letterSpacing: -1 }}>325</span>
            <span style={{ fontSize: 13, fontWeight: 700, opacity: 0.9 }}>chants today</span>
          </div>
          <div style={{ display: 'flex', gap: 4, marginTop: 12 }}>
            {Array.from({ length: 14 }).map((_, i) =>
            <div key={i} style={{ flex: 1, height: 6, borderRadius: 3, background: i < 11 ? '#fff' : 'rgba(255,255,255,0.3)' }} />
            )}
          </div>
        </div>
      </div>

      <div style={{ padding: '4px 18px 28px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {items.map((it, i) =>
        <div key={i} style={{ background: SR.card, borderRadius: 18, padding: 14, border: `1px solid ${SR.line}`, position: 'relative', overflow: 'hidden' }}>
            <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 3, background: it.color }} />
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 10 }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: SR.mal, fontSize: 17, fontWeight: 800, color: SR.ink }}>{it.t}</div>
                {it.en && <div style={{ fontSize: 11, color: SR.ink3, marginTop: 2, letterSpacing: 0.5 }}>{it.en.toUpperCase()}</div>}
              </div>
              <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
                {it.daily >= 100 &&
              <div style={{ display: 'flex', alignItems: 'center', gap: 3, padding: '3px 7px', borderRadius: 100, background: `${SR.jade}25`, color: SR.jade, fontSize: 10, fontWeight: 800 }}>
                    <SrIcon d={sr_check} color={SR.jade} size={11} sw={3} /> DONE
                  </div>
              }
                <SrIcon d={sr_cal} color={SR.ink3} size={16} />
              </div>
            </div>

            {/* big number row */}
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 12, marginTop: 10 }}>
              <div style={{ fontFamily: SR.mono, fontSize: 28, fontWeight: 800, color: it.color, lineHeight: 1, letterSpacing: -1 }}>{it.count.toLocaleString()}</div>
              <div style={{ fontSize: 12, color: SR.ink2 }}>chants</div>
              <div style={{ fontFamily: SR.mono, fontSize: 18, fontWeight: 700, color: SR.ink, lineHeight: 1 }}>{it.mala}</div>
              <div style={{ fontSize: 12, color: SR.ink2 }}>mala</div>
            </div>

            {/* progress chips */}
            <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
              <div style={{ flex: 1, padding: '8px 10px', borderRadius: 10, background: SR.cardHi }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: SR.ink3, fontWeight: 700, letterSpacing: 1 }}>
                  <span>DAILY</span><span style={{ color: it.daily >= 100 ? SR.jade : it.color }}>{it.daily}%</span>
                </div>
                <div style={{ height: 4, background: 'rgba(255,255,255,0.08)', borderRadius: 2, marginTop: 6 }}>
                  <div style={{ height: '100%', width: `${Math.min(it.daily, 100)}%`, background: it.daily >= 100 ? SR.jade : it.color, borderRadius: 2 }} />
                </div>
              </div>
              {it.lifeShown &&
            <div style={{ flex: 1, padding: '8px 10px', borderRadius: 10, background: SR.cardHi }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: SR.ink3, fontWeight: 700, letterSpacing: 1 }}>
                    <span>LIFETIME</span><span style={{ color: it.color }}>{it.life}%</span>
                  </div>
                  <div style={{ height: 4, background: 'rgba(255,255,255,0.08)', borderRadius: 2, marginTop: 6 }}>
                    <div style={{ height: '100%', width: `${Math.max(it.life, 1)}%`, background: it.color, borderRadius: 2 }} />
                  </div>
                </div>
            }
              {!it.lifeShown &&
            <div style={{ flex: 1, padding: '8px 10px', borderRadius: 10, background: SR.cardHi, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ fontSize: 10, color: SR.ink3, fontWeight: 700, letterSpacing: 1 }}>TODAY</div>
                  <div style={{ fontFamily: SR.mono, fontSize: 14, fontWeight: 700, color: SR.ink }}>{it.today}c · 1m</div>
                </div>
            }
            </div>
          </div>
        )}
      </div>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 2 — Active counter (devotional ring)
// ─────────────────────────────────────────────────────────────
function SunriseCounter() {
  const count = 86,goal = 108,pct = count / goal * 100;
  const r = 100,C = 2 * Math.PI * r,dash = C * pct / 100;
  return (
    <div style={{ background: SR.bg, minHeight: '100%', fontFamily: SR.sans, color: SR.ink, display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '16px 16px 8px', display: 'flex', alignItems: 'center', gap: 8 }}>
        <button style={iconBtnSr}><SrIcon d={sr_back} /></button>
        <div style={{ flex: 1, textAlign: 'center' }}>
          <div style={{ fontFamily: SR.mal, fontSize: 14, fontWeight: 800 }}>ലളിതാ സഹസ്രനാമം</div>
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '3px 10px', borderRadius: 100, background: `${SR.jade}22`, color: SR.jade, fontSize: 10, fontWeight: 800, letterSpacing: 1, marginTop: 4, whiteSpace: 'nowrap' }}>
            <SrIcon d={sr_check} color={SR.jade} size={11} sw={3} /> GOAL · 00:02
          </div>
        </div>
        <button style={iconBtnSr}><SrIcon d={sr_dots} /></button>
      </div>

      {/* Sadhana progress */}
      <div style={{ padding: '8px 16px 4px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: 'linear-gradient(135deg,#ff4d8d,#ff8c1a)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}><SrIcon d={sr_lotus} color="#fff" size={18} sw={1.6} /></div>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: SR.ink3, fontWeight: 700, letterSpacing: 1 }}>
              <span>SADHANA · 31 OF 40 DAYS</span><span>620 / 1000</span>
            </div>
            <div style={{ height: 6, background: SR.card, borderRadius: 3, marginTop: 4 }}>
              <div style={{ height: '100%', width: '62%', background: 'linear-gradient(90deg,#ff4d8d,#ff8c1a)', borderRadius: 3 }} />
            </div>
          </div>
        </div>
      </div>

      {/* Big tap ring */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative', padding: '12px 0' }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 50% 45%, rgba(255,177,59,0.18), transparent 60%)' }} />
        <div style={{ position: 'relative', width: 250, height: 250, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="250" height="250" viewBox="0 0 250 250" style={{ position: 'absolute', inset: 0, transform: 'rotate(-90deg)' }}>
            <defs>
              <linearGradient id="srGrad" x1="0" y1="0" x2="1" y2="1">
                <stop offset="0%" stopColor="#ffb13b" />
                <stop offset="100%" stopColor="#ff4d8d" />
              </linearGradient>
            </defs>
            <circle cx="125" cy="125" r={r} fill="none" stroke={SR.card} strokeWidth="10" />
            <circle cx="125" cy="125" r={r} fill="none" stroke="url(#srGrad)" strokeWidth="10"
            strokeDasharray={`${dash} ${C}`} strokeLinecap="round" />
            {/* tick marks */}
            {Array.from({ length: 12 }).map((_, i) => {
              const a = i * 30 * Math.PI / 180;
              const x1 = 125 + Math.cos(a) * 78;
              const y1 = 125 + Math.sin(a) * 78;
              const x2 = 125 + Math.cos(a) * 84;
              const y2 = 125 + Math.sin(a) * 84;
              return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} stroke={SR.ink3} strokeWidth="2" />;
            })}
          </svg>
          <div style={{ width: 200, height: 200, borderRadius: '50%', background: 'radial-gradient(circle, #2a1d52, #1a1230)', border: `1px solid ${SR.line}`, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ fontSize: 10, letterSpacing: 2, color: SR.marigold, fontWeight: 800 }}>SESSION</div>
            <div style={{ fontFamily: SR.sans, fontSize: 96, fontWeight: 900, lineHeight: 0.9, letterSpacing: -3, background: 'linear-gradient(180deg,#fff,#ffb13b)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>{count}</div>
            <div style={{ fontSize: 11, color: SR.ink2, marginTop: 4, fontWeight: 700 }}>{Math.round(pct)}% to mala</div>
          </div>
        </div>

                {/* mantra chip */}
        <div style={{ marginTop: 14, display: 'inline-flex', alignItems: 'center', gap: 6, padding: '6px 14px', borderRadius: 100, background: SR.card, border: `1px solid ${SR.line}`, whiteSpace: 'nowrap' }}>
          <SrIcon d={sr_lotus} color={SR.marigold} size={14} />
          <span style={{ fontSize: 12, fontWeight: 800, letterSpacing: 0.5 }}>tap to chant</span>
          <span style={{ fontSize: 12, color: SR.ink3 }}>· 22 to mala</span>
        </div>
      </div>

      {/* bottom strip */}
      <div style={{ padding: '0 16px 16px' }}>
        <div style={{ display: 'flex', gap: 8 }}>
          <SrStat icon={sr_clock} v="86" l="Session" />
          <SrStat icon={sr_flame} v="0" l="Mala" c={SR.magenta} />
          <SrStat icon={sr_lotus} v="31" l="Days" c={SR.jade} />
          <button style={{ width: 44, height: 44, borderRadius: 12, border: 'none', background: SR.magenta, color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <SrIcon d={sr_minus} color="#fff" sw={2.5} />
          </button>
        </div>
      </div>
    </div>);

}
function SrStat({ icon, v, l, c = SR.marigold }) {
  return (
    <div style={{ flex: 1, padding: '8px 10px', background: SR.card, border: `1px solid ${SR.line}`, borderRadius: 12 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, color: c }}>
        <SrIcon d={icon} color={c} size={12} />
        <span style={{ fontSize: 9, letterSpacing: 1, fontWeight: 800 }}>{l.toUpperCase()}</span>
      </div>
      <div style={{ fontFamily: SR.mono, fontSize: 18, fontWeight: 800, marginTop: 2 }}>{v}</div>
    </div>);

}
const iconBtnSr = {
  width: 40, height: 40, borderRadius: 12, border: `1px solid ${SR.line}`,
  background: SR.card, color: SR.ink, cursor: 'pointer',
  display: 'flex', alignItems: 'center', justifyContent: 'center'
};

// ─────────────────────────────────────────────────────────────
// Screen 3 — History (achievements / heatmap)
// ─────────────────────────────────────────────────────────────
function SunriseHistory() {
  const days = [
  { d: 'Today', sub: 'Day 31', c: 1, m: 0, time: '18:29', life: '31/1008', pct: 3.08, today: true },
  { d: 'ഏപ്രി 26', sub: 'Day 30', c: 1, m: 0, time: '15:13', life: '30/1008', pct: 2.98 },
  { d: 'ഏപ്രി 25', sub: 'Day 29', c: 1, m: 0, time: '15:44', life: '29/1008', pct: 2.88 },
  { d: 'ഏപ്രി 24', sub: 'Day 28', c: 1, m: 0, time: '17:40', life: '28/1008', pct: 2.78 }];

  return (
    <div style={{ background: SR.bg, minHeight: '100%', fontFamily: SR.sans, color: SR.ink }}>
      <div style={{ padding: '16px 16px 0', display: 'flex', alignItems: 'center', gap: 8 }}>
        <button style={iconBtnSr}><SrIcon d={sr_back} /></button>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, letterSpacing: 2, color: SR.marigold, fontWeight: 800 }}>JOURNEY</div>
          <div style={{ fontFamily: SR.mal, fontSize: 17, fontWeight: 800 }}>ലളിതാ സഹസ്രനാമം</div>
        </div>
        <button style={iconBtnSr}><SrIcon d={sr_trash} /></button>
      </div>

      {/* Hero stats */}
      <div style={{ padding: '14px 16px 8px' }}>
        <div style={{ display: 'flex', gap: 10 }}>
          <div style={{ flex: 1, padding: 14, borderRadius: 16, background: 'linear-gradient(135deg,#ff4d8d,#ff8c1a)', color: '#fff' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <SrIcon d={sr_flame} color="#fff" size={14} />
              <span style={{ fontSize: 10, fontWeight: 800, letterSpacing: 1 }}>STREAK</span>
            </div>
            <div style={{ fontSize: 32, fontWeight: 900, lineHeight: 1, marginTop: 4, letterSpacing: -1 }}>31</div>
            <div style={{ fontSize: 11, opacity: 0.9 }}>days · best ever</div>
          </div>
          <div style={{ flex: 1, padding: 14, borderRadius: 16, background: SR.card, border: `1px solid ${SR.line}` }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: SR.cyan }}>
              <SrIcon d={sr_lotus} color={SR.cyan} size={14} />
              <span style={{ fontSize: 10, fontWeight: 800, letterSpacing: 1 }}>LIFETIME</span>
            </div>
            <div style={{ fontFamily: SR.mono, fontSize: 28, fontWeight: 900, lineHeight: 1, marginTop: 4, color: SR.ink }}>31<span style={{ color: SR.ink3, fontSize: 14 }}>/1008</span></div>
            <div style={{ height: 4, background: SR.cardHi, borderRadius: 2, marginTop: 8 }}>
              <div style={{ height: '100%', width: '3%', background: SR.cyan, borderRadius: 2 }} />
            </div>
          </div>
        </div>

        {/* Heatmap */}
        <div style={{ marginTop: 14, padding: 14, background: SR.card, borderRadius: 16, border: `1px solid ${SR.line}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 }}>
            <div style={{ fontSize: 11, letterSpacing: 1, color: SR.ink3, fontWeight: 800 }}>THIS YEAR · 31 DAYS</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 10, color: SR.ink3 }}>
              <span>less</span>
              {[0.15, 0.35, 0.6, 0.85, 1].map((o, i) => <div key={i} style={{ width: 10, height: 10, borderRadius: 2, background: SR.marigold, opacity: o }} />)}
              <span>more</span>
            </div>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(20, 1fr)', gap: 3 }}>
            {Array.from({ length: 100 }).map((_, i) => {
              const has = i >= 69;
              const intensity = has ? 0.5 + Math.random() * 0.5 : 0.08;
              return <div key={i} style={{ aspectRatio: '1', borderRadius: 2, background: has ? SR.marigold : 'rgba(255,255,255,0.05)', opacity: has ? intensity : 1 }} />;
            })}
          </div>
        </div>
      </div>

      {/* day cards */}
      <div style={{ padding: '4px 16px 24px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {days.map((d, i) =>
        <div key={i} style={{
          background: d.today ? `linear-gradient(135deg, ${SR.cardHi}, ${SR.card})` : SR.card,
          border: `1px solid ${d.today ? SR.marigold + '88' : SR.line}`,
          borderRadius: 14, padding: '12px 14px'
        }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{ fontFamily: d.d.startsWith('ഏ') ? SR.mal : SR.sans, fontSize: 15, fontWeight: 800 }}>{d.d}</span>
                  {d.today && <span style={{ fontSize: 9, padding: '2px 6px', borderRadius: 100, background: SR.marigold, color: '#1a1230', fontWeight: 800, letterSpacing: 1 }}>NOW</span>}
                  <span style={{ fontSize: 11, color: SR.ink3 }}>· {d.sub}</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 4 }}>
                  <SrIcon d={sr_check} color={SR.jade} size={12} sw={3} />
                  <span style={{ fontSize: 11, color: SR.jade, fontWeight: 700 }}>Daily 1/1</span>
                  <span style={{ fontSize: 11, color: SR.ink3 }}>· {d.time}</span>
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontFamily: SR.mono, fontSize: 18, fontWeight: 800, color: SR.cyan }}>+{d.pct}%</div>
                <div style={{ fontSize: 10, color: SR.ink3 }}>{d.life}</div>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
              <Pill icon={sr_zap} v={`${d.c} chant`} />
              <Pill icon={sr_lotus} v={`${d.m} mala`} />
              <Pill icon={sr_flame} v={`day ${31 - i}`} c={SR.marigold} />
            </div>
          </div>
        )}
      </div>
    </div>);

}
function Pill({ icon, v, c = SR.ink2 }) {
  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '4px 9px', borderRadius: 100, background: SR.cardHi, fontSize: 11, color: c, fontWeight: 700 }}>
      <SrIcon d={icon} color={c} size={11} /> {v}
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 4 — Settings
// ─────────────────────────────────────────────────────────────
function SunriseSettings() {
  return (
    <div style={{ background: SR.bg, minHeight: '100%', fontFamily: SR.sans, color: SR.ink }}>
      <div style={{ padding: '16px 16px 8px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button style={iconBtnSr}><SrIcon d={sr_back} /></button>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, letterSpacing: 2, color: SR.marigold, fontWeight: 800 }}>CONFIG</div>
          <div style={{ fontSize: 22, fontWeight: 900, letterSpacing: -0.5 }}>Settings</div>
        </div>
        <SrIcon d={sr_settings} color={SR.ink3} />
      </div>

      <div style={{ padding: '8px 16px 24px' }}>
        <SrSection title="DAILY GOAL · CELEBRATION" color={SR.marigold}>
          <SrRow icon={sr_bell} title="Enable Notification" sub="Vibrate + sound when you hit goal" toggle />
          <SrRow icon={sr_vibrate} title="Vibration" sub="Buzz on completion" toggle />
          <SrRow icon={sr_sound} title="Sound" sub="Play a celebratory tone" toggle />
          <SrRow icon={sr_music} title="Notification Tone" right="Clear" arrow />
          <SrRow icon={sr_file} title="Choose from Files" sub="Use any audio file" arrow />
          <SrRow icon={sr_play} title="Preview Sound" arrow last />
        </SrSection>

        <SrSection title="MALA TICK · 108 COUNTS" color={SR.magenta}>
          <SrRow icon={sr_clock} title="Enable Mala Sound" sub="Tick when each mala (108) completes" toggle />
          <SrRow icon={sr_play} title="Preview Mala Sound" arrow last />
        </SrSection>

        <SrSection title="POWER · BATTERY" color={SR.cyan}>
          <SrRow icon={sr_brightness} title="Reduce Brightness" sub="Dim screen during chanting" toggle />
          <div style={{ padding: '14px', borderTop: `1px solid ${SR.line}` }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <div style={{ fontSize: 13, fontWeight: 700 }}>Brightness Level</div>
              <div style={{ fontFamily: SR.mono, fontSize: 18, color: SR.cyan, fontWeight: 800 }}>10%</div>
            </div>
            <div style={{ height: 6, background: SR.cardHi, borderRadius: 3, marginTop: 10, position: 'relative' }}>
              <div style={{ height: '100%', width: '10%', background: SR.cyan, borderRadius: 3, boxShadow: `0 0 12px ${SR.cyan}` }} />
              <div style={{ position: 'absolute', left: '10%', top: '50%', transform: 'translate(-50%, -50%)', width: 18, height: 18, borderRadius: '50%', background: SR.cyan, boxShadow: `0 0 12px ${SR.cyan}` }} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: SR.ink3, marginTop: 8, letterSpacing: 1, fontWeight: 700 }}>
              <span>10%</span><span>100%</span>
            </div>
          </div>
        </SrSection>

        <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start', padding: 14, borderRadius: 14, background: SR.card, border: `1px solid ${SR.line}` }}>
          <div style={{ width: 28, height: 28, borderRadius: 8, background: `${SR.marigold}22`, color: SR.marigold, display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 900, flexShrink: 0 }}>i</div>
          <div style={{ fontSize: 12, color: SR.ink2, lineHeight: 1.5 }}>
            <b style={{ color: SR.ink }}>Daily goal sound</b> plays when goal is reached. <b style={{ color: SR.ink }}>Mala sound</b> ticks every 108 counts (when not also a daily goal).
          </div>
        </div>
      </div>
    </div>);

}
function SrSection({ title, color, children }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 4px 8px' }}>
        <div style={{ width: 4, height: 12, background: color, borderRadius: 2 }} />
        <div style={{ fontSize: 10, letterSpacing: 2, color, fontWeight: 800 }}>{title}</div>
      </div>
      <div style={{ background: SR.card, border: `1px solid ${SR.line}`, borderRadius: 16, overflow: 'hidden' }}>
        {children}
      </div>
    </div>);

}
function SrRow({ icon, title, sub, toggle, arrow, right, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '13px 14px', borderTop: !last ? `1px solid ${SR.line}` : 'none' }}>
      <div style={{ width: 34, height: 34, borderRadius: 10, background: SR.cardHi, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
        <SrIcon d={icon} color={SR.marigold} size={16} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 700 }}>{title}</div>
        {sub && <div style={{ fontSize: 11, color: SR.ink3, marginTop: 1 }}>{sub}</div>}
      </div>
      {right && <div style={{ fontSize: 12, color: SR.marigold, fontWeight: 700 }}>{right}</div>}
      {toggle &&
      <div style={{ width: 42, height: 24, borderRadius: 12, background: SR.marigold, position: 'relative', boxShadow: `0 0 12px ${SR.marigold}66` }}>
          <div style={{ position: 'absolute', right: 2, top: 2, width: 20, height: 20, borderRadius: '50%', background: '#fff' }} />
        </div>
      }
      {arrow && <SrIcon d={sr_chevR} color={SR.ink3} size={16} />}
    </div>);

}

window.SunriseList = SunriseList;
window.SunriseCounter = SunriseCounter;
window.SunriseHistory = SunriseHistory;
window.SunriseSettings = SunriseSettings;