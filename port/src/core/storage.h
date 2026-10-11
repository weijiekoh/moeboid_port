/* Settings and high-score store as one text blob (M1; analysis/shell.md 2.4).
 * The host keeps the blob in localStorage (port_storage_get_ptr/len, port_storage_load).
 * M4 decides the key names (for example per-game properties "Score1Name").
 *
 * Blob format (text, bytes kept as is, entries in insertion order):
 *   MOEBOID-STORAGE 1\n
 *   key=value\n            (one line per entry)
 * Keys: 1..255 bytes, no '=', no byte below 0x20. Values: any bytes except NUL; '\\', '\n',
 * '\r' are written as \\ \n \r. A value can be empty. Every set that changes the content sets
 * `changed` (write-through, shell.md 2.4); port_advance reports it as bit 2. */
#ifndef MOEBOID_CORE_STORAGE_H
#define MOEBOID_CORE_STORAGE_H

#include "../rt/rt.h"

#define STORAGE_HEADER "MOEBOID-STORAGE 1\n"

typedef struct StorageEntry {
    char *key;
    char *value;
} StorageEntry;

typedef struct Storage {
    StorageEntry *e;
    uint32_t count, cap;
    char *blob; /* last serialisation */
    uint32_t blob_len;
    bool blob_valid;
    bool changed; /* content changed since the host last took the flag */
} Storage;

/* A zero-filled Storage is a valid empty store. */
void storage_clear(Storage *s);
/* NULL when the key is absent ("missing" for the engine get, shell.md 2.3). */
const char *storage_get(const Storage *s, const char *key);
/* False for an invalid key or out of memory. */
bool storage_set(Storage *s, const char *key, const char *value);
bool storage_remove(Storage *s, const char *key);
/* Serialised blob (valid until the next change). */
const char *storage_blob(Storage *s, uint32_t *len);
/* Replace the content with a parsed blob. Returns the number of lines that were not valid
 * entries (0 = clean); -1 if the header is wrong (the store is then empty). An empty blob
 * gives an empty store and returns 0. Does not set `changed`. */
int32_t storage_load(Storage *s, const uint8_t *data, uint32_t len);

#endif
