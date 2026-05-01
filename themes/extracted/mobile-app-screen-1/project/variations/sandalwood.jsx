// Variation A — Sandalwood (Serene / Warm Earth Tones, Light)
// Cream + saffron + ochre. Humanist sans (Nunito) + Fraunces serif numerals.
// Subtle lotus/mandala line motifs. Calm, generous spacing.

const SW = {
  bg: '#faf4ea',
  card: '#ffffff',
  cardSoft: '#fbf1e3',
  ink: '#3a2a17',
  ink2: '#6b5847',
  ink3: '#998472',
  line: '#ebdcc6',
  saffron: '#d97727',
  saffronDeep: '#b35a14',
  ochre: '#c9a04a',
  jade: '#557a5e',
  rose: '#c2624a',
  sans: '"Nunito", system-ui, sans-serif',
  serif: '"Fraunces", Georgia, serif',
  mal: '"Noto Sans Malayalam", "Nunito", system-ui, sans-serif'
};

// ─── decorative motif ─────────────────────────────────────────
const SwMandala = ({ size = 120, color = SW.saffron, op = 0.08 }) =>
<svg width={size} height={size} viewBox="0 0 120 120" style={{ opacity: op }}>
    <g fill="none" stroke={color} strokeWidth="1">
      <circle cx="60" cy="60" r="50" />
      <circle cx="60" cy="60" r="38" />
      <circle cx="60" cy="60" r="26" />
      {Array.from({ length: 12 }).map((_, i) => {
      const a = i * 30 * Math.PI / 180;
      const x1 = 60 + Math.cos(a) * 26;
      const y1 = 60 + Math.sin(a) * 26;
      const x2 = 60 + Math.cos(a) * 50;
      const y2 = 60 + Math.sin(a) * 50;
      return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} />;
    })}
      {Array.from({ length: 8 }).map((_, i) => {
      const a = i * 45 * Math.PI / 180;
      const cx = 60 + Math.cos(a) * 32;
      const cy = 60 + Math.sin(a) * 32;
      return <circle key={i} cx={cx} cy={cy} r="6" />;
    })}
    </g>
  </svg>;


const SwLotus = ({ size = 18, color = SW.saffron }) =>
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
    <path d="M12 20 C 6 16, 4 10, 4 6 C 8 8, 11 12, 12 16 C 13 12, 16 8, 20 6 C 20 10, 18 16, 12 20 Z"
  stroke={color} strokeWidth="1.4" strokeLinejoin="round" />
    <path d="M12 20 C 9 17, 8 13, 8 8 C 10 11, 12 14, 12 20" stroke={color} strokeWidth="1.2" />
    <path d="M12 20 C 15 17, 16 13, 16 8 C 14 11, 12 14, 12 20" stroke={color} strokeWidth="1.2" />
  </svg>;


const SwIcon = ({ d, size = 20, color = SW.ink, sw = 1.6 }) =>
<svg width={size} height={size} viewBox="0 0 24 24" fill="none"
stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">
    {d}
  </svg>;


