MINNESOTA METADATA EDITOR V1.1  June, 2012

*************************************************************************************************************
Installation and Configuration Instructions for the Minnesota Metadata Editor (MME) v1.1
*************************************************************************************************************
MME Installation Requirements:

  -> The MME runs as a standalone executable program though it does require a Windows .NET framework. MME is packaged for distribution as both a standard Windows install (.msi ) file and a portable application.  
  
  -> In order to run MME, Microsoft .NET Framework 3.5 must be installed on your machine.You can determine if the .NET Framework is on your machine by going to Start->Control Panel->Add or Remove Programs.  
You should see Microsoft .NET Framework 3.5 listed.  Multiple versions of Microsoft .Net Framework (e.g., 1,2,3) may exist on your machine simultaneously. Microsoft's .NET Framework 3.5 is freely available and can be accessed from Microsoft's website: 
http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=21

Application MS Access Database:

  -> The application is data-driven using a Microsoft Access database, metadata.mdb. You may need to edit this database to assign default values that apply to your particular agency or group. You need Microsoft Access in order to edit the database. Once edited, it can, however, be distributed to other machines that do not have Access installed. The application, itself, does not require Access installed on the local computer in order to run.
  
  -> The application can run in two modes:
      > Installed - application installs as a normal Windows program. A local copy of the application database is created from the program's \template directory on first run. The user's copy of the application database can be further customized as needed per individual by selecting Tools > Open Database. Admin privileges are likely required for this install. 
	  
	  > Portable - application needs no installation and uses one copy of the application database for anyone who runs the application. Nothing is installed or modified on the machine running the program. All files are kept in the folder containing the application. 
	  In portable mode, you can:
		> place the application folder on a network drive,
		> edit the database for your agency's default values,
		> have multiple users run the application directly from the network drive
		Bear in mind security restrictions may limit the sort of things you can do from a network drive. For example, since the help file consists of HTML pages, it can't be viewed directly on a network, nor can the application's Access database be directly edited when it resides on a network drive due to Microsoft security restrictions. These restrictions don't apply to a USB or local drive copy. For some possible workarounds, visit this site: http://www.helpscribble.com/chmnetwork.html.
*************************************************************************************************************
Installing the standard Minnesota Metadata Editor 
*************************************************************************************************************
NOTE: You'll need ADMIN privileges for the standard install.
1. Double click the MME set up file (MMEv1_1.msi).
2. Follow set-up instructions for locating the installed files.
3. The default installation location on 32-bit Win 7 machines is C:\Program Files\MnGeo\Minnesota Metadata Editor\ or for 64-bit machines C:\Program Files (x86)\MnGeo\Minnesota Metadata Editor\.
4. By default, the installation places an shortcut to the application in the Start Menu. Go to Start -> Programs -> Minnesota Metadata Editor.

After you launch the editor once, a copy of the folder C:\Program Files\MnGeo\Minnesota Metadata Editor\template is copied to your local user directory. You can edit the local copy by running the MME and selecting Tools -> Open database. If nothing happens, you probably don't have MS Access installed. 
*************************************************************************************************************
Installing the Minnesota Metadata Editor - Portable
*************************************************************************************************************
NOTE: You shouldn't need special privileges for the portable installation. 
> In the installation ZIP file, open the MMEPortable folder. All necessary files are in the Minnesota Metadata Editor folder. You may place the folder anywhere you wish. 
> One folder is added in addition to those found in the standard installation: \portable. The \portable folder has a copy of the same files as the \template folder. The presence or absence of the \portable folder determines whether or not a local or portable version of the application database is used.
	> If the application finds a \portable folder in its directory, it uses \portable\metadata.mdb as its source database. This databse can be shared among several users if needed.
	> If no \portable folder is found, a copy of the \template\metadata.mdb is made into the user's local directory. Once there it can be personalized for the individual user.
*************************************************************************************************************
Editing the Access database for default values
*************************************************************************************************************
The application database stores values for creating pull-down lists for certain fields in the application. Often one value can be designated as the 'default', if the field has a capital D button next to it. Consult the help file for the application for more information. You can find the help file by running the editor and choosing Help -> Contents.

*************************************************************************************************************
Installing the MGMG 1.2 stylesheets for ArcCatalog 10.0 (optional)
*************************************************************************************************************
New stylesheets are required for use in ArcGIS 10 to view metadata in the familiar MGMG 1.2 format from within ArcCatalog 10.0.  The MME has a menu option (Tools -> View metadata HTML) which can create and save a formatted HTML version of the metadata for the current metadata XML file loaded into the editor.

Installation: 

NOTE: You'll need ADMIN privileges to install the stylesheets for use with ArcGIS. These customized stylesheet files are added to the ArcGIS program installation, normally in C:\Program Files\ArcGIS\Desktop10.0 or if WIndow7 64-bit C:\Program Files (86)\ArcGIS\Desktop 10.0. 
NO EXISTING FILES IN ARCGIS ARE CHANGED. We are only adding some additional ones.

All the stylesheet files can be found in the installation for the Minnesota Metadata Editor, on 32-bit machines, it's the C:\Program Files\MnGeo\Minnesota Metadata Editor\styesheet\ folder.

1.) C:\program files\MnGeo\Minnesota Metadata Editor\stylesheet\ArcGIS_MGMG.xsl

This stylesheet determines how to detect MGMG metadata and format it. It is based on the ESRI stylesheet ArcGIS.xsl.

Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Stylesheets folder.

2.) C:\program files\MnGeo\Minnesota Metadata Editor\stylesheet\MGMG.xslt 

This stylesheet formats the MGMG standard metadata into the ArcCatalog Description pane. It is also used by the Minnesota Metadata Editor 1.1.

Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Stylesheets\ArcGIS_Imports folder for use with ArcCatalog.

3.) C:\program files\MnGeo\Minnesota Metadata Editor\stylesheet\MGMG Metadata.cfg
This configuration file ties it all together. Copy this file into C:\Program Files\ArcGIS\Desktop 10.0\Metadata\Config folder.

Once the three files are copied to the correct locations, 'MGMG Metadata' will appear as an additional option in the Customize -> ArcCatalog Options -> Metadata tab -> Metadata Style.

Note: Native ArcCatalog Editing of metadata is disabled with this configuration. You will only be able to edit metadata from the MGMG editor. Should you wish to return to the default editing arrangement, simply choose another Metadata style from the ArcCatalog Options -> Metadata tab.

Use:

After all three files are copied to their respective locations, open ArcCatalog and choose Customize -> ArcCatalog Options -> Metadata. In the Metadata Style pull-down, you should now have a choice for "MGMG Metadata".  Select it.

Now, everytime you select a file in ArcCatalog that has MGMG metadata associated with it, whether in SDE, file geodatabase or a free-standing XML, it will display like the MGMG format you're used to. To determine if the metadata is in MGMG format, the tag <metstdn> is checked for the value "Minnesota Geographic Metadata Guidelines".

If the metadata is not in MGMG format, it displays according to ESRI's rules for ArcGIS, ISO or FGDC metadata. 
