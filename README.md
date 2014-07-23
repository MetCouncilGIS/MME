Minnesota Metadata Editor
==========

MME is a DotNet incarnation of a simple editor for GIS metadata XML files that adhere to the [Minnesota Geographic Metadata Guidelines (MGMG version 1.2)](http://www.mngeo.state.mn.us/committee/standards/mgmg/metadata.htm). 

####MME Version
    1.1.24  July, 2014

#### Release Notes
1. Force 'mailing and physical' in addrtype fields for contacts if none provided on these tags:
    * 10290 idinfo/ptcontac/cntinfo/cntaddr/addrtype
    * 13250 distinfo/distrib/cntinfo/cntaddr/addrtype
    * 13450 metainfo/metc/cntinfo/cntaddr/addrtype
2. XSL template MGMG.xsl
   * return the 'HTTP' protocol that was stripped during formatting on output
   * allow HTTPS as a URL protocol that HyperLinks
3. Remove all references to MnGeo
4. Change the spatial extent of data field to a text box (from a combo with pull-down list).
5. Fix Online linkage field wipe-out when doing a 'refresh from database'

Pending:

1. New fields / tags for Vertical Datum.
2. Links to Help

    

What it is
==========
The Minnesota Metadata Editor (MME) is a desktop application that is intended to simplify and expedite the process of developing geospatial metadata.  

The program operates as a portable application that helps you create, edit and display formatted metadata that adheres to the [Minnesota Geographic Metadata Guildelines (MGMG version 1.2)](http://www.mngeo.state.mn.us/committee/standards/mgmg/metadata.htm), an implementation of the Federal Geographic Data Committee's (FGDC's) Content Standard for Digital Geospatial Metadata (CSDGM).  

The MME is a customized version of the EPA Metadata Editor (EME) 3.1.1.  For more information on the EPA Metadata Editor, see [https://edg.epa.gov/EME/](https://edg.epa.gov/EME/). 

##Get it

Visit the [MME GitHub site](https://github.com/MetropolitanCouncil/MME) and click the **Download ZIP** button in the lower right-hand corner to get a copy of the program. It always helps to read the help: http://www.mngeo.state.mn.us/chouse/mme/Minnesota_Metadata_Editor_Help.pdf.

##Run it
MME runs as portable application and needs no installation. Just unzip the contents of the application to any folder on your computer. Then open the folder and double-click **Minnesota Metadata Editor.exe** to run it. Installing the application to a network drive can cause problems at certain installations so we don't recommend it. 

Microsoft .NET Framework 3.5 must be installed on your machine.You can determine if the .NET Framework is on your machine by going to Start->Control Panel->Add or Remove Programs. 
You should see Microsoft .NET Framework 3.5 listed.  Multiple versions of Microsoft .Net Framework (e.g., 1,2,3) may exist on your machine simultaneously. Microsoft's .NET Framework 3.5 is freely available and can be accessed from Microsoft's website: http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=21.

###Source
The source code for this application is available at [GitHub MME-Source](https://github.com/MetropolitanCouncil/MME-Source). It was last compiled with Visual Studio 2012 but should be reasonably compatible with Visual Studio 2010 as well. Most of the **helper** files for spell-checking and old-time XML support are included in the \bin\debug directory.

###Database
The application is data-driven using a Microsoft Access database, metadata.mdb. You may need to edit this database to assign default values that apply to your particular agency or group. You need Microsoft Access in order to edit the database. Once edited, it can, however, be distributed to other machines that do not have Access installed. The application, itself, does not require Access installed on the local computer in order to run.



