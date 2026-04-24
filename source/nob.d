module nob;

import std.stdio;
import std.process;
import std.file;
import std.format;
import std.path;
import std.array : array;
import std.algorithm.iteration : map, filter;
import core.stdc.stdlib : exit;

bool executeInst(scope string[] args) {
  writeln("[EXECUTE] ", args);
  return wait(spawnProcess(args)) == 0;
}

string[] lsInst(string dirpath, bool join = false) {
  assert(exists(dirpath) && isDir(dirpath));
  writeln("[LIST] ", dirpath);
  return dirEntries(dirpath, SpanMode.shallow)
    .map!((return a) => (join) ? buildPath(dirpath, baseName(a.name)) : baseName(a.name)).array;
}

void renameInst(string from, string to) {
  writeln(format("[MOVE] %s -> %s", from, to));
  rename(from, to);
}

void removeInst(string path) {
  writeln(format("[REMOVE] %s", path));
  remove(path);
}

bool needsRebuilding(string outPath, string[] inPaths) {
  import std.datetime : SysTime;

  SysTime outModificationTime = timeLastModified(outPath);
  foreach (string inPath; inPaths) {
    SysTime inModificationTime = timeLastModified(inPath);
    if (outModificationTime < inModificationTime) {
      return true;
    }
  }
  return false;
}

// In most of the use cases we would pass __FILE__ in place of sourcePath. 
void goRebuildYourself(string[] args, string sourcePath) {
  string binaryPath = args[0];
  if (!needsRebuilding(binaryPath, [sourcePath])) {
    return;
  }
  string oldBinaryPath = format("%s.old", binaryPath);
  renameInst(binaryPath, oldBinaryPath);
  if (!executeInst(["dmd", sourcePath, format("-of=%s", binaryPath)])) {
    renameInst(oldBinaryPath, binaryPath);
  }
  removeInst(oldBinaryPath);
  exit(!executeInst([binaryPath]));
}
