An unofficial port of [nob.h - tsoding](https://github.com/tsoding/nob.h) to [D](https://dlang.org/),
inspired by [tsoding's vod - 'Most underrated "C/C++ Killer"'](https://youtu.be/Gj5310KnUTQ).

I created this to use in my D projects, and future updates will be driven by my project needs.

> **Note** This is not a full implementation/port of `nob.h`, just a minimal subset to get started.

## Example

```d
module main;

import nob;

int main(string[] args) {
  goRebuildYourself(args);
  writeln("saluton! mi estas ninthcircle.");
  return 0;
}
```

All credits go to [tsoding](https://github.com/tsoding) for the original `nob.h`.
