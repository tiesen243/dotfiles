import QtQuick
import QtQuick.Layouts

Loader {
  id: layoutLoader
  default property alias data: layoutLoader.innerData
  property list<Item> innerData

  sourceComponent: Settings.isBarHorizontal ? rowComponent : columnComponent

  Component {
    id: rowComponent
    RowLayout {
      spacing: Settings.style.spacing ?? 5
      
      Component.onCompleted: {
        for (var i = 0; i < layoutLoader.innerData.length; i++)
          layoutLoader.innerData[i].parent = this;
      }
    }
  }

  Component {
    id: columnComponent
    ColumnLayout {
      spacing: Settings.style.spacing ?? 5
      
      Component.onCompleted: {
        for (var i = 0; i < layoutLoader.innerData.length; i++)
          layoutLoader.innerData[i].parent = this;
      }
    }
  }
}
