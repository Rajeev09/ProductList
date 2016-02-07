# ProductList

This Project uses a tableview to show list of products.

First Json file is converted into model.Then model is populated to a tableview
/////
Each different templates are shown using different tableview cells

1)Template1:
  It is implemented using a simple imageview with fully stretched image.
2)Template2:
  It is implemented using collection view as a subview of tableviewcell and populating collection cells within collectionview
3)Template3:
  It is implemented using a scrollView and pageControlview as a subview of tableviewcell.
  
///// 
a)Caching:
   Caching is done using a dictionary by storing images using urls as their keys
b)Non-Blocking UI:
   Images are downloaded asynchronously in background and after downloding imageview is updated accordingly.This prevents UI from blocking.
c)AutoLayout:
   AutoLayout is used so that it can work across multiplescreens.

 
