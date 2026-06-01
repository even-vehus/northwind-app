-- Data for table: USysRibbons
-- Row count: 1

IF NOT EXISTS (SELECT 1 FROM [USysRibbons])
BEGIN
    SET IDENTITY_INSERT [USysRibbons] ON;
    INSERT INTO [USysRibbons] ([ID], [RibbonName], [RibbonXML])
    VALUES
        (1, N'Main', N'<customUI xmlns="http://schemas.microsoft.com/office/2006/01/customui" onLoad="ribbonLoaded">
	<!-- Do not start from scratch; suppress built-ins instead. -->
	<ribbon startFromScratch="false">
		<tabs>
			<tab id="tHome" label="Home">
				<group id="gCurrentStatus" label="MRU">
					<box id="bxMRU" boxStyle="vertical">
						<dropDown id="ddMRU"
						          getItemCount="ddMRU_GetItemCount"
						          getItemLabel="ddMRU_GetItemLabel"
						          getSelectedItemIndex="ddMRU_GetSelectedItemIndex"
						          getItemID="ddMRU_GetItemID"
						          onAction="ddMRU_OnAction"
						          screentip="Most Recently Used Objects">
						</dropDown>
					</box>
				</group>
				<group id="gOrders" label="Orders">
					<button id="cmdOrders"
					        label="Orders"
					        size="large"
					        imageMso="CatalogMergeFindRecipient"
					        onAction="cmdOrders_OnAction"/>
					<button id="cmdAddOrder"
					        label="Add Order"
					        size="large"
					        imageMso="AdpNewTable"
					        onAction="cmdAddOrder_OnAction"/>
					<button id="cmdPurchaseOrders"
					        label="Purchase Orders"
					        size="large"
					        imageMso="WindowsCascade"
					        onAction="cmdPurchaseOrders_OnAction"/>
					<button id="cmdAddPurchaseOrder"
					        label="Add Purchase Order"
					        size="large"
					        imageMso="WindowNew"
					        onAction="cmdAddPurchaseOrder_OnAction"/>
				</group>
				<group id="gMaintenance" label="Maintenance">
					<button id="cmdCustomers"
					        label="Companies"
					        size="large"
					        imageMso="BusinessCardInsertMenu"
					        onAction="cmdCustomers_OnAction"/>
					<button id="cmdProducts"
					        label="Products"
					        size="large"
					        imageMso="MaterialResourceInsert"
					        onAction="cmdProducts_OnAction"/>
					<button id="cmdEmployees"
					        label="Employees"
					        size="large"
					        imageMso="MeetingsWorkspace"
					        onAction="cmdEmployees_OnAction"/>
					<button id="cmdAdmin"
					        label="System Admin"
					        size="large"
					        imageMso="ControlsGalleryClassic"
					        onAction="cmdAdmin_OnAction"/>
				</group>
				<group id="gReports" label="Reports" visible="true">
					<button id="cmdReports"
					        label="Reports"
					        size="large"
					        imageMso="ViewsReportView"
					        onAction="cmdReports_OnAction"/>
				</group>
				<group id="gExport" label="Export">
					<button id="cmdExportToExcel"
					        label="Export to Excel"
					        size="large"
					        imageMso="ExportExcel"
					        onAction="cmdExportToExcel_OnAction"/>
				</group>
				<group id="gReportOptions" label="Report Options" getVisible="gReportOptions_GetVisible">
					<button idMso="PrintDialogAccess" size="large"/>
					<button idMso="FilePrintQuick" size="large"/>
					<button idMso="FileSendAsAttachment" size="large"/>
					<button idMso="PublishToPdfOrEdoc" size="large"/>
					<button idMso="PrintPreviewClose" size="large"/>
				</group>
				<group id="gAbout" label="Help Topics">
					<button id="cmdLearn"
					        label="Learn"
					        size="large"
					        imageMso="WatchWindow"
					        onAction="cmdLearn_OnAction"/>
					<button id="cmdFeatures"
					        label="Northwind Features"
					        size="large"
					        imageMso="HelpDevResources"
					        onAction="cmdFeatures_OnAction"/>
					<button id="cmdNorthwindDocumentation"
					        label="Northwind Documentation"
					        size="large"
					        imageMso="HelpDevResources"
					        onAction="cmdNorthwindDocumentation_OnAction"/>
					<button id="cmdAbout"
					        label="About Northwind"
					        size="large"
					        imageMso="GroupAuthors"
					        onAction="cmdAbout_OnAction"/>
				</group>
				<group id="gExit" label="Exit Application">
					<button id="cmdExitApplication"
					        imageMso="PrintPreviewClose"
					        size="large"
					        label="Exit"
					        onAction="cmdExitApplication_OnAction"/>
				</group>
			</tab>

			<!-- Built-in tabs -->
			<tab idMso="TabPrintPreviewAccess" label="Original Print Preview" visible="false"/>
			<tab idMso="TabHomeAccess" label="Original Home" visible="false"/>
			<tab idMso="TabCreate" label="Original Create" visible="false"/>
			<tab idMso="TabExternalData" label="Original External Data" visible="false"/>
			<tab idMso="TabDatabaseTools" label="Original Database Tools" visible="false"/>
			<!-- Rarely use Source Control, not worth customizing -->
			<tab idMso="TabSourceControl" label="Original Source Control" visible="false"/>
			<!-- Normally this may be desirable to disable AddIns tab but to avoid confusion I''m leaving this alone for now. -->
			<tab idMso="TabAddIns" label="AddIns" visible="true"/>
			<!-- Custom tabs -->
			<tab id="DevelopTab" label="Develop">
				<group id="ViewGroup" label="View or Run">
					<splitButton idMso="ViewsModeMenu" size="large">
					</splitButton>
					<button idMso="QueryRunQuery" size="large"/>
				</group>
				<group id="EditGroup" label="Edit">
					<box id="EditBox1" boxStyle="horizontal">
						<button idMso="Cut"/>
						<button idMso="Copy"/>
						<splitButton id="PasteIt">
							<button idMso="Paste"/>
							<menu id="PasteMenu">
								<button idMso="Paste"/>
								<button idMso="PasteSpecialDialog"/>
								<button idMso="PasteAppend"/>
							</menu>
						</splitButton>
					</box>
					<box id="EditBox2" boxStyle="horizontal">
						<gallery idMso="Undo"/>
						<gallery idMso="Redo"/>
					</box>
					<box id="EditBox3" boxStyle="horizontal">
						<comboBox idMso="FormattingFormat"/>
						<control idMso="FormatPainter" label="Paint"/>
					</box>
				</group>
				<group id="TableGroup" label="Tables and Relationship">
					<splitButton id="CreateTableSplitButton" size="large">
						<button idMso="CreateTableInDesignView"/>
						<menu id="CreateTableMenu">
							<button idMso="CreateTableInDesignView"/>
							<button idMso="CreateTable"/>
							<gallery idMso="CreateTableTemplatesGallery"/>
							<gallery idMso="CreateTableUsingSharePointListsGallery"/>
						</menu>
					</splitButton>
					<splitButton id="DatabaseRelationshipsSplitButton" size="large">
						<button idMso="DatabaseRelationships"/>
						<menu id="RelationshipsMenu">
							<button idMso="DatabaseRelationships"/>
							<toggleButton idMso="DatabaseObjectDependencies"/>
						</menu>
					</splitButton>
				</group>
				<group id="ExternalDataGroup" label="External Data">
					<menu id="ImportMenu" label="Import or Link" imageMso="ImportMoreMenu" size="large">
						<menuSeparator id="ImportLink" title="Link tables"/>
						<button idMso="FileServerLinkTables"/>
						<menuSeparator id="ImportMicrosoft" title="Import from Office"/>
						<button idMso="ImportAccess"/>
						<button idMso="ImportExcel"/>
						<button idMso="ImportOutlook"/>
						<button idMso="ImportSharePointList"/>
						<menuSeparator id="ImportOdbc" title="Import from ODBC"/>
						<button idMso="ImportOdbcDatabase"/>
						<menuSeparator id="ImportFlatFile" title="Import from flat files"/>
						<button idMso="ImportTextFile"/>
						<button idMso="ImportHtmlDocument"/>
						<button idMso="ImportXmlFile"/>
						<button idMso="ImportSavedImports"/>
						<menuSeparator id="ImportISAM" title="Import from ISAM"/>
						<button idMso="ImportDBase"/>
						<button idMso="ImportParadox"/>
						<button idMso="ImportLotus"/>
					</menu>
					<menu id="ExportMenu" label="Export" imageMso="ExportMoreMenu" size="large">
						<menuSeparator id="ExportMicrosoft" title="Export to Office"/>
						<button idMso="ExportAccess"/>
						<button idMso="ExportExcel"/>
						<button idMso="ExportWord"/>
						<button idMso="ExportSharePointList"/>
						<menuSeparator id="ExportOdbc" title="Export to ODBC"/>
						<button idMso="ExportOdbcDatabase"/>
						<menuSeparator id="ExportFlatFiles" title="Export to flat files"/>
						<button idMso="ExportTextFile"/>
						<button idMso="ExportHtmlDocument"/>
						<button idMso="ExportXmlFile"/>
						<button idMso="ExportSavedExports"/>
						<menuSeparator id="ExportISAM" title="Export to ISAM"/>
						<button idMso="ExportDBase"/>
						<button idMso="ExportParadox"/>
						<button idMso="ExportLotus"/>
						<menuSeparator id="ExportSnapshot" title="Export as PDF"/>
						<!-- <button idMso="ExportSnapshot" /> -->
						<button idMso="PublishToPdfOrEdoc"/>
					</menu>
					<splitButton id="LinkedTableSplitButton" size="large">
						<button idMso="DatabaseLinedTableManager"/>
						<menu id="LinkedTableMenu">
							<button idMso="DatabaseLinedTableManager"/>
							<button idMso="DatabaseAccessBackEnd" label="Split Database"/>
						</menu>
					</splitButton>
				</group>
				<group id="ObjectGroup" label="Create Objects">
					<splitButton id="QuerySplitButton" size="large">
						<button idMso="CreateQueryInDesignView"/>
						<menu id="QueryMenu">
							<button idMso="CreateQueryInDesignView"/>
							<button idMso="CreateQueryFromWizard"/>
						</menu>
					</splitButton>
					<splitButton id="FormSplitButton" size="large">
						<button idMso="CreateFormInDesignView"/>
						<menu id="FormMenu">
							<button idMso="CreateFormInDesignView"/>
							<button idMso="CreateFormBlankForm"/>
							<button idMso="CreateForm"/>
							<button idMso="CreateFormSplitForm"/>
							<button idMso="CreateFormWithMultipleItems"/>
							<menuSeparator id="SwitchBoardSeparator" title="Switchboard"/>
							<button idMso="DatabaseSwitchboardManager"/>
							<button idMso="BusinessFormWizard"/>
						</menu>
					</splitButton>
					<splitButton id="ReportSplitButton" size="large">
						<button idMso="CreateReportInDesignView"/>
						<menu id="ReportMenu">
							<button idMso="CreateReportInDesignView"/>
							<button idMso="CreateReportBlankReport"/>
							<button idMso="CreateReport"/>
							<button idMso="CreateLabels"/>
							<button idMso="CreateReportFromWizard"/>
						</menu>
					</splitButton>
					<splitButton id="MacroSplitButton" size="large">
						<button idMso="CreateMacro"/>
						<menu id="MacroMenu">
							<button idMso="CreateMacro"/>
							<button idMso="CreateShortcutMenuFromMacro"/>
						</menu>
					</splitButton>
					<splitButton id="VBASplitButton" size="large">
						<button idMso="VisualBasic"/>
						<menu id="VBAMenu">
							<button idMso="VisualBasic"/>
							<button idMso="CreateModule"/>
							<button idMso="CreateClassModule"/>
							<menuSeparator id="ConvertMacroSeparator" title="Convert Macros to VBA"/>
							<button idMso="MacroConvertMacrosToVisualBasic"/>
						</menu>
					</splitButton>
				</group>
				<group id="AdministerGroup" label="Administer">
					<splitButton id="AdministerSplitButton" size="large">
						<button idMso="FileCompactAndRepairDatabase" label="Compact and Repair"/>
						<menu id="AdministerMenu">
							<button idMso="FileCompactAndRepairDatabase"/>
							<button idMso="FileBackupDatabase"/>
							<button idMso="DatabaseCopyDatabaseFile"/>
							<menuSeparator id="ConvertFileSeparator" title="Convert to different version"/>
							<button idMso="FileSaveAsAccess2007"/>
							<button idMso="FileSaveAsAccess2002_2003"/>
							<button idMso="FileSaveAsAccess2000"/>
							<menuSeparator id="SecuritySeparator" title="Secure the file"/>
							<button idMso="SetDatabasePassword"/>
							<button idMso="DatabaseMakeMdeFile"/>
							<button idMso="FilePackageAndSign"/>
							<menuSeparator id="AnalyzeSeparator" title="Analyze/Document"/>
							<button idMso="DatabaseAnalyzeTable"/>
							<button idMso="DatabaseAnalyzePerformance"/>
							<button idMso="DatabaseDocumenter"/>
							<menuSeparator id="CustomizeSeparator" title="Customize"/>
							<button idMso="QuickAccessToolbarCustomization"/>
							<menu idMso="AddInsMenu"/>
							<button idMso="ComAddInsDialog"/>
						</menu>
					</splitButton>
					<button idMso="ApplicationOptionsDialog" size="large"/>
				</group>
				<group id="HelpGroup" label="Help">
					<button idMso="Help" size="large" label="Help"/>
				</group>
			</tab>
		</tabs>
		<contextualTabs>
			<!-- Built-in contextual tabs will be used -->
			<!-- To suppress the built-in tabs, change visible to false, rename the label to "Original <whatever>" then add new tab with a new id, same label -->
			<!-- The ordering of tabSets are roughly Tables, Queries, Forms, Reports, Macros -->
			<tabSet idMso="TabSetTableToolsDesign">
				<tab idMso="TabTableToolsDesignAccess" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetTableToolsDatasheet">
				<tab idMso="TabTableToolsDatasheet" label="Datasheet" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetRelationshipTools">
				<tab idMso="TabRelationshipToolsDesign" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetQueryTools">
				<tab idMso="TabQueryToolsDesign" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetFormTools">
				<tab idMso="TabFormToolsDesign" label="Design" visible="true"/>
				<tab idMso="TabFormToolsLayout" label="Arrange" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetFormToolsLayout">
				<tab idMso="TabFormToolsFormatting" label="Format" visible="true"/>
				<tab idMso="TabControlLayout" label="Arrange" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetReportTools">
				<tab idMso="TabReportToolsDesign" label="Design" visible="true"/>
				<tab idMso="TabReportToolsAlignment" label="Arrange" visible="true"/>
				<tab idMso="TabReportToolsPageSetupDesign" label="Page Setup" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetReportToolsLayout">
				<tab idMso="TabReportToolsFormatting" label="Format" visible="true"/>
				<tab idMso="TabReportToolsLayout" label="Layout" visible="true"/>
				<tab idMso="TabReportToolsPageSetupLayout" label="Page Setup" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetMacroTools">
				<tab idMso="TabMacroToolsDesign" label="Design" visible="true"/>
			</tabSet>
		</contextualTabs>
	</ribbon>
</customUI>');
    SET IDENTITY_INSERT [USysRibbons] OFF;
END