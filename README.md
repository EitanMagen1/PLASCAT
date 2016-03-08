# PLASCAT final project

PLASCAT is a  mobile-ready, offline-storage, SWIFT powered catalog search engine.

  - Searches Part and BOM catalog
  - Searches by Part number or partiel description
  - Help users understand what is the part they are searching for used , where is it used and determine the defrence between defrent parts in the factory
  - The SW is intended to be used in Plasson poultry factory see this [Video Plasson]  and [follow this link to visit the company web site]

PLASCAT is an offline search engine which download a local data base on your device , the files needs to be updated ocasunaly and are persisted in the documents directory of your app. 

> The overriding design goal for Plascat's
> search engine is to clarify the parts usage and defenition.
> as possible. The idea is that a
> user use the power of his mobile phone to get on the spot information about the part in question.
# Detail use:
The application uses two data files CSV downloaded from a remote server and saved locally on the device , after first installation the app will automatically download the files
The search can be based on words , numbers and starts searching when the Enter key is pressed or 7 characters are typed
# Example 
Part Number is 2310929  : expected results are avaliable at the following link
[User Images]
# How To use:
In the landing screen the User will choose between Catalog Number and BOM , which are the two files , the first will look in the parts catalog for data on relevant part the second will search for assemblies where the part or description entered appear.
> Choose the History button to view and use persisted search items

### Version
0.9 is the initial release version

### Tech

Plascat uses an open source project to work properly:

* [CSwiftV.swift File by Daniel Haight] - Library to traslate CSV files to dictionary.


### Installation

Available on the appstore
```

### Plugins
None

### Development

Want to contribute? Great!

Make a change in your file share it with me.

```

### Todos

 - Write Tests
 - Make visual progress bar acording to dowload delegate
 - Add Code Comments

License
----

The content of this repository is licensed under [Apache 2.0 Licenses]



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[User Images]: <https://drive.google.com/folderview?id=0BxWdnf9_DvkNMVZ0WVBMQlVFYTg&usp=sharing>
[Apache 2.0 Licenses]: <http://choosealicense.com/licenses/apache-2.0/> 
[Video Plasson]: <http://www.dailymotion.com/video/x97o75_lul-plasson_lifestyle>
[follow this link to visit the company web site]: <http://www.plasson.com/>
[CSwiftV.swift File by Daniel Haight]: <https://github.com/Daniel1of1/CSwiftV>
