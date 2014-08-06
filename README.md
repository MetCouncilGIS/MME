Minnesota Metadata Editor
==========

MME is a DotNet incarnation of a simple editor for GIS metadata XML files that adhere to the [Minnesota Geographic Metadata Guidelines (MGMG version 1.2)](http://www.mngeo.state.mn.us/committee/standards/mgmg/metadata.htm). 

####MME Version
    1.2.1

#####Changes in this version
1. Force *mailing and physical* in addrtype fields for contacts on these tags:
    * idinfo/ptcontac/cntinfo/cntaddr/addrtype
    * distinfo/distrib/cntinfo/cntaddr/addrtype
    * metainfo/metc/cntinfo/cntaddr/addrtype
2. XSL template MGMG.xsl
   * restore the 'HTTP' protocol to hyperlinks.
   * allow HTTPS as a URL protocol for hyperLinks.
3. Remove all references to MnGeo.
4. Change the *spatial extent of data* field to a text box (from a combo with pull-down list).
5. Fix Online linkage field, publisher text getting erased when doing a *refresh from database*.
6. All help now links directly to a Web site at MnGeo.
7. Minnesota County Coordinate System now supports *feet* as well as *meters* for NAD83 datum.
8. Extraneous blank rows in database tables removed. This should prevent poeple from setting blank values as default.
9. Add check for database version and fail to load if the wrong database is used - link user to a help page.
10. Add fields: Vertical Datum, vertical Units, depth datum, depth units, browse graphic description.
11. Modify fields: Publication Date, Progress of data, Update Frequency to pull-down lists + text entry.
12. To avoid confusion, the *address2* field in the database table for *Contact_Information* was removed as it is not a supported element in MGMG2.

#####Upgrading from a prior version
This version of MME makes several changes to database structures and is not backward-compatible with earlier database formats. During start-up the application checks to determine if the database is in the correct format and will not proceed with an earlier version. 

Install the new version in a new location and then edit the new database as needed to provide the default values for your configuration. Look further on in this document for more detailed instructions on  user-configurable values in MME and how to set them.


What it is
==========
The Minnesota Metadata Editor (MME) is a desktop application to create geospatial metadata files. 

The program operates as a standalone application that allows you create, edit and display formatted metadata that adheres to the [Minnesota Geographic Metadata Guildelines (MGMG version 1.2)](http://www.mngeo.state.mn.us/committee/standards/mgmg/metadata.htm), an implementation of the Federal Geographic Data Committee's (FGDC's) Content Standard for Digital Geospatial Metadata (CSDGM).  

The MME is a customized version of the EPA Metadata Editor (EME) 3.1.1.  For more information on the EPA Metadata Editor, see [https://edg.epa.gov/EME/](https://edg.epa.gov/EME/). 

##Get it

Click the **Download ZIP** button in the lower right-hand corner to get a copy of the program. It might help to [read the help](http://www.mngeo.state.mn.us/chouse/mme/help).

##Run it
MME runs as portable application and needs no installation. Just unzip the contents of the application to any folder on your computer (We suggest **Minnesota Metadata Editor** as the folder name). Then open the folder and double-click **MetadataEditor.exe** to run the editor. 

Microsoft .NET Framework 3.5 must be installed on your machine.You can determine if the .NET Framework is on your machine by going to Start->Control Panel->Add or Remove Programs. 
You should see Microsoft .NET Framework 3.5 listed.  Multiple versions of Microsoft .Net Framework (e.g., 1,2,3) may exist on your machine simultaneously. Microsoft's .NET Framework 3.5 is freely available and can be accessed from [Microsoft's website](http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=21).

##Source
The source for this application is available [here](https://github.com/MetropolitanCouncil/MME-source). It was last compiled with Visual Studio 2012 but should be reasonably compatible with Visual Studio 2010 if you create a new solution.

##Database
The application is data-driven using a Microsoft Access database -- metadata.mdb -- stored in the application **\portable** folder. You may store some field values in this database to assign default values that apply to your particular agency or group. You need Microsoft Access in order to edit the database. Once edited, it can, however, be distributed to other machines that do not have Access installed. The application, itself, does not require Access installed on the local computer in order to run.

###Required User-configurable Database Values 
Contact information needs to be entered in the database table: **Contact_Information** in order for it to appear in your metadata files. You can store any number of contact names and addresses in the table. Within the application, the contact information will appear in the form of pull-down lists for each of these fields:

   * data set contact Tab 1 
   * distribution contact Tab 3
   * metadata contact Tab 3


###Optional User-Configurable Database Values

####Citation
> Access table: 1a_Citation

> Tab 1 Basic Data Set Information

> Area: Citation

> Field: Origin
> 
> You can establish one or more values in the database table. You MUST designate one as the default to appear when the 'D' button is pressed.

####Publisher

> Access table: 1b_Publisher

> Tab 1 Basic Data Set Information

> Field: Published By

> You can enter one or more values in this database table and, optionally, set one of the value as the Default. All the values will appear in the Pull-down list for publisher and the default value will populate the field when the 'D' button is pressed.

####Bounding Box

> Access table: 1g_BoundingBox

> Tab 1 Basic Data Set Information

> Field: Bounding Box
 
> One value is provided for a Minnesota state bounding box and set as the default. You may edit this one or add your own. All values will appear in the Pull-dowm list for Bounding Box and the default value will populate when the 'D' button is pressed.

####Constraints

> Access table: 1k_Constraints 

> Tab 1 Basic Data Set Information

> Field: Access (database column *accconst*)

> Field: Use (database column *useconst*)

> You can establish one or more sets of values in this table and then MUST designate one as the default set. These values will populate their respective fields when the 'D' button is pressed.

####Distribution Liability

> Access table: 3b_DistributionLiability

> Tab 3 Distribution and Metadata Information

> Field: Distribution Liability (database column *distliab*)

> You can establish one or more values in the database table. You MUST designate one as the default to appear when the 'D' button is pressed.

####OnLine Linkage

> Access table: 3d_OnlineLinkage

> Tab 3 Distribution and Metadata Information

> Field: OnLine Linkage

> You can establish one or more values for your online linkage URLs. These values appear in the pull-down list for the field. No default value is set.

####Ordering Instructions

> Access Table: 3e_OrderingInstructions

> Tab 3 Distribution and Metadata Information

> Field: Ordering Instructions

> You can establish one or more values in the database table. You MUST designate one as the default to appear when the 'D' button is pressed.








