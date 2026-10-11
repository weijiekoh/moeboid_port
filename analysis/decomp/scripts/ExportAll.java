// Export decompiled C, functions, imports, strings, globals, vtables and a listing
// for the current program into <outdir>/<program name>/.
// Usage: analyzeHeadless <proj_dir> moeboid -process <prog> -noanalysis -readOnly
//        -scriptPath <dir> -postScript ExportAll.java <outdir>
//@category Export

import java.io.*;
import java.util.*;

import ghidra.app.decompiler.*;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.*;
import ghidra.program.model.data.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.mem.*;
import ghidra.program.model.symbol.*;

public class ExportAll extends GhidraScript {

    private PrintWriter open(File dir, String name) throws IOException {
        return new PrintWriter(new BufferedWriter(new OutputStreamWriter(
            new FileOutputStream(new File(dir, name)), "UTF-8")));
    }

    private String fname(Address a) {
        Function f = getFunctionContaining(a);
        return f == null ? "-" : f.getName() + "@" + f.getEntryPoint();
    }

    private static String esc(String s) {
        StringBuilder b = new StringBuilder();
        for (char c : s.toCharArray()) {
            if (c == '\n') b.append("\\n");
            else if (c == '\r') b.append("\\r");
            else if (c == '\t') b.append("\\t");
            else if (c == '\\') b.append("\\\\");
            else if (c < 0x20 || c == 0x7f) b.append(String.format("\\x%02x", (int) c));
            else b.append(c);
        }
        return b.toString();
    }

    private boolean isExec(Address a) {
        MemoryBlock b = currentProgram.getMemory().getBlock(a);
        return b != null && b.isExecute();
    }