const sw_plus = <><path d="M12 5v14M5 12h14" /></>;
const sw_dots = <><circle cx="12" cy="5" r="1.2" fill={SW.ink} stroke="none" /><circle cx="12" cy="12" r="1.2" fill={SW.ink} stroke="none" /><circle cx="12" cy="19" r="1.2" fill={SW.ink} stroke="none" /></>;
const sw_back = <><path d="M15 6l-6 6 6 6" /></>;
const sw_cal = <><rect x="4" y="5" width="16" height="15" rx="2" /><path d="M8 3v4M16 3v4M4 10h16" /></>;
const sw_trash = <><path d="M4 7h16M9 7V5a2 2 0 012-2h2a2 2 0 012 2v2M6 7l1 13a2 2 0 002 2h6a2 2 0 002-2l1-13" /></>;
const sw_chevR = <><path d="M9 6l6 6-6 6" /></>;
const sw_chevD = <><path d="M6 9l6 6 6-6" /></>;
const sw_check = <><path d="M5 12l5 5L20 7" /></>;
const sw_play = <><path d="M7 5l12 7-12 7V5z" fill={SW.ink} stroke="none" /></>;
const sw_bell = <><path d="M6 16V11a6 6 0 0112 0v5l1.5 2h-15L6 16zM10 20a2 2 0 004 0" /></>;
const sw_vibrate = <><rect x="9" y="6" width="6" height="12" rx="1" /><path d="M5 9v6M19 9v6M3 11v2M21 11v2" /></>;
const sw_sound = <><path d="M5 10v4h3l4 4V6L8 10H5zM16 9a4 4 0 010 6" /></>;
const sw_music = <><path d="M9 17V5l10-2v12" /><circle cx="7" cy="17" r="2" /><circle cx="17" cy="15" r="2" /></>;
const sw_file = <><path d="M14 3H7a2 2 0 00-2 2v14a2 2 0 002 2h10a2 2 0 002-2V8l-5-5zM14 3v5h5" /></>;
const sw_clock = <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>;
const sw_brightness = <><circle cx="12" cy="12" r="4" /><path d="M12 3v2M12 19v2M3 12h2M19 12h2M5.5 5.5l1.4 1.4M17.1 17.1l1.4 1.4M5.5 18.5l1.4-1.4M17.1 6.9l1.4-1.4" /></>;
const sw_info = <><circle cx="12" cy="12" r="9" /><path d="M12 8h.01M11 12h1v5h1" /></>;
const sw_minus = <><path d="M5 12h14" /></>;
const sw_book = <><path d="M4 5a2 2 0 012-2h12v18H6a2 2 0 01-2-2V5zM4 5v14M18 3v18" /></>;
const sw_flame = <><path d="M12 3c0 4-5 5-5 10a5 5 0 0010 0c0-2-1-3-2-4 0 1-1 2-2 2 0-3 1-5-1-8z" /></>;

