ArcGIS 10 stylesheets for the Minnesota Geographic Metadata Standard 1.2

Requirements: ArcGIS 10.0 installed and (if Win7) Admin privileges because you will be adding files to the installed ArcGIS program area.

Description: These stylesheets allow viewing MGMG standard metadata from within ArcCatalog. 

Installation: 

These customized stylesheet files are added to the ArcGIS program installation, normally in C:\Program Files\ArcGIS\Desktop10.0 or if WIndow7 64-bit C:\Program Files (86)\ArcGIS\Desktop 10.0.

1.) ArcGIS_MGMG.xsl

This stylesheet determines how to detect MGMG metadata and format it. It is based on the ESRI stylesheet ArcGIS.xsl.

Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Stylesheets folder.

2.) MGMG.xslt 

This stylesheet formats the MGMG standard metadata into the ArcCatalog Description pane. It is also used by the Minnesota Metadata Editor 1.1.

Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Stylesheets\ArcGIS_Imports folder for use with ArcCatalog.

3.) MGMG Metadata.cfg
This configuration file ties it all together. Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Config folder.

Once installed, 'MGMG Metadata' will appear as an additional option in the Customize -> ArcCatalog Options -> Metadata tab -> Metadata Style.

Note: Native ArcCatalog Editing of metadata is disabled with this configuration. You will only be able to edit metadata from the MGMG editor.
Should you wish to return to the default editing arrangement, simply choose another Metadata style from the ArcCatalog Options -> Metadata tab.

Use:

After all three files are copied to their respective locations, open ArcCatalog and choose Customize -> ArcCatalog Options -> Metadata. In the Metadata Style pull-down, you should now have a choice for "MGMG Metadata".  Select it.

Now, everytime you select a file in ArcCatalog that has MGMG metadata associated with it, whether in SDE, file geodatabase or a free-standing XML, it will display like the MGMG format you're used to. 

If the selected metadata is not in MGMG 1.2 format, it displays according to ESRI's rules for ArcGIS , ISO or FGDC metadata. 

To determine what is in MGMG metadata format, the stylesheet looks for this tag:
<metstdn>Minnesota Geographic Metadata Guidelines</metstdn> 

