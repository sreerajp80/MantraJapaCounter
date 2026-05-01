// Variation C — Temple (Spiritual / Devotional, Light Mode)
// Soft cream + temple vermillion + sandal yellow + tulsi green.
// Eb Garamond serif + Inter humanist sans. Stillness, devotion, breath.

const TP = {
  bg: '#fbf6ec',
  bg2: '#f3eada',
  card: '#ffffff',
  cardSoft: '#f7eed8',
  ink: '#2a1a08',
  ink2: '#5a4429',
  ink3: '#9a8568',
  line: '#e8d9b8',
  vermillion: '#c8401e',
  vermillionDeep: '#9a2c10',
  sandal: '#d8a13a',
  tulsi: '#3f6b3a',
  rose: '#b8506a',
  serif: '"EB Garamond", "Cormorant Garamond", Georgia, serif',
  sans: '"Inter", system-ui, sans-serif',
  mal: '"Noto Sans Malayalam", "Inter", system-ui, sans-serif'
};

const TpIcon = ({ d, size = 18, color = TP.ink, sw = 1.5 }) =>
<svg width={size} height={size} viewBox="0 0 24 24" fill="none"
stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;


const tp_plus = <><path d="M12 5v14M5 12h14" /></>;
const tp_dots = <><circle cx="12" cy="5" r="1.2" fill={TP.ink} stroke="none" /><circle cx="12" cy="12" r="1.2" fill={TP.ink} stroke="none" /><circle cx="12" cy="19" r="1.2" fill={TP.ink} stroke="none" /></>;
const tp_back = <><path d="M19 12H5M12 19l-7-7 7-7" /></>;
const tp_chevR = <><path d="M9 6l6 6-6 6" /></>;
const tp_check = <><path d="M5 12l5 5L20 7" /></>;
const tp_play = <><path d="M7 5l12 7-12 7V5z" fill={TP.ink} stroke="none" /></>;
const tp_bell = <><path d="M6 16V11a6 6 0 0112 0v5l1.5 2h-15L6 16zM10 20a2 2 0 004 0" /></>;
const tp_vibrate = <><rect x="9" y="6" width="6" height="12" rx="1" /><path d="M5 9v6M19 9v6M3 11v2M21 11v2" /></>;
const tp_sound = <><path d="M5 10v4h3l4 4V6L8 10H5zM16 9a4 4 0 010 6" /></>;
const tp_music = <><path d="M9 17V5l10-2v12" /><circle cx="7" cy="17" r="2" /><circle cx="17" cy="15" r="2" /></>;
const tp_file = <><path d="M14 3H7a2 2 0 00-2 2v14a2 2 0 002 2h10a2 2 0 002-2V8l-5-5zM14 3v5h5" /></>;
const tp_clock = <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>;
const tp_brightness = <><circle cx="12" cy="12" r="4" /><path d="M12 3v2M12 19v2M3 12h2M19 12h2M5.5 5.5l1.4 1.4M17.1 17.1l1.4 1.4M5.5 18.5l1.4-1.4M17.1 6.9l1.4-1.4" /></>;
const tp_minus = <><path d="M5 12h14" /></>;
const tp_trash = <><path d="M4 7h16M9 7V5a2 2 0 012-2h2a2 2 0 012 2v2M6 7l1 13a2 2 0 002 2h6a2 2 0 002-2l1-13" /></>;
const tp_lotus = <><path d="M12 20 C 5 15, 4 8, 4 3 C 8 5, 11 11, 12 17 C 13 11, 16 5, 20 3 C 20 8, 19 15, 12 20 Z" /></>;
const tp_flame = <><path d="M12 3c0 4-5 5-5 10a5 5 0 0010 0c0-2-1-3-2-4 0 1-1 2-2 2 0-3 1-5-1-8z" /></>;
const tp_diya = <><path d="M3 14a9 4 0 0018 0M5 14c0-2 3-3 7-3s7 1 7 3M12 11V8M11 5c0 1 1 2 1 3 0-1 1-2 1-3" /></>;

