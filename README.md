### **HTML File I/O**
---
#### HtmlFile
A class that wraps the File class, but provides three simple read
methods:

* **readAsBytes**: Reads the file as a Uint8List
* **readAsString()**: Reads the files as a String
* **readAsDataUrl()**: Reads the file as a String and converts it to a
   Data:URL

#### FileStream
A class that wraps the File class, but provides the ability to read a
File as a _Stream_ of chunks.

    Future readFileStream(File file) async {
      var stream = new FileStream(file);
      await for (Uint8List blob in stream) {
        process(blob);
      }
    }




