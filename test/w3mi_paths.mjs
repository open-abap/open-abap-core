import assert from "node:assert/strict";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import {test} from "node:test";
import {fileURLToPath, pathToFileURL} from "node:url";
import runtime from "@abaplint/runtime";

const output = fileURLToPath(new URL("../output/", import.meta.url));
const moduleName = "zw3mi.fugr.mjs";
let source;
try {
  source = await fs.readFile(path.join(output, "project", moduleName));
} catch (error) {
  if (error.code !== "ENOENT") throw error;
  source = await fs.readFile(path.join(output, moduleName));
}

// Exercise the generated functions in both layouts, without transpiler/runtime
// initialization choosing the fixture's root on their behalf.
for (const layout of ["grouped", "flat", "legacy flat"]) {
  test(`W3MI ${layout} output from another working directory`, async () => {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), "w3mi fixture #"));
    const previousCwd = process.cwd();
    try {
      const moduleDir = layout === "grouped" ? path.join(root, "mime-library") : root;
      await fs.mkdir(moduleDir, {recursive: true});
      await fs.writeFile(path.join(moduleDir, moduleName), source);
      if (layout !== "legacy flat") {
        await fs.writeFile(path.join(root, "_top.mjs"), "");
      }
      const filename = layout === "grouped" ? "project/asset.w3mi.data.bin" : "asset.w3mi.data.bin";
      await fs.mkdir(path.dirname(path.join(root, filename)), {recursive: true});
      if (layout === "grouped") {
        // A module-relative decoy must never shadow the registered root-relative asset.
        await fs.mkdir(path.join(moduleDir, "project"));
        await fs.writeFile(path.join(moduleDir, filename), "wrong asset");
      }

      globalThis.abap = new runtime.ABAP();
      process.chdir(os.tmpdir());
      await import(pathToFileURL(path.join(moduleDir, moduleName)).href);
      abap.W3MI.TEST_ASSET = {objectType: "W3MI", filename};
      const char = (length, value) => new abap.types.Character(length).set(value);
      const key = (relid = "MI", objid = "TEST_ASSET") => new abap.types.Structure({
        relid: char(2, relid), objid: char(40, objid),
      });
      const mime = abap.types.TableFactory.construct(new abap.types.Structure({
        line: new abap.types.Hex({length: 255}),
      }), {withHeader: true, keyType: "DEFAULT"});
      const read = (assetKey = key()) => abap.FunctionModules.WWWDATA_IMPORT({
        exporting: {key: assetKey}, tables: {mime},
      });

      for (const length of [0, 1, 255, 256, 510, 600]) {
        const bytes = Buffer.from(Array.from({length}, (_, i) => i % 256));
        await fs.writeFile(path.join(root, filename), bytes);
        const value = char(10, "");
        await abap.FunctionModules.WWWPARAMS_READ({
          exporting: {relid: char(2, "MI"), objid: char(40, "TEST_ASSET"), name: char(8, "filesize")},
          importing: {value},
        });
        assert.equal(value.get().trim(), String(length));
        assert.equal(abap.builtin.sy.get().subrc.get(), 0);

        // A successful import replaces any previous rows, including for an empty asset.
        abap.statements.append({source: new abap.types.Structure({line: new abap.types.Hex({length: 255}).set("FF")}), target: mime});
        await read();
        assert.equal(mime.array().length, Math.ceil(length / 255));
        const actual = mime.array().map(row => row.get().line.get()).join("");
        assert.equal(actual, bytes.toString("hex").toUpperCase().padEnd(Math.ceil(length / 255) * 510, "0"));
        assert.equal(abap.builtin.sy.get().subrc.get(), 0);
      }

      const before = mime.array().map(row => row.get().line.get());
      for (const [assetKey, exception] of [[key("XX"), "wrong_object_type"], [key("MI", "MISSING"), "import_error"]]) {
        await assert.rejects(read(assetKey), error => error instanceof abap.ClassicError && error.classic === exception);
        assert.deepEqual(mime.array().map(row => row.get().line.get()), before);
      }
      await fs.unlink(path.join(root, filename));
      await assert.rejects(read(), {code: "ENOENT"});
      assert.equal(mime.array().length, 0);
    } finally {
      process.chdir(previousCwd);
      await fs.rm(root, {recursive: true, force: true});
    }
  });
}
