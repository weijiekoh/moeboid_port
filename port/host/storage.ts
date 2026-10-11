// Settings and high-score blob in localStorage (M1; shell.md 2.4). The blob is bytes
// (src/core/storage.h); each byte is kept as one UTF-16 code unit 0..255, so no byte changes.

const KEY = "moeboid.storage.v1";

export function loadStorage(): Uint8Array {
  let s: string | null = null;
  try {
    s = window.localStorage.getItem(KEY);
  } catch {
    return new Uint8Array(0); // storage blocked: start empty
  }
  if (!s) return new Uint8Array(0);
  const out = new Uint8Array(s.length);
  for (let i = 0; i < s.length; i++) out[i] = s.charCodeAt(i) & 0xff;
  return out;
}

export function saveStorage(bytes: Uint8Array): void {
  let s = "";
  for (let i = 0; i < bytes.length; i += 4096) {
    s += String.fromCharCode(...bytes.subarray(i, Math.min(bytes.length, i + 4096)));
  }
  try {
    window.localStorage.setItem(KEY, s);
  } catch (err) {
    console.warn("moeboid: localStorage write failed", err);
  }
}