    @Override
    public void run() throws Exception {
        String[] args = getScriptArgs();
        File root = new File(args[0]);
        File dir = new File(root, currentProgram.getName());
        dir.mkdirs();
        Listing listing = currentProgram.getListing();
        FunctionManager fm = currentProgram.getFunctionManager();
        ReferenceManager rm = currentProgram.getReferenceManager();
        SymbolTable st = currentProgram.getSymbolTable();
        Memory mem = currentProgram.getMemory();

        // 1. functions.tsv
        try (PrintWriter w = open(dir, "functions.tsv")) {
            w.println("entry\tname\tsource\tsize\tthunk\tcallconv\tparams\tcallers\tcallees\tsignature");
            for (Function f : fm.getFunctions(true)) {
                Set<String> callers = new TreeSet<>();
                for (Function c : f.getCallingFunctions(monitor)) callers.add(c.getName());
                Set<String> callees = new TreeSet<>();
                for (Function c : f.getCalledFunctions(monitor)) callees.add(c.getName());
                w.println(f.getEntryPoint() + "\t" + f.getName() + "\t" + f.getSymbol().getSource()
                    + "\t" + f.getBody().getNumAddresses() + "\t" + f.isThunk()
                    + "\t" + f.getCallingConventionName() + "\t" + f.getParameterCount()
                    + "\t" + String.join(",", callers) + "\t" + String.join(",", callees)
                    + "\t" + esc(f.getPrototypeString(false, false)));
            }
        }

        // 2. imports.tsv (externals with xrefs)
        try (PrintWriter w = open(dir, "imports.tsv")) {
            w.println("library\tname\tordinal\tref_from\tref_type\tfunction");
            ExternalManager em = currentProgram.getExternalManager();
            for (String lib : em.getExternalLibraryNames()) {
                ExternalLocationIterator it = em.getExternalLocations(lib);
                while (it.hasNext()) {
                    ExternalLocation loc = it.next();
                    Symbol s = loc.getSymbol();
                    String ord = loc.getOriginalImportedName() != null ? loc.getOriginalImportedName() : "";
                    boolean any = false;
                    for (Reference r : rm.getReferencesTo(s.getAddress())) {
                        Address t = r.getFromAddress();
                        Function th = fm.getFunctionAt(t);
                        if (isExec(t) && (th == null || !th.isThunk())) {
                            w.println(lib + "\t" + loc.getLabel() + "\t" + ord + "\t" + t + "\t" + r.getReferenceType() + "\t" + fname(t));
                            any = true;
                            continue;
                        }
                        // t is an IAT slot or a thunk: list references to it
                        for (Reference r2 : rm.getReferencesTo(t)) {
                            w.println(lib + "\t" + loc.getLabel() + "\t" + ord + "\t" + r2.getFromAddress()
                                + "\t" + r2.getReferenceType() + (th != null ? "_VIA_THUNK" : "_VIA_IAT") + "\t" + fname(r2.getFromAddress()));
                            any = true;
                        }
                    }
                    if (!any) w.println(lib + "\t" + loc.getLabel() + "\t" + ord + "\t-\tNO_REFS\t-");
                }
            }
        }

        // 3. strings.tsv
        try (PrintWriter w = open(dir, "strings.tsv")) {
            w.println("address\ttype\txrefs\tvalue");
            DataIterator di = listing.getDefinedData(true);
            while (di.hasNext()) {
                Data d = di.next();
                if (!d.hasStringValue()) continue;
                Set<String> xs = new TreeSet<>();
                for (Reference r : rm.getReferencesTo(d.getAddress())) xs.add(r.getFromAddress() + ":" + fname(r.getFromAddress()));
                Object v = d.getValue();
                w.println(d.getAddress() + "\t" + d.getDataType().getName() + "\t" + String.join(",", xs)
                    + "\t" + esc(v == null ? "" : v.toString()));
            }
        }

        // 4. globals.tsv: referenced addresses in non-executable blocks
        try (PrintWriter w = open(dir, "globals.tsv")) {
            w.println("address\tblock\tname\tdatatype\tnrefs\tfunctions");
            AddressIterator ai = rm.getReferenceDestinationIterator(currentProgram.getMemory().getLoadedAndInitializedAddressSet()
                .union(mem.getAllInitializedAddressSet()).union(allNonExec(mem)), true);
            while (ai.hasNext()) {
                Address a = ai.next();
                if (isExec(a)) continue;
                MemoryBlock b = mem.getBlock(a);
                if (b == null) continue;
                Set<String> fs = new TreeSet<>();
                int n = 0;
                for (Reference r : rm.getReferencesTo(a)) { n++; fs.add(fname(r.getFromAddress())); }
                Symbol s = st.getPrimarySymbol(a);
                Data d = listing.getDataContaining(a);
                w.println(a + "\t" + b.getName() + "\t" + (s == null ? "-" : s.getName(true)) + "\t"
                    + (d == null ? "-" : d.getDataType().getName()) + "\t" + n + "\t" + String.join(",", fs));
            }
        }

        // 5. vtables: RTTI-derived and heuristic
        try (PrintWriter w = open(dir, "vtables.txt")) {
            // RTTI type descriptors: strings ".?AV" / ".?AU"
            w.println("# RTTI type descriptor names (.?AV/.?AU) and derived vtables");
            Map<Address, String> rttiVt = new TreeMap<>();
            for (String pfx : new String[] {".?AV", ".?AU"}) {
                Address start = mem.getMinAddress();
                while (start != null) {
                    Address hit = mem.findBytes(start, pfx.getBytes("ASCII"), null, true, monitor);
                    if (hit == null) break;
                    StringBuilder nm = new StringBuilder();
                    Address p = hit;
                    while (true) { byte c = mem.getByte(p); if (c == 0) break; nm.append((char) (c & 0xff)); p = p.add(1); }
                    Address td = hit.subtract(8);
                    w.println("TypeDescriptor " + td + " " + nm);
                    // find COL: dword at COL+0xC == td
                    for (Address colRef : findDword(mem, td.getOffset())) {
                        Address col = colRef.subtract(0xC);
                        for (Address vtm1 : findDword(mem, col.getOffset())) {
                            if (isExec(vtm1)) continue;
                            Address vt = vtm1.add(4);
                            rttiVt.put(vt, nm.toString());
                            w.println("  COL " + col + " vftable " + vt);
                        }
                    }
                    start = hit.add(1);
                }
            }
            w.println();
            w.println("# Candidate vtables: runs of >=2 dwords pointing to function entries, in non-executable initialized memory");
            for (MemoryBlock b : mem.getBlocks()) {
                if (b.isExecute() || !b.isInitialized()) continue;
                Address a = b.getStart();
                Address end = b.getEnd();
                while (a.add(3).compareTo(end) <= 0) {
                    List<Address> run = new ArrayList<>();
                    Address p = a;
                    while (p.add(3).compareTo(end) <= 0) {
                        long v = mem.getInt(p) & 0xffffffffL;
                        Address t;
                        try { t = currentProgram.getAddressFactory().getDefaultAddressSpace().getAddress(v); } catch (Exception e) { break; }
                        if (!isExec(t)) break;
                        if (p != a && rm.getReferencesTo(p).iterator().hasNext() && run.size() >= 2) break; // new table starts
                        run.add(t);
                        p = p.add(4);
                    }
                    if (run.size() >= 2) {
                        Set<String> xs = new TreeSet<>();
                        for (Reference r : rm.getReferencesTo(a)) xs.add(r.getFromAddress() + ":" + fname(r.getFromAddress()));
                        String rt = rttiVt.containsKey(a) ? " RTTI=" + rttiVt.get(a) : "";
                        Symbol s = st.getPrimarySymbol(a);
                        w.println("VTABLE " + a + " n=" + run.size() + (s != null ? " sym=" + s.getName(true) : "") + rt
                            + " xrefs=" + String.join(",", xs));
                        for (int i = 0; i < run.size(); i++)
                        {
                            Function rf = fm.getFunctionAt(run.get(i));
                            w.println(String.format("  +0x%03x %s %s", i * 4, run.get(i), rf == null ? "(no function at target)" : rf.getName()));
                        }
                        a = p;
                    } else {
                        a = a.add(4);
                    }
                }
            }
        }

        // 6. indirect_calls.tsv
        try (PrintWriter w = open(dir, "indirect_calls.tsv")) {
            w.println("address\tfunction\tinstruction");
            InstructionIterator ii = listing.getInstructions(true);
            while (ii.hasNext()) {
                Instruction ins = ii.next();
                if (!ins.getFlowType().isCall()) continue;
                if (!ins.getFlowType().isComputed()) continue;
                w.println(ins.getAddress() + "\t" + fname(ins.getAddress()) + "\t" + ins.toString());
            }
        }

        // 7. listing.asm
        try (PrintWriter w = open(dir, "listing.asm")) {
            InstructionIterator ii = listing.getInstructions(true);
            while (ii.hasNext()) {
                Instruction ins = ii.next();
                Function f = fm.getFunctionAt(ins.getAddress());
                if (f != null) w.println("\n;==== FUNCTION " + f.getName() + " @ " + f.getEntryPoint() + " : " + esc(f.getPrototypeString(false, false)));
                Symbol s = st.getPrimarySymbol(ins.getAddress());
                if (s != null && f == null) w.println(s.getName() + ":");
                StringBuilder refs = new StringBuilder();
                for (Reference r : ins.getReferencesFrom()) {
                    Symbol ts = st.getPrimarySymbol(r.getToAddress());
                    if (ts != null) refs.append(" ").append(ts.getName(true));
                }
                w.println("  " + ins.getAddress() + "  " + ins.toString() + (refs.length() > 0 ? "    ;" + refs : ""));
            }
        }

        // 8. decompiled.c and decompiled_index.tsv
        DecompInterface ifc = new DecompInterface();
        DecompileOptions opts = new DecompileOptions();
        opts.grabFromProgram(currentProgram);
        ifc.setOptions(opts);
        ifc.toggleCCode(true);
        ifc.toggleSyntaxTree(false);
        ifc.openProgram(currentProgram);
        int line = 1;
        int nfail = 0;
        try (PrintWriter w = open(dir, "decompiled.c"); PrintWriter idx = open(dir, "decompiled_index.tsv")) {
            idx.println("entry\tname\tline");
            for (Function f : fm.getFunctions(true)) {
                if (f.isExternal()) continue;
                String hdr = "/* ==== FUNCTION " + f.getName() + " @ " + f.getEntryPoint() + " size=" + f.getBody().getNumAddresses() + " ==== */";
                idx.println(f.getEntryPoint() + "\t" + f.getName() + "\t" + line);
                w.println(hdr); line++;
                String c;
                DecompileResults res = ifc.decompileFunction(f, 180, monitor);
                if (res != null && res.decompileCompleted() && res.getDecompiledFunction() != null) {
                    c = res.getDecompiledFunction().getC();
                } else {
                    nfail++;
                    c = "/* DECOMPILE FAILED: " + (res == null ? "null" : res.getErrorMessage()) + " */\n";
                }
                w.print(c);
                line += c.split("\n", -1).length - 1;
                if (!c.endsWith("\n")) { w.println(); line++; }
                w.println(); line++;
            }
        }
        ifc.dispose();
        println("ExportAll: " + currentProgram.getName() + " done, decompile failures: " + nfail);
    }

    private AddressSetView allNonExec(Memory mem) {
        AddressSet s = new AddressSet();
        for (MemoryBlock b : mem.getBlocks()) if (!b.isExecute()) s.add(b.getStart(), b.getEnd());
        return s;
    }

    private List<Address> findDword(Memory mem, long value) throws Exception {
        byte[] pat = new byte[] {(byte) value, (byte) (value >> 8), (byte) (value >> 16), (byte) (value >> 24)};
        List<Address> out = new ArrayList<>();
        Address start = mem.getMinAddress();
        while (start != null) {
            Address hit = mem.findBytes(start, pat, null, true, monitor);
            if (hit == null) break;
            if ((hit.getOffset() & 3) == 0) out.add(hit);
            start = hit.add(1);
        }
        return out;
    }
}