const iconBtnTp = {
  width: 38, height: 38, borderRadius: '50%', border: `1px solid ${TP.line}`,
  background: TP.card, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer'
};

// Decorative arch (temple gateway)
const TpArch = ({ w = 200, h = 80, color = TP.vermillion, op = 0.1 }) =>
<svg width={w} height={h} viewBox="0 0 200 80" style={{ opacity: op }}>
    <path d="M10 80 L10 40 Q10 10, 100 10 Q190 10, 190 40 L190 80" fill="none" stroke={color} strokeWidth="1.2" />
    <path d="M30 80 L30 50 Q30 25, 100 25 Q170 25, 170 50 L170 80" fill="none" stroke={color} strokeWidth="0.8" />
    <circle cx="100" cy="22" r="3" fill={color} />
  </svg>;


// Lotus medallion
const TpMedallion = ({ size = 80, color = TP.vermillion, op = 0.12 }) =>
<svg width={size} height={size} viewBox="0 0 100 100" style={{ opacity: op }}>
    <g fill="none" stroke={color} strokeWidth="0.8">
      <circle cx="50" cy="50" r="45" />
      <circle cx="50" cy="50" r="32" />
      {Array.from({ length: 8 }).map((_, i) => {
      const a = (i * 45 - 90) * Math.PI / 180;
      const x = 50 + Math.cos(a) * 24;
      const y = 50 + Math.sin(a) * 24;
      return <ellipse key={i} cx={x} cy={y} rx="6" ry="14" transform={`rotate(${i * 45} ${x} ${y})`} />;
    })}
      <circle cx="50" cy="50" r="6" fill={color} />
    </g>
  </svg>;


