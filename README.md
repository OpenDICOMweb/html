HTML File I/O
-------------
#### HtmlFile
A class that wraps the File class, but provides three simple read
methods:

* **readAsBytes**: Reads the file as a [Uint8List]
* **readAsString()**: Reads the files as a [String]
* **readAsDataUrl()**: Reads the file as a String and converts it to a
   [Data:URL]

An example using ```async``` and ```await```:

```
  Future readFile(File file) async {
    HtmlFile f = new HtmlFile(file);
    String s = await f.readAsString();
    showFile(f, s);
  }
```


#### FileStream
A class that wraps the File class, but provides the ability to read a
File as a [Stream] of [Uint8List]s (i.e. chunks).

An example using ```async``` and ```await for```:

```
  Future readFileStream(File file) async {
    var stream = new FileStream(file);
    await for (Uint8List blob in stream) {
      process(blob);
    }
  }
```



