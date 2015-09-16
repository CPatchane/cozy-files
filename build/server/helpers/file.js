// Generated by CoffeeScript 1.10.0
module.exports = {
  normalizePath: function(path) {
    if (path === "/") {
      path = "";
    } else if (path.length > 0 && path[0] !== '/') {
      path = "/" + path;
    }
    return path;
  },
  getFileClass: function(file) {
    var fileClass, type;
    type = file.headers['content-type'];
    switch (type.split('/')[0]) {
      case 'image':
        fileClass = "image";
        break;
      case 'application':
        fileClass = "document";
        break;
      case 'text':
        fileClass = "document";
        break;
      case 'audio':
        fileClass = "music";
        break;
      case 'video':
        fileClass = "video";
        break;
      default:
        fileClass = "file";
    }
    return fileClass;
  },
  folderContentComparatorFactory: function(criterion, order) {
    var CRITERION, ORDER;
    CRITERION = criterion || 'name';
    ORDER = order || 'asc';
    return function(f1, f2) {
      var e1, e2, n1, n2, sort, t1, t2;
      t1 = f1.docType.toLowerCase();
      t2 = f2.docType.toLowerCase();
      if (t1 === t2) {
        if (CRITERION === 'name') {
          n1 = f1.name.toLocaleLowerCase();
          n2 = f2.name.toLocaleLowerCase();
        } else if (CRITERION === "lastModification") {
          n1 = new Date(f1.lastModification).getTime();
          n2 = new Date(f2.lastModification).getTime();
        } else {
          n1 = f1[CRITERION];
          n2 = f2[CRITERION];
        }
        sort = ORDER === 'asc' ? -1 : 1;
        if (CRITERION === 'class' && n1 === n2) {
          n1 = f1.name.toLocaleLowerCase();
          n2 = f2.name.toLocaleLowerCase();
          e1 = n1.split('.').pop();
          e2 = n2.split('.').pop();
          if (e1 !== e2) {
            if (e1 > e2) {
              return -sort;
            }
            if (e1 < e2) {
              return sort;
            }
            return 0;
          }
        }
        if (n1 > n2) {
          return -sort;
        } else if (n1 < n2) {
          return sort;
        } else {
          return 0;
        }
      } else if (t1 === 'file' && t2 === 'folder') {
        return 1;
      } else {
        return -1;
      }
    };
  }
};