// ─────────────────────────────────────────────────────────────
// Screen 1 — Counter list (devotional altar)
// ─────────────────────────────────────────────────────────────
function TempleList() {
  const items = [
  { t: 'ലളിതാ സഹസ്രനാമം', count: 31, mala: 0, todayC: 1, todayM: 0, daily: 100, life: 3.1, lifeShown: true, accent: TP.vermillion },
  { t: 'കൃഷ്ണായ നമ', count: 3456, mala: 32, todayC: 108, todayM: 1, daily: 100, lifeShown: false, accent: TP.tulsi },
  { t: 'ഗണപതയേ നമ', count: 3456, mala: 32, todayC: 108, todayM: 1, daily: 100, lifeShown: false, accent: TP.sandal },
  { t: 'Om Durgaayai Namaha', count: 17543, mala: 162, todayC: 108, todayM: 1, daily: 4.3, life: 1.5, lifeShown: true, accent: TP.rose }];

  return (
    <div style={{ background: TP.bg, minHeight: '100%', fontFamily: TP.sans, color: TP.ink, position: 'relative' }}>
      {/* devotional header with arch */}
      <div style={{ padding: '24px 22px 18px', textAlign: 'center', position: 'relative', borderBottom: `1px solid ${TP.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 }}>
          <button style={iconBtnTp}><TpIcon d={tp_plus} /></button>
          <div style={{ fontSize: 10, letterSpacing: 4, color: TP.vermillion, fontWeight: 600 }}>॥ ॐ ॥</div>
          <button style={iconBtnTp}><TpIcon d={tp_dots} /></button>
        </div>
        <div style={{ position: 'relative', display: 'flex', justifyContent: 'center', marginBottom: -4 }}>
          <TpArch w={240} h={50} color={TP.vermillion} op={0.18} />
        </div>
        <div style={{ fontFamily: TP.serif, fontSize: 32, fontWeight: 500, lineHeight: 1, letterSpacing: 0, color: TP.ink, fontStyle: 'italic' }}>
          Mantra Counters
        </div>
        <div style={{ fontSize: 11, letterSpacing: 2, color: TP.ink3, marginTop: 6, textTransform: 'uppercase', width: "0px", opacity: "0" }}>The morning offering</div>
        {/* today summary */}
        <div style={{ marginTop: 16, display: 'inline-flex', gap: 18, padding: '10px 18px', background: TP.cardSoft, borderRadius: 100, border: `1px solid ${TP.line}` }}>
          <Stat2 v="325" l="chants" c={TP.vermillion} />
          <div style={{ width: 1, background: TP.line }} />
          <Stat2 v="3" l="malas" c={TP.sandal} />
          <div style={{ width: 1, background: TP.line }} />
          <Stat2 v="31" l="days" c={TP.tulsi} />
        </div>
      </div>

      <div style={{ padding: '14px 18px 28px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {items.map((it, i) =>
        <div key={i} style={{ background: TP.card, borderRadius: 16, border: `1px solid ${TP.line}`, padding: 16, position: 'relative', overflow: 'hidden' }}>
            <div style={{ position: 'absolute', top: -10, right: -10, opacity: 1 }}>
              <TpMedallion size={84} color={it.accent} op={0.1} />
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ width: 38, height: 38, borderRadius: '50%', background: TP.cardSoft, border: `1px solid ${TP.line}`, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <TpIcon d={tp_lotus} color={it.accent} size={18} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: TP.mal, fontSize: 17, fontWeight: 600, color: TP.ink, lineHeight: 1.2 }}>{it.t}</div>
                <div style={{ fontSize: 11, color: TP.ink3, letterSpacing: 1, marginTop: 2 }}>OFFERING {String(i + 1).padStart(2, '0')}</div>
              </div>
              {it.daily >= 100 &&
            <div style={{ width: 22, height: 22, borderRadius: '50%', background: TP.tulsi, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <TpIcon d={tp_check} color="#fff" size={13} sw={3} />
                </div>
            }
            </div>

            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 14 }}>
              <div style={{ fontFamily: TP.serif, fontSize: 38, fontWeight: 500, lineHeight: 1, color: it.accent, letterSpacing: -0.5 }}>{it.count.toLocaleString()}</div>
              <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.ink3 }}>chants · {it.mala} mala</div>
            </div>

            {/* prayer beads progress */}
            <div style={{ marginTop: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
                <div style={{ fontSize: 10, letterSpacing: 1.5, color: TP.ink3, fontWeight: 600 }}>TODAY · {it.todayC}c · {it.todayM}m</div>
                <div style={{ fontSize: 11, color: it.daily >= 100 ? TP.tulsi : TP.vermillion, fontWeight: 600 }}>
                  {it.daily >= 100 ? '✓ complete' : `${it.daily}% daily`}
                </div>
              </div>
              <div style={{ display: 'flex', gap: 3, alignItems: 'center' }}>
                {Array.from({ length: 27 }).map((_, j) =>
              <div key={j} style={{ flex: 1, height: 4, borderRadius: 2, background: j < Math.round(Math.min(it.daily, 100) / 100 * 27) ? it.accent : TP.line }} />
              )}
              </div>
              {it.lifeShown &&
            <div style={{ marginTop: 8, display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 11, color: TP.ink3 }}>
                  <span style={{ fontFamily: TP.serif, fontStyle: 'italic' }}>lifetime · {it.life}%</span>
                  <span style={{ fontFamily: TP.serif }}>{it.count} / {i === 0 ? '1,008' : '1,200,000'}</span>
                </div>
            }
            </div>
          </div>
        )}
      </div>
    </div>);

}
function Stat2({ v, l, c }) {
  return (
    <div style={{ textAlign: 'center' }}>
      <div style={{ fontFamily: TP.serif, fontSize: 18, fontWeight: 500, color: c, lineHeight: 1 }}>{v}</div>
      <div style={{ fontSize: 9, letterSpacing: 1.5, color: TP.ink3, marginTop: 2, textTransform: 'uppercase' }}>{l}</div>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 2 — Active counter (mala / prayer beads)
// ─────────────────────────────────────────────────────────────
function TempleCounter() {
  const count = 86,goal = 108;
  const beads = 27;
  const filled = Math.round(count / goal * beads);
  return (
    <div style={{ background: TP.bg, minHeight: '100%', fontFamily: TP.sans, color: TP.ink, display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '18px 18px 8px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <button style={iconBtnTp}><TpIcon d={tp_back} /></button>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '4px 12px', borderRadius: 100, background: TP.cardSoft, border: `1px solid ${TP.sandal}55` }}>
          <TpIcon d={tp_diya} color={TP.vermillion} size={14} />
          <span style={{ fontSize: 10, letterSpacing: 1.5, color: TP.vermillion, fontWeight: 700, whiteSpace: 'nowrap' }}>00:02</span>
        </div>
        <button style={iconBtnTp}><TpIcon d={tp_dots} /></button>
      </div>

      {/* Mantra title */}
      <div style={{ padding: '14px 22px 8px', textAlign: 'center' }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 4 }}>
          <TpArch w={200} h={36} color={TP.vermillion} op={0.25} />
        </div>
        <div style={{ fontFamily: TP.mal, fontSize: 22, fontWeight: 600, color: TP.ink, lineHeight: 1.2 }}>ലളിതാ സഹസ്രനാമം</div>
        <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.ink3, marginTop: 4 }}>session in progress · breathe with each bead</div>
      </div>

      {/* Mala beads — circular */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative', padding: '8px 0' }}>
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', pointerEvents: 'none' }}>
          <TpMedallion size={320} color={TP.vermillion} op={0.06} />
        </div>
        <div style={{ position: 'relative', width: 280, height: 280 }}>
          {/* prayer beads */}
          {Array.from({ length: beads }).map((_, i) => {
            const a = (i * (360 / beads) - 90) * Math.PI / 180;
            const r = 120;
            const x = 140 + Math.cos(a) * r;
            const y = 140 + Math.sin(a) * r;
            const isFilled = i < filled;
            const isLast = i === filled - 1;
            const size = isLast ? 14 : isFilled ? 11 : 8;
            return (
              <div key={i} style={{
                position: 'absolute', left: x, top: y, transform: 'translate(-50%, -50%)',
                width: size, height: size, borderRadius: '50%',
                background: isFilled ? isLast ? TP.vermillion : TP.sandal : TP.line,
                boxShadow: isLast ? `0 0 16px ${TP.vermillion}` : 'none',
                border: isFilled ? `1px solid ${TP.vermillionDeep}33` : 'none',
                transition: 'all .3s'
              }} />);

          })}
          {/* guru bead at top */}
          <div style={{ position: 'absolute', left: 140, top: 20, transform: 'translate(-50%, -50%)', width: 18, height: 22, borderRadius: 8, background: TP.vermillionDeep, border: `2px solid ${TP.sandal}` }} />

          {/* center number */}
          <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ fontSize: 10, letterSpacing: 3, color: TP.vermillion, fontWeight: 700 }}>SESSION</div>
            <div style={{ fontFamily: TP.serif, fontSize: 110, fontWeight: 500, lineHeight: 0.85, color: TP.ink, letterSpacing: -3, marginTop: 4, fontStyle: 'italic' }}>{count}</div>
            <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.ink3, marginTop: 6 }}>of one hundred eight</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 8, fontSize: 10, color: TP.tulsi, fontWeight: 700, letterSpacing: 1 }}>
              <div style={{ width: 6, height: 6, borderRadius: '50%', background: TP.tulsi, animation: 'pulse 2s infinite' }} />
              22 BEADS REMAIN
            </div>
          </div>
        </div>
      </div>

      {/* Stats footer */}
      <div style={{ padding: '0 18px 16px' }}>
        <div style={{ display: 'flex', gap: 8, marginBottom: 10 }}>
          <TpFooterStat l="Lifetime" v="31" sub="of 1,008" />
          <TpFooterStat l="Daily" v="1/1" sub="✓ complete" c={TP.tulsi} />
          <TpFooterStat l="Today" v="86" sub="chants" />
        </div>
        <button style={{
          width: '100%', height: 48, borderRadius: 100,
          border: `1px solid ${TP.line}`, background: TP.card, color: TP.ink2,
          fontFamily: TP.serif, fontStyle: 'italic', fontSize: 14, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8
        }}>
          <TpIcon d={tp_minus} color={TP.ink2} size={14} /> ---deduct
        </button>
      </div>
    </div>);

}
function TpFooterStat({ l, v, sub, c = TP.ink }) {
  return (
    <div style={{ flex: 1, padding: '10px 12px', background: TP.card, border: `1px solid ${TP.line}`, borderRadius: 12, textAlign: 'center' }}>
      <div style={{ fontSize: 9, letterSpacing: 1.5, color: TP.ink3, fontWeight: 600 }}>{l.toUpperCase()}</div>
      <div style={{ fontFamily: TP.serif, fontSize: 20, fontWeight: 500, color: c, lineHeight: 1, marginTop: 2 }}>{v}</div>
      <div style={{ fontSize: 10, color: TP.ink3, fontStyle: 'italic', fontFamily: TP.serif, marginTop: 2 }}>{sub}</div>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 3 — History (devotional chronicle)
// ─────────────────────────────────────────────────────────────
function TempleHistory() {
  const days = [
  { d: 'Today', sub: 'Day 31', c: 1, m: 0, time: '18:29', life: '31 / 1,008', pct: 3.08, today: true },
  { d: 'Apr 26', sub: 'Day 30', c: 1, m: 0, time: '15:13', life: '30 / 1,008', pct: 2.98 },
  { d: 'Apr 25', sub: 'Day 29', c: 1, m: 0, time: '15:44', life: '29 / 1,008', pct: 2.88 },
  { d: 'Apr 24', sub: 'Day 28', c: 1, m: 0, time: '17:40', life: '28 / 1,008', pct: 2.78 }];

  return (
    <div style={{ background: TP.bg, minHeight: '100%', fontFamily: TP.sans, color: TP.ink }}>
      <div style={{ padding: '18px 18px 10px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <button style={iconBtnTp}><TpIcon d={tp_back} /></button>
        <div style={{ fontSize: 10, letterSpacing: 4, color: TP.vermillion, fontWeight: 600 }}>॥ ॐ ॥</div>
        <button style={iconBtnTp}><TpIcon d={tp_trash} /></button>
      </div>

      {/* Hero */}
      <div style={{ padding: '8px 22px 22px', textAlign: 'center', borderBottom: `1px solid ${TP.line}`, position: 'relative' }}>
        <div style={{ position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)', opacity: 1 }}>
          <TpMedallion size={120} color={TP.vermillion} op={0.08} />
        </div>
        <div style={{ fontFamily: TP.mal, fontSize: 22, fontWeight: 600, color: TP.ink, position: 'relative' }}>ലളിതാ സഹസ്രനാമം</div>
        <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.ink3, marginTop: 4, position: 'relative' }}>a record of devotion</div>

        <div style={{ marginTop: 22, display: 'flex', justifyContent: 'center', alignItems: 'baseline', gap: 8, position: 'relative' }}>
          <div style={{ fontFamily: TP.serif, fontSize: 72, fontWeight: 500, lineHeight: 0.85, color: TP.vermillion, letterSpacing: -2, fontStyle: 'italic' }}>31</div>
          <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 16, color: TP.ink3 }}>/ 1,008</div>
        </div>
        <div style={{ fontSize: 10, letterSpacing: 2, color: TP.ink3, marginTop: 6, position: 'relative' }}>CHANTS OFFERED · 3.08% OF VOW</div>

        {/* hairline progress with diya */}
        <div style={{ marginTop: 18, position: 'relative', height: 24 }}>
          <div style={{ position: 'absolute', top: 11, left: 0, right: 0, height: 2, background: TP.line }} />
          <div style={{ position: 'absolute', top: 10, left: 0, height: 4, width: '3%', background: TP.vermillion, borderRadius: 2 }} />
          <div style={{ position: 'absolute', top: 0, left: 'calc(3% - 12px)' }}>
            <TpIcon d={tp_diya} color={TP.vermillion} size={24} sw={1.6} />
          </div>
        </div>
      </div>

      {/* day list */}
      <div style={{ padding: '14px 18px 28px' }}>
        <div style={{ fontSize: 10, letterSpacing: 3, color: TP.ink3, fontWeight: 600, padding: '4px 0 12px' }}>RECENT OFFERINGS</div>
        {days.map((d, i) =>
        <div key={i} style={{ padding: '14px 0', borderBottom: i < days.length - 1 ? `1px solid ${TP.line}` : 'none', display: 'flex', gap: 14, alignItems: 'center' }}>
            <div style={{ width: 44, height: 44, borderRadius: '50%', background: d.today ? TP.vermillion : TP.cardSoft, border: `1px solid ${d.today ? TP.vermillionDeep : TP.line}`, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
              <div style={{ fontFamily: TP.serif, fontSize: 18, fontStyle: 'italic', fontWeight: 500, color: d.today ? '#fff' : TP.vermillion, lineHeight: 1 }}>{d.sub.replace('Day ', '')}</div>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{ fontSize: 14, fontWeight: 600, whiteSpace: 'nowrap' }}>{d.d}</span>
                  <span style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 12, color: TP.ink3 }}>at {d.time}</span>
                </div>
                <div style={{ width: 16, height: 16, borderRadius: '50%', background: TP.tulsi, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <TpIcon d={tp_check} color="#fff" size={10} sw={3} />
                </div>
              </div>
              <div style={{ display: 'flex', gap: 14, marginTop: 6, fontSize: 12, color: TP.ink2 }}>
                <span><b style={{ fontFamily: TP.serif, fontWeight: 500 }}>{d.c}</b> chant</span>
                <span><b style={{ fontFamily: TP.serif, fontWeight: 500 }}>{d.m}</b> mala</span>
                <span style={{ color: TP.vermillion, fontStyle: 'italic', fontFamily: TP.serif }}>{d.life} · {d.pct}%</span>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>);

}

// ─────────────────────────────────────────────────────────────
// Screen 4 — Settings (devotional)
// ─────────────────────────────────────────────────────────────
function TempleSettings() {
  return (
    <div style={{ background: TP.bg, minHeight: '100%', fontFamily: TP.sans, color: TP.ink }}>
      <div style={{ padding: '18px 18px 14px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: `1px solid ${TP.line}` }}>
        <button style={iconBtnTp}><TpIcon d={tp_back} /></button>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 10, letterSpacing: 3, color: TP.vermillion, fontWeight: 600, textTransform: 'uppercase' }}>Practice</div>
          <div style={{ fontFamily: TP.serif, fontSize: 28, fontWeight: 500, lineHeight: 1, marginTop: 2, fontStyle: 'italic' }}>Settings</div>
        </div>
        <TpIcon d={tp_lotus} color={TP.vermillion} size={22} />
      </div>

      <div style={{ padding: '8px 18px 28px' }}>
        <TpSection title="Daily goal" sub="When the offering is complete" icon={tp_diya}>
          <TpRow icon={tp_bell} title="Enable notification" sub="Vibrate and sound on completion" toggle />
          <TpRow icon={tp_vibrate} title="Vibration" sub="A gentle hum on completion" toggle />
          <TpRow icon={tp_sound} title="Sound" sub="Play a tone on completion" toggle />
          <TpRow icon={tp_music} title="Notification tone" right="Clear" />
          <TpRow icon={tp_file} title="Choose from files" sub="Use any audio you wish" />
          <TpRow icon={tp_play} title="Preview sound" last />
        </TpSection>

        <TpSection title="Mala completion" sub="The closing of every 108 beads" icon={tp_lotus}>
          <TpRow icon={tp_clock} title="Enable mala sound" sub="A soft tick on each full mala" toggle />
          <TpRow icon={tp_play} title="Preview mala sound" last />
        </TpSection>

        <TpSection title="Stillness" sub="For longer sessions" icon={tp_brightness}>
          <TpRow icon={tp_brightness} title="Reduce brightness" sub="Dim the screen during chanting" toggle />
          <div style={{ padding: '14px 16px', borderTop: `1px solid ${TP.line}` }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <div style={{ fontSize: 13, fontWeight: 500 }}>Brightness level</div>
              <div style={{ fontFamily: TP.serif, fontSize: 22, fontStyle: 'italic', lineHeight: 1, color: TP.vermillion }}>10<span style={{ fontSize: 12, color: TP.ink3, fontStyle: 'normal' }}>%</span></div>
            </div>
            <div style={{ height: 2, background: TP.line, marginTop: 14, position: 'relative' }}>
              <div style={{ position: 'absolute', top: -1, left: 0, height: 4, width: '10%', background: TP.vermillion, borderRadius: 2 }} />
              <div style={{ position: 'absolute', top: '50%', left: '10%', transform: 'translate(-50%, -50%)', width: 14, height: 14, borderRadius: '50%', background: TP.vermillion, border: `2px solid ${TP.bg}`, boxShadow: `0 0 8px ${TP.vermillion}66` }} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: TP.ink3, fontFamily: TP.serif, fontStyle: 'italic', marginTop: 10 }}>
              <span>still</span><span>full</span>
            </div>
          </div>
        </TpSection>

        <div style={{ padding: 16, background: TP.cardSoft, borderRadius: 14, border: `1px solid ${TP.line}`, display: 'flex', gap: 12, alignItems: 'flex-start' }}>
          <TpIcon d={tp_diya} color={TP.vermillion} size={20} />
          <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.ink2, lineHeight: 1.6 }}>
            The daily-goal sound plays when your goal is reached. The mala sound rings softly after every 108 chants — except when that count also completes the daily offering.
          </div>
        </div>
      </div>
    </div>);

}
function TpSection({ title, sub, icon, children }) {
  return (
    <div style={{ marginTop: 18 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 4px 12px' }}>
        <div style={{ width: 32, height: 32, borderRadius: '50%', background: TP.cardSoft, border: `1px solid ${TP.line}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <TpIcon d={icon} color={TP.vermillion} size={16} />
        </div>
        <div>
          <div style={{ fontFamily: TP.serif, fontSize: 18, fontWeight: 500, fontStyle: 'italic', lineHeight: 1, color: TP.ink }}>{title}</div>
          <div style={{ fontSize: 11, color: TP.ink3, marginTop: 3, letterSpacing: 0.3 }}>{sub}</div>
        </div>
      </div>
      <div style={{ background: TP.card, border: `1px solid ${TP.line}`, borderRadius: 16, overflow: 'hidden' }}>{children}</div>
    </div>);

}
function TpRow({ icon, title, sub, right, toggle, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '13px 14px', borderTop: !last ? `1px solid ${TP.line}` : 'none' }}>
      <div style={{ width: 30, height: 30, borderRadius: 8, background: TP.cardSoft, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
        <TpIcon d={icon} color={TP.ink2} size={15} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 13.5, fontWeight: 500, color: TP.ink }}>{title}</div>
        {sub && <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 11.5, color: TP.ink3, marginTop: 1 }}>{sub}</div>}
      </div>
      {right && <div style={{ fontFamily: TP.serif, fontStyle: 'italic', fontSize: 13, color: TP.vermillion }}>{right}</div>}
      {toggle &&
      <div style={{ width: 40, height: 22, borderRadius: 11, background: TP.vermillion, position: 'relative' }}>
          <div style={{ position: 'absolute', right: 2, top: 2, width: 18, height: 18, borderRadius: '50%', background: '#fff' }} />
        </div>
      }
      {!toggle && !right && <TpIcon d={tp_chevR} color={TP.ink3} size={16} />}
    </div>);

}

window.TempleList = TempleList;
window.TempleCounter = TempleCounter;
window.TempleHistory = TempleHistory;
window.TempleSettings = TempleSettings;