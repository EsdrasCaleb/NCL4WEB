<xsl:stylesheet xmlns:e="http://www.ncl.org.br/NCL3.0/EDTVProfile" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"></xsl:output>	
	<xsl:namespace-alias stylesheet-prefix="e" result-prefix="#default"></xsl:namespace-alias>
	<xsl:template match="ncl|e:ncl">
		<html>
			<xsl:apply-templates></xsl:apply-templates>
		</html>
	</xsl:template>
	<xsl:template match="head|e:head">
		<head>
			<title>
				<xsl:value-of select="//ncl/@title|//e:ncl/@title"/>
			</title>
			<style>
				.innerRegion{
					position:absolute;
					height:100%;
					width:100%;
					z-index:auto;
				}
				.stoped{
					display:none;
					visibility:hidden;
				}
				.started{
					display:inline;
					visibility:visible;
				}
				.active *{
					margin-left:-4px;
					border-width:2px;
					border-color:blue;
					border-style: solid;
				}
			</style>
			<!--script src="/home/caleb/tvd/ncl4web/jquery.min.js">
			</script>
			<script src="/home/caleb/tvd/ncl4web/ncl-complements.js">
			</script-->
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js">
			</script>
			<script src="http://www.midiacom.uff.br/~caleb/ncl4web/ncl-complements.js">
			</script>
			<script>
				<xsl:if test="count(//transitionBase|//e:transitionBase)>0" >
					var transicoes = {};
					<xsl:for-each select="//transitionBase/transition|//e:transitionBase/e:transition">
						transicoes["<xsl:value-of select="@id" />"] = {dur:"<xsl:value-of select="@dur" />",type:"<xsl:value-of select="@type" />"};
					</xsl:for-each>
					<xsl:for-each select="//transitionBase/importBase|//e:transitionBase/e:importBase">
						<xsl:variable name="docImp" select="document(@documentURI)"></xsl:variable>
						<xsl:variable name="alias" select="@alias"></xsl:variable>
						<xsl:for-each select="$docImp/ncl/head/transitionBase/transition|$docImp/e:ncl/e:head/e:transitionBase/e:transition">
						transicoes["<xsl:value-of select="concat($alias,'_',@id)" />"] = {dur:"<xsl:value-of select="@dur" />",type:"<xsl:value-of select="@type" />"};
						</xsl:for-each>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="/ncl/head/ruleBase/compositeRule|/e:ncl/e:head/e:ruleBase/e:compositeRule">
					<xsl:call-template name="interpretaRegraComposta">
						<xsl:with-param name="regra" select="."></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="/ncl/head/ruleBase/rule|/e:ncl/e:head/e:ruleBase/e:rule">
					<xsl:call-template name="interpretaRegra">
						<xsl:with-param name="regra" select="."></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			<xsl:if test="count(/ncl/head/ruleBase/importBase|/e:ncl/e:head/e:ruleBase/e:importBase)>0">
				<xsl:variable name="documento" select="document(/ncl/head/ruleBase/importBase/@documentURI|/e:ncl/e:head/e:ruleBase/e:importBase/@documentURI)" />
				<xsl:variable name="alias" select="/ncl/head/ruleBase/importBase/@alias|/e:ncl/e:head/e:ruleBase/e:importBase/@alias"></xsl:variable> 
				<xsl:for-each select="$documento/ncl/head/ruleBase/rule|$documento/e:ncl/e:head/e:ruleBase/e:rule">
					<xsl:call-template name="interpretaRegra">
						<xsl:with-param name="regra" select="."></xsl:with-param>
						<xsl:with-param name="alias" select="$alias" />
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="$documento/ncl/head/ruleBase/compositeRule|$documento/e:ncl/e:head/e:ruleBase/e:compositeRule">
					<xsl:call-template name="interpretaRegraComposta">
						<xsl:with-param name="regra" select="."></xsl:with-param>
						<xsl:with-param name="alias" select="$alias" />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			</script>
			
		</head>
	</xsl:template>
	
	<xsl:template name="interpretaDescritor">
		<xsl:param name="descritor"></xsl:param>
		<xsl:param name="alias"></xsl:param>
		<xsl:param name="originalDoc"></xsl:param>
		<div>
			<xsl:attribute name="id"><xsl:if test="$alias!=''"><xsl:value-of select="concat($alias,'_')"></xsl:value-of></xsl:if><xsl:value-of select="$descritor/@id"></xsl:value-of></xsl:attribute>
			<xsl:attribute name="class">
			<xsl:text>descriptor</xsl:text>
			<xsl:if test="$descritor/@region!=''">
					<xsl:text> innerRegion</xsl:text>
			</xsl:if>
			</xsl:attribute>
			<xsl:if test="count($descritor/@transIn)>0">
				<xsl:attribute name="transIn">
				<xsl:call-template name="encontraNaBase">
					<xsl:with-param name="searchId" select="$descritor/@transIn"></xsl:with-param>
					<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
					<xsl:with-param name="baseName">transition</xsl:with-param>
				</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="count($descritor/@transOut)>0">
				<xsl:attribute name="transOut">
				<xsl:call-template name="encontraNaBase">
					<xsl:with-param name="searchId" select="$descritor/@transOut"></xsl:with-param>
					<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
					<xsl:with-param name="baseName">transition</xsl:with-param>
				</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="count($descritor/@focusIndex)>0">
			<xsl:attribute name="focusIndex">
			<xsl:value-of select="$descritor/@focusIndex"/>
			</xsl:attribute>
			<xsl:if test="count($descritor/@moveUp)>0">
			<xsl:attribute name="moveUp">
				<xsl:value-of select="$descritor/@moveUp"/>
			</xsl:attribute>
			</xsl:if>
			<xsl:if test="count($descritor/@moveLeft)>0">
			<xsl:attribute name="moveLeft">
				<xsl:value-of select="$descritor/@moveLeft"/>
			</xsl:attribute>
			</xsl:if>
			<xsl:if test="count(@moveRight)>0">
			<xsl:attribute name="moveRight">
				<xsl:value-of select="$descritor/@moveRight"/>
			</xsl:attribute>
			</xsl:if>
			<xsl:if test="count($descritor/@moveDown)>0">
			<xsl:attribute name="moveDown">
				<xsl:value-of select="$descritor/@moveDown"/>
			</xsl:attribute>
			</xsl:if>
			</xsl:if>
			<xsl:if test="count($descritor/@explicitDur)>0">
			<xsl:attribute name="explicitDur">
				<xsl:value-of select="$descritor/@explicitDur"/>
			</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="$descritor/descriptorParam|$descritor/e:descriptorParam">
					<xsl:element name="input">
						<xsl:attribute name="class">
							<xsl:text>descriptorParam</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="parent">
							<xsl:value-of select="$descritor/@id" />
						</xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@name"></xsl:value-of></xsl:attribute>
						<xsl:if test="@value!=''">
							<xsl:attribute name="value"><xsl:value-of select="@value"></xsl:value-of></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="type">
						<xsl:text>hidden</xsl:text>
						</xsl:attribute>
					</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="$originalDoc//media[@descriptor=$descritor/@id][count(@refer)=0]|$originalDoc//e:media[@descriptor=$descritor/@id][count(@refer)=0]">
				<xsl:call-template name="interpretaMedia">
					<xsl:with-param name="media" select="."></xsl:with-param>	
					<xsl:with-param name="id" select="@id"></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:if test="$alias!=''">
				<xsl:for-each select="$originalDoc//media[@descriptor=concat($alias,'#',$descritor/@id)][count(@refer)=0]|$originalDoc//e:media[@descriptor=concat($alias,'#',$descritor/@id)][count(@refer)=0]">
					<xsl:call-template name="interpretaMedia">
						<xsl:with-param name="media" select="."></xsl:with-param>	
						<xsl:with-param name="id" select="@id"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="interpretaRegiao">
		<xsl:param name="regiao"></xsl:param>
		<xsl:param name="alias"></xsl:param>
		<xsl:param name="regionURI"></xsl:param>
		<xsl:param name="originalDoc"></xsl:param>
		<div>
		<xsl:attribute name="id"><xsl:if test="$alias!=''"><xsl:value-of select="concat($alias,'_')"></xsl:value-of></xsl:if><xsl:value-of select="$regiao/@id"></xsl:value-of></xsl:attribute>
		<xsl:attribute name="class">region</xsl:attribute>
		<xsl:attribute name="style">
			<xsl:text>position:absolute;</xsl:text>
			<xsl:if test="$regiao/@left != ''">
				<xsl:text>left:</xsl:text><xsl:value-of select="$regiao/@left"></xsl:value-of><xsl:if test="not(contains($regiao/@left,'%'))"><xsl:text>px</xsl:text></xsl:if><xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="$regiao/@right != ''">
				<xsl:text>right:</xsl:text><xsl:value-of select="$regiao/@right"/><xsl:if test="not(contains($regiao/@right,'%'))"><xsl:text>px</xsl:text></xsl:if><xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="$regiao/@top != ''">
				<xsl:text>top:</xsl:text><xsl:value-of select="$regiao/@top"/><xsl:if test="not(contains($regiao/@top,'%'))"><xsl:text>px</xsl:text></xsl:if><xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="$regiao/@bottom != ''">
				<xsl:text>bottom:</xsl:text><xsl:value-of select="$regiao/@bottom"/><xsl:if test="not(contains($regiao/@bottom,'%'))"><xsl:text>px</xsl:text></xsl:if><xsl:text>;</xsl:text>
			</xsl:if>
				<xsl:text>height:</xsl:text><xsl:if test="count($regiao/@height) = 0">100%</xsl:if><xsl:if test="$regiao/@height != ''"><xsl:value-of select="$regiao/@height"/><xsl:if test="not(contains(@height,'%'))"><xsl:text>px</xsl:text></xsl:if></xsl:if><xsl:text>;</xsl:text>
				<xsl:text>width:</xsl:text><xsl:if test="count($regiao/@width) = 0">100%</xsl:if><xsl:if test="$regiao/@width != ''"><xsl:value-of select="$regiao/@width"/><xsl:if test="not(contains(@width,'%'))"><xsl:text>px</xsl:text></xsl:if></xsl:if><xsl:text>;</xsl:text>
		</xsl:attribute>
			<xsl:if test="$regiao/@zIndex != ''">
				<xsl:attribute name="zIndex">
					<xsl:value-of select="number($regiao/@zIndex)*1000"/><xsl:text>;</xsl:text>
				</xsl:attribute>
			</xsl:if>
		<xsl:for-each select="$originalDoc//descriptor[@region=$regiao/@id]|$originalDoc//e:descriptor[@region=$regiao/@id]">
			<xsl:call-template name="interpretaDescritor">
				<xsl:with-param name="descritor" select="."></xsl:with-param>
				<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:if test="$alias!=''">
			<xsl:for-each select="$originalDoc//descriptor[@region=concat($alias,'#',$regiao/@id)]|$originalDoc//e:descriptor[@region=concat($alias,'#',$regiao/@id)]">
				<xsl:call-template name="interpretaDescritor">
					<xsl:with-param name="descritor" select="."></xsl:with-param>
					<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="$originalDoc//descriptorBase/importBase|$originalDoc//e:descriptorBase/e:importBase">
			<xsl:variable name="docDescr" select="document(@documentURI)"/>
			<xsl:if test="count($docDescr/ncl/head/regionBase/importBase[@documentURI=$regionURI]|$docDescr/e:ncl/e:head/e:regionBase/e:importBase[@documentURI=$regionURI])>0">
				<xsl:variable name="aliasDes" select="$originalDoc//descriptorBase/importBase/@alias|$originalDoc//e:descriptorBase/e:importBase/@alias" />
				<xsl:variable name="aliasReg" select="$docDescr/ncl/head/regionBase/importBase[@documentURI=$regionURI]/@alias|$docDescr/e:ncl/e:head/e:regionBase/e:importBase[@documentURI=$regionURI]/@alias" />
				<xsl:for-each select="$docDescr/ncl/head/descriptorBase/descriptor[@region=concat($aliasReg,'#',$regiao/@id)]|$docDescr/e:ncl/e:head/e:descriptorBase/e:descriptor[@region=concat($aliasReg,'#',$regiao/@id)]" >
					<xsl:call-template name="interpretaDescritor">
						<xsl:with-param name="descritor" select="."></xsl:with-param>
						<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
						<xsl:with-param name="alias" select="$aliasDes"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$regiao/region|$regiao/e:region">
			<xsl:call-template name="interpretaRegiao">
				<xsl:with-param name="regiao" select="."></xsl:with-param>
				<xsl:with-param name="alias" select="$alias"></xsl:with-param>
				<xsl:with-param name="regionURI" select="$regionURI"></xsl:with-param>
				<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		</div>
		</xsl:template>
	<xsl:template match="body|e:body">
		<body style="height:100%; width:100%;overflow:hidden">
			<xsl:if test="@id != ''">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"></xsl:value-of>
			</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates></xsl:apply-templates>
			<xsl:variable name="originalDoc" select="/"></xsl:variable>
			<xsl:for-each select="//regionBase/region|//e:regionBase/e:region">
				<xsl:call-template name="interpretaRegiao">
					<xsl:with-param name="regiao" select="."></xsl:with-param>
					<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="//regionBase/importBase|//e:regionBase/e:importBase">
				<xsl:variable name="regionURI" select="@documentURI"></xsl:variable>
				<xsl:variable name="docReg" select="document(@documentURI)" />
				<xsl:variable name="alias" select="@alias"></xsl:variable>
					<xsl:for-each select="$docReg/ncl/head/regionBase|$docReg/e:ncl/e:head/e:regionBase">
						<xsl:call-template name="interpretaRegiao">
							<xsl:with-param name="regiao" select="."></xsl:with-param>
							<xsl:with-param name="alias" select="$alias" />
							<xsl:with-param name="regionURI" select="$regionURI" />
							<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="media[count(@descriptor)=0][count(@refer)=0]|e:media[count(@descriptor)=0][count(@refer)=0]">
				<xsl:call-template name="interpretaMedia">
					<xsl:with-param name="media" select="."></xsl:with-param>	
					<xsl:with-param name="id" select="./@id"></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:call-template name="interpretaPropriedade">
				<xsl:with-param name="parent" select="."></xsl:with-param>
			</xsl:call-template>
			<xsl:for-each select="//descriptor[count(@region)=0]|//e:descriptor[count(@region)=0]">
				<xsl:call-template name="interpretaDescritor">
							<xsl:with-param name="descritor" select="."></xsl:with-param>
							<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="//descriptorBase/importBase|//e:descriptorBase/e:importBase">
				<xsl:variable name="docDescr" select="document(@documentURI)"/>
				<xsl:variable name="aliasDes" select="@alias" />
				<xsl:for-each select="$docDescr/ncl/head/descriptorBase/descriptor[count(@region)=0]|$docDescr/e:ncl/e:head/e:descriptorBase/e:descriptor[count(@region)=0]" >
						<xsl:call-template name="interpretaDescritor">
							<xsl:with-param name="descritor" select="."></xsl:with-param>
							<xsl:with-param name="originalDoc" select="$originalDoc/ncl/head"></xsl:with-param>
							<xsl:with-param name="alias" select="$aliasDes"></xsl:with-param>
						</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="count($docDescr/ncl/head/descriptorBase/descriptorSwitch|$docDescr/e:ncl/e:head/e:descriptorBase/e:descriptorSwitch)>0">
					<xsl:for-each select="$docDescr/ncl/head/descriptorBase/descriptorSwitch|$docDescr/e:ncl/e:head/e:descriptorBase/e:descriptorSwitch">
						<xsl:call-template name="interpretaDescriptorSwitch">
							<xsl:with-param name="descritorSwitch" select="."></xsl:with-param>
							<xsl:with-param name="originalDoc" select="$originalDoc"></xsl:with-param>
							<xsl:with-param name="alias" select="$aliasDes"></xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="//descriptorSwitch|//e:descriptorSwitch">
				<xsl:call-template name="interpretaDescriptorSwitch">
					<xsl:with-param name="descritorSwitch" select="."></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<script>
			<xsl:for-each select="//link|//e:link">
				<xsl:call-template name="interpretaElo">
					<xsl:with-param name="oelo" select="."></xsl:with-param>				 
				</xsl:call-template>
			</xsl:for-each>
			</script>
		</body>
	</xsl:template>
	<xsl:template name="encontraNaBase">
		<xsl:param name="searchId" />
		<xsl:param name="originalDoc" />
		<xsl:param name="baseName" />
		<xsl:choose>
		<xsl:when test="$originalDoc !='' and $originalDoc !=/">
			<xsl:choose>
			<xsl:when test="not(contains($searchId,'#'))">
				<xsl:for-each select="$originalDoc//*[name()=concat($baseName,'Base')]/importBase|$originalDoc//*[name()=concat($baseName,'Base')]/e:importBase">
					<xsl:if test="document(@documentURI)//*[@id=$searchId]">
						<xsl:value-of select="concat(@alias,'_',$searchId)"></xsl:value-of>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:choose>
				<xsl:when test="count($originalDoc//*[name()=concat($baseName,'Base')]/importBase|$originalDoc//*[name()=concat($baseName,'Base')]/e:importBase)>0">
					<xsl:variable name="docURI" select="$originalDoc//importBase[@alias=substring-before($searchId,'#')]/@documentURI|$originalDoc//importBase[@alias=substring-before($searchId,'#')]/@documentURI" />
					<xsl:for-each select="$originalDoc//*[name()=concat($baseName,'Base')]/importBase|$originalDoc//*[name()=concat($baseName,'Base')]/e:importBase">
						<xsl:if test="@documentURI = $docURI">
							<xsl:value-of select="concat(@alias,'_',substring-after($searchId,'#'))"></xsl:value-of>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="document(//*[name()=concat($baseName,'Base')]/importBase[@alias=substring-before($searchId,'#')]/@documentURI|//*[name()=concat($baseName,'Base')]/importBase[@alias=substring-before($searchId,'#')]/@documentURI)=$originalDoc">
						<xsl:value-of select="substring-after($searchId,'#')"></xsl:value-of>
					</xsl:if>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="contains($searchId,'#')">
				<xsl:value-of select="concat(substring-before($searchId,'#'),'_',substring-after($searchId,'#'))"></xsl:value-of>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$searchId"></xsl:value-of>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="interpretaDescriptorSwitch">
		<xsl:param name="descritorSwitch" />
		<xsl:param name="originalDoc" />
		<xsl:param name="alias" />
		<xsl:variable name="descId">
			<xsl:if test="alias!=''"><xsl:value-of select="concat($alias,'_')" /></xsl:if><xsl:value-of select="$descritorSwitch/@id" />
		</xsl:variable>
		<xsl:variable name="descIdM">
			<xsl:if test="alias!=''"><xsl:value-of select="concat($alias,'#')" /></xsl:if><xsl:value-of select="$descritorSwitch/@id" />
		</xsl:variable>
		<script>
		function <xsl:value-of select="$descId" />(){
			entrou = false
			<xsl:for-each select="$descritorSwitch/bindRule|$descritorSwitch/e:bindRule">
			<xsl:variable name="regra">
				<xsl:call-template name="encontraNaBase"><xsl:with-param name="searchId" select="@rule" /><xsl:with-param name="originalDoc" select="$originalDoc" /><xsl:with-param name="baseName">rule</xsl:with-param></xsl:call-template>
			</xsl:variable>
			<xsl:choose>
			<xsl:when test="$regra!=''">
			if(window['<xsl:value-of select="$regra" />']()){
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="contains($descritorSwitch/@rule,'#')">
					<xsl:variable name="docRule" select="document(//ruleBase/importBase[@alias=substring-before($descritorSwitch/@rule,'#')]|//e:ruleBase/e:importBase[@alias=substring-before($descritorSwitch/@rule,'#')])"></xsl:variable>
					<xsl:variable name="ruleNova" select="$docRule/ncl/head/ruleBase/rule[@alias=substring-after($descritorSwitch/@rule,'#')]|$docRule/e:ncl/e:head/e:ruleBase/e:rule[@alias=substring-after($descritorSwitch/@rule,'#')]"></xsl:variable>
			if($('span.settings>input.property[name="<xsl:value-of select="$ruleNova/@var" />"]').attr('value') <xsl:call-template name="pegaComparador"><xsl:with-param name="comparator" select="$ruleNova/@comparator "></xsl:with-param></xsl:call-template> '<xsl:value-of select="$ruleNova/@value" />'){
				</xsl:when>
				<xsl:otherwise>
				<xsl:variable name="ruleNova" select="//rule[@alias=substring-after($descritorSwitch/@rule,'#')]|//e:rule[@alias=substring-after($descritorSwitch/@rule,'#')]"></xsl:variable>
			if($('span.settings>input.property[name="<xsl:value-of select="$ruleNova/@var" />"]').attr('value') <xsl:call-template name="pegaComparador"><xsl:with-param name="comparator" select="$ruleNova/@comparator "></xsl:with-param></xsl:call-template> '<xsl:value-of select="$ruleNova/@value" />'){
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$alias!=''">
					<xsl:variable name="target" select="concat($alias,'_',@constituent)" />
					<xsl:for-each select="$originalDoc//media[@descriptor=$descId]|$originalDoc//e:media[@descriptor=$descId]">
						trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						<xsl:variable name="idReferido" select="@id"></xsl:variable>
						<xsl:for-each select="$originalDoc//media[@refer=$idReferido]|$originalDoc//e:media[@id=$idReferido]">
							trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						</xsl:for-each>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="target" select="@constituent" />
					<xsl:for-each select="//media[@descriptor=$descId]|//e:media[@descriptor=$descId]">
						trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						<xsl:variable name="idReferido" select="@id"></xsl:variable>
						<xsl:for-each select="//media[@refer=$idReferido]|//e:media[@refer=$idReferido]">
							trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						</xsl:for-each>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			entrou = true
			}			
			</xsl:for-each>
			<xsl:if test="count($descritorSwitch/defaultDescriptor|$descritorSwitch/e:defaultDescriptor)>0">
			if(!entrou){
				<xsl:variable name="constituent" select="$descritorSwitch/defaultDescriptor/@descriptor|$descritorSwitch/e:defaultDescriptor/@descriptor" />
				
				<xsl:choose>
				<xsl:when test="$alias!=''">
					<xsl:variable name="target" select="concat($alias,'_',$constituent)" />
					<xsl:for-each select="$originalDoc//media[@descriptor=$descId]|$originalDoc//e:media[@descriptor=$descId]">
						trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						<xsl:variable name="idReferido" select="@id"></xsl:variable>
						<xsl:for-each select="$originalDoc//media[@refer=$idReferido]|$originalDoc//e:media[@id=$idReferido]">
							trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						</xsl:for-each>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="target" select="$constituent" />
					<xsl:for-each select="//media[@descriptor=$descId]|//e:media[@descriptor=$descId]">
						trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						<xsl:variable name="idReferido" select="@id"></xsl:variable>
						<xsl:for-each select="//media[@refer=$idReferido]|//e:media[@refer=$idReferido]">
							trocaDescritor('<xsl:value-of select="@id" />','<xsl:value-of select="$target" />');
						</xsl:for-each>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			}
			</xsl:if>
		}
		</script>
		<xsl:for-each select="//media[@descriptor=$descIdM]|//e:media[@descriptor=$descIdM]">
			<xsl:call-template name="interpretaMedia">
				<xsl:with-param name="media" select="."></xsl:with-param>	
				<xsl:with-param name="id" select="./@id"></xsl:with-param>	
			</xsl:call-template>
		</xsl:for-each>
		<script>
		<xsl:value-of select="$descId" />();
		$('span.settings').bind('onEndAttribution',<xsl:value-of select="$descId" />);
		</script>
	</xsl:template>
	<xsl:template name="fazNome">
		<xsl:param name="id"></xsl:param>
		<xsl:param name="alias" />
		<xsl:choose>
				<xsl:when test="$alias!=''">
					<xsl:value-of select="concat($alias,'_',$id)"></xsl:value-of>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$id"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template name="interpretaRegraComposta">
		<xsl:param name="regra" />
		<xsl:param name="alias" />
		<xsl:variable name="nomeRega">
			<xsl:call-template name="fazNome">
				<xsl:with-param name="id" select="$regra/@id"></xsl:with-param>
				<xsl:with-param name="alias" select="$alias"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="operador">
			<xsl:choose>
			<xsl:when test="$regra/@operator = 'or'">||</xsl:when>
			<xsl:otherwise>&amp;&amp;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="endComp">
			<xsl:choose>
			<xsl:when test="$regra/@operator = 'or'">false</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		function <xsl:value-of select="$nomeRega" />(){
		<xsl:for-each select="$regra/rule|$regra/e:rule">
			<xsl:call-template name="interpretaRegra">
				<xsl:with-param name="regra" select="." />
				<xsl:with-param name="alias" select="$alias" />
			</xsl:call-template>		
		</xsl:for-each>
		<xsl:for-each select="$regra/compositeRule|$regra/e:compositeRule">
			<xsl:call-template name="interpretaRegraComposta">
				<xsl:with-param name="regra" select="."  />
				<xsl:with-param name="alias" select="$alias"  />
			</xsl:call-template>		
		</xsl:for-each>
		<xsl:variable name="stringCondicao">
			<xsl:for-each select="$regra/compositeRule|$regra/e:compositeRule|$regra/rule|$regra/e:rule">
				<xsl:value-of select="concat(@id,'()',$operador)"></xsl:value-of>
			</xsl:for-each>
				<xsl:value-of select="$endComp"></xsl:value-of>
		</xsl:variable>
		return <xsl:value-of select="$stringCondicao"></xsl:value-of>;
		}
	</xsl:template>
	<xsl:template name="interpretaRegra">
		<xsl:param name="regra" />
		<xsl:param name="alias" />
		<xsl:variable name="nomeRega">
			<xsl:call-template name="fazNome">
				<xsl:with-param name="id" select="$regra/@id"></xsl:with-param>
				<xsl:with-param name="alias" select="$alias"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		function <xsl:value-of select="$nomeRega" />(){
			variavel = $('span.settings>input.property[name="<xsl:value-of select="$regra/@var" />"]').attr('value');
			valor =  '<xsl:value-of select="$regra/@value" />';
			return variavel<xsl:call-template name="pegaComparador"><xsl:with-param name="comparator" select="$regra/@comparator "></xsl:with-param></xsl:call-template>valor;
		}
	</xsl:template>
	<xsl:template name="pegaComparador">
		<xsl:param name="comparator"></xsl:param>
		<xsl:choose>
	  			<xsl:when test="$comparator = 'eq'">==</xsl:when>
	  			<xsl:when test="$comparator = 'ne'">!=</xsl:when>
	  			<xsl:when test="$comparator  = 'lt'">&lt;</xsl:when>
	  			<xsl:when test="$comparator  = 'lte'">&lt;=</xsl:when>
	  			<xsl:when test="$comparator  = 'gt'">&gt;</xsl:when>
	  			<xsl:when test="$comparator  = 'gte'">&gt;=</xsl:when>
	  		</xsl:choose>
	</xsl:template>
	<xsl:template match="switch|e:switch">
		<xsl:variable name="id">
			<xsl:value-of select="@id"></xsl:value-of>
		</xsl:variable>
		<ul style="display:none;visibility:hidden;">
		<xsl:attribute name="id">
			<xsl:value-of select="@id"></xsl:value-of>
		</xsl:attribute>
		<xsl:if test="@refer != ''">
			<xsl:attribute name="refer">
				<xsl:value-of select="@refer" />
			</xsl:attribute>
		</xsl:if>
		<xsl:for-each select="bindRule|e:bindRule">
			<li>
				<xsl:attribute name="rule">
					<xsl:choose>
						<xsl:when test="contains(@role,'#')">
							<xsl:value-of select="concat(substring-before(@role,'#'),'_',substring-after(@role,'#'))"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@rule" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="constituent">
					<xsl:value-of select="@constituent" />
				</xsl:attribute>
			</li>
		</xsl:for-each>
		<xsl:if test="count(defaultComponent|e:defaultComponent)>0">
			<li>
				<xsl:attribute name="default">
					<xsl:value-of  select="defaultComponent/@component|e:defaultComponent/@component" />
				</xsl:attribute>
			</li>
		</xsl:if>
		<xsl:if test="count(switchPort|e:switchPort)>0">
			<li>
			<xsl:for-each select="switchPort|e:switchPort">				
				<ul>
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
					<xsl:if test="@refer != ''">
						<xsl:attribute name="refer">
							<xsl:value-of select="@refer"></xsl:value-of>
						</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="mapping|e:mapping">
						<li>
						<xsl:attribute name="component">
							<xsl:value-of select="@component"></xsl:value-of>
						</xsl:attribute>
						<xsl:if test="@interface != ''">
							<xsl:attribute name="interface">
								<xsl:value-of select="@interface"></xsl:value-of>
							</xsl:attribute>
						</xsl:if>
							<xsl:variable name="component" select="@component"></xsl:variable>	
 						<xsl:variable name="vinculoRegra" select="//switch[@id=$id]/bindRule[@constituent=$component]|//e:switch[@id=$id]/e:bindRule[@constituent=$component]" />
					    <xsl:choose>
				    	<xsl:when test="count($vinculoRegra)>0">
			    		<xsl:attribute name="rule">
						<xsl:choose>
							<xsl:when test="contains($vinculoRegra/@rule,'#')">
								<xsl:value-of select="concat(substring-before($vinculoRegra/@rule,'#'),'_',substring-after($vinculoRegra/@rule,'#'))"></xsl:value-of>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$vinculoRegra/@rule" />
							</xsl:otherwise>
						</xsl:choose>
						</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="default">
								<xsl:value-of select="@component"></xsl:value-of>
							</xsl:attribute>
						</xsl:otherwise>
						</xsl:choose>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:for-each>	
			</li>
		</xsl:if>
		</ul>	
		<xsl:for-each select="media[count(@descriptor)=0][count(@refer)=0]|e:media[count(@descriptor)=0][count(@refer)=0]">
			<xsl:call-template name="interpretaMedia">
				<xsl:with-param name="media" select="."></xsl:with-param>	
				<xsl:with-param name="id" select="./@id"></xsl:with-param>	
			</xsl:call-template>
		</xsl:for-each>
		<xsl:apply-templates></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="context|e:context">
		<div>
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="class">context</xsl:attribute>
			<xsl:if test="@refer !=''">
				<xsl:attribute name="refer">
					<xsl:value-of select="@refer"/>
				</xsl:attribute>	
			</xsl:if>
			<xsl:attribute name="context">
				<xsl:choose>
				<xsl:when test="count(parent::node()[local-name()='context'])>0">
					<xsl:value-of select="parent::node()[local-name()='context']/@id" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>body</xsl:text>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates></xsl:apply-templates>
			<xsl:for-each select="media[count(@descriptor)=0][count(@refer)=0]|e:media[count(@descriptor)=0][count(@refer)=0]">
				<xsl:call-template name="interpretaMedia">
					<xsl:with-param name="media" select="."></xsl:with-param>	
					<xsl:with-param name="id" select="./@id"></xsl:with-param>	
				</xsl:call-template>
			</xsl:for-each>
			<xsl:call-template name="interpretaPropriedade">
				<xsl:with-param name="parent" select="."></xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template match="e:port|port">
		<input type="hidden" class="port">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="@component"/>
			</xsl:attribute>
			<xsl:if test="count(@interface) > 0"> 
			<xsl:attribute name="interface">
				<xsl:value-of select="@interface"/>
			</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template name="acaoComplexa">
		<xsl:param name="connector" />
		<xsl:param name="elo" />
		<xsl:param name="functionName" />
		<xsl:param name="interaction" />
		<xsl:for-each select="$connector/compoundAction|$connector/e:compoundAction">
			<xsl:variable name="tempo">
 			<xsl:call-template name="pegaDelay">
 				<xsl:with-param name="delay" select="$connector/compoundCondition/@delay|$connector/e:compoundCondition/@delay"></xsl:with-param>
 				<xsl:with-param name="elo" select="$elo"></xsl:with-param>
 			</xsl:call-template>
 			</xsl:variable>
 			
 			<xsl:variable name="restoDaAcao">
			<xsl:choose>
			<xsl:when test="@operator = 'par'">
				<xsl:call-template name="acaoComplexa">
					<xsl:with-param name="connector" select="." />
					<xsl:with-param name="elo" select="$elo" />
					<xsl:with-param name="functionName" select="concat($functionName,'a')" />
					<xsl:with-param name="interaction" select="true()" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="acaoComplexa">
					<xsl:with-param name="connector" select="." />
					<xsl:with-param name="elo" select="$elo" />
					<xsl:with-param name="functionName" select="$functionName" />
					<xsl:with-param name="interaction" select="false()" />
				</xsl:call-template>	
			</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			<xsl:choose>
			<xsl:when test="$tempo != ''">
 			function <xsl:value-of select="concat($functionName,'__delayed')"></xsl:value-of>(){
 				<xsl:value-of select="$restoDaAcao"></xsl:value-of>
 			}
 			setTimeout("<xsl:value-of select="concat($functionName,'__delayed')"></xsl:value-of>()",<xsl:value-of select="$tempo"></xsl:value-of>*1000);
 			</xsl:when>
 			<xsl:otherwise>
 			<xsl:value-of select="$restoDaAcao"></xsl:value-of>
 			</xsl:otherwise>
 			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="count($connector/simpleAction|$connector/e:simpleAction) >0">
			
			<xsl:for-each select="$connector/simpleAction|$connector/e:simpleAction">
				<xsl:variable name="qualifier" select="@qualifier"></xsl:variable>
				<xsl:variable name="role" select="@role"></xsl:variable>
				<xsl:if test="$interaction">
					$(document).bind('<xsl:value-of select="$functionName" />',function(){		
				</xsl:if>
				<xsl:for-each select="$elo/bind[@role=$role]|$elo/e:bind[@role=$role]">
			 		<!-- seto a acao que ira acontecer-->
			 		<xsl:variable name="acaoJava">
					<xsl:choose>
					<xsl:when test="@role='set'">
							<xsl:variable name="no" >
								<xsl:call-template name="pegaOriginal">
									<xsl:with-param name="component" select="@component" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
							<xsl:when test="contains($connector/simpleAction[@role='set']/@value|$connector/e:simpleAction[@role='set']/@value,'$')" >
								<xsl:variable name="paramName" select="substring-after($connector/simpleAction[@role='set']/@value|$connector/e:simpleAction[@role='set']/@value,'$')" />
								<xsl:variable name="valor">
									<xsl:choose>
									<xsl:when test="count(bindParam[@name=$paramName]/@value|e:bindParam[@name=$paramName]/@value)>0">
										<xsl:value-of select="bindParam[@name=$paramName]/@value|e:bindParam[@name=$paramName]/@value" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$elo/linkParam[@name=$paramName]/@value|$elo/e:linkParam[@name=$paramName]/@value" />
									</xsl:otherwise>	
									</xsl:choose>
								</xsl:variable>
								<xsl:text>set('</xsl:text><xsl:value-of select="$no" /><xsl:text>','</xsl:text><xsl:value-of select="$valor"></xsl:value-of><xsl:text>'</xsl:text><xsl:if test="@interface != ''"><xsl:text>,'</xsl:text><xsl:value-of select="@interface" />'</xsl:if><xsl:text>)</xsl:text>	
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>set('</xsl:text><xsl:value-of select="$no" /><xsl:text>','</xsl:text><xsl:value-of select="$connector/simpleAction[@role='set']/@value|$connector/e:simpleAction[@role='set']/@value" /><xsl:text>'</xsl:text><xsl:if test="@interface != ''"><xsl:text>,'</xsl:text><xsl:value-of select="@interface" />'</xsl:if><xsl:text>)</xsl:text>
							</xsl:otherwise>
							</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!--Tratando descriptor-->
						<xsl:variable name="medialocalid" select="@component" />
						<xsl:variable name="medialocal" select="//media[@id=$medialocalid]|//e:media[@id=$medialocalid]" />
						<xsl:choose>
							<xsl:when test="@descriptor != '' and @descriptor!=string($medialocal/@descriptor)">
								trataDescriptorInLink('<xsl:value-of select="@component" />','<xsl:value-of select="@descriptor" />','<xsl:value-of select="@role" />','<xsl:value-of select="@interface" />');
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@role" /><xsl:text>('</xsl:text><xsl:value-of select="@component" /><xsl:text>'</xsl:text><xsl:if test="@interface != ''"><xsl:text>,'</xsl:text><xsl:value-of select="@interface" /><xsl:text>'</xsl:text></xsl:if><xsl:text>)</xsl:text>	
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>
					<!--seta repeat-->
					<xsl:if test="count($connector/simpleAction/@repeat|$connector/e:simpleAction/@repeat)>0">
						$(<xsl:value-of select="@component" />).attr('repeat',<xsl:value-of select="$connector/simpleAction/@repeat|$connector/e:simpleAction/@repeat" />);
						<xsl:if test="count($connector/simpleAction/@repeatDelay|$connector/e:simpleAction/@repeatDelay)>0">
							<xsl:variable name="repeatDelay" select="connector/simpleAction/@repeatDelay|$connector/e:simpleAction/@repeatDelay"></xsl:variable>
							<xsl:variable name="rpDelay">
								<xsl:choose>
								<xsl:when test="contains($repeatDelay,'$')">
									<xsl:choose>
								 		<xsl:when test="count(bindParam[@name=substring-after($repeatDelay,'$')]|e:bindParam[@name=substring-after($repeatDelay,'$')])> 0">
								 			<xsl:value-of select="substring-before(bindParam[@name=substring-after($repeatDelay,'$')]/@value|e:bindParam[@name=substring-after($repeatDelay,'$')]/@value,'s')" ></xsl:value-of>
								 		</xsl:when>
								 		<xsl:otherwise>
								 			<xsl:value-of select="substring-before($elo/linkParam[@name=substring-after($repeatDelay,'$')]/@value|$elo/e:linkParam[@name=substring-after($repeatDelay,'$')]/@repeatDelay,'s')" ></xsl:value-of>
								 		</xsl:otherwise>
							 		</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$repeatDelay"></xsl:value-of>
								</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							$(<xsl:value-of select="@component" />).attr('repeatDelay',<xsl:value-of select="$rpDelay" />);
						</xsl:if>
					</xsl:if>
					
					<!--finalmente acha a linha de execução da funçao-->
					<xsl:variable name="tempo">
									<xsl:variable name="delay" select="$connector/simpleAction/@delay|$connector/e:simpleAction/@delay"></xsl:variable>
				 					<xsl:call-template name="pegaDelay">
							 			<xsl:with-param name="delay" select="$delay"></xsl:with-param>
							 			<xsl:with-param name="elo" select="$elo"></xsl:with-param>
							 			<xsl:with-param name="bindParam" select="bindParam[@name=substring-after($delay,'$')]|e:bindParam[@name=substring-after($delay,'$')]"></xsl:with-param>
							 		</xsl:call-template>
				 				</xsl:variable>
					<xsl:variable name="execLine">
						<xsl:choose>
				 			<xsl:when test="$tempo != ''">
				 				<!-- pego o tempo do delay-->
				 				<xsl:text>setTimeout("</xsl:text><xsl:value-of select="$acaoJava"></xsl:value-of><xsl:text>",</xsl:text><xsl:value-of select="$tempo"></xsl:value-of>*1000);
						 	 </xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$acaoJava"></xsl:value-of>;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!--finalmente coloco o valor final-->
					<xsl:choose>
					<xsl:when test="$qualifier = 'par'">
						$(document).bind('<xsl:value-of select="concat($functionName,$role,'abc_123')" />',function(){
							<xsl:value-of select="$execLine" />
						});
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$execLine" />
					</xsl:otherwise>
					</xsl:choose>
			    </xsl:for-each>
			    <xsl:if test="$qualifier = 'par'">
			    	$(document).bind('<xsl:value-of select="concat($functionName,$role,'abc_123')" />',function(){
			    		$(document).unbind('<xsl:value-of select="concat($functionName,$role,'abc_123')" />');
			    	});
			    	$(document).trigger('<xsl:value-of select="concat($functionName,$role,'abc_123')" />');
		    	</xsl:if>
				<xsl:if test="$interaction">
					});
				</xsl:if>
	    	</xsl:for-each>
			<xsl:if test="$interaction">
				$(document).bind('<xsl:value-of select="$functionName" />',function(){$(document).unbind('<xsl:value-of select="$functionName" />')});
				$(document).trigger('<xsl:value-of select="$functionName" />');	
			</xsl:if>
		</xsl:if>	
	</xsl:template>
	<xsl:template name="pegaOriginal">
		<xsl:param name="component"/>
		<xsl:param name="originalDoc" />
		<xsl:choose>
			<xsl:when test="count(//media[@id=$component][@instance='instSame']|//e:media[@id=$component][@instance='instSame'])>0">
				<xsl:value-of select="//media[@id=$component][@instance='instSame']/@refer|//e:media[@id=$component][@instance='instSame']/@refer"></xsl:value-of>
			</xsl:when>
			<xsl:when test="$originalDoc!=''">
				<xsl:choose>
					<xsl:when test="count($originalDoc//media[@id=$component][@instance='instSame']|$originalDoc//e:media[@id=$component][@instance='instSame'])>0">
						<xsl:value-of select="$originalDoc//media[@id=$component][@instance='instSame']/@refer|$originalDoc//e:media[@id=$component][@instance='instSame']/@refer"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$component"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$component"></xsl:value-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<xsl:template name="interpretaAssassement">
		<xsl:param name="assaement"></xsl:param>
		<xsl:param name="elo"></xsl:param>
		<xsl:param name="role"></xsl:param>
		<xsl:param name="originalDoc"></xsl:param>
		<xsl:choose>
		<xsl:when test="local-name($assaement) = 'attributeAssessment'">
			<xsl:variable name="atipe" select="$assaement/@attributeType" />
			<xsl:variable name="no" >
				<xsl:call-template name="pegaOriginal">
					<xsl:with-param name="component" select="$elo/bind[@role=$assaement/@role]/@component|$elo/e:bind[@role=$assaement/@role]/@component" />
					<xsl:with-param name="originalDoc" select="$originalDoc" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
			<xsl:when test="$atipe='nodeProperty'">
				<!-- testar se é uma porta de contexto-->
				<xsl:choose>
					<xsl:when test="count($originalDoc//*[@id=$no]/property[@name=$elo/bind[@role=$assaement/@role]/@interface]|$originalDoc//*[@id=$no]/e:property[@name=$elo/e:bind[@role=$assaement/@role]/@interface])>0">
						<xsl:text>$('input.property[parent="</xsl:text><xsl:value-of select="$no"></xsl:value-of><xsl:text>"][name="</xsl:text><xsl:value-of select="$elo/bind[@role=$assaement/@role]/@interface|$elo/e:bind[@role=$assaement/@role]/@interface"></xsl:value-of><xsl:text>"]').attr('value');</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="interface" select="$elo/bind[@role=$assaement/@role]/@interface" />
						<xsl:text>$('input.property[parent="</xsl:text><xsl:value-of select="$originalDoc//port[@id=$interface]/@component|$originalDoc//e:port[@id=$interface]/@component" /><xsl:text>"][name="</xsl:text><xsl:value-of select="$originalDoc//port[@id=$interface]/@interface|$originalDoc//e:port[@id=$interface]/@inteface" /><xsl:text>"]').attr('value');</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$atipe='state'">
				<xsl:choose>
				<!--é uma porta-->
				<xsl:when test="$elo/bind[@role=$assaement/@role]/@interface|$elo/e:bind[@role=$assaement/@role]/@interface != ''">
					<xsl:text>$('#'+$('#</xsl:text><xsl:value-of select="$no"></xsl:value-of><xsl:text>').attr('value')).attr('state');</xsl:text>
				</xsl:when>
				<xsl:otherwise>
				<!--é um nó-->
					<xsl:text>$('#</xsl:text><xsl:value-of select="$no"></xsl:value-of><xsl:text>').attr('state');</xsl:text>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise><!--é valor-->
			<xsl:choose>
			<xsl:when test="contains($assaement/@value,'$')">
				<xsl:variable name="nomeAss" select="substring-after($assaement/@value,'$')"></xsl:variable>
				<xsl:choose>
					<xsl:when test="count($elo/e:bind[@role=$role]/e:bindParam[@name=$nomeAss]|$elo/bind[@role=$role]/bindParam[@name=$nomeAss])>0">
						<xsl:text>'</xsl:text><xsl:value-of select="$elo/e:bind[@role=$role]/e:bindParam[@name=$nomeAss]/@value|$elo/bind[@role=$role]/bindParam[@name=$nomeAss]/@value"></xsl:value-of><xsl:text>';</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>'</xsl:text><xsl:value-of select="$elo/e:linkParam[@name=$nomeAss]/@value|$elo/linkParam[@name=$nomeAss]/@value"></xsl:value-of><xsl:text>';</xsl:text>
				</xsl:otherwise>
				</xsl:choose>	  						
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>'</xsl:text><xsl:value-of select="$assaement/@value"></xsl:value-of><xsl:text>';</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="pegaDelay">
		<xsl:param name="delay"></xsl:param>
		<xsl:param name="elo"></xsl:param>
		<xsl:param name="bindParam"></xsl:param>
 			<xsl:choose>
 			<xsl:when test="contains($delay,'$')">
		 		<xsl:choose>
		 		<xsl:when test="count($bindParam)> 0">
		 			<xsl:value-of select="substring-before($bindParam[@name=substring-after($delay,'$')]/@value,'s')" ></xsl:value-of>
		 		</xsl:when>
		 		<xsl:otherwise>
		 			<xsl:value-of select="substring-before($elo/linkParam[@name=substring-after($delay,'$')]/@value|$elo/e:linkParam[@name=substring-after($delay,'$')]/@value,'s')" ></xsl:value-of>
		 		</xsl:otherwise>
		 		</xsl:choose>
		 	</xsl:when> 
		 	<xsl:otherwise>
		 		<xsl:value-of select="substring-before($delay,'s')" ></xsl:value-of>
		 	</xsl:otherwise>
		 	</xsl:choose>
	</xsl:template>
	<xsl:template name="condicaoComposta">
		<xsl:param name="connector" />
		<xsl:param name="elo" />
		<xsl:param name="functionName" />
		<xsl:param name="interaction" />
		<xsl:if test="$connector/e:compoundCondition/@operator|$connector/compoundCondition/@operator != ''">
			<xsl:variable name="tempo">
 			<xsl:call-template name="pegaDelay">
 				<xsl:with-param name="delay" select="$connector/compoundCondition/@delay|$connector/e:compoundCondition/@delay"></xsl:with-param>
 				<xsl:with-param name="elo" select="$elo"></xsl:with-param>
 			</xsl:call-template>
 			</xsl:variable>
			<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of> = {number:<xsl:value-of select="count($connector/e:compoundCondition/e:simpleCondition|$connector/compoundCondition/simpleCondition)+count($connector/compoundCondition/compoundCondition|$connector/e:compoundCondition/e:compoundCondition)" />,string:"",counter:0};
			function <xsl:value-of select="concat($functionName,'_',$interaction)" />(origin,target){
  				if(origin.data.id == target){
  		  			<xsl:if test="$connector/compoundCondition/@operator|$connector/e:compoundCondition/@operator = 'and'">
  					if(<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.string.indexOf(target)&lt;0){
  						<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.string.concat(target);
  						<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.counter+=1;
  						<!-- espera um segundo antes de cancelar os triggers-->
  						if(!<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.number == <xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.counter){
  							setTimeout("<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.string = '';<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.counter = 0;",1000)
  							return;
  						}
  						else{
  							<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.string = '';
  							<xsl:value-of select="concat($functionName,$interaction)"></xsl:value-of>.counter = 0;
  						}
  						<xsl:variable name="originalDoc" select="/" />
  						<xsl:for-each select="$connector/e:compoundCondition/e:assessmentStatement|$connector/compoundCondition/assessmentStatement">
  							comparado = <xsl:call-template name="interpretaAssassement"> <xsl:with-param name="assaement" select="*[1]"></xsl:with-param><xsl:with-param name="elo" select="$elo"></xsl:with-param><xsl:with-param name="role" select="*[2]/@role"></xsl:with-param><xsl:with-param name="originalDoc" select="$originalDoc" /> </xsl:call-template>
  							valor = <xsl:call-template name="interpretaAssassement"> <xsl:with-param name="assaement" select="*[2]"></xsl:with-param><xsl:with-param name="role" select="*[1]/@role"></xsl:with-param><xsl:with-param name="elo" select="$elo"></xsl:with-param> <xsl:with-param name="originalDoc" select="$originalDoc" />  </xsl:call-template>
	  					<xsl:variable name="comparador" select="$connector/e:compoundCondition/e:assessmentStatement/@comparator|$connector/compoundCondition/assessmentStatement/@comparator"></xsl:variable>
							if(!(comparado<xsl:call-template name="pegaComparador"><xsl:with-param name="comparator" select="$comparador "></xsl:with-param></xsl:call-template> valor))
								return;
  						
  						</xsl:for-each>
  					}
  					else{
  						return;
  					}
  	  			</xsl:if>
  	  			<xsl:choose>
  	  				<xsl:when test="$tempo != ''">
  	  					<xsl:text>setTimeout("</xsl:text><xsl:value-of select="$functionName"></xsl:value-of><xsl:text>({data:{id:"+origin.data.id+"}},"+target+")",</xsl:text><xsl:value-of select="$tempo"></xsl:value-of>*1000);
  	  				</xsl:when>
  	  				<xsl:otherwise>
  	  					<xsl:value-of select="$functionName"></xsl:value-of>(origin,target);
  	  				</xsl:otherwise>
  	  			</xsl:choose>
					if(origin.stopImmediatePropagation)
						origin.stopImmediatePropagation();
					return true;
  				}
  			}
			<xsl:call-template name="condicaoComposta">
			<xsl:with-param name="connector" select="$connector/compoundCondition|$connector/e:compoundCondition" />
			<xsl:with-param name="elo" select="$elo"/>
			<xsl:with-param name="functionName" select="concat($functionName,'_',$interaction)"/>
			<xsl:with-param name="interaction" select="string(number($interaction)+1)" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count($connector/simpleCondition|$connector/e:simpleCondition)>0">
			<xsl:variable name="role" select="$connector/simpleCondition/@role|$connector/e:simpleCondition/@role"></xsl:variable>
			<xsl:for-each select="$elo/bind[@role=$role]|$elo/e:bind[@role=$role]">
			<xsl:variable name="interface" select="@interface"></xsl:variable>
			<xsl:variable name="key" select="$connector/simpleCondition[@role=$role]/@key|$connector/e:simpleCondition[@role=$role]/@key"></xsl:variable>
			<xsl:variable name="nosDoContexto" select="$elo/../media|$elo/../e:media|//media[@id=$elo/../media/@refer]|//media[@id=$elo/../media/@refer]" />
			<xsl:variable name="componentInterface">
			<xsl:choose>
				<xsl:when test="count(@interface) > 0 and count($nosDoContexto/area[@id=$interface]|$nosDoContexto/e:area[@id=$interface])>0">
					<xsl:value-of select="@interface" />
				</xsl:when>
				<!--nao necessario trata somente de mídias-->
				<!--xsl:when test="count(@interface) > 0 and count($nosDoContexto/property[@name=$interface]|$nosDoContexto/e:property[@name=$interface])>0">
				$('#<xsl:value-of select="@component"></xsl:value-of> property[name=&quot;<xsl:value-of select="@interface" />&quot;]').bind('<xsl:value-of select="@role"></xsl:value-of>',{id:'<xsl:value-of select="@interface" />'},<xsl:value-of select="$functionName"></xsl:value-of>);
				</xsl:when-->
				<!-- trata demais nos -->
				<xsl:when test="count(@interface) and count($nosDoContexto/property[@name=$interface]|$nosDoContexto/e:property[@name=$interface])=0">
					<xsl:value-of select="@interface" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@component" />
				</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			<xsl:variable name="tempo">
				<xsl:variable name="delay" select="$connector/simpleCondition/@delay|$connector/e:simpleCondition/@delay"></xsl:variable>
 				<xsl:call-template name="pegaDelay">
		 			<xsl:with-param name="delay" select="$delay"></xsl:with-param>
		 			<xsl:with-param name="elo" select="$elo"></xsl:with-param>
		 			<xsl:with-param name="bindParam" select="bindParam[@name=substring-after($delay,'$')]|e:bindParam[@name=substring-after($delay,'$')]"></xsl:with-param>
		 		</xsl:call-template>
 			</xsl:variable>
			<xsl:variable name="chave">
				<xsl:choose>
				<xsl:when test="contains($key,'$')">
							<xsl:choose>
							<xsl:when test="count(bindParam[@name=substring-after($key,'$')]|e:bindParam[@name=substring-after($key,'$')])>0">
								<xsl:value-of select="bindParam[@name=substring-after($key,'$')]/@value|e:bindParam[@name=substring-after($key,'$')]/@value"></xsl:value-of>
							</xsl:when>
							<xsl:when test="count($elo/linkParam[@name=substring-after($key,'$')]|$elo/e:linkParam[@name=substring-after($key,'$')])>0">
								<xsl:value-of select="$elo/linkParam[@name=substring-after($key,'$')]/@value|$elo/e:linkParam[@name=substring-after($key,'$')]/@value"></xsl:value-of>
							</xsl:when>
							</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$key"></xsl:value-of>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="component" select="@component" />
			<xsl:if test="$chave != ''">
						hasNclKeys = true;
						nclKeys['<xsl:value-of select="$chave" />'] = "";
						nclKeys['<xsl:value-of select="$chave" />Name'] = "não selecionada";
						function  <xsl:value-of select="$functionName"></xsl:value-of>_<xsl:value-of select="$chave"></xsl:value-of>(origin,target){
							if($('#<xsl:value-of select="$componentInterface" />').attr('state')!='occurring')
								return false;
								
							if($('.started#'+origin.data.id).length>0)
								if(<xsl:value-of select="$functionName"></xsl:value-of>({data:{id:origin.data.id}},origin.data.id))					origin.stopImmediatePropagation();
						}
						<xsl:choose>
						<xsl:when test="$tempo != ''">
							function <xsl:value-of select="concat($functionName,'_SimpleCondDelay')"></xsl:value-of>(origin,target){
								<xsl:text>setTimeout("</xsl:text><xsl:value-of select="$functionName"></xsl:value-of><xsl:text>({data:{id:"+origin.data.id+"}},"+target+")",</xsl:text><xsl:value-of select="$tempo"></xsl:value-of>*1000);
							}
						$('#<xsl:value-of select="$componentInterface" />').bind('<xsl:value-of select="$chave"></xsl:value-of>',{id:'<xsl:value-of select="$componentInterface" />'},<xsl:value-of select="concat($functionName,'_SimpleCondDelay')"></xsl:value-of>);
						</xsl:when>
						<xsl:otherwise>
						$('#<xsl:value-of select="$componentInterface" />').bind('<xsl:value-of select="$chave"></xsl:value-of>',{id:'<xsl:value-of select="$componentInterface" />'},<xsl:value-of select="$functionName"></xsl:value-of>_<xsl:value-of select="$chave"></xsl:value-of>);
						</xsl:otherwise>
						</xsl:choose>
			</xsl:if>
			<xsl:if test="$chave = '' or count($elo/bind[@role='onSelection'][@component=$component])=1">	
			<xsl:choose>
			<xsl:when test="$tempo != ''">
			function <xsl:value-of select="concat($functionName,'_SimpleCondDelay')"></xsl:value-of>(origin,target){
				<xsl:text>setTimeout("</xsl:text><xsl:value-of select="$functionName"></xsl:value-of><xsl:text>({data:{id:"+origin.data.id+"}},"+target+")",</xsl:text><xsl:value-of select="$tempo"></xsl:value-of>*1000);
			}
			$('#<xsl:value-of select="$componentInterface" />').bind('<xsl:value-of select="@role"></xsl:value-of>',{id:'<xsl:value-of select="$componentInterface" />'},<xsl:value-of select="concat($functionName,'_SimpleCondDelay')"></xsl:value-of>)
			</xsl:when>
			<xsl:otherwise>
				$('#<xsl:value-of select="$componentInterface" />').bind('<xsl:value-of select="@role"></xsl:value-of>',{id:'<xsl:value-of select="$componentInterface" />'},<xsl:value-of select="$functionName"></xsl:value-of>);
			</xsl:otherwise>
			</xsl:choose>	
			</xsl:if>
		</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="interpretaElo">
	<xsl:param name="oelo"></xsl:param>
	<xsl:variable name="functionName">
		<xsl:choose>
		<xsl:when test="count($oelo/@id)=1">
			<xsl:value-of select="$oelo/@id"></xsl:value-of>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$oelo/bind|$oelo/e:bind">
					<xsl:variable name="roleComp">
						<xsl:if test="count(@interface) = 1">
							<xsl:value-of select="concat(@role,@component,@interface,'_')"></xsl:value-of>
						</xsl:if>
						<xsl:if test="count(@interface) = 0">
							<xsl:value-of select="concat(@role,@component,'_')"></xsl:value-of>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="contains($roleComp,'.')">
					<xsl:value-of select="concat(substring-before($roleComp,'.'),'_',substring-after($roleComp,'.'))"></xsl:value-of>
					</xsl:if>
					<xsl:if test="not(contains($roleComp,'.'))">
						<xsl:value-of select="$roleComp"></xsl:value-of>
					</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
			<xsl:variable name="xconector">
				<xsl:choose>
				<xsl:when test="contains(@xconnector,'.')">
				<xsl:value-of select="concat(substring-before(@xconnector,'.'),'_',substring-after(@xconnector,'.'))"></xsl:value-of>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@xconnector"></xsl:value-of>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
			<xsl:when test="contains($xconector,'#')">
				<xsl:value-of select="concat(substring-before($xconector,'#'),substring-after($xconector,'#'))"></xsl:value-of>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$xconector"></xsl:value-of>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
		<xsl:when test="contains($oelo/@xconnector,'#')">
		<xsl:variable name="connectorID" select="substring-after($oelo/@xconnector,'#')"></xsl:variable>
		<xsl:variable name="alias" select="substring-before($oelo/@xconnector,'#')"></xsl:variable>
		<xsl:variable name="conectorExterno" select="document(//connectorBase/importBase[@alias=$alias]/@documentURI|//e:connectorBase/e:importBase[@alias=$alias]/@documentURI)" />
			<xsl:call-template name="intepretaElo2">
				<xsl:with-param name="connector" select="$conectorExterno/ncl/head/connectorBase/causalConnector[@id=$connectorID]|$conectorExterno/e:ncl/e:head/e:connectorBase/e:causalConnector[@id=$connectorID]"></xsl:with-param>
				<xsl:with-param name="functionName" select="$functionName"></xsl:with-param>
				<xsl:with-param name="oelo" select="$oelo"></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		<xsl:variable name="connectorID" select="@xconnector"></xsl:variable>
			<xsl:call-template name="intepretaElo2">
				<xsl:with-param name="connector" select="//causalConnector[@id=$connectorID]|//e:causalConnector[@id=$connectorID]"></xsl:with-param>
				<xsl:with-param name="functionName" select="$functionName"></xsl:with-param>
				<xsl:with-param name="oelo" select="$oelo"></xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="intepretaElo2">
		<xsl:param name="connector"></xsl:param>
		<xsl:param name="oelo"></xsl:param>
		<xsl:param name="functionName"></xsl:param>
		function <xsl:value-of select="$functionName"></xsl:value-of>(origin,target){
		<xsl:if test="bind/@role|e:bind/@role = 'onSelection'">
			if($('#'+target+'.started,input.port#'+target).length ==0){
				return;
			}
		</xsl:if>
		if(origin.data.id==target){
		<xsl:call-template name="acaoComplexa">
			<xsl:with-param name="connector" select="$connector" />
			<xsl:with-param name="elo" select="$oelo"/>
			<xsl:with-param name="functionName" select="$functionName"/>
		</xsl:call-template>
		}
		}
		<xsl:call-template name="condicaoComposta">
			<xsl:with-param name="connector" select="$connector" />
			<xsl:with-param name="elo" select="."/>
			<xsl:with-param name="functionName" select="$functionName"/>
			<xsl:with-param name="interaction" select="string(0)"/>
		</xsl:call-template>		
	</xsl:template>
	<xsl:template match="text()" />
	<xsl:template name="interpretaPropriedade">
		<xsl:param name="parent" />
		<!--xsl:attribute name="style">
			<xsl:for-each select="$media/property|$media/e:property">
				<xsl:if test="@value!=''">
				<xsl:choose>
				<xsl:when test="@name ='bounds'">
					<xsl:text>left:</xsl:text><xsl:value-of select="substring-before(@value,',')"></xsl:value-of><xsl:text>; </xsl:text>
					<xsl:variable name="valor" select="substring-after(@value,',')" />
					<xsl:text>top:</xsl:text><xsl:value-of select="substring-before($valor,',')"></xsl:value-of><xsl:text>; </xsl:text>
					<xsl:variable name="valor" select="substring-after($valor,',')" />
					<xsl:text>width:</xsl:text><xsl:value-of select="substring-before($valor,',')"></xsl:value-of><xsl:text>; </xsl:text>
					<xsl:variable name="valor" select="substring-after($valor,',')" />
					<xsl:text>height:</xsl:text><xsl:value-of select="substring-before($valor,',')"></xsl:value-of><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name ='size'">
					<xsl:text>width:</xsl:text><xsl:value-of select="substring-before(@value,',')"></xsl:value-of><xsl:text>; </xsl:text>
					<xsl:text>height:</xsl:text><xsl:value-of select="substring-after(@value,',')"></xsl:value-of><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name ='location'">
					<xsl:text>left:</xsl:text><xsl:value-of select="substring-before(@value,',')"></xsl:value-of><xsl:text>; </xsl:text>
					<xsl:text>top:</xsl:text><xsl:value-of select="substring-after(@value,',')"></xsl:value-of><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name ='transparency'">
					<xsl:text>opacity:</xsl:text>
					<xsl:choose>
					<xsl:when test="contains(@value,'%')"><xsl:value-of select="1-(number(substring-before(@value,'%')) div 100)" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="1-number(@value)" /></xsl:otherwise>
					</xsl:choose>
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name ='visible'">
					<xsl:text>visibility:</xsl:text>
					<xsl:choose>
					<xsl:when test="@value ='false'"><xsl:text>hidden</xsl:text></xsl:when>
					<xsl:when test="@value ='true'"><xsl:text>visible</xsl:text></xsl:when>
					</xsl:choose>
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name='scroll'">
					<xsl:choose>
					<xsl:when test="@value ='both'">
						<xsl:text>overflow:scroll; </xsl:text>
					</xsl:when>
					<xsl:when test="@value ='horizontal'">
						<xsl:text>overflow-y:hidden;overflow-x:scroll; </xsl:text>
					</xsl:when>
					<xsl:when test="@value ='vertical'">
						<xsl:text>overflow-y:scroll;overflow-x:hidden; </xsl:text>
					</xsl:when>
					<xsl:when test="@value ='none'">
						<xsl:text>overflow:scroll; </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>overflow:auto; </xsl:text>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="contains('top,left,bottom,right,width,height,background,visible,fit,scroll',@name)">
					<xsl:value-of select="@name" /><xsl:text>:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontColor'">
						<xsl:text>color:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontFamily'">
						<xsl:text>font-family:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontStyle'">
						<xsl:text>font-style:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontSize'">
						<xsl:text>font-size:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontVariant'">
						<xsl:text>font-variant:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="@name = 'fontWeight'">
						<xsl:text>font-weight:</xsl:text>:<xsl:value-of select="@name" /><xsl:text>; </xsl:text>
				</xsl:when>
				</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute-->
		<xsl:for-each select="$parent/property|$parent/e:property">
			<xsl:element name="input">
				<xsl:attribute name="class">
					<xsl:text>property</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="parent">
					<xsl:value-of select="$parent/@id" />
				</xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name"></xsl:value-of></xsl:attribute>
				<xsl:if test="@value!=''">
					<xsl:attribute name="value"><xsl:value-of select="@value"></xsl:value-of></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="type">
				<xsl:text>hidden</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="interpretaArea">
		<xsl:param name="media" />
			<xsl:for-each select="$media/e:area|$media/area|$media/e:area">
				<xsl:element name="area">
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
					<xsl:attribute name="parent">
						<xsl:value-of select="$media/@id" />
					</xsl:attribute>
					<xsl:if test="@begin!=''">
					<xsl:attribute name="begin">
						<xsl:choose>
						<xsl:when test="contains(@begin,'s')">
							<xsl:value-of select="substring-before(@begin,'s')"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@begin" />
						</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@coords!=''">
					<xsl:attribute name="coords">
						<xsl:value-of select="@coords" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@end!=''">
						<xsl:attribute name="end">
							<xsl:choose>
							<xsl:when test="contains(@end,'s')">
								<xsl:value-of select="substring-before(@end,'s')"></xsl:value-of>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@end" />
							</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@endText!=''">
					<xsl:attribute name="endText">
						<xsl:value-of select="@endText" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@beginText!=''">
					<xsl:attribute name="beginText">
						<xsl:value-of select="@beginText" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@beginPosition!=''">
					<xsl:attribute name="beginPosition">
						<xsl:value-of select="@beginPosition" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@endPosition!=''">
					<xsl:attribute name="endPosition">
						<xsl:value-of select="@endPosition" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@first!=''">
					<xsl:attribute name="first">
						<xsl:value-of select="@first" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@last!=''">
					<xsl:attribute name="last">
						<xsl:value-of select="@last" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@label!=''">
					<xsl:attribute name="label">
						<xsl:value-of select="@label" />
					</xsl:attribute>
					</xsl:if>
					<xsl:if test="@clip!=''">
					<xsl:attribute name="clip">
						<xsl:value-of select="@clip" />
					</xsl:attribute>
					</xsl:if>
				</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="interPretaAtributosMedia">
		<xsl:param name="id" />		
		<xsl:param name="media" />
		<xsl:param name="class" />
		<xsl:attribute name="id"><xsl:value-of select="$id"></xsl:value-of></xsl:attribute>
		<xsl:attribute name="class">
		<xsl:if test="$class!=''">
				<xsl:value-of select="$class"></xsl:value-of><xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="count(media[@id=$id]/property[name=@style]|e:media[@id=$id]/e:property[name=@style])>0">
			<xsl:value-of select="media[@id=$id]/property[name=@style]/@value|e:media[@id=$id]/e:property[name=@style]/@value"></xsl:value-of><xsl:text> </xsl:text>
		</xsl:if>
		</xsl:attribute>
		<xsl:attribute name="context">
			<xsl:choose>
			<xsl:when test="count(//media[@id=$id]/ancestor::node()[name()='context']|//e:media[@id=$id]/ancestor::node()[name()='context'])>0">
				<xsl:value-of select="//media[@id=$id]/parent::node()[local-name()='context']/@id|//e:media[@id=$id]/parent::node()[local-name()='context']/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>body</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$media/@descriptor != ''">
			<xsl:attribute name="descriptor">
					<xsl:if test="not(contains($media/@descriptor,'#'))"><xsl:value-of select="$media/@descriptor"></xsl:value-of></xsl:if>
					<xsl:if test="contains($media/@descriptor,'#')"><xsl:value-of select="concat(substring-before($media/@descriptor,'#'),'_',substring-after($media/@descriptor,'#'))"></xsl:value-of></xsl:if>
			</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="onclick">select('<xsl:value-of select="$id" ></xsl:value-of>')</xsl:attribute>
		<xsl:if test="$media/@id!= $id">
			<xsl:attribute name="instance">
				<xsl:value-of select="//media[@id=$id]/@instance|//e:media[@id=$id]/@instance" />
			</xsl:attribute>
			<xsl:attribute name="refer">
						<xsl:value-of select="$media/@id" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$media/@src">
			<!--trata mirror-->
			<xsl:for-each select="//media[@id=substring-after($media/@src,'//')]|//e:media[@id=substring-after($media/@src,'//')]">
				<xsl:attribute name="mirror">
					<xsl:choose>
						<xsl:when test="@refer != '' and @interface = 'instSame'">
							<xsl:value-of select="@refer"></xsl:value-of>					
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@id"></xsl:value-of>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:attribute name="src">
				<xsl:value-of select="$media/@src">
				</xsl:value-of>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="interpretaMedia">
		<xsl:param name="media"></xsl:param>
		<xsl:param name="id"></xsl:param>
		<xsl:choose>
		<xsl:when test="$media/@id != $id and count(//media[@id=$id][@instance='instSame']|//e:media[@id=$id][@instance='instSame'])>0">
			<span>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="class">
					<xsl:text>instSame</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</span>
		</xsl:when>
		<xsl:when test="contains($media/@src,'.txt') or contains($media/@src,'.htm') or contains($media/@src,'.ncl')">
			<iframe>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="class" >innerRegion</xsl:with-param>
				</xsl:call-template>
			</iframe>
			<xsl:if test="count($media/property|$media/e:property) > 0">
				<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="$media"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
				<xsl:if test="count(property|e:property) > 0">
					<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="."/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="count($media/area|$media/e:area) > 0">
				<xsl:call-template name="interpretaArea">
					<xsl:with-param name="media" select="$media"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
				<xsl:if test="count(area|e:area) > 0">
					<xsl:call-template name="interpretaArea">
						<xsl:with-param name="media" select="."/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="contains($media/@src,'.png') or contains($media/@src,'.jpg') or contains($media/@src,'.jpeg') or contains($media/@src,'.gif') or contains($media/@src,'.bmp')">
			<img>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="class" >innerRegion</xsl:with-param>
				</xsl:call-template>
			</img>
			<xsl:if test="count($media/property|$media/e:property) > 0">
				<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="$media"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
				<xsl:if test="count(property|e:property) > 0">
					<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="."/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="count($media/area|$media/e:area) > 0">
				<xsl:call-template name="interpretaArea">
					<xsl:with-param name="media" select="$media"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
				<xsl:if test="count(area|e:area) > 0">
					<xsl:call-template name="interpretaArea">
						<xsl:with-param name="media" select="."/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="contains($media/@type,'audio') or(contains($media/@src,'.mp3') or contains($media/@src,'.mp2') or contains($media/@src,'.wav'))">
			<audio>
				<xsl:attribute name="preload">none</xsl:attribute>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
				</xsl:call-template>
				<xsl:if test="count($media/property|$media/e:property) > 0">
				<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="$media"/>
				</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(property|e:property) > 0">
						<xsl:call-template name="interpretaPropriedade">
							<xsl:with-param name="parent" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="count($media/area|$media/e:area) > 0">
					<xsl:call-template name="interpretaArea">
						<xsl:with-param name="media" select="$media"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(area|e:area) > 0">
						<xsl:call-template name="interpretaArea">
							<xsl:with-param name="media" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</audio> 
		</xsl:when>
		<xsl:when test="contains($media/@type,'video') or(contains($media/@src,'.mp4') or contains($media/@src,'.mpg4') or contains($media/@src,'.mpeg') or contains($media/@src,'.mpg'))">
			<video>
				<xsl:attribute name="preload">none</xsl:attribute>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="class" >innerRegion</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="count($media/property|$media/e:property) > 0">
				<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="$media"/>
				</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(property|e:property) > 0">
						<xsl:call-template name="interpretaPropriedade">
							<xsl:with-param name="parent" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="count($media/area|$media/e:area) > 0">
					<xsl:call-template name="interpretaArea">
						<xsl:with-param name="media" select="$media"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(area|e:area) > 0">
						<xsl:call-template name="interpretaArea">
							<xsl:with-param name="media" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</video>
		</xsl:when>
		<xsl:when test="$media/@type='application/x-ginga-settings'">
			<span>
				<xsl:call-template name="interPretaAtributosMedia">
					<xsl:with-param name="media" select="$media" />
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="class">
					<xsl:text>settings</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="count($media/property|$media/e:property) > 0">
				<xsl:call-template name="interpretaPropriedade">
						<xsl:with-param name="parent" select="$media"/>
				</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(property|e:property) > 0">
						<xsl:call-template name="interpretaPropriedade">
							<xsl:with-param name="parent" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="count($media/area|$media/e:area) > 0">
					<xsl:call-template name="interpretaArea">
						<xsl:with-param name="media" select="$media"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="//media[@refer=$id][@instance='instSame']|//e:media[@refer=$id][@instance='instSame']">
					<xsl:if test="count(area|e:area) > 0">
						<xsl:call-template name="interpretaArea">
							<xsl:with-param name="media" select="."/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</span>
		</xsl:when>
		</xsl:choose>

		<xsl:if test="$id = $media/@id">
			<xsl:for-each select="//media[@refer = $id]|//e:media[@refer = $id]">
					<xsl:call-template name="interpretaMedia">
						<xsl:with-param name="media" select="$media"></xsl:with-param>
						<xsl:with-param name="id" select="@id"></xsl:with-param>
					</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
