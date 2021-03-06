function [ namelist ] = getLayerNames()
% function [ namelist ] = getLayerNames()
% 
% Robert Cooper 05-22-2013
% Requires: Photoshop CS5 Extended, and an active connection to a running
% version of photoshop. Photoshop must be running before MATLAB starts!
%
% This function connects to a running copy of Photoshop CS5.1, and extracts
% all of the layer name information.
%
% It returns the information in a cell array.
%
%     Copyright (C) 2014  Robert F Cooper
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


%     layernames = ['var layers = app.activeDocument.artLayers;'...
%     'var len = layers.length;'...
%     'var allnames = ";";'...
%     ''...
%     '    for(var i=0;i<len;i++){'...
%     '            var layer = layers[i];'...
%     '             if(layer.kind==undefined || !layer.visible){'...
%     '                     continue;'...
%     '              }'...
%     '            allnames = allnames +layers[i].name+";";'...
%     '    }'...
%     'allnames;'];
%     disp('Before old name grab');
% tic;
%     namestring = psjavascript(layernames);
%     toc;
%     disp('After old name grab');
    
layernames = ['function getLayerSetsIndex(){'...
'    '...
'   var i = getNumberLayers();'...
'   var res = new Array();'...
'   '...
'  '...
'   var prop =  stringIDToTypeID("layerSection"); '...
'   '...
'   var startingsectiondepth = 0;'...
'   var sectiondepth = 0;'...
'   var visibilitylock = false;'...
'   '...
'    for(i; i > hasBackground() ;i--){'...
'      var type = getLayerType(i,prop);'...
'      '...
'       if( type == "layerSectionStart" ){'...
'                sectiondepth++;'...
'       }else if( type == "layerSectionEnd" ){'...
'                sectiondepth--;'...
'       }'...
''...
'       if( visibilitylock ){'...
'           if( type == "layerSectionEnd" && sectiondepth == startingsectiondepth){'...
'               visibilitylock=false;'...
'           }'...
'       }else{'...
'            if( type == "layerSectionStart" ){'...
'                if( !isVisible( i ) ){'...
'                    visibilitylock = true;'...
'                    startingsectiondepth = (sectiondepth-1);'...
'                }'...
'            }else if( type == "layerSectionContent" && isVisible( i ) ){'...
'                var name = getLayerName(i);'...
'                res.push(name);'...
'            }'...
'      }'...
''...
'    }'...
'   return res;'...
'   '...
'   function getNumberLayers(){'...
'       var ref = new ActionReference();'...
'       ref.putProperty( charIDToTypeID("Prpr") , charIDToTypeID("NmbL") );'...
'       ref.putEnumerated( charIDToTypeID("Dcmn"), charIDToTypeID("Ordn"), charIDToTypeID("Trgt") );'...
'       return executeActionGet(ref).getInteger(charIDToTypeID("NmbL"));'...
'   }'...
''...
'   function hasBackground() {'...
'       var ref = new ActionReference();'...
'       ref.putProperty( charIDToTypeID("Prpr"), charIDToTypeID( "Bckg" ));'...
'       ref.putEnumerated(charIDToTypeID( "Lyr " ),charIDToTypeID( "Ordn" ),charIDToTypeID( "Back" ));'...
'       var desc =  executeActionGet(ref);'...
'       var res = desc.getBoolean(charIDToTypeID( "Bckg" ));'...
'       if(res){'...
'            return 1;'...
'       }else{'...
'            return 0;'...
'       }'...
'    };'...
''...
'   function getLayerType(idx,prop) {'...
'       var ref = new ActionReference();'...
'       ref.putIndex(charIDToTypeID( "Lyr " ), idx);'...
'       var desc =  executeActionGet(ref);'...
'       var type = desc.getEnumerationValue(prop);'...
'       var res = typeIDToStringID(type);'...
'       return res;   '...
'    };'...
''...
'    function getLayerName(idx){'...
'        var ref = new ActionReference();'...
'        ref.putProperty( charIDToTypeID("Prpr"), charIDToTypeID("Nm  ") );'...
'        ref.putIndex( charIDToTypeID("Lyr "), idx);'...
'        var desc = executeActionGet(ref);'...
'        var res = desc.getString( charIDToTypeID("Nm  ") );'...
'        return res;'...
'    };'...
''...
'    function isVisible( idx ) {'...
'        var ref = new ActionReference();'...
'        ref.putProperty( charIDToTypeID("Prpr") , charIDToTypeID( "Vsbl" ));'...
'        ref.putIndex( charIDToTypeID( "Lyr " ), idx );'...
'        return executeActionGet(ref).getBoolean(charIDToTypeID( "Vsbl" ));'...
'    };'...
'};'...
'var allnames = getLayerSetsIndex();'...
''...
'allnames;' ];
%     disp('Before new name grab');
%     tic;
    namestring = psjavascript(layernames);
%     toc;
%     disp('After new name grab');

    namelist = regexp(namestring(2:end-1),',','split');

end