// ─────────────────────────────────────────────────────────────
// Screen 1 — Counter list
// ─────────────────────────────────────────────────────────────
function SandalwoodList() {
  const items = [
  { t: 'ലളിതാ സഹസ്രനാമം', en: 'Lalita Sahasranama', count: 31, mala: 0, today: '1c · 0m', daily: 100, life: 3.1, lifeShown: true },
  { t: 'കൃഷ്ണായ നമ', en: 'Krishnaya Namah', count: 3456, mala: 32, today: '108c · 1m', daily: 100, life: null, lifeShown: false },
  { t: 'ഗണപതയേ നമ', en: 'Ganapataye Namah', count: 3456, mala: 32, today: '108c · 1m', daily: 100, life: null, lifeShown: false },
  { t: 'Om Durgaayai Namaha', en: null, count: 17543, mala: 162, today: '108c · 1m', daily: 4.3, life: 1.5, lifeShown: true }];

  return (
    <div style={{ background: SW.bg, minHeight: '100%', fontFamily: SW.sans, color: SW.ink, position: 'relative', overflow: 'hidden' }}>
      {/* decorative motif top right */}
      <div style={{ position: 'absolute', top: -40, right: -40, pointerEvents: 'none' }}>
        <SwMandala size={220} color={SW.saffron} op={0.07} />
      </div>
      <div style={{ padding: '24px 20px 14px', position: 'relative', height: "80px" }}>
        <div style={{ fontSize: 12, letterSpacing: 2, color: SW.ink3, textTransform: 'uppercase', marginBottom: 6 }}>JAPA · ജപം</div>
        <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
          <div style={{ fontFamily: SW.serif, fontSize: 32, fontWeight: 400, lineHeight: 1.05, letterSpacing: -0.5 }}>
            Mantra<br /><i style={{ color: SW.saffronDeep }}>Counters</i>
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            <button style={iconBtnSw}><SwIcon d={sw_plus} /></button>
            <button style={iconBtnSw}><SwIcon d={sw_dots} /></button>
          </div>
        </div>
        {/* today summary */}
        <div style={{ marginTop: 18, padding: '12px 14px', background: SW.cardSoft, borderRadius: 14, border: `1px solid ${SW.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: "0px", opacity: "0" }}>
          <div>
            <div style={{ fontSize: 11, letterSpacing: 1.5, color: SW.ink3, textTransform: 'uppercase' }}>TODAY · ഇന്ന്</div>
            <div style={{ fontFamily: SW.serif, fontSize: 22, marginTop: 2 }}>325 <span style={{ color: SW.ink3, fontSize: 14 }}>chants · 3 mala</span></div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: SW.saffronDeep }}>
            <SwIcon d={sw_flame} color={SW.saffronDeep} size={18} />
            <span style={{ fontWeight: 700, fontSize: 14 }}>31 day</span>
          </div>
        </div>
      </div>

      <div style={{ padding: '4px 20px 28px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {items.map((it, i) =>
        <div key={i} style={{
          background: SW.card, borderRadius: 18, padding: '16px 16px 14px',
          border: `1px solid ${SW.line}`, position: 'relative'
        }}>
            {/* left ribbon */}
            <div style={{ position: 'absolute', left: 0, top: 18, bottom: 18, width: 3, background: SW.saffron, borderRadius: 2 }} />
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 10 }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: SW.mal, fontSize: 18, fontWeight: 700, lineHeight: 1.25, color: SW.ink }}>{it.t}</div>
                {it.en && <div style={{ fontSize: 12, color: SW.ink3, marginTop: 2, fontStyle: 'italic', fontFamily: SW.serif, opacity: "0", width: "0px", height: "0px" }}>{it.en}</div>}
              </div>
              <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                <SwIcon d={sw_cal} color={SW.ink3} size={16} />
                <div style={{ width: 18, height: 18, border: `1.5px solid ${SW.line}`, borderRadius: 5 }} />
              </div>
            </div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 10 }}>
              <div style={{ fontFamily: SW.serif, fontSize: 28, fontWeight: 500, color: SW.saffronDeep, lineHeight: 1 }}>{it.count.toLocaleString()}</div>
              <div style={{ fontSize: 13, color: SW.ink3 }}>chants · <b style={{ color: SW.ink2 }}>{it.mala}</b> mala</div>
            </div>
            <div style={{ fontSize: 12, color: SW.ink2, marginBottom: 8 }}>Today · {it.today}</div>
            {/* progress strip */}
            <div>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, letterSpacing: 0.5, color: SW.ink3, marginBottom: 4 }}>
                <span>DAILY</span>
                <span style={{ color: it.daily >= 100 ? SW.jade : SW.ink2, fontWeight: 700 }}>
                  {it.daily}% {it.daily >= 100 && '✓'}
                </span>
              </div>
              <div style={{ height: 4, background: SW.line, borderRadius: 2 }}>
                <div style={{ height: '100%', width: `${Math.min(it.daily, 100)}%`, background: it.daily >= 100 ? SW.jade : SW.saffron, borderRadius: 2 }} />
              </div>
              {it.lifeShown &&
            <>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, letterSpacing: 0.5, color: SW.ink3, marginTop: 8, marginBottom: 4 }}>
                    <span>LIFETIME</span>
                    <span style={{ color: SW.ochre, fontWeight: 700 }}>{it.life}%</span>
                  </div>
                  <div style={{ height: 4, background: SW.line, borderRadius: 2 }}>
                    <div style={{ height: '100%', width: `${Math.max(it.life, 1)}%`, background: SW.ochre, borderRadius: 2 }} />
                  </div>
                </>
            }
            </div>
          </div>
        )}
      </div>
    </div>);

}

const iconBtnSw = {
  width: 40, height: 40, borderRadius: 12, border: `1px solid ${SW.line}`,
  background: SW.card, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer'
};

// ─────────────────────────────────────────────────────────────
// Screen 2 — Active counter
// ─────────────────────────────────────────────────────────────
function SandalwoodCounter() {
  const count = 86;
  const goal = 108;
  const pct = count / goal * 100;
  const r = 92;
  const C = 2 * Math.PI * r;
  const dash = C * pct / 100;
  return (
    <div style={{ background: SW.bg, minHeight: '100%', fontFamily: SW.sans, color: SW.ink, display: 'flex', flexDirection: 'column' }}>
      {/* header */}
      <div style={{ padding: '16px 16px 8px', display: 'flex', alignItems: 'center', gap: 8 }}>
        <button style={iconBtnSw}><SwIcon d={sw_back} /></button>
        <div style={{ flex: 1, textAlign: 'center' }}>
          <div style={{ fontFamily: SW.mal, fontSize: 15, fontWeight: 700 }}>ലളിതാ സഹസ്രനാമം</div>
          <div style={{ fontSize: 11, color: SW.jade, fontWeight: 700, letterSpacing: 1, marginTop: 2 }}>00:02</div>
        </div>
        <button style={iconBtnSw}><SwIcon d={sw_dots} /></button>
      </div>

      {/* Goal pills */}
      <div style={{ padding: '6px 16px 0', display: 'flex', gap: 10 }}>
        <div style={{ flex: 1, background: SW.card, border: `1px solid ${SW.line}`, borderRadius: 14, padding: 12 }}>
          <div style={{ fontSize: 10, letterSpacing: 1.5, color: SW.ink3 }}>LIFETIME</div>
          <div style={{ fontFamily: SW.serif, fontSize: 18, marginTop: 2 }}>31 <span style={{ color: SW.ink3, fontSize: 13 }}>/ 1,008</span></div>
          <div style={{ height: 3, background: SW.line, borderRadius: 2, marginTop: 6 }}>
            <div style={{ height: '100%', width: '3%', background: SW.ochre, borderRadius: 2 }} />
          </div>
        </div>
        <div style={{ flex: 1, background: SW.saffron, border: `1px solid ${SW.saffronDeep}`, borderRadius: 14, padding: 12, color: '#fff' }}>
          <div style={{ fontSize: 10, letterSpacing: 1.5, opacity: 0.85 }}>DAILY ✓</div>
          <div style={{ fontFamily: SW.serif, fontSize: 18, marginTop: 2 }}>1 / 1</div>
          <div style={{ height: 3, background: 'rgba(255,255,255,0.3)', borderRadius: 2, marginTop: 6 }}>
            <div style={{ height: '100%', width: '100%', background: '#fff', borderRadius: 2 }} />
          </div>
        </div>
      </div>

      {/* Big counter */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative', padding: '20px 0' }}>
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', pointerEvents: 'none' }}>
          <SwMandala size={300} color={SW.saffron} op={0.06} />
        </div>
        <div style={{ position: 'relative', width: 230, height: 230, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="230" height="230" viewBox="0 0 230 230" style={{ position: 'absolute', inset: 0, transform: 'rotate(-90deg)' }}>
            <circle cx="115" cy="115" r={r} fill="none" stroke={SW.line} strokeWidth="6" />
            <circle cx="115" cy="115" r={r} fill="none" stroke={SW.saffron} strokeWidth="6"
            strokeDasharray={`${dash} ${C}`} strokeLinecap="round" />
          </svg>
          <div style={{ textAlign: 'center', position: 'relative' }}>
            <div style={{ fontSize: 11, letterSpacing: 2, color: SW.ink3 }}>SESSION</div>
            <div style={{ fontFamily: SW.serif, fontSize: 88, fontWeight: 400, lineHeight: 1, color: SW.ink, letterSpacing: -2 }}>{count}</div>
            <div style={{ fontSize: 13, color: SW.ink2, marginTop: 4 }}>of <b>{goal}</b> · 1 mala</div>
          </div>
        </div>
        <div style={{ marginTop: 18, fontSize: 12, color: SW.ink3, fontStyle: 'italic', fontFamily: SW.serif }}>tap anywhere to chant</div>
      </div>

      {/* Bottom strip */}
      <div style={{ padding: '0 16px 16px' }}>
        <div style={{ display: 'flex', gap: 8, marginBottom: 10 }}>
          <Stat label="Session count" v="86" />
          <Stat label="Session mala" v="0" />
          <Stat label="Today" v="86" />
        </div>
        <button style={{
          width: '100%', height: 48, borderRadius: 14, border: 'none',
          background: SW.ink, color: SW.bg, fontFamily: SW.sans, fontWeight: 700, fontSize: 15, letterSpacing: 0.5,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8
        }}>
          <SwIcon d={sw_minus} color={SW.bg} size={16} /> -Deduct
        </button>
      </div>
    </div>);

}
function Stat({ label, v }) {
  return (
    <div style={{ flex: 1, background: SW.card, border: `1px solid ${SW.line}`, borderRadius: 12, padding: '8px 10px' }}>
      <div style={{ fontSize: 10, letterSpacing: 1, color: SW.ink3 }}>{label.toUpperCase()}</div>
      <div style={{ fontFamily: SW.serif, fontSize: 18, marginTop: 2 }}>{v}</div>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 3 — History
// ─────────────────────────────────────────────────────────────
function SandalwoodHistory() {
  const days = [
  { d: 'Today', sub: 'Day 31', c: 1, m: 0, time: '18:29', life: '31/1,008 · 3.08%', complete: true, today: true },
  { d: 'Apr 26', sub: 'Day 30', c: 1, m: 0, time: '15:13', life: '30/1,008 · 2.98%', complete: true },
  { d: 'Apr 25', sub: 'Day 29', c: 1, m: 0, time: '15:44', life: '29/1,008 · 2.88%', complete: true },
  { d: 'Apr 24', sub: 'Day 28', c: 1, m: 0, time: '17:40', life: '28/1,008 · 2.78%', complete: true }];

  return (
    <div style={{ background: SW.bg, minHeight: '100%', fontFamily: SW.sans, color: SW.ink }}>
      <div style={{ padding: '16px 16px 8px', display: 'flex', alignItems: 'center', gap: 8 }}>
        <button style={iconBtnSw}><SwIcon d={sw_back} /></button>
        <div style={{ flex: 1, fontFamily: SW.mal, fontSize: 17, fontWeight: 700 }}>ലളിതാ സഹസ്രനാമം</div>
        <button style={iconBtnSw}><SwIcon d={sw_trash} /></button>
      </div>

      {/* Lifetime hero */}
      <div style={{ padding: '8px 16px 14px' }}>
        <div style={{ background: SW.card, border: `1px solid ${SW.line}`, borderRadius: 18, padding: 18, position: 'relative', overflow: 'hidden' }}>
          <div style={{ position: 'absolute', top: -30, right: -30, opacity: 1 }}>
            <SwMandala size={140} color={SW.saffron} op={0.1} />
          </div>
          <div style={{ fontSize: 11, letterSpacing: 2, color: SW.ink3 }}>LIFETIME GOAL</div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
            <div style={{ fontFamily: SW.serif, fontSize: 38, lineHeight: 1, fontWeight: 500 }}>31</div>
            <div style={{ color: SW.ink3, fontSize: 14 }}>/ 1,008 chants</div>
          </div>
          <div style={{ height: 6, background: SW.line, borderRadius: 3, marginTop: 14 }}>
            <div style={{ height: '100%', width: '3%', background: SW.saffron, borderRadius: 3 }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 6, fontSize: 12, color: SW.ink3 }}>
            <span><b style={{ color: SW.ink2 }}>3%</b> complete</span>
            <span>977 to go</span>
          </div>
          {/* tiny streak dots */}
          <div style={{ display: 'flex', gap: 4, marginTop: 14 }}>
            {Array.from({ length: 31 }).map((_, i) =>
            <div key={i} style={{ flex: 1, height: 18, borderRadius: 2, background: SW.saffron, opacity: 0.45 + i / 60 }} />
            )}
            <div style={{ flex: 1, height: 18, borderRadius: 2, background: SW.line }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: SW.ink3, marginTop: 4, letterSpacing: 0.5 }}>
            <span>31 DAYS</span><span>STREAK</span>
          </div>
        </div>
      </div>

      <div style={{ padding: '0 16px 24px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {days.map((d, i) =>
        <div key={i} style={{
          background: d.today ? SW.cardSoft : SW.card,
          border: `1px solid ${d.today ? SW.saffron : SW.line}`,
          borderRadius: 14, padding: '12px 14px'
        }}>
            <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ fontFamily: d.d.startsWith('ഏ') ? SW.mal : SW.sans, fontSize: 15, fontWeight: 700 }}>{d.d}</span>
                  <span style={{ fontFamily: SW.serif, fontStyle: 'italic', color: SW.ink3, fontSize: 13 }}>· {d.sub}</span>
                  <div style={{ width: 16, height: 16, borderRadius: '50%', background: SW.jade, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <SwIcon d={sw_check} color="#fff" size={11} sw={2.5} />
                  </div>
                </div>
                <div style={{ fontSize: 12, color: SW.ink3, marginTop: 4 }}>1 session · daily 1/1 ✓</div>
              </div>
              <SwIcon d={sw_chevD} color={SW.ink3} size={18} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 10, paddingTop: 10, borderTop: `1px dashed ${SW.line}` }}>
              <div style={{ display: 'flex', gap: 14 }}>
                <Mini label="chants" v={d.c} />
                <Mini label="malas" v={d.m} />
              </div>
              <div style={{ display: 'flex', gap: 6, alignItems: 'center', color: SW.ink3, fontSize: 12 }}>
                <SwIcon d={sw_clock} color={SW.ink3} size={14} /> {d.time}
              </div>
            </div>
            <div style={{ fontSize: 11, color: SW.ochre, marginTop: 6, fontWeight: 700 }}>Lifetime · {d.life}</div>
          </div>
        )}
      </div>
    </div>);

}
function Mini({ label, v }) {
  return (
    <div>
      <span style={{ fontFamily: SW.serif, fontSize: 16, fontWeight: 600 }}>{v}</span>
      <span style={{ fontSize: 11, color: SW.ink3, marginLeft: 4, letterSpacing: 0.5 }}>{label.toUpperCase()}</span>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 4 — Settings
// ─────────────────────────────────────────────────────────────
function SandalwoodSettings() {
  return (
    <div style={{ background: SW.bg, minHeight: '100%', fontFamily: SW.sans, color: SW.ink }}>
      <div style={{ padding: '16px 16px 8px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button style={iconBtnSw}><SwIcon d={sw_back} /></button>
        <div style={{ fontFamily: SW.serif, fontSize: 26, fontWeight: 500 }}>Settings</div>
      </div>

      <div style={{ padding: '8px 16px 24px' }}>
        <SwSection title="Daily Goal Notification" k="ദൈനംദിന ലക്ഷ്യം">
          <SwRow icon={sw_bell} title="Enable Notification" sub="Vibrate and sound on goal" toggle={true} />
          <SwRow icon={sw_vibrate} title="Vibration" sub="Vibrate on completion" toggle={true} />
          <SwRow icon={sw_sound} title="Sound" sub="Play tone on completion" toggle={true} />
          <SwRow icon={sw_music} title="Notification Tone" sub="Clear · 0:03" arrow />
          <SwRow icon={sw_file} title="Choose from Files" sub="Custom audio from device" arrow />
          <SwRow icon={sw_play} title="Preview Sound" sub="Hear current selection" arrow last />
        </SwSection>

        <SwSection title="Mala Completion" k="മാല പൂർത്തിയാക്കൽ">
          <SwRow icon={sw_clock} title="Enable Mala Sound" sub="Tick when each mala (108) is done" toggle={true} />
          <SwRow icon={sw_play} title="Preview Mala Sound" sub="Hear the tick" arrow last />
        </SwSection>

        <SwSection title="Power" k="ബാറ്ററി">
          <SwRow icon={sw_brightness} title="Reduce Brightness" sub="Dim screen during chanting" toggle={true} />
          <div style={{ padding: '14px 16px 16px', borderTop: `1px solid ${SW.line}` }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <div style={{ fontSize: 14, fontWeight: 700 }}>Brightness Level</div>
              <div style={{ fontFamily: SW.serif, fontSize: 18 }}>10%</div>
            </div>
            <div style={{ height: 6, background: SW.line, borderRadius: 3, marginTop: 10, position: 'relative' }}>
              <div style={{ height: '100%', width: '10%', background: SW.saffron, borderRadius: 3 }} />
              <div style={{ position: 'absolute', left: '10%', top: '50%', transform: 'translate(-50%, -50%)', width: 18, height: 18, background: SW.card, border: `2px solid ${SW.saffron}`, borderRadius: '50%' }} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: SW.ink3, marginTop: 6 }}>
              <span>10%</span><span>100%</span>
            </div>
          </div>
        </SwSection>

        <div style={{ background: SW.cardSoft, borderRadius: 14, padding: '12px 14px', display: 'flex', gap: 10, border: `1px solid ${SW.line}` }}>
          <SwIcon d={sw_info} color={SW.ochre} size={18} />
          <div style={{ fontSize: 12, color: SW.ink2, lineHeight: 1.5 }}>
            Daily goal sound plays on goal completion. Mala sound plays after every 108 counts (when not also a daily goal).
          </div>
        </div>
      </div>
    </div>);

}
function SwSection({ title, k, children }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, padding: '0 4px 8px' }}>
        <div style={{ fontSize: 11, letterSpacing: 2, color: SW.saffronDeep, fontWeight: 800 }}>{title.toUpperCase()}</div>
        <div style={{ fontFamily: SW.mal, fontSize: 12, color: SW.ink3 }}>· {k}</div>
      </div>
      <div style={{ background: SW.card, border: `1px solid ${SW.line}`, borderRadius: 16, overflow: 'hidden' }}>
        {children}
      </div>
    </div>);

}
function SwRow({ icon, title, sub, toggle, arrow, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '13px 14px', borderTop: !last ? `1px solid ${SW.line}` : 'none' }}>
      <div style={{ width: 36, height: 36, borderRadius: 10, background: SW.cardSoft, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
        <SwIcon d={icon} color={SW.saffronDeep} size={18} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 700 }}>{title}</div>
        <div style={{ fontSize: 12, color: SW.ink3, marginTop: 1 }}>{sub}</div>
      </div>
      {toggle &&
      <div style={{ width: 42, height: 24, borderRadius: 12, background: SW.saffron, position: 'relative' }}>
          <div style={{ position: 'absolute', right: 2, top: 2, width: 20, height: 20, borderRadius: '50%', background: '#fff' }} />
        </div>
      }
      {arrow && <SwIcon d={sw_chevR} color={SW.ink3} size={18} />}
    </div>);

}

window.SandalwoodList = SandalwoodList;
window.SandalwoodCounter = SandalwoodCounter;
window.SandalwoodHistory = SandalwoodHistory;
window.SandalwoodSettings = SandalwoodSettings;